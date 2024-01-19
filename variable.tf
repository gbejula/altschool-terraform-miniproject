variable "ami" {
    default = "ami-0faab6bdbac9486fb"
    type = string
}

variable "type" {
    default = "t2.micro"
    type = string
}

variable "key_pair" {
  default = "server2-london"
}

variable "availability_zone" {
    type = map(any)
    default = {
      "a" = "us-east-1a"
      "b" = "us-east-2b"
    }
  
}