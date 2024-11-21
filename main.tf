####### variables ######
variable "ami_id" {
    description = "ID de la AMI para la instancia EC2"
    default     = "ami-00eb69d236edcfaf8"
}

variable "instance_type" {
    description = "Tipo de instancia EC2"
    default     = "t2.micro"
}

variable "server_name" {
    description = "Nombre del servidor web"
    default     = "nginx-server"
}

variable "enviroment" {
    description = "Ambiente de la aplicación"
    default     = "test"
}

variable "owner_project" {
    description = "Propietario del proyecto"
    default     = "codafgamer@gmail.com"
}

variable "team_project" {
    description = "Equipo de trabajo asigando para el proyecto"
    default     = "DevOps${var.team_project}"
}

variable "project_name" {
    description = "Nombre del proyecto"
    default     = "Terraform test"
}



####### providor ######
provider "aws" {
    region = "us-east-2"
}

####### resource #######
resource "aws_instance" "nginx-server" {
    ami           = var.ami_id
    instance_type = var.instance_type

    user_data = <<-EOF
                #!/bin/bash
                sudo yum install -y nginx
                sudo systemctl enable nginx
                sudo systemctl start nginx
                EOF

    #asigno un valor a una variable apartir de otro recurso
    key_name = aws_key_pair.nginx-server-ssh.key_name 

    #asigno el security group a mi instancia
    vpc_security_group_ids = [
        aws_security_group.nginx-server-sg.id
    ] 

    tags = {
        Name = var.server_name
        Enviroment = var.enviroment
        Owner = "${var.owner_project}"
        Team = "${var.team_project}"
        Project = "${var.project_name}"
    }
}

####### ssh_key #######
#ssh-keygen -t rsa -b 2048 -f "nginx-server.key"

resource "aws_key_pair" "nginx-server-ssh"{
    key_name = "${var.server_name}-ssh"
    public_key = file("${var.server_name}.key.pub")

    tags = {
        Name = "${var.server_name}-ssh"
        Enviroment = var.enviroment
        Owner = "${var.owner_project}"
        Team = "${var.team_project}"
        Project = "${var:project_name}"
    }
}

####### security_group #######
resource "aws_security_group" "nginx-server-sg"{
    name        = "${var.server_name}-sg"
    description = "Security group allowing SSH and HTTP access"

    ingress{
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress{
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress{
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.server_name}-sg"
        Enviroment = "${var.enviroment}"
        Owner = "${var.owner_project}"
        Team = "${var.team_project}"
        Project = "${var:project_name}"
    }
}

####### output #######
output "server_public_ip" {
    description = "Dirección IP pública de la instancia EC2"
    value       = aws_instance-nginx-server.public_ip
}

output "server_public_dns"{
    description = "DNS público de la instancia EC2"
    value       = aws_instance-nginx-server.public_dns
}


