# Tenta recuperar informações do bucket, se ele já existir
data "aws_s3_bucket" "existing_bucket" {
  bucket = "tfstate-bucket-horadoqa"
}

# Se o bucket não existir, cria o bucket
resource "aws_s3_bucket" "remote_state" {
  count  = length(data.aws_s3_bucket.existing_bucket.id) == 0 ? 1 : 0
  bucket = "tfstate-bucket-horadoqa"

  tags = {
    Description = "Bucket para armazenar o estado remoto"
    ManageBy    = "hora do qa"
    Owner       = "Ricardo Fahham"
    CreatedAt   = "31/01/2025"
  }
}

# Configuração do versionamento
resource "aws_s3_bucket_versioning" "remote_state_versioning" {
  bucket = length(data.aws_s3_bucket.existing_bucket.id) == 0 ? aws_s3_bucket.remote_state[0].bucket : data.aws_s3_bucket.existing_bucket.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

# Outputs, ajustando para o caso de o bucket já existir
output "remote_state_bucket" {
  value = length(data.aws_s3_bucket.existing_bucket.id) == 0 ? aws_s3_bucket.remote_state[0].bucket : data.aws_s3_bucket.existing_bucket.bucket
}

output "remote_state_bucket_arn" {
  value = length(data.aws_s3_bucket.existing_bucket.id) == 0 ? aws_s3_bucket.remote_state[0].arn : data.aws_s3_bucket.existing_bucket.arn
}
