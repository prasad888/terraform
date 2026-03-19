# vpc creation
resource "aws_vpc" "terraform-vpc" {
  cidr_block       = var.cidr
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = var.envname
  }
}
# subnet creation
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.terraform-vpc.id
  count = length(var.pubsubnet)
  cidr_block = var.pubsubnet[count.index]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.envname}-publicsubnet-${count.index+1}"
  }
}


resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.terraform-vpc.id
  count = length(var.privatesubnet)
  cidr_block = var.privatesubnet[count.index]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.envname}-privatesubnet-${count.index+1}"
  }
}

#igw creation
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.terraform-vpc.id 
  
  tags = {
    Name = "${var.envname}-eip"
  }
}

#nat pubsubnet
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.natgw.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.envname}-natgw"
  }
}

#route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

    tags = {
        Name = "${var.envname}-route-public"
    }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw.id
  }

    tags = {
        Name = "${var.envname}-route-private"
    }
}

#associate
resource "aws_route_table_association" "pubassociation" {
  count = length(var.pubsubnet)
  subnet_id = element(aws_subnet.public.*.id,count.index)
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "privateassociation" {
  count = length(var.privatesubnet)
  subnet_id = element(aws_subnet.private.*.id,count.index)
  route_table_id = aws_route_table.private.id
}
