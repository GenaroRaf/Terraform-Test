####### module #######
module "nginx_server_dev" {
    source = "./nginx_server_module"

    ami_id = "ami-00eb69d236edcfaf8"
    instance_type = "t2.micro"
    server_name = "nginx-server-dev"
    enviroment = "devOps"
}

module "nginx_server_qa" {
    source = "./nginx_server_module"

    ami_id = "ami-00eb69d236edcfaf8"
    instance_type = "t2.micro"
    server_name = "nginx-server-qa"
    enviroment = "devOps"
}


####### output #######
output "nginx_dev_ip" {
    description = "Dirección IP pública de la instancia EC2"
    value       = module.nginx_server_dev.server_public_ip
}

output "nginx_dev_dns" {
    description = "DNS público de la instancia EC2"
    value = module.nginx_server_dev.server_public_dns
}


output "nginx_qa_ip" {
    description = "Dirección IP pública de la instancia EC2"
    value       = module.nginx_server_qa.server_public_ip
}

output "nginx_qa_dns" {
    description = "DNS público de la instancia EC2"
    value = module.nginx_server_qa.server_public_dns
}