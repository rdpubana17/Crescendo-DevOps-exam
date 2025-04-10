variable "aws_region" {
  description = "AWS region to deploy the infrastructure"
  default     = "aws-global"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "ec2_instance_count" {
  description = "Number of EC2 instances to provision"
  default     = 2
}

variable "ec2_instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t2.micro"
}

variable "ec2_ami" {
  description = "AMI ID for EC2 instances"
  default     = "ami-0f9de6e2d2f067fca" # Replace with a valid AMI ID
}

variable "alb_security_groups" {
  description = "Security groups for the Application Load Balancer"
  default     = [] # Add security group IDs here
}

variable "aws_access_key_id" {
  description = "AWS Access Key ID"
  type        = string
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key"
  type        = string
}
