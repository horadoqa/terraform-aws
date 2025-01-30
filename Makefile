# Variáveis
TF_DIR := ./terraform
ANSIBLE_AMZ_DIR := ./ansible/AmazonLinux
TF_VAR_FILE := env/dev.tfvars  # Use apenas o nome do arquivo, sem o caminho extra
INVENTORY_AMZ_FILE := $(ANSIBLE_AMZ_DIR)/inventory.ini
ANSIBLE_PLAYBOOK := $(ANSIBLE_AMZ_DIR)/horadoqa.yml  # Caminho correto para o playbook

# Comandos
TF_CMD := terraform
ANSIBLE_CMD := ansible-playbook

# Targets

# Inicializar e aplicar o Terraform
.PHONY: terraform-init terraform-apply terraform-destroy

terraform-init:
	@echo "Inicializando o Terraform..."
	cd $(TF_DIR) && $(TF_CMD) init

terraform-apply: terraform-init
	@echo "Aplicando o Terraform..."
	cd $(TF_DIR) && $(TF_CMD) apply -var-file=$(TF_VAR_FILE) -auto-approve

terraform-destroy:
	@echo "Destruindo a infraestrutura com Terraform..."
	cd $(TF_DIR) && $(TF_CMD) destroy -var-file=$(TF_VAR_FILE) -auto-approve
	@echo "[web]" > $(INVENTORY_AMZ_FILE)

# Rodar o Ansible para Amazon Linux
.PHONY: ansible-playbook-amz

ansible-playbook-amz: terraform-apply
	@sleep 60
	@echo "Adicionando o IP público da instância no arquivo inventory.ini..."
	@echo "$(shell terraform -chdir=$(TF_DIR) output -json instance_public_ip | jq -r '.[0]') ansible_ssh_user=ec2-user ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> $(INVENTORY_AMZ_FILE)
	@echo "Executando o playbook do Ansible para Amazon Linux..."
	$(ANSIBLE_CMD) -i $(INVENTORY_AMZ_FILE) $(ANSIBLE_PLAYBOOK)

# Menu para Deploy ou Destruir a Infraestrutura
.PHONY: menu

menu:
	@echo "Escolha uma opção:"
	@echo "1. Criar infraestrutura (Deploy)"
	@echo "2. Destruir infraestrutura"
	@echo "3. Sair"
	@read option; \
	if [ $$option -eq 1 ]; then \
		make deploy-amz; \
	elif [ $$option -eq 2 ]; then \
		make terraform-destroy; \
	elif [ $$option -eq 3 ]; then \
		echo "Saindo..."; \
	else \
		echo "Opção inválida!"; \
	fi

# Executar Terraform e Ansible para Amazon Linux
.PHONY: deploy-amz

deploy-amz: terraform-apply ansible-playbook-amz
	@echo "Deploy completo para Amazon Linux!"
	@echo "Acesse o site: https://$(shell terraform -chdir=$(TF_DIR) output -json instance_public_ip | jq -r '.[0]')"
