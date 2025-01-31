# Terraform

## Instalação no Linux

Para instalar o Terraform em uma distribuição Linux, você pode seguir os passos abaixo. O método pode variar dependendo da sua distribuição, mas, de forma geral, você pode utilizar os pacotes disponíveis para o Ubuntu/Debian ou o gerenciador de pacotes `wget` para fazer o download manual.

1. **Para distribuições baseadas em Debian/Ubuntu**:
   
   Adicione o repositório oficial do Terraform e instale com o `apt`:

   ```bash
   sudo apt update && sudo apt install -y gnupg software-properties-common
   curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor > /usr/share/keyrings/hashicorp-archive-keyring.gpg
   sudo apt update
   sudo apt install terraform
   ```

2. **Alternativamente, via `wget` (para qualquer distribuição)**:

   Baixe o pacote diretamente do site oficial do Terraform:

   ```bash
   wget https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip
   unzip terraform_1.5.0_linux_amd64.zip
   sudo mv terraform /usr/local/bin/
   ```

   **Nota**: Verifique a versão mais recente no [site oficial](https://www.terraform.io/downloads.html).

## Verificando a Instalação

Após a instalação, verifique se o Terraform foi instalado corretamente, executando o seguinte comando:

```bash
terraform --version
```

Isso retornará a versão do Terraform instalada no seu sistema.

## Inicializando o Terraform

Antes de começar a trabalhar com o Terraform, é necessário inicializar o ambiente. Isso prepara o diretório de trabalho e baixa os plugins necessários.

```bash
terraform init
```

Esse comando irá configurar o backend e os providers necessários, preparando o ambiente para a execução de comandos posteriores.

## Validando o Plano de Execução

Para ver o que o Terraform irá fazer antes de aplicar as mudanças, utilize o comando `plan`. Ele gera um plano de execução, detalhando as ações que o Terraform realizará, sem fazer alterações efetivas.

```bash
terraform plan
```

Isso permitirá que você revise as mudanças propostas e evite configurações indesejadas.

## Criando a Infraestrutura

Após revisar o plano com `terraform plan`, você pode aplicar as mudanças com o comando `apply`. O Terraform criará ou modificará os recursos definidos nos arquivos de configuração.

```bash
terraform apply -auto-approve
```

A opção `-auto-approve` faz com que o Terraform aplique as mudanças automaticamente, sem pedir confirmação. **Use com cautela.**

## Destruindo a Infraestrutura

Caso precise destruir a infraestrutura criada (por exemplo, para limpeza ou testes), utilize o comando `destroy`. Isso removerá todos os recursos criados.

```bash
terraform destroy -auto-approve
```

Assim como no `apply`, o `-auto-approve` permite que a destruição aconteça sem confirmação manual. **Cuidado para não destruir recursos acidentalmente.**

## Formatando os arquivos

O comando `terraform fmt -recursive` formata os arquivos utilizados no terraform

```bash
terraform fmt -recursive
```

## Exibir o estado atual do Terraform 

O comando `terraform show` é utilizado no Terraform para exibir o estado atual de uma infraestrutura gerida pelo Terraform.

```bash
terraform show 
```

Em formato `json`

```bash
terraform show json
```