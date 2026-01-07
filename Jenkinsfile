pipeline {
    agent any

    environment {
        AWS_REGION   = "us-east-1"
        CLUSTER_NAME = "prod-eks-cluster"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Projectbenchnew/project15.git'
            }
        }

        stage('Install kubectl') {
            steps {
                sh '''
                export PATH=$HOME/bin:$PATH

                if ! command -v kubectl >/dev/null 2>&1; then
                  echo "Installing kubectl..."
                  mkdir -p $HOME/bin
                  curl -sLO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
                  chmod +x kubectl
                  mv kubectl $HOME/bin/
                fi

                kubectl version --client
                '''
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
                export PATH=$HOME/bin:$PATH

                aws eks update-kubeconfig \
                  --region $AWS_REGION \
                  --name $CLUSTER_NAME
                '''
            }
        }

        stage('Wait for EKS API') {
            steps {
                echo "Waiting for EKS control plane to be ready..."
                sh 'sleep 120'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                export PATH=$HOME/bin:$PATH

                kubectl get nodes
                kubectl apply -f k8s/deployment.yaml
                kubectl apply -f k8s/service.yaml
                '''
            }
        }
    }
}
