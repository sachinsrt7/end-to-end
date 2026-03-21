region          = "ap-south-2" #hyderabad
cluster_name    = "modak-dev"
cluster_version = "1.29"

vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
azs                  = ["ap-south-2a", "ap-south-2b"]

instance_types = ["t3.medium"]
desired_nodes  = 2
min_nodes      = 1
max_nodes      = 3
