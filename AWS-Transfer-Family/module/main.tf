# sftp => server managed and VPC endpoint
resource "aws_transfer_server" "sftp_server" {
  identity_provider_type = "SERVICE_MANAGED"
  protocols            = ["SFTP"]
  endpoint_type        = "VPC"
  dynamic "endpoint_details" {
    for_each = var.endpoint_details != null ? [var.endpoint_details] : []
    content {
      subnet_ids = endpoint_details.value.subnet_ids
      vpc_id     = endpoint_details.value.vpc_id
      security_group_ids = endpoint_details.value.security_group_ids
    }
  }

  tags = {
    NAME     = "${var.aws-transfer-server-name}"
  }
}
# IAM role policy
data "aws_iam_policy_document" "sftp_assume_role" {
    statement {
      effect = "Allow"
      principals {
        type = "Service"
        identifiers = ["transfer.amazonaws.com"]
      }

      actions = ["sts:AssumeRole"]
    }
}

#IAM role - Associating data policy
resource "aws_iam_role" "sftp_role" {
    name = join("-", [var.application, var.service, var.environment, var.role])
    assume_role_policy = data.aws_iam_policy_document.sftp_assume_role.json
}
  
data "aws_iam_policy_document" "sftp_policy_document" {
    statement {
      sid = "AllowFullAccesstoS3"
      effect = "Allow"
      actions = ["s3:ListBucket"]
      resources = ["*"]
    }
}
resource "aws_iam_role_policy" "sftp_policy" {
  name = join("-", [var.application, var.environment, var.policy])
  role = aws_iam_role.sftp_role.id
  policy = data.aws_iam_policy_document.sftp_policy_document.json

}
# Resource to add user to server 
resource "aws_transfer_user" "sftp_transfer_user" {
  for_each = var.user_group_name
  server_id      = aws_transfer_server.sftp_server.id
  user_name      = each.key // username are mapped as map(object) in user_group_name variable
  home_directory = each.value.home_dir
  role           = aws_iam_role.sftp_role.arn
  
}
# If there is single user then enable this data template_file and use it in body of aws_transfer_ssh_key
# data "template_file" "ssh_keys" {
#   template = "${file("${path.module}/mykey.tpl")}"
# }

resource "aws_transfer_ssh_key" "sftp-ssh" {
  for_each =  var.user_group_name
  server_id = aws_transfer_server.sftp_server.id
  user_name = each.key
  body      = templatefile("${path.module}/${each.key}.tpl", {name = each.key})
  # body      = data.template_file.ssh_keys.rendered
}