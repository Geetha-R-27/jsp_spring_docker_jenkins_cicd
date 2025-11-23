pipeline {
    agent any

    environment {
        IMAGE_NAME = "geethar27/springapp"
    }
    tools{
        maven 'maven'
    }

    stages {
          stage('Set Permissions') {
            steps {
                sh 'chmod +x mvnw'
            }
        }
        stage('Build JAR') {
            steps {
                sh './mvnw clean package -DskipTests'
            }
        }
       

        pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'sudo docker build -t geethar27/springapp:latest .'
                }
            }
        }
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
                docker run -d -p 9090:80 --name springapp ${IMAGE_NAME}:latest
                """
            }
        }
    }

    post {
        success { echo "🚀 Deployment completed successfully!" }
        failure { echo "❌ Deployment failed. Check logs." }
    }
}
