# Configuração de HTTPS no NGINX

Para habilitar o acesso via **HTTPS** em sua aplicação hospedada no NGINX, é necessário configurar corretamente o servidor para suportar SSL/TLS. Isso inclui a criação de um certificado SSL (autoassinado ou de uma autoridade certificadora) e a configuração adequada do NGINX para escutar na porta 443.

## 1. **Configuração do Certificado SSL/TLS**

Para que a aplicação funcione via HTTPS, o NGINX deve estar configurado com um certificado SSL válido. Isso pode ser feito de duas maneiras:

- **Certificado SSL autoassinado** (gerado manualmente).
- **Certificado SSL de uma autoridade certificadora** (para produção).

### Solução

Você precisará:

- Garantir que o NGINX esteja configurado para suportar HTTPS na porta 443.
- Criar ou configurar um certificado SSL.
- Atualizar o arquivo de configuração do NGINX para incluir as instruções SSL.

### Exemplo de Configuração do NGINX para HTTPS (nginx.conf)

```nginx
# Settings for a TLS enabled server.

   server {
       listen       443 ssl;
       listen       [::]:443 ssl;
       http2        on;
       server_name  _;
        root         /usr/share/nginx/html;

        ssl_certificate "/etc/pki/nginx/server.crt";
        ssl_certificate_key "/etc/pki/nginx/private/server.key";
        ssl_session_cache shared:SSL:1m;
        ssl_session_timeout  10m;
        ssl_ciphers PROFILE=SYSTEM;
        ssl_prefer_server_ciphers on;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
```

---

## 2. **Gerando um Certificado SSL Autoassinado**

Se você ainda não tem um certificado SSL, pode gerar um **autoassinado** para fins de teste. Para isso, siga os passos abaixo:

### Passos para Gerar Certificado SSL

1. **Conecte-se à instância EC2**:

   ```bash
   ssh -i ~/.ssh/id_rsa ec2-user@<IP_PÚBLICO_DA_INSTÂNCIA>
   ```

2. **Crie o diretório onde os certificados serão armazenados**:

   ```bash
   sudo mkdir -p /etc/pki/nginx/private
   ```

