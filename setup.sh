#!/bin/bash

# Variables to be set for certificate generation:
country=""
state=""
city=""
organisation=""
department=""
servername=""

# Change current filepath to scripts directory
cd "$(dirname "$0")"

# Generate folders for ollama and open-webui
mkdir -p ollama
mkdir -p open-webui
mkdir -p nginx-gateway/cert

echo "Do you want to generate a certificate? (y/n)"
read generate_cert
if [ "$generate_cert" = "y" ]; then
    # Check if all required variables are set
    if [ -z "$country" ] || [ -z "$state" ] || [ -z "$city" ] || [ -z "$organisation" ] || [ -z "$department" ] || [ -z "$servername" ]; then
        echo "Please set the variables at the top of the setup script before proceeding. Script exiting."
        exit 1
    else
	# Generate SSL-Key and Certificate
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx-gateway/cert/nginx.key -out nginx-gateway/cert/nginx.crt -subj "/C=$country/ST=$state/L=$city/O=$organisation/OU=$department/CN=$servername"
    fi
fi

# Generate containers according to docker-compose.yaml file (must be in the same folder)
docker compose up -d
