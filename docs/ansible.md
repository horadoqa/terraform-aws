# Ansible

## Instalação

O Ansible está disponível nos repositórios oficiais do Ubuntu/Debian, permitindo uma instalação fácil via `apt`:

```bash
sudo apt install ansible
```

Para verificar se a instalação foi concluída com sucesso, execute:

```bash
ansible --version
```

## Atualização do Ansible

Você pode atualizar o Ansible de duas maneiras:

1. Usando o `pip`:

   ```bash
   pip install --upgrade ansible
   ```

2. Ou via `apt`:

   ```bash
   sudo apt update
   sudo apt upgrade ansible
   ```

## Adicionando Hosts ao Inventário

O arquivo de inventário do Ansible é onde você define seus hosts e grupos de hosts. No seu caso, você está criando um grupo de hosts chamado `web`. Para isso, adicione o IP ou o DNS da sua instância AWS no arquivo de inventário.

O arquivo de inventário padrão do Ansible está localizado em `/etc/ansible/hosts`, mas você pode optar por criar um arquivo de inventário personalizado. Exemplo de configuração:

```ini
[web]
<IP PÚBLICO AWS> ansible_ssh_user=ec2-user ansible_ssh_private_key_file=~/.ssh/id_rsa
```

## Validando a Conexão

Após adicionar os hosts ao arquivo de inventário, você pode testar a conectividade com o comando `ping`:

```bash
ansible web -m ping -i ansible/AmazonLinux/inventory.ini
```

A resposta será:

```json
<IP PÚBLICO AWS> | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.9"
    },
    "changed": false,
    "ping": "pong"
}
```

## Criando o Playbook do Ansible

Exemplo de Playbook para instalar e configurar o NGINX em suas instâncias:

```yaml
---
- name: Instalar e configurar o NGINX
  hosts: web
  become: yes
  tasks:
    - name: Atualizar o sistema
      apt:
        update_cache: yes
        upgrade: yes
        cache_valid_time: 3600

    - name: Instalar o NGINX
      apt:
        name: nginx
        state: present

    - name: Garantir que o serviço NGINX esteja rodando
      service:
        name: nginx
        state: started
        enabled: yes
```

Este playbook irá:

- Atualizar o sistema.
- Instalar o NGINX.
- Garantir que o serviço NGINX esteja rodando e habilitado para iniciar automaticamente.

## Executando o Playbook do Ansible

Para rodar o playbook, use o seguinte comando:

```bash
ansible-playbook -i inventory.ini horadoqa.yml
```

## Acessando o site

Após a execução do playbook, o NGINX estará instalado e em execução. Para verificar, acesse a URL:

```
http://<IP PÚBLICO AWS>
```
