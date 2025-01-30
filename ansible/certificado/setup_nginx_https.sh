#!/bin/bash

# Definindo variáveis
NGINX_SSL_DIR="/etc/pki/nginx"
PRIVATE_SSL_DIR="/etc/pki/nginx/private"
CERT_FILE="server.crt"
KEY_FILE="server.key"
NGINX_CONF_DIR="/etc/nginx/conf.d"
NGINX_CONF_FILE="$NGINX_CONF_DIR/default.conf"

# Verifica se o script está sendo executado como root
if [ "$(id -u)" -ne 0 ]; then
    echo "Este script precisa ser executado como root ou com sudo."
    exit 1
fi

# Passo 1: Criar diretórios para os certificados SSL
echo "Criando diretórios para certificados SSL..."
mkdir -p $NGINX_SSL_DIR
mkdir -p $PRIVATE_SSL_DIR

# Passo 2: Gerar certificado SSL autoassinado
echo "Gerando certificado SSL autoassinado..."
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout $PRIVATE_SSL_DIR/$KEY_FILE -out $NGINX_SSL_DIR/$CERT_FILE <<EOF
BR
Rio de Janeiro
Rio de Janeiro
Hora do QA
Infraestrutura
localhost
horadoqa@gmail.com
EOF

# Passo 3: Ajustar permissões dos arquivos de certificado
echo "Ajustando permissões dos arquivos de certificado..."
chmod 644 $NGINX_SSL_DIR/$CERT_FILE
chmod 600 $PRIVATE_SSL_DIR/$KEY_FILE
chown nginx:nginx $NGINX_SSL_DIR/$CERT_FILE
chown nginx:nginx $PRIVATE_SSL_DIR/$KEY_FILE

# Passo 4: Configurar o NGINX para usar SSL
echo "Configurando o NGINX para usar SSL..."


# Passo 5: Testar a configuração do NGINX
echo "Testando a configuração do NGINX..."
nginx -t
if [ $? -ne 0 ]; then
    echo "Erro na configuração do NGINX. Abortando."
    exit 1
fi

# Passo 6: Reiniciar o NGINX
echo "Reiniciando o NGINX para aplicar as mudanças..."
systemctl restart nginx

# Passo 7: Verificar se o NGINX está escutando na porta 443
echo "Verificando se o NGINX está escutando na porta 443..."
netstat -tuln | grep 443

echo "HTTPS configurado com sucesso!"
