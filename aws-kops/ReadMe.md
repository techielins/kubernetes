This folder contains the yaml files and instructions to deploy Kubernetes cluster to AWS using kops.

# Install KOPS:

#Amazon Linux

~# curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64

~# chmod +x kops

~# sudo mv kops /usr/local/bin/kops


###Install kubectl binary with curl

~# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

~# sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

#Test to ensure the version you installed is up-to-date:
~# kubectl version --client

# Setup your environment

AWS

In order to correctly prepare your AWS account for kops, we require you to install the AWS CLI tools, and have API credentials for an account that has the permissions to create a new IAM account for kops.

Setup IAM user

In order to build clusters within AWS we'll create a dedicated IAM user for kops. This user requires API credentials in order to use kops.

You can create the kOps IAM user from the command line using the following:

~# aws iam create-group --group-name kops

~# aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name kops
~# aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --group-name kops
~# aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name kops
~# aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --group-name kops
~# aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name kops
~# aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonSQSFullAccess --group-name kops
~# aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess --group-name kops

~# aws iam create-user --user-name kops

~# aws iam add-user-to-group --user-name kops --group-name kops

~# aws iam create-access-key --user-name kops

You should record the SecretAccessKey and AccessKeyID in the returned JSON output, and then use them below:

# Configure the aws client to use your new IAM user

~# aws configure           # Use your new access and secret key here
~# aws iam list-users      # you should see a list of all your IAM users here

Because "aws configure" doesn't export these vars for kops to use, we export them now

~# export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)

~# export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)

# Cluster State storage

In order to store the state of your cluster, and the representation of your cluster, we need to create a dedicated S3 bucket for kops to use. This bucket will become the source of truth for our cluster configuration. 

~# aws s3api create-bucket --bucket mylins-kops-state-store --region us-east-1

# Creating your first cluster:

Prepare local environment
We're ready to start creating our first cluster! Let's first set up a few environment variables to make the process easier.

~# export NAME=mylins.k8s.local

~# export KOPS_STATE_STORE=s3://mylins-kops-state-store

Create cluster configuration

We will need to note which availability zones are available to us. In this example we will be deploying our cluster to the us-east-1 region.

~#  aws ec2 describe-availability-zones --region us-east-1

Create config files for cluster

~# kops create cluster --zones us-east-1a,us-east-1b,us-east-1c,us-east-1d,us-east-1e,us-east-1f --name=${NAME}

Generate SSK keys:

~# ssh-keygen -t rsa

Set SSH key to manage the cluster

~# kops create secret --name ${NAME} sshpublickey admin -i /home/ec2-user/.ssh/id_rsa.pub

# Customize Cluster Configuration

~# kops edit cluster --name ${NAME}

# Build the Cluster

~# kops update cluster --name ${NAME} --yes --admin

Get admin privileges and set the context for your cluster

~# kops export kubecfg --admin

# Check if cluster up and running

~# kops validate cluster

# Delete the Cluster

~# kops delete cluster --name ${NAME} --yes

