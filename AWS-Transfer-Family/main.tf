module "stfp_module" {
    source = "../modules"
    application = "mysftp"
    service = "transfer"
    environment = "dev"
    role = "sftp-role"
    policy = "sftp-policy"
    aws-transfer-server-name = "sftp-server-user1"

    user_group_name = {
        user1 = {
            username = "user1"
            home_dir = "/user1"
            }
        user2 = {
            username = "user2"
            home_dir = "/user2"
            }
            }
    endpoint_details = {
        subnet_ids = ["<Enter Public Subnet ID>","<Enter Public Subnet ID>"]
        vpc_id     = "<Enter VPC ID>"
        security_group_ids = ["<Enter Security group>"]

    }
    
}