pipeline {
  agent any
  parameters {
    string (name: 'KubeApiEndpoint')
  } 
  stages {
    stage('Geting nodes ips and creating host file') {
      steps {
        sh """
        cd /root/AnsibleConfig/${params.env}/${params.version}
        chmod 755 GetClusterNodesIp.py
        python GetClusterNodesIp.py ${params.Region}
        mv -f groups hosts/groups
        """
      }
    }
    stage('Install kubernetes components') {
      steps {
        sh """
        cd /root/AnsibleConfig/${params.env}/${params.version}
        ls -lart
        ansible-playbook infra.yaml -i hosts/groups
        """
      }
    }
    stage('Install kubectl component on master and nodes') {
      steps {
        sh """
        cd /root/AnsibleConfig/${params.env}/${params.version}
        ls -lart
        ansible-playbook kubectl.yaml --extra-vars "kubernetes_api_endpoint=${params.KubeApiEndpoint}"
        """
      }
    }
    stage('Configure routing between master and nodes') {
      steps {
        sh """
        cd /root/AnsibleConfig/${params.env}/${params.version}
        ansible-playbook kubernetes-routing.yaml -i hosts/groups
        """
      }
    }
    
    stage('Unit testing for installed components on respective nodes') {
      steps {
        sh """
        cd /root/AnsibleConfig/${params.env}/${params.version}
        sh unit-testing.sh
        """
      }
    }
    stage('Integration testing to confirm components interconnectivity') {
      steps {
        sh """
        cd /root/AnsibleConfig/${params.env}/${params.version}
        sleep 60s
        kubectl get componentstatuses --insecure-skip-tls-verify
        kubectl get nodes --insecure-skip-tls-verify -o wide
        kubectl cluster-info --insecure-skip-tls-verify
        """
      }
    }
    stage('Smoke testing by deploying nginx after configuring kube8') {
      steps {
        sh """
        cd /root/AnsibleConfig/${params.env}/${params.version}
        ansible-playbook smoke-testing.yaml -i hosts/groups
        kubectl get svc nginx --output=jsonpath='{range .spec.ports[0]}{.nodePort}' --insecure-skip-tls-verify
        kubectl get pods -o wide --insecure-skip-tls-verify
        """
      }
    }
  }
}
