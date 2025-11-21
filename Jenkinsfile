pipeline {
    agent any

    environment {
        IMAGE_NAME = "geethar27/jspgram"
        CONTAINER_NAME = "jspgram-app"
    }

    tools{
        maven 'maven'
    }
    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Geetha-R-27/jsp_spring_docker_jenkins_cicd.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh '''
                    echo "📂 Directory:"
                    pwd
                    echo "📄 Listing files:"
                    ls -l

                    echo "🐳 Building Docker Image..."
                    docker build -t $IMAGE_NAME .
                    '''
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub_creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                    echo "$PASS" | docker login -u "$USER" --password-stdin
                    docker push $IMAGE_NAME
                    '''
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                docker stop $CONTAINER_NAME || true
                docker rm $CONTAINER_NAME || true
                docker run -d -p 8080:8080 --name $CONTAINER_NAME $IMAGE_NAME
                '''
            }
        }
    }

    post {
        always { echo "🏁 Pipeline Finished" }
        success { echo "🚀 Deployment Successful!" }
        failure { echo "❌ Deployment Failed" }
    }
}
