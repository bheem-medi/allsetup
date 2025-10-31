# On CentOS/RHEL (your system)
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Verify installation
minikube version

# Start Minikube cluster
minikube start --force --driver=docker

# Check cluster status
cmd : minikube status
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured


# To install the kubectl 
step 1: curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
step 2: chmod +x kubectl
step 3: mv kubectl /usr/local/bin/
step 4: kubectl version --client


# Get cluster info
kubectl cluster-info



