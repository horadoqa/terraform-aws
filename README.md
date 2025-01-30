# terraform-aws

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
