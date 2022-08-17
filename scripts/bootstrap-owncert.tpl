#!/bin/bash
sudo apt update -y && sudo apt upgrade -y
sudo apt-get install jq -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt install docker-ce -y
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo systemctl enable docker
sudo systemctl status docker
sudo mkdir netskope && cd netskope
sudo git clone https://github.com/netskopeoss/ta_cloud_exchange
cd ta_cloud_exchange
sudo python3 ./setup <<< $'n\n${tenant}\nhttps\n${port}\n${jwt}\n${password}\n${password}\nn\n${beta}\n'
TOKEN=$(curl -s 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fvault.azure.net' -H Metadata:true | jq -r '.access_token')
sudo curl '${kv}secrets/ce-cert?api-version=2016-10-01' -H "Authorization: Bearer "$TOKEN"" | jq -r '.value' | tee /netskope/ta_cloud_exchange/data/ssl_certs/cte_cert.crt > /dev/null
sudo curl '${kv}secrets/ce-key?api-version=2016-10-01' -H "Authorization: Bearer "$TOKEN"" | jq -r '.value'  | tee /netskope/ta_cloud_exchange/data/ssl_certs/cte_cert_key.key > /dev/null
sudo ./start