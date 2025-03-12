# Commands Used

## Installations

### Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management)

1. >sudo apt-get update
2. >sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
3. >curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
4. >sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
5. >echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
6. >sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list
7. >sudo apt-get update
8. >sudo apt-get install -y kubectl
9. >apt-get install bash-completion
10. >echo 'source <(kubectl completion bash)' >>~/.bashrc
11. >. ~/.bashrc

### Install [eksctl](https://eksctl.io/installation/#for-unix)

```bash
# for ARM systems, set ARCH to: arm64, armv6 or armv7
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
# (Optional) Verify checksum
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo mv /tmp/eksctl /usr/local/bin
```

1. Copy the script from below or the provided script and run it.
2. >echo ". <(eksctl completion bash)" >> ~/.bashrc
3. Run >source ~/.bashrc
4. >eksctl version
5. >echo "complete -C '/usr/local/bin/aws_completer' aws >> ~/.bashrc"

### Install [aws cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

1. >curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
2. >unzip awscliv2.zip
3. >sudo ./aws/install
4. >aws --version

## Practical

Creating a fargate cluster in the Mumbai Region.
>eksctl create cluster --name eks-learning --region ap-south-1 --fargate

Importing or Updating the Kubeconfig for the kubectl
>aws eks update-kubeconfig  --name eks-learning --region ap-south-1

Creating a fargate profile for a namespace in AWS for the EKS Cluster
>eksctl create fargateprofile --cluster eks-learning --region ap-south-1 --name alb-sample-app --namespace game-2048

Applying a config from
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/examples/2048/2048_full.yaml

## Kube Commands

Listing things

>kubectl get pods -n game-2048
>kubectl get svc -n game-2048
>kubectl get ingress -n game-2048
