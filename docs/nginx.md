# HTTPS NGINX

Além do **Security Group** estar configurado para permitir acesso na porta **443** (HTTPS), precisamos adicionar os certificados SSL/TLS.

1. **Certificado SSL/TLS para HTTPS**
   Para que a aplicação funcione via HTTPS, o servidor NGINX precisa estar configurado com um certificado SSL válido. 
   Precisa adicionar noplaybook do Ansible, a configuração de certificados SSL para a porta 443.

   **Solução:**
   - Você precisará garantir que o NGINX esteja configurado para suportar HTTPS. Para isso, será necessário criar ou usar um certificado SSL e configurar o NGINX para escutar na porta 443.

   Exemplo de configuração no **NGINX** para HTTPS:

   ```nginx
   server {
       listen 443 ssl;
       server_name example.com;

       ssl_certificate /etc/nginx/ssl/nginx.crt;
       ssl_certificate_key /etc/nginx/ssl/nginx.key;

       location / {
           root /usr/share/nginx/html;
           index index.html;
       }
   }

   # Redireciona HTTP para HTTPS
   server {
       listen 80;
       server_name example.com;
       return 301 https://$host$request_uri;
   }
   ```

   Você precisará garantir que os arquivos de certificado (`nginx.crt` e `nginx.key`) estejam disponíveis no servidor e configurá-los corretamente.

2. **Instalação de um Certificado SSL (Autoassinado ou de Autoridade Certificadora)**
   Se você não tiver um certificado SSL configurado, pode gerar um **autoassinado** para testar:

   ```bash
   sudo mkdir -p /etc/nginx/ssl
   sudo openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
   ```

   Essa abordagem cria um certificado autoassinado, mas lembre-se de que ele não será confiável para navegadores (gerando alertas). Para uma implementação em produção, você deve obter um certificado de uma autoridade certificadora (CA).

3. **Verificar a configuração do Security Group**
   O seu **Security Group** já está configurado corretamente para permitir o tráfego na porta 443, então isso não deve ser o problema, desde que o tráfego realmente esteja chegando à instância e o NGINX esteja configurado para escutar nessa porta.

4. **Verificar se o NGINX está escutando na porta 443**
   Verifique se o NGINX está escutando corretamente na porta **443**. Você pode fazer isso com o seguinte comando na instância EC2:

   ```bash
   sudo netstat -tuln | grep 443
   ```

   Se não aparecer nenhuma linha referente à porta 443, significa que o NGINX não está configurado para escutar nessa porta.

   **Solução:**
   Certifique-se de que a configuração do NGINX foi atualizada para escutar na porta 443 conforme mencionado no passo 1.

5. **Reiniciar o NGINX após a configuração do SSL**
   Depois de atualizar a configuração do NGINX para HTTPS, não se esqueça de reiniciar o serviço para aplicar as mudanças:

   ```bash
   sudo systemctl restart nginx
   ```

6. **Verificar se a instância está acessível via HTTPS**
   Depois de configurar corretamente o NGINX e o SSL, tente acessar novamente o IP público da instância com o prefixo `https://` no navegador:

   ```text
   https://<IP_PÚBLICO>
   ```

   Se estiver usando um nome de domínio, o processo será o mesmo, só trocando o IP pelo domínio configurado no NGINX.

### Resumo dos passos para resolver:

1. **Configurar um certificado SSL no servidor** (autoassinado ou oficial).
2. **Atualizar a configuração do NGINX** para escutar na porta 443 e usar o certificado SSL.
3. **Reiniciar o NGINX** para aplicar as mudanças.
4. Verificar a conectividade via HTTPS (não apenas HTTP).

Se você já configurou o certificado SSL, mas ainda está com problemas, compartilhe mais detalhes sobre a configuração ou erro que aparece no navegador, e posso ajudar mais a fundo!