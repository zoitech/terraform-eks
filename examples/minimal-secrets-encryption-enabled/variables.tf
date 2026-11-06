variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "AWS Region"
}

variable "cluster-name" {
  type        = string
  default     = "testing-cluster-minimal-tf-mod-aws-eks"
  description = "Name of the EKS cluster"
}
