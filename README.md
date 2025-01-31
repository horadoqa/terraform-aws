# AWS / Terraform / Ansible / Makefile

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
│   ├── certificado
│   │   ├── dev
│   │   │   └── nginx.md
│   │   ├── nginx.conf
│   │   ├── prod
│   │   │   └── nginx.md
│   │   ├── scp.md
│   │   └── setup_nginx_https.sh
│   └── ubuntu
│       ├── inventory.ini
│       └── nginx.yml
├── docs
│   ├── ansible.md
│   ├── make.md
│   └── terraform.md
├── images
│   ├── horadoqa.png
│   └── hqa.png
└── terraform
    ├── env
    │   ├── dev.tfvars
    │   ├── prod.tfvars
    │   └── staging.tfvars
    ├── main.tf
    ├── resource.tf
    ├── security_group.tf
    ├── terraform.tfstate
    ├── terraform.tfstate.backup
    └── variables.tf

11 directories, 29 files
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

## Como Contribuir

Se você deseja contribuir para este projeto, siga as etapas abaixo:

1. **Fork o repositório**:
   - Clique no botão "Fork" no canto superior direito da página do projeto no GitHub.

2. **Clone o repositório**:
   - Clone o seu repositório para a sua máquina local.

   ```bash
   git clone https://github.com/seu-usuario/hora-do-qa.git
   ```

3. **Faça suas alterações**:
   - Crie uma nova branch para as suas alterações:

   ```bash
   git checkout -b minha-nova-funcionalidade
   ```

4. **Suba suas alterações**:
   - Depois de concluir suas alterações, faça commit e envie-as para o repositório remoto.

   ```bash
   git add .
   git commit -m "Adiciona nova funcionalidade"
   git push origin minha-nova-funcionalidade
   ```

5. **Abra um Pull Request**:
   - Vá até o seu repositório no GitHub e clique em "New Pull Request" para enviar suas alterações para o repositório original.

