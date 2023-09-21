## Goto site https://kubernetes.github.io/ingress-nginx/  >> Deployment >> AWS

In AWS, we use a Network load balancer (NLB) to expose the Ingress-Nginx Controller behind a Service of Type=LoadBalancer.

TLS TERMINATION IN AWS LOAD BALANCER (NLB)
By default, TLS is terminated in the ingress controller. But it is also possible to terminate TLS in the Load Balancer. This section explains how to do that on AWS using an NLB.
1.Download the deploy.yaml template
```
wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/aws/nlb-with-tls-termination/deploy.yaml
```
2. Edit the file and change the VPC CIDR in use for the Kubernetes cluster:
```
proxy-real-ip-cidr: XXX.XXX.XXX/XX
```
3. Deploy the manifest:
```
kubectl apply -f deploy.yaml
```
4. 





