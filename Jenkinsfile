pipeline {
  agent any

  environment {
    AWS_REGION = "us-east-1"
  }

  stages {

    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/Projectbenchnew/project15.git'
      }
    }

    stage('Terraform Init') {
      steps {
        dir('terraform') {
          sh 'terraform init'
        }
      }
    }

    stage('Terraform Apply') {
      steps {
        dir('terraform') {
          sh 'terraform apply -auto-approve'
        }
      }
    }

    stage('Configure kubeconfig') {
      steps {
        sh '''
          aws eks update-kubeconfig \
          --region $AWS_REGION \
          --name prod-eks-cluster
        '''
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        sh '''
          kubectl apply -f k8s/deployment.yaml
          kubectl apply -f k8s/service.yaml
        '''
      }
    }
  }
}
