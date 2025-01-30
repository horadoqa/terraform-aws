# Script para gerar o certificado

1. **Copiar script para a instância**

```bash
scp -i ~/.ssh/id_rsa setup_nginx_https.sh ec2-user@44.212.56.143:/home/ec2-user/
```

2. **Copiar arquivo de conf do NGINX para a instância**

```bash
scp -i ~/.ssh/id_rsa certificado/nginx.conf ec2-user@44.212.56.143:/home/ec2-user/nginx.conf
```

4. **Conecte-se à instância EC2**:

```bash
ssh -i ~/.ssh/id_rsa ec2-user@44.212.56.143
```

5. **Mover o arquivo para a pasta do NGINX**

```bash
sudo mv /home/ec2-user/nginx.conf /etc/nginx/nginx.conf
```

6. **Executar o script**

```bash
sudo ./setup_nginx_https.sh
```

---

HTTPS configurado com sucesso!