#!/bin/bash
sudo apt update -y && sudo apt upgrade -y
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
sudo python3 ./setup <<< $'1\nn\n${tenant}\nhttps\n${port}\n${jwt}\n${password}\n${password}\nn\n'
sudo ./start