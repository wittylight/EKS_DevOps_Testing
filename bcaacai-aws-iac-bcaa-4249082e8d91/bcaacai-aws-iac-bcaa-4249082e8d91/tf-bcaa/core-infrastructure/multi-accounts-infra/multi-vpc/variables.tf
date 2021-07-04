variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = "vpc1"
}

variable "region" {
  type        = string
  default     = "us-west-2"
  description = "AWS Region, e.g. us-east-1."
}

variable "tgw_id" {
  type        = string
  default     = "tgw-0d5cea5c3439e8623"
  description = "Transit gateway ID"
}

variable "flow_log_destination_arn" {
  type        = string
  default     = "arn:aws:s3:::aws-vpc-flow-logs-538275038169-us-west-2/"
  description = "The ARN of flow log destination"
}
  
variable "enable_database_subnets" {
  description = "Controls if database subnets should be created"
  type        = bool
  default     = true
}

variable "enable_elasticache_subnets" {
  description = "Controls if elasticache subnets should be created"
  type        = bool
  default     = true
}

variable "enable_redshift_subnets" {
  description = "Controls if redshift subnets should be created"
  type        = bool
  default     = true
}

variable "enable_intra_subnets" {
  description = "Controls if intra subnets should be created"
  type        = bool
  default     = true
}

variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  default     = "0.0.0.0/0"
}

variable "azs" {
  description = "A list of availability zones in the region"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "database_subnets" {
  type        = list(string)
  description = "A list of database subnets"
  default     = []
}

variable "redshift_subnets" {
  type        = list(string)
  description = "A list of redshift subnets"
  default     = []
}

variable "elasticache_subnets" {
  type        = list(string)
  description = "A list of elasticache subnets"
  default     = []
}

# "private" versus "intra" subnets
/*
By default, if NAT Gateways are enabled, private subnets will be configured with routes for Internet traffic that point at the NAT Gateways configured by use of the above options.

If you need private subnets that should have no Internet routing (in the sense of RFC1918 Category 1 subnets), intra_subnets should be specified. An example use case is configuration of AWS Lambda functions within a VPC, where AWS Lambda functions only need to pass traffic to internal resources or VPC endpoints for AWS services.

Since AWS Lambda functions allocate Elastic Network Interfaces in proportion to the traffic received (read more), it can be useful to allocate a large private subnet for such allocations, while keeping the traffic they generate entirely internal to the VPC.

You can add additional tags with intra_subnet_tags as with other subnet types.
*/
variable "intra_subnets" {
  type        = list(string)
  description = "A list of intra subnets"
  default     = []
}

variable "dhcp_options_domain_name_servers" {
  description = "Specify a list of DNS server addresses for DHCP options set, default to AWS provided"
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
}

variable "amazon_side_asn" {
  description = "The Autonomous System Number (ASN) for the Amazon side of the gateway. By default the virtual private gateway is created with the current default Amazon ASN."
  default     = "7224"
}