3. **Gere o certificado SSL e a chave privada** usando o `openssl`:

   ```bash
   sudo openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout /etc/pki/nginx/private/server.key -out /etc/pki/nginx/server.crt
   ```

   Durante a execução do comando, você será solicitado a inserir algumas informações, como nome da organização e nome do servidor (use o IP da instância ou um domínio, se tiver).

   Country Name (2 letter code) [XX]: BR
   State or Province Name (full name) []: Rio de Janeiro
   Locality Name (eg, city) [Default City]: Rio de Janeiro
   Organization Name (eg, company) [Default Company Ltd]: Hora do QA
   Organizational Unit Name (eg, section) []: Infraestrutura
   Common Name (eg, your name or your server's hostname) []: horadoqa.com.br
   Email Address []: contato@horadoqa.com

4. **Verifique os arquivos gerados**:

**Importante:** Certifique-se de que os arquivos de certificado (`nginx.crt` e `nginx.key`) estejam no diretório correto e que as permissões estejam configuradas adequadamente.

   Após gerar o certificado e a chave, verifique se eles existem:

   ```bash
   sudo ls -l /etc/pki/nginx/server.crt
   -rw-r--r--. 1 root root 1387 Jan 30 18:51 /etc/pki/nginx/server.crt
   ```

   ```bash
   sudo ls -l /etc/pki/nginx/private/server.key
   -rw-------. 1 root root 1704 Jan 30 18:50 /etc/pki/nginx/private/server.key
   ```

5. **Ajuste as permissões dos arquivos** para garantir que o NGINX tenha acesso:

   ```bash
   sudo chmod 644 /etc/pki/nginx/server.crt
   sudo chmod 600 /etc/pki/nginx/private/server.key
   sudo chown nginx:nginx /etc/pki/nginx/server.crt
   sudo chown nginx:nginx /etc/pki/nginx/private/server.key
   ```

6. **Teste a configuração do NGINX** para garantir que não há erros de sintaxe:

   ```bash
   sudo nginx -t
   ```
   
   A resposta

   ```bash
   nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
   nginx: configuration file /etc/nginx/nginx.conf test is successful
   ```

7. **Reinicie o NGINX** para aplicar as mudanças:

   ```bash
   sudo systemctl restart nginx
   ```

---

## 3. **Configuração do NGINX para Usar o Certificado SSL**

Após gerar o certificado, edite o arquivo de configuração do NGINX para habilitar o suporte a HTTPS.

1. **Abra o arquivo de configuração do NGINX**:

   O arquivo de configuração principal geralmente está em **`/etc/nginx/nginx.conf`**, mas ele pode estar em outro local, como **`/etc/nginx/sites-available/`**. Use o comando abaixo para editar o arquivo:

   ```bash
   sudo vi /etc/nginx/nginx.conf
   ```

2. **Adicione a configuração de SSL** para a porta 443:

   ```nginx
   # Configurações do servidor TLS (SSL)
   server {
       listen 443 ssl;
       server_name _;

       ssl_certificate "/etc/nginx/ssl/nginx.crt";
       ssl_certificate_key "/etc/nginx/ssl/nginx.key";
       ssl_session_cache shared:SSL:1m;
       ssl_session_timeout 10m;
       ssl_ciphers PROFILE=SYSTEM;
       ssl_prefer_server_ciphers on;

       root /usr/share/nginx/html;
       index index.html;

       # Configurações de erro
       error_page 404 /404.html;
       location = /404.html {}

       error_page 500 502 503 504 /50x.html;
       location = /50x.html {}
   }

   # Redireciona HTTP para HTTPS
   server {
       listen 80;
       server_name _;

       return 301 https://$host$request_uri;
   }
   ```

3. **Salve as mudanças** e saia do editor.

4. **Reinicie o NGINX** para aplicar as configurações:

```bash
sudo systemctl restart nginx
```
## 4. **Verificar a Configuração**

### Verificar se o NGINX está escutando na porta 443

Para garantir que o NGINX está escutando na porta 443, execute:

```bash
sudo netstat -tuln | grep 443
tcp        0      0 0.0.0.0:443             0.0.0.0:*               LISTEN     
tcp6       0      0 :::443                  :::*                    LISTEN 
```

Se o comando retornar uma linha indicando que a porta 443 está em uso, isso significa que o NGINX está configurado corretamente.

### Verificar o Status do NGINX

Verifique o status do serviço NGINX para confirmar que ele está ativo e sem erros:

```bash
sudo systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; preset: disabled)
     Active: active (running) since Thu 2025-01-30 19:23:47 UTC; 53s ago
    Process: 27682 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 27683 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 27684 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 27685 (nginx)
      Tasks: 2 (limit: 1111)
     Memory: 2.6M
        CPU: 41ms
     CGroup: /system.slice/nginx.service
             ├─27685 "nginx: master process /usr/sbin/nginx"
             └─27686 "nginx: worker process"

Jan 30 19:23:47 ip-172-31-94-233.ec2.internal systemd[1]: Starting nginx.service - The nginx HTTP and reverse proxy server...
Jan 30 19:23:47 ip-172-31-94-233.ec2.internal nginx[27683]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Jan 30 19:23:47 ip-172-31-94-233.ec2.internal nginx[27683]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Jan 30 19:23:47 ip-172-31-94-233.ec2.internal systemd[1]: Started nginx.service - The nginx HTTP and reverse proxy server.
```

Se o serviço estiver ativo e em execução, a configuração foi aplicada corretamente.

---

## 5. **Verificar Acessibilidade via HTTPS**

Após configurar o NGINX, tente acessar a aplicação através do navegador utilizando o prefixo **`https://`** seguido do IP público ou domínio da instância:

```text
https://<IP_PÚBLICO_DA_INSTÂNCIA>
```

Se você estiver usando um domínio configurado no NGINX, substitua o IP pelo nome do domínio.

**Atenção:** Se você estiver usando um certificado autoassinado, o navegador provavelmente exibirá um alerta de segurança. Para fins de testes, basta ignorar o aviso e continuar.

---

## Resumo dos Passos

1. **Gerar ou obter um certificado SSL** (autoassinado ou oficial).
2. **Configurar o NGINX** para escutar na porta 443 e usar o certificado SSL.
3. **Reiniciar o NGINX** para aplicar as configurações.
4. **Verificar a conectividade via HTTPS**.
