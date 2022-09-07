variable "subnets_cidr" {
            default = ["10.20.1.0/24", "10.20.2.0/24","10.20.3.0/24",
                        "10.20.4.0/24","10.20.5.0/24", "10.20.6.0/24"] 
                        }
variable "azs" {
        default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d",
            "us-east-1e", "us-east-1f"]
        
    }

variable "cluster_name" {
  type        = string
  description = "ECS cluster name"
  default = "red-cluster"
}