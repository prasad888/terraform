terraform plan -generate-config-out=generated_resource.tf
terraform import aws_instance.bastion i-0ce06d03f065bd947
terraform state show aws_instance.bastion > bastion.tf