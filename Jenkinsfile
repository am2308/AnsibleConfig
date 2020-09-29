pipeline {
  agent any
  parameters {
    string (name: 'KubeApiEndpoint')
    string (name: 'GitUsername')
  } 
  stages {
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
    stage('Run kubectl command to versify cluster info after configuration') {
      steps {
        sh """
        cd /root/AnsibleConfig/${params.env}/${params.version}
        sleep 60s
        kubectl get nodes --insecure-skip-tls-verify -o wide
        kubectl cluster-info --insecure-skip-tls-verify
        """
      }
    }
  }
}
