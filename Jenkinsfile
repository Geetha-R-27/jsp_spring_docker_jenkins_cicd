pipeline {
    agent any

    environment {
        IMAGE_NAME = "geethar27/springapp"
        CONTAINER_NAME = "springapp"
        DOCKERHUB_CRED = "dockerhub-creds"
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

        stage('Build Maven Project') {
            steps {
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: DOCKERHUB_CRED, usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh "echo \$PASSWORD | docker login -u \$USERNAME --password-stdin"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh "docker push ${IMAGE_NAME}:latest"
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                script {
                    sh """
                    echo "🛑 Stopping previous container..."
                    docker-compose down || true

                    echo "📥 Pulling latest image..."
                    docker pull ${IMAGE_NAME}:latest

                    echo "🚀 Starting application with docker-compose..."
                    docker-compose up -d
                    """
                }
            }
        }
    }

    post {
        success {
            echo "🎉 Deployment Successful! Your App is Live!"
        }
        failure {
            echo "❌ Deployment Failed. Check logs."
        }
    }
}
