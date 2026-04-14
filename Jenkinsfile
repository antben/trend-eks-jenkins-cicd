pipeline {
    agent any

    environment {
        IMAGE_NAME   = "antben1204/trend-app"
        AWS_REGION   = "ap-south-1"
        CLUSTER_NAME = "trend-eks-cluster"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Vennilavanguvi/Trend.git'
            }
        }

        stage('Verify Tools') {
            steps {
                sh '''
                    echo "Checking installed tools..."
                    git --version
                    docker --version
                    aws --version
                    kubectl version --client
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    echo "Building Docker image..."
                    docker build -t $IMAGE_NAME:latest .
                '''
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "Logging in to Docker Hub..."
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

                        echo "Pushing image to Docker Hub..."
                        docker push $IMAGE_NAME:latest
                    '''
                }
            }
        }

        stage('Deploy to EKS') {
    steps {
        sh '''
            mkdir -p ~/.kube
            aws eks update-kubeconfig --region ap-south-1 --name trend-eks-cluster
            kubectl get nodes
            kubectl apply -f kubernetes/deployment.yaml
            kubectl apply -f kubernetes/service.yaml
            kubectl rollout status deployment/trend-app-deployment
            kubectl get pods
            kubectl get svc
        '''
    }
   }
 }

    post {
        success {
            echo 'Pipeline completed successfully: build, push, and deployment done.'
        }
        failure {
            echo 'Pipeline failed. Check the console output for details.'
        }
    }
}
