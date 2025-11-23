pipeline {
    agent any

    environment {
        IMAGE_NAME = "geethar27/springapp"
        CONTAINER_NAME = "springapp"
        PORT = "80"
    }

    tools {
        maven 'maven'
    }

    stages {

        stage('Build Maven Project') {
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

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh "echo $PASSWORD | docker login -u $USERNAME --password-stdin"
                }
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                sh "docker push ${IMAGE_NAME}:latest"
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    sh """
                    echo "🔍 Checking existing container..."
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true
                    
                    echo "⬇ Pulling latest image..."
                    docker pull ${IMAGE_NAME}:latest
                    
                    echo "🚀 Running new container..."
                    docker run -d -p ${PORT}:${PORT} --name ${CONTAINER_NAME} ${IMAGE_NAME}:latest
                    """
                }
            }
        }
    }

    post {
        success {
            echo "🚀 Deployment completed successfully! Application running on port ${PORT}"
        }
        failure {
            echo "❌ Build or Deployment failed. Check Jenkins logs."
        }
    }
}
