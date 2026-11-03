variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "AWS Region"
}

variable "cluster-name" {
  type        = string
  default     = "test-cluster-with-configmap"
  description = "Name of the EKS cluster"
}
