#Install Minikube Steps
#Update the system packages on Ubuntu 22.04 LTS AWS EC2
sudo apt update
#Download kubectl binary with curl on Ubuntu using below command
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
#Make the kubectl binary executable
chmod +x ./kubectl
#Move kubectl to /usr/local/bin/kubectl directory
sudo mv ./kubectl /usr/local/bin/kubectl
#To check kubectl version on Ubuntu
kubectl version
#Install below packages before installing docker
sudo apt-get install  ca-certificates curl gnupg lsb-release -y
#Add Docker official GPG Key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
#Setup Docker repository using below command
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#Update the package to take effect
sudo apt-get update
#Install Docker on Ubuntu 22.04 LTS using below command
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
#To check docker service status on Ubuntu
sudo systemctl is-active docker
#Create group named docker
sudo groupadd docker
#Configure to Run docker without sudo permission
sudo usermod -aG docker $USER && newgrp docker
#To enable docker service at system startup
sudo systemctl enable docker
#To check status of docker service
sudo systemctl is-active docker
#Install cri-dockerd on Ubuntu 22.04 LTS
#Clone the below git repo
git clone https://github.com/Mirantis/cri-dockerd.git
#To install, on a Linux system that uses systemd, and already has Docker Engine installed
wget https://storage.googleapis.com/golang/getgo/installer_linux
chmod +x ./installer_linux
./installer_linux
source ~/.bash_profile
cd
cd ~/cri-dockerd
mkdir bin
go build -o bin/cri-dockerd
sleep 30
mkdir -p /usr/local/bin
sudo install -o root -g root -m 0755 bin/cri-dockerd /usr/local/bin/cri-dockerd
sudo cp -a packaging/systemd/* /etc/systemd/system
sudo sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
sudo systemctl daemon-reload
sudo systemctl enable cri-docker.service
sudo systemctl enable --now cri-docker.socket
#Install conntrack package on Ubuntu 22.04 LTS
sudo apt-get install -y conntrack
#Install crictl package on Ubuntu 22.04 LTS
VERSION="v1.24.2"
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz
sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
rm -f crictl-$VERSION-linux-amd64.tar.gz
#Download and Install Minikube on Ubuntu 22.04 LTS
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
#Make the minikube binary executable
chmod +x minikube
#Move minikube to /usr/local/bin/kubectl directory
sudo mv minikube /usr/local/bin/
#To check minikube version on ubuntu
minikube version

#Start Minikube command
echo "Start the minikube Kubernetes cluster on Ubuntu with calico network plugin, use the following command"
echo "minikube start --network-plugin=cni --cni=calico"
echo ""
echo "Or"
echo "minikube start --network-plugin=cni --cni=calico --wait=false"

