variable "namespace" {
  type        = string
  default     = "bcaa"
  description = "Namespace (e.g. `bcaa` or `evo`)"
}

variable "stage" {
  type        = string
  default     = "ops"
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
}

variable "name" {
  type        = string
  description = "Name  (e.g. `app` or `db`)"
  default     = "vault"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `policy` or `role`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map('BusinessUnit`,`XYZ`)"
}

variable "cluster_tag_key" {
  description = "Add a tag with this key and the value var.cluster_tag_value to each Instance in the ASG. This can be used to automatically find other Consul nodes and form a cluster."
  type        = string
  default     = "aws-consul"
}

variable "cluster_tag_value" {
  description = "Add a tag with key var.clsuter_tag_key and this value to each Instance in the ASG. This can be used to automatically find other Consul nodes and form a cluster."
  type        = string
  default     = "auto-join"
}

variable "prefix" {
  type        = string
  description = "The S3 bucket prefix for the AWSLogs"
  default     = ""
}

variable "lifecycle_rule_enabled" {
  description = "Enable lifecycle events on this bucket"
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "A state of versioning. Versioning is a means of keeping multiple variants of an object in the same bucket."
  type        = bool
  default     = true
}

variable "policy" {
  type        = string
  description = "A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the verbose/specific version of the policy."
  default     = ""
}

variable "standard_transition_days" {
  type        = number
  description = "Number of days to persist in the standard storage tier before moving to the infrequent access tier"
  default     = 30
}

variable "glacier_transition_days" {
  type        = number
  description = "Number of days after which to move the data to the glacier storage tier"
  default     = 60
}

variable "expiration_days" {
  type        = number
  description = "Number of days after which to expunge the objects"
  default     = 90
}

variable "block_public_acls" {
  type        = bool
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  default     = true
}

variable "block_public_policy" {
  type        = bool
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  default     = true
}

variable "ignore_public_acls" {
  type        = bool
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  default     = true
}

variable "restrict_public_buckets" {
  type        = bool
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  default     = true
}

variable "acl" {
  type        = string
  description = "Canned ACL to apply to the S3 bucket"
  default     = "log-delivery-write"
}

variable "force_destroy" {
  type        = bool
  description = "(Optional, Default:false ) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  default     = false
}

variable "sse_algorithm" {
  type        = string
  description = "The server-side encryption algorithm to use. Valid values are AES256 and aws:kms"
  default     = "aws:kms"
}

#variable "kms_master_key_id" {
#  description = "The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse_algorithm is aws:kms"
#  default     = ""
#}


variable "api_port" {
  description = "The port to use for Vault API calls"
  default     = 8200
}

variable "cluster_port" {
  description = "The port to use for Vault server-to-server communication"
  default     = 8201
}

variable "instance_type" {
  type        = string
  description = "Instance type to launch"
  default     = "t3.small"
}

variable "key_name" {
  type        = string
  description = "The SSH key name that should be used for the instance"
  default     = "bcaa-ops-keypair"
}

variable "elb_internal" {
  type        = bool
  description = "If true, ELB will be an internal ELB"
  default     = true
}

variable "elb_cross_zone_load_balancing" {
  type        = bool
  description = "Set to true to enable cross-zone load balancing"
  default     = true
}

variable "elb_idle_timeout" {
  type        = number
  description = "The time, in seconds, that the connection is allowed to be idle."
  default     = 60
}

variable "elb_connection_draining" {
  type        = bool
  description = "Set to true to enable connection draining."
  default     = true
}

variable "elb_connection_draining_timeout" {
  type        = number
  description = "The time, in seconds, to allow for connections to drain."
  default     = 300
}

variable "lb_port" {
  type        = string
  description = "The port the load balancer should listen on for API requests."
  default     = "443"
}

variable "vault_api_port" {
  type        = string
  description = "The port to listen on for API requests."
  default     = "8200"
}

variable "health_check_protocol" {
  type        = string
  description = "The protocol to use for health checks. Must be one of: HTTP, HTTPS, TCP, SSL."
  default     = "HTTP"
}

variable "health_check_path" {
  type        = string
  description = "The path to use for health checks. Must return a 200 OK when the service is ready to receive requests from the ELB."
  default     = "/v1/sys/health?standbyok=true"
}

variable "health_check_port" {
  type        = string
  description = "The port to use for health checks if not vault_api_port."
  default     = 0
}

variable "health_check_interval" {
  type        = string
  description = "The amount of time, in seconds, between health checks."
  default     = 15
}

variable "health_check_healthy_threshold" {
  type        = string
  description = "The number of health checks that must pass before the instance is declared healthy."
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  type        = string
  description = "The number of health checks that must fail before the instance is declared unhealthy."
  default     = 2
}

variable "health_check_timeout" {
  type        = string  
  description = "The amount of time, in seconds, before a health check times out."
  default     = 5
}