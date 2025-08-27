#!/bin/bash
set -e

echo "=== Nettoyage des anciens dépôts Docker ==="
sudo rm -f /etc/apt/sources.list.d/docker.list
sudo rm -f /etc/apt/sources.list.d/archive_uri-https_download_docker_com_linux_ubuntu-noble.list

echo "=== Mise à jour du système ==="
sudo apt update && sudo apt upgrade -y

echo "=== Installation des dépendances ==="
sudo apt install -y ca-certificates curl gnupg lsb-release

echo "=== Ajout de la clé GPG Docker ==="
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "=== Ajout du dépôt Docker officiel ==="
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu noble stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "=== Mise à jour des dépôts ==="
sudo apt update

echo "=== Installation de Docker CE et plugins ==="
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "=== Ajout de l’utilisateur actuel au groupe docker ==="
sudo usermod -aG docker $USER

echo "=== Installation de Docker Compose (binaire) ==="
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "=== Vérification des versions installées ==="
docker --version
docker-compose --version

echo "=== Installation de Portainer ==="
sudo docker volume create portainer_data
sudo docker run -d -p 9000:9000 -p 9443:9443 \
    --name portainer \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce:latest

echo "=== Installation terminée avec succès ✅ ==="
echo "Accède à Portainer via : http://IP_DE_TON_VPS:9000 ou https://IP_DE_TON_VPS:9443"
