output "stfp_arn" {
    value = aws_iam_role.sftp_role.arn
    description = "IAM role arn"
}

output "sftp_id" {
    value = aws_transfer_server.sftp_server.id
    description = "SFTP server ID"
  
}