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