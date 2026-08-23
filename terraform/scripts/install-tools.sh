#!/bin/bash
# This script runs ONCE, automatically, the first time jenkins-server boots.
# AWS calls this "user_data" - Terraform hands it to EC2, EC2 runs it as root on first boot.
set -e   # stop immediately if any command fails, so we don't continue on a broken install

exec > /var/log/user-data.log 2>&1   # log everything here so we can debug if something fails
echo "===== Bootstrap started: $(date) ====="

apt-get update -y
apt-get upgrade -y

# ---------- Docker ----------
# Jenkins needs Docker to build your app's image. Installing the official Docker repo
# (not the older 'docker.io' apt package) gives us the current, supported version.
apt-get install -y ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
usermod -aG docker ubuntu   # let the default 'ubuntu' user run docker without sudo

# ---------- Java (Jenkins requires it) ----------
apt-get install -y openjdk-17-jdk

# ---------- Jenkins ----------
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | gpg --dearmor -o /usr/share/keyrings/jenkins-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.gpg] https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list > /dev/null
apt-get update -y
apt-get install -y jenkins
usermod -aG docker jenkins   # Jenkins runs as its own 'jenkins' user - it needs docker group too
systemctl enable jenkins
systemctl start jenkins

# ---------- Trivy (image vulnerability scanner) ----------
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# ---------- SonarQube ----------
# SonarQube needs this kernel setting increased or it crashes on startup (Elasticsearch under the hood).
# This directly fixes "Problem #2" from your original build notes.
sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" >> /etc/sysctl.conf
docker run -d --name sonarqube -p 9000:9000 --restart unless-stopped sonarqube:lts-community

# ---------- AWS CLI ----------
# Jenkins needs this to authenticate kubectl against the EKS cluster (aws eks update-kubeconfig)
apt-get install -y unzip
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
./aws/install
rm -rf awscliv2.zip aws/

# ---------- kubectl ----------
# Jenkins uses this in the pipeline to update k8s manifests (not to deploy - just to edit YAML/tags)
KVER=$(curl -L -s https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KVER}/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl

echo "===== Bootstrap finished: $(date) ====="
