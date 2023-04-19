# Setup Prometheus Stack for Kubernetes

Step1 : Transfer the cdrs.yaml to your master node.
Step2 : Transfer the kops-monitoring.yaml to your master node.
Step3 : Execute the cdrs.yaml file first using kubectl apply command.
Step4: Execute the kops-monitoring.yaml file first using kubectl apply command.
Note: You must execute crds.yaml file before executing kops-monitoring.yaml.

This will deploy pods under "monitoring" namespace.

You may verify it via **kubeclt get pods -n monitoring**

To list the services, you may use the command **kubectl get svc -n monitoring**
