# Declare TF variables
variable "AWS_Region" {
  default = "us-east-2"
}
variable "AvailabilityZone" {
  default = "us-east-2a"
}

variable "ImageId" {
 default = "ami-0a75b786d9a7f8144"
}

variable "VPC_cidr" {
 default = "10.0.0.0/16"
}


variable "InstanceType" {
 default = "t2.micro"
}

variable "KeyName" {
 default = "kalai-terra"
}

variable "AccessKey" {
 default = ""
}

variable "SecretKey" {
 default = ""
}
