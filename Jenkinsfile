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
        cd /root/AnsibleConfig/${params.env}/${params.version}/ansible_kube8_installation
        ls -lart
        ansible-playbook infra.yaml -i hosts/groups
        """
      }
    }
    stage('Install kubectl component on master and nodes') {
      steps {
        sh """
        cd /root/AnsibleConfig/${params.env}/${params.version}/ansible_kube8_installation
        ls -lart
        ansible-playbook kubectl.yaml --extra-vars "kubernetes_api_endpoint=${params.KubeApiEndpoint}"
        """
      }
    }
    stage('Configure routing between master and nodes') {
      steps {
        sh """
        cd /root/AnsibleConfig/${params.env}/${params.version}/ansible_kube8_installation
        ansible-playbook kubernetes-routing.yaml -i hosts/groups
        """
      }
    }
    stage('Run kubectl command to versify cluster info after configuration') {
      steps {
        sh """
        cd /root/AnsibleConfig/${params.env}/${params.version}/ansible_kube8_installation
        kubectl get nodes -o wide
        kubectl cluster-info
        """
      }
    }
    stage('Pusshing back changes back to SCM') {
      steps {
        sh """
        cd /root/AnsibleConfig
        git add .
        git commit -m "adding updated config files"
        git push https://${params.GitUsername}:${params.GitPassword}@github.com/am2308/AnsibleConfig.git --all
        """
      }
    }
  }
}
