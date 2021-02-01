terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.24"
    }
  }
}

output "example_public_dns" {
  value = aws_instance.example.public_dns
}