# Configure and Install Kubernetes components using Ansible

## Components 

A worked example to setup kubernetes cluster using Ansible.

- Kube-Controller
- Kube-Scheduler
- Kube-proxy
- Kube-api
- Kubelet
- Kubectl
- Docker

## Requirements

Requirements on control machine:

- Python (tested with Python 2.7.12, may be not compatible with older versions; requires Jinja2 2.8)
- Ansible (tested with Ansible 2.1.0.0)
- *cfssl* and *cfssljson*:  https://github.com/cloudflare/cfssl
- Kubernetes CLI
- SSH Agent
- kubernetes version 1.17.0
- kubeapi server version 1.3.6


Ansible expects the SSH identity loaded by SSH agent:
```
$ ssh-add <keypair-name>.pem
```

### Generated SSH config

Terraform generates `ssh.cfg`, SSH configuration file in the project directory.
It is convenient for manually SSH into machines using node names (`controller0`...`controller2`, `etcd0`...`2`, `worker0`...`2`), but it is NOT used by Ansible.

e.g.
```
$ ssh -F ssh.cfg worker0
```

## Install Kubernetes, with Ansible

We have multiple playbooks.

### Install and set up Kubernetes cluster

Install Kubernetes components and *etcd* cluster.
```
$ ansible-playbook infra.yaml
```

### Setup Kubernetes CLI

Configure Kubernetes CLI (`kubectl`) on your machine, setting Kubernetes API endpoint (as returned by Terraform).
```
$ ansible-playbook kubectl.yaml --extra-vars "kubernetes_api_endpoint=<kubernetes-api-dns-name>"
```

Verify all components and minions (workers) are up and running, using Kubernetes CLI (`kubectl`).

```
$ kubectl get componentstatuses

$ kubectl get nodes
```

### Setup Pod cluster routing

Set up additional routes for traffic between Pods.
```
$ ansible-playbook kubernetes-routing.yaml
```

### Smoke test: Deploy *nginx* service

Deploy a *ngnix* service inside Kubernetes.
```
$ kubectl run nginx --image=nginx --port=80
$ kubectl expose pods nginx --type NodePort
```

Verify pods and service are up and running.

```
$ kubectl get pods -o wide
...

Retrieve the port *nginx* has been exposed on:

```
$ kubectl get svc nginx --output=jsonpath='{range .spec.ports[0]}{.nodePort}'
32700
```

Now you should be able to access *nginx* default page:
```
$ curl http://<worker-public-ip>:<exposed-port>
...

# Advantages of module

There are many known simplifications:

- Networking setup is very simple: ALL instances have a public IP.
- Infrastructure managed by direct SSH into instances (no VPN, no Bastion).
- Very basic Service Account and Secret (to change them, modify: `./ansible/roles/controller/files/token.csv` and `./ansible/roles/worker/templates/kubeconfig.j2`)
- Simplified Ansible lifecycle. Playbooks support changes in a simplistic way, including possibly unnecessary restarts.
- Instances use static private IP addresses
