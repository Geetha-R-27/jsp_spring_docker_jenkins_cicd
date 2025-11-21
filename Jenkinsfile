pipeline {
    agent any

    environment {
        IMAGE_NAME = "geethar27/jspgram"
        CONTAINER_NAME = "jspgram-app"
        DOCKERHUB_CREDENTIALS = "dockerhub-creds"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    echo "📂 Directory:"
                    pwd
                    echo "📄 Listing files:"
                    ls -l

                    echo "🐳 Building Docker image..."
                    docker build -t ${IMAGE_NAME}:latest .
                '''
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: DOCKERHUB_CREDENTIALS, usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                        echo "$PASS" | docker login -u "$USER" --password-stdin
                        docker push ${IMAGE_NAME}:latest
                        docker logout
                    '''
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true
                    docker run -d --name ${CONTAINER_NAME} -p 8080:8080 ${IMAGE_NAME}:latest
                '''
            }
        }
    }

    post {
        success {
            echo "🎉 Pipeline succeeded - App deployed!"
        }
        failure {
            echo "❌ Pipeline failed - check logs!"
        }
    }
}
