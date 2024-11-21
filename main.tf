####### Proveedores ######
provider "aws" {
    region = "us-east-2"
}

####### dirección #######
resource "aws_instance" "nginx-server" {
    ami           = "ami-00eb69d236edcfaf8"
    instance_type = "t2.micro"
}