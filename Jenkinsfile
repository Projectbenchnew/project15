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
                if ! command -v kubectl >/dev/null 2>&1; then
                  echo "Installing kubectl..."
                  curl -LO https://dl.k8s.io/release/v1.29.3/bin/linux/amd64/kubectl
                  chmod +x kubectl
                  sudo mv kubectl /usr/local/bin/kubectl
                fi

                kubectl version --client
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh '''
                    rm -f terraform.tfstate.lock.info
                    terraform init
                    '''
                }
            }
        }

        stage('Terraform Apply (Create EKS)') {
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
                  --region ${AWS_REGION} \
                  --name ${CLUSTER_NAME}

                kubectl config current-context
                '''
            }
        }

        stage('Wait for Nodes Ready') {
            steps {
                sh '''
                echo "Waiting for worker nodes..."
                for i in {1..12}; do
                  kubectl get nodes && break
                  echo "Retry $i..."
                  sleep 30
                done
                '''
            }
        }

        stage('Deploy Application') {
            steps {
                sh '''
                kubectl apply -f k8s/deployment.yaml
                kubectl apply -f k8s/service.yaml
                kubectl get svc
                '''
            }
        }
    }
}
