pipeline {
    agent any

    environment {
        IMAGE_NAME   = "antben1204/trend-app"
        AWS_REGION   = "ap-south-1"
        CLUSTER_NAME = "trend-eks-cluster"
    }

    stages {
        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/antben/trend-eks-jenkins-cicd.git'
            }
        }

        stage('Debug Workspace') {
            steps {
                sh '''
                    echo "===== WHOAMI ====="
                    whoami

                    echo "===== ID ====="
                    id

                    echo "===== PWD ====="
                    pwd

                    echo "===== FILES IN ROOT ====="
                    ls -la

                    echo "===== ALL FILES ====="
                    find . -maxdepth 3 -type f | sort

                    echo "===== DOCKERFILE DETAILS ====="
                    ls -l Dockerfile || true
                    file Dockerfile || true

                    echo "===== DOCKERFILE CONTENT ====="
                    cat Dockerfile || true

                    echo "===== NGINX CONF CONTENT ====="
                    cat nginx.conf || true

                    echo "===== GIT REMOTE ====="
                    git remote -v || true

                    echo "===== GIT BRANCH ====="
                    git branch || true

                    echo "===== TOOL VERSIONS ====="
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
                    echo "Updating kubeconfig..."
                    mkdir -p ~/.kube
                    aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME

                    echo "Checking cluster access..."
                    kubectl get nodes

                    echo "Deploying manifests..."
                    kubectl apply -f kubernetes/deployment.yaml
                    kubectl apply -f kubernetes/service.yaml

                    echo "Waiting for rollout..."
                    kubectl rollout status deployment/trend-app-deployment

                    echo "Listing deployment resources..."
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
            echo 'Pipeline failed. Check the debug workspace stage and console output for details.'
        }
    }
}
