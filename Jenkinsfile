pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "geethar27/springapp:latest"
        APP_PORT = "80"
        COMPOSE_FILE = "docker-compose.yml"
        DB_VOLUME = "clicknbuy-data"
    }
    
    tools {
        maven 'maven'
    }

    stages {

        stage('Build & Package') {
            steps {
                echo "Building the Spring Boot application"
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image"
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Stop & Remove Existing Containers') {
            steps {
                echo "Stopping and removing existing containers"
                sh """
                if [ \$(docker ps -q -f name=springapp) ]; then
                    docker stop springapp
                    docker rm springapp
                fi
                if [ \$(docker ps -q -f name=clicknbuy-db) ]; then
                    docker stop clicknbuy-db
                    docker rm clicknbuy-db
                fi
                """
            }
        }

        stage('Remove Docker Volume (Optional Fresh DB)') {
            steps {
                echo "Removing old database volume if exists"
                sh """
                if [ \$(docker volume ls -q -f name=${DB_VOLUME}) ]; then
                    docker volume rm ${DB_VOLUME} || true
                fi
                """
            }
        }

        stage('Build & Run Docker Compose') {
            steps {
                echo "Building and starting containers using Docker Compose"
                sh "docker-compose -f ${COMPOSE_FILE} up --build -d"
            }
        }
    }

    post {
        success {
            echo "Deployment completed successfully!"
        }
        failure {
            echo "Deployment failed. Check logs for errors."
        }
    }
}
