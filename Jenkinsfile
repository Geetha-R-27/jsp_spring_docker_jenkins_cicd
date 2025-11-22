pipeline {
    agent any

    environment {
        IMAGE_NAME = "geethar27/springapp"
    }
    tools{
        maven 'maven'
    }

    stages {
        stage('Build JAR') {
            steps {
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Login & Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh "echo $PASSWORD | docker login -u $USERNAME --password-stdin"
                    sh "docker push ${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Deploy Application') {
            steps {
                sh """
                docker stop springapp || true
                docker rm springapp || true
                docker pull ${IMAGE_NAME}:latest
                docker run -d -p 8080:8080 --name springapp ${IMAGE_NAME}:latest
                """
            }
        }
    }

    post {
        success { echo "🚀 Deployment completed successfully!" }
        failure { echo "❌ Deployment failed. Check logs." }
    }
}
