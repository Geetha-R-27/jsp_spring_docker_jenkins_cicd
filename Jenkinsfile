pipeline {
    agent any

    environment {
        IMAGE_NAME = "geethar27/springapp"
        CONTAINER_NAME = "springapp"
        DOCKERHUB_CRED = "dockerhub-creds"      // Jenkins credential ID
    }

    tools {
        maven 'maven'
    }

    stages {

        stage('Permission Setup') {
            steps {
                sh 'chmod +x mvnw'
            }
        }

        stage('Build Spring Boot App') {
            steps {
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:latest ."
                }
            }
        }

        stage('DockerHub Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: DOCKERHUB_CRED, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh "echo $PASSWORD | docker login -u $USERNAME --password-stdin"
                }
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                sh "docker push ${IMAGE_NAME}:latest"
            }
        }

        stage('Deploy Using Docker Compose') {
            steps {
                script {
                    sh """
                    echo "🛑 Stopping existing deployment..."
                    docker compose down || true

                    echo "⬇ Pulling latest image..."
                    docker pull ${IMAGE_NAME}:latest

                    echo "🚀 Starting new deployment..."
                    docker compose up -d
                    """
                }
            }
        }
    }

    post {
        success {
            echo "🎉 Deployment Successful! Your SpringBoot App is Live."
        }

        failure {
            echo "❌ Build or Deployment FAILED. Check Console Output."
        }
    }
}
