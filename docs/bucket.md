# BUCKET S3

O **S3 Bucket** é um **armazenamento de objetos** da AWS, onde você pode guardar praticamente qualquer tipo de dado, como arquivos, imagens, vídeos, backups e até o estado do Terraform.

### Resumo de suas principais funcionalidades:

1. **Armazenamento de Dados**: Serve para armazenar e organizar dados em objetos. Cada objeto pode ser um arquivo ou qualquer dado em formato binário. Esses objetos são organizados dentro de "buckets" (baldes).

2. **Acessibilidade**: Você pode acessar os dados de qualquer lugar pela internet, com permissão adequada. Pode ser usado para armazenar e recuperar dados para aplicativos, sites ou backups.

3. **Segurança**: Com o S3, você pode configurar **políticas de acesso**, **criptografia** e **controle de versão** para garantir que seus dados sejam seguros e gerenciáveis.

4. **Escalabilidade**: O S3 é altamente escalável, ou seja, você pode armazenar de poucos bytes até petabytes de dados sem se preocupar com a infraestrutura subjacente.

5. **Backup e Recuperação**: Ideal para armazenar backups e fornecer uma camada de recuperação em caso de falhas de sistema ou desastres.

6. **Armazenamento de Estado (Terraform)**: No caso do Terraform, o **bucket S3** é usado para armazenar o estado remoto, permitindo que várias pessoas ou equipes compartilhem e manipulem a infraestrutura de forma sincronizada.

### Exemplos de Uso:

- **Armazenamento de arquivos estáticos**: Imagens, vídeos, documentos, backups, etc.
- **Armazenamento de logs de aplicativos ou sistemas**.
- **Armazenamento de estado do Terraform** para gerenciar infraestruturas em equipe.
- **Hosting de sites estáticos** (como sites em HTML/CSS/JS).

Em resumo, o **S3 Bucket** é uma solução de armazenamento altamente flexível e segura na nuvem, ideal para muitas necessidades de armazenamento de dados.

Se precisar de mais detalhes ou exemplos específicos, só avisar! 😊

Precisamos que o usuário tenha permissão `AmazonS3FullAccess` para trabalhar com BUCKET `S3`

## Criar um bucket na AWS

Podemos criar um bucket diretamente na linha de comando

```bash
aws s3api create-bucket --bucket tfstate-bucket-horadoqa --region us-east-1

{
    "Location": "/bucket-horadoqa"
}
```

## Criar o arquivo `bucket.tf`

```bash
resource "aws_s3_bucket" "remote_state" {
  bucket = "tfstate-bucket-horadoqa"

  tags = {
    Description = "Bucket para armazenar o estado remoto"
    ManageBy   = "hora do qa"
    Owner      = "Ricardo Fahham"
    CreatedAt  = "31/01/2025"
  }
}

resource "aws_s3_bucket_versioning" "remote_state_versioning" {
  bucket = aws_s3_bucket.remote_state.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

output "remote_state_bucket" {
  value = aws_s3_bucket.remote_state.bucket
}

output "remote_state_bucket_arn" {
  value = aws_s3_bucket.remote_state.arn
}

```

## Adicionar o bloco abaixo, dentro do terraform no arquivo `main.tf`

```bash
backend "s3" {
    bucket = "bucket-horadoqa"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
}
```

Executar o:

```bash
terraform init

terraform init                                                     
Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.
Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Using previously-installed hashicorp/aws v5.84.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

## Aplicar o Terraform

Dentro da pasta `terraform`

```bash
terraform apply -auto-approve -var-file=env/dev.tfvars

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

instance_public_ip = [
  "<IP PÚBLICO AWS>",
]
remote_state_bucket = "tfstate-bucket-horadoqa"
remote_state_bucket_arn = "arn:aws:s3:::tfstate-bucket-horadoqa"
```

## Verificar a criação do BUCKET

```bash
aws s3 ls

2025-01-31 09:12:10 bucket-horadoqa
2025-01-31 09:22:33 tfstate-bucket-horadoqa
```
A partir desta configuração, o arquivo `terraform-tfstate` vai ficar armazenado no bucket na AWS permitindo que outro integrantes do time tenham acesso.

## Para apagar o bucket

Passos para apagar o bucket:

1. Verifique se o bucket está vazio: Primeiro, verifique se o bucket não contém objetos. Você pode listar os objetos no bucket com o seguinte comando:

```bash
aws s3 ls s3://tfstate-bucket-horadoqa
```

Excluir os objetos no bucket (se houver algum):

Se o bucket tiver objetos, você precisa deletá-los. Você pode usar o seguinte comando para excluir todos os objetos dentro do bucket:

```bash
aws s3 rm s3://tfstate-bucket-horadoqa --recursive
```

Esse comando remove todos os arquivos dentro do bucket.

3. Apagar o bucket: Depois de garantir que o bucket está vazio, você pode deletá-lo com o seguinte comando:

```bash
aws s3api delete-bucket --bucket tfstate-bucket-horadoqa --region us-east-1
```
