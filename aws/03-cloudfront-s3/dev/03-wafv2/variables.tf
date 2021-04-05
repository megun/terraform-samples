variable "developers" {
  type = list(string)
  default = [
    "1.1.1.1/32",
    "2.2.2.2/32",
    #chomp(data.http.ifconfig.body)
  ]
}
