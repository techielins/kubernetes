This folder contains the yaml files and instructions to deploy Kubernetes cluster to AWS using kops.

##Install KOPS:

#Amazon Linux

~# curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
~# chmod +x kops
~# sudo mv kops /usr/local/bin/kops


###Install kubectl binary with curl

~# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
~# sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

#Test to ensure the version you installed is up-to-date:
~# kubectl version --client

Setup your environment

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





