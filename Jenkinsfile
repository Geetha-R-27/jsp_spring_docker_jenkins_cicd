pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "geethar27/springapp:latest"
        APP_PORT = "80"
        COMPOSE_FILE = "docker-compose.yml"
        CONTAINER_NAME = "springapp"
        DB_CONTAINER_NAME = "clicknbuy-db"
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

        stage('Clean Old Docker Containers & Images') {
            steps {
                echo "Stopping and removing old containers if they exist"
                sh """
                # Stop and remove spring app container
                if [ \$(docker ps -q -f name=${CONTAINER_NAME}) ]; then
                    docker stop ${CONTAINER_NAME}
                    docker rm ${CONTAINER_NAME}
                fi

                # Stop and remove DB container
                if [ \$(docker ps -q -f name=${DB_CONTAINER_NAME}) ]; then
                    docker stop ${DB_CONTAINER_NAME}
                    docker rm ${DB_CONTAINER_NAME}
                fi

                # Remove old image
                if [ \$(docker images -q ${DOCKER_IMAGE}) ]; then
                    docker rmi -f ${DOCKER_IMAGE}
                fi
                """
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image from ClickNBuy code"
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                echo "Stopping any existing containers via Docker Compose"
                sh """
                if [ -f ${COMPOSE_FILE} ]; then
                    docker-compose -f ${COMPOSE_FILE} down
                fi
                """
                echo "Starting containers using Docker Compose"
                sh "docker-compose -f ${COMPOSE_FILE} up --build -d"
            }
        }

        stage('Verify Deployment') {
            steps {
                echo "Checking if containers are running"
                sh "docker ps"
                echo "Logs from Spring Boot container"
                sh "docker logs ${CONTAINER_NAME} --tail 50"
            }
        }
    }

    post {
        success {
            echo "✅ Deployment completed successfully!"
        }
        failure {
            echo "❌ Deployment failed. Check logs for errors."
        }
    }
}
