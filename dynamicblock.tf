locals {
  ingress_rules = [
    { port = 22},
    { port = 80},
    { port = 443}
  ]

}

resource "aws_security_group" "dynamic" {
    name = "dynamic-sg"
    description = "Dynamic security group"
    vpc_id = aws_vpc.terraform-vpc.id   
    dynamic "ingress" {
        for_each = local.ingress_rules
        content {
            description      = "Allow traffic on port ${ingress.value.port}"
            protocol  = "tcp"
            from_port = ingress.value.port
            to_port   = ingress.value.port
            cidr_blocks = ["0.0.0.0/0"]     
      
    }
    
}
}