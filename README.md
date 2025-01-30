# AWS / Terraform / Ansible Makefile

<div align="center">
    <img src="./images/hqa.png" alt="Hora do QA">
</div>

## Objetivo desse projeto:

- Provisionar a infraestrutura com Terraform,
- Automatizar a implantação da aplicação com Ansible e 
- Gerenciar o fluxo de trabalho com Makefile.

## Estrutura do projeto

```bash
tree
.
├── Makefile
├── README.md
├── ansible
│   ├── AmazonLinux
│   │   ├── horadoqa.yml
│   │   ├── inventory.ini
│   │   ├── nginx.yml
│   │   └── site
│   │       ├── index.html
│   │       ├── script.js
│   │       └── style.css
│   └── ubuntu
│       └── install_nginx.yml
├── docs
│   ├── ansible.md
│   ├── make.md
│   ├── makefile-funcionando.md
│   └── terraform.md
└── terraform
    ├── ec2.tf
    ├── env
    │   ├── dev.tfvars
    │   ├── prod.tfvars
    │   └── staging.tfvars
    ├── main.tf
    ├── sg.tf
    ├── terraform.tfstate
    ├── terraform.tfstate.backup
    └── variables.tf

7 directories, 22 files
```

## Executando Deploy para Amazon Linux

Para realizar o deploy para uma instância **Amazon Linux**, basta executar o comando:

```bash
make menu

Escolha uma opção:
1. Criar infraestrutura (Deploy)
2. Destruir infraestrutura
3. Sair
```

Este comando irá:

- Executar as tarefas definidas no Makefile para provisionar ou atualizar a aplicação na instância Amazon Linux.
- Garantir que todas as dependências necessárias sejam instaladas.
- Automatizar o processo de deploy, evitando a necessidade de rodar comandos manualmente.

## Resultado

Acessando o endereço: `http://<IP PÚBLICO AWS>`

<div align="center">
    <img src="./images/horadoqa.png" alt="Hora do QA">
</div>