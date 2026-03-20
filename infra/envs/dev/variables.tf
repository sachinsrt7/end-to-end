variable "region" {
  description = "AWS region"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  type        = list(string)
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
}

variable "instance_types" {
  description = "Node instance types"
  type        = list(string)
}

variable "desired_nodes" {
  description = "Desired node count"
  type        = number
}

variable "min_nodes" {
  description = "Minimum node count"
  type        = number
}

variable "max_nodes" {
  description = "Maximum node count"
  type        = number
}
