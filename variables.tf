variable "name" {
  description = "The name of the deployed service. Used for tagging resources; this can help identify costs."
  type        = string
  default     = "network"
}

variable "environment" {
  description = "The environment the service is deployed to or in. Used for tagging resources; this can help identify costs."
  type        = string
}

variable "service" {
  description = "The service this deployment supports. Used for tagging resources; this can help identify costs."
  type        = string
  default     = "network"
}

variable "vpc_cidr" {
  description = "The CIDR of the VPC, in slash notation."
  type        = string

  validation {
    condition     = cidrnetmask(var.vpc_cidr) == "255.255.0.0"
    error_message = "This is only tested so far with /16 VPCs. PRs welcome here."
  }
}

variable "zone_ids" {
  description = "The AWS Zone IDs of Availability Zones (datacenters) to deploy the network into. Specify 3 or more. More info [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#using-regions-availability-zones-describe)"
  type        = list(string)

  validation {
    condition     = length(distinct(var.zone_ids)) >= 3
    error_message = "Please specify 3 or more distinct availability zones to deploy to."
  }
}
