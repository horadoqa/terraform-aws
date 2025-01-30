variable "aws_region" {
  type        = string
  # default     = "us-east-1"
  description = "Região onde será criada a instância"
}

variable "aws_ami" {
  type        = string
  # default     = "ami-0c614dee691cbbf37"
  description = "Imagem da instância"
}

variable "instance_type" {
  type        = string
  # default     = "t2.micro"
  description = "Tipo da Instância"
}

variable "number_instances" {
  type        = number
  default     = 1
  description = "Numero de instancias"
}