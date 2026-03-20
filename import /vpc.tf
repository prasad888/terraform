resource "aws_vpc" "terraform-vpc" {
  assign_generated_ipv6_cidr_block     = false
  cidr_block                           = "10.1.0.0/16"
  enable_dns_hostnames                 = true
  enable_dns_support                   = true
  enable_network_address_usage_metrics = false
  instance_tenancy                     = "default"
  ipv4_ipam_pool_id                    = null
  ipv4_netmask_length                  = null
  region                               = "ap-south-1"
  tags = {
    Name = "dev"
  }
  tags_all = {
    Name = "dev"
  }
}
