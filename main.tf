####### Providor ######
provider "aws" {
    region = "us-east-2"
}

####### resource #######
resource "aws_instance" "nginx-server" {
    ami           = "ami-00eb69d236edcfaf8"
    instance_type = "t2.micro"

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
        Name = "nginx-server"
        Enviroment = "test"
        Owner = "codafgamer@gmail.com"
        Team = "DevOps"
        Project = "webinar-CaosBinario"
    }
}

####### ssh_key #######
#ssh-keygen -t rsa -b 2048 -f "nginx-server.key"

resource "aws_key_pair" "nginx-server-ssh"{
    key_name = "nginx-server-ssh"
    public_key = file("nginx-server.key.pub")

    tags = {
        Name = "nginx-server-ssh"
        Enviroment = "test"
        Owner = "codafgamer@gmail.com"
        Team = "DevOps"
        Project = "webinar-CaosBinario"
    }
}

####### security_group #######
resource "aws_security_group" "nginx-server-sg"{
    name        = "nginx-server-sg"
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
        Name = "nginx-server-sg"
        Enviroment = "test"
        Owner = "codafgamer@gmail.com"
        Team = "DevOps"
        Project = "webinar-CaosBinario"
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

