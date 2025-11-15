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


# To install KOPS
curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops-linux-amd64
sudo mv kops-linux-amd64 /usr/local/bin/kops
kops version

Step 1: Create S3 Bucket (AWS Console)
- Go to S3 Console -> Create bucket
- Bucket name: your-kops-bucket-name (unique)
- Region: us-east-1
- Block Public Access: Keep enabled
- Bucket Versioning: Enable
- Create bucket


Step 2: Configure IAM Role for EC2 (AWS Console)
- Go to IAM Console → Roles
- Create role
- Trusted entity: AWS service → EC2
- Attach policies:
  - AmazonEC2FullAccess
  - AmazonS3FullAccess
  - IAMFullAccess
  - AmazonVPCFullAccess
  - AmazonEventBridgeFullAccess
  - AmazonSQSFullAccess
- Role name: kops-ec2-role
Create role


Step 3: Attach IAM Role to EC2 (AWS Console)
Go to EC2 Console → Instances
- Select your instance
- Actions → Security → Modify IAM role
- Select kops-ec2-role
Update IAM role


Step 4: Create Cluster (Back to EC2 Terminal)
# Set environment variables
-> export KOPS_STATE_STORE=s3://your-kops-bucket-name
-> export CLUSTER_NAME=my-kops-cluster.k8s.local

# Create cluster
kops create cluster \
  --name=${CLUSTER_NAME} \
  --cloud=aws \
  --zones=us-east-1a \
  --node-count=2 \
  --node-size=t3.small \
  --master-size=t3.small \
  --yes


Step 5: Monitor in AWS Console
Go to EC2 Console to watch:
- 3 new instances being created (1 master + 2 nodes)
- New security groups
- New VPC and subnets



Step 6: Verify Cluster (EC2 Terminal)
# Wait for cluster (10-15 minutes)
kops validate cluster --wait 15m

# Check nodes
kubectl get nodes -o wide



Step 7: Deploy Application (EC2 Terminal)
kubectl create deployment my-garage --image=bheem05/garage:garage-image
kubectl expose deployment my-garage --type=NodePort --port=8080




Step 8: Configure Security Group (AWS Console)
Go to EC2 Console → Security Groups
- Find security group with name containing your cluster name
- Edit inbound rules
Add rule:
- Type: Custom TCP
- Port range: 30000-32767 (NodePort range)
- Source: 0.0.0.0/0


Step 9: Find Node Public IP (AWS Console)
Go to EC2 Console → Instances
- Find worker nodes (not master)
- Copy Public IPv4 address


Step 10: Access Application
# Get NodePort number (from EC2 terminal)
kubectl get svc my-garage

# Access from browser
http://<NODE_PUBLIC_IP>:<NODE_PORT>


Step 11: Monitor Resources (AWS Console)
EC2: Watch instance metrics
- CloudWatch: View logs and metrics
- S3: See cluster state files
- VPC: View network configuration

  

Step 12: Cleanup (AWS Console)
Delete cluster (from EC2 terminal):
command --> kops delete cluster ${CLUSTER_NAME} --yes

Verify in EC2 Console: All instances terminated
- Delete S3 bucket manually if needed
- Delete IAM role if desired

