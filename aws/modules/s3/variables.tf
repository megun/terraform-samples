variable "project" {
  type    = string
  default = ""
}

variable "env" {
  type    = string
  default = ""
}

variable "name" {
  type = string
}

variable "acl" {
  type    = string
  default = null
}

variable "block_all_public_access" {
  type    = bool
  default = false
}

variable "block_public_acls" {
  type    = bool
  default = null
}

variable "block_public_policy" {
  type    = bool
  default = null
}

variable "restrict_public_buckets" {
  type    = bool
  default = null
}

variable "ignore_public_acls" {
  type    = bool
  default = null
}

variable "sse_enc_defaults" {
  type    = list(map(string))
  default = []
}

variable "versioning" {
  type    = bool
  default = false
}

variable "mfa_delete" {
  type    = bool
  default = false
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "policy" {
  type    = string
  default = null
}

variable "grants" {
  type    = any
  default = []
}

variable "website" {
  type = any
  default = []
}
