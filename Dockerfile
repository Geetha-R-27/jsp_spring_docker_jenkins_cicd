# ---- Stage 1: Build application ----
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy only pom first to cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the rest of project and build
COPY . .
RUN mvn clean package -DskipTests

# ---- Stage 2: Runtime image ----
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app

# Copy JAR built from previous stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port your Spring Boot runs on (default 8080)
EXPOSE 9090

# The command to run your app
ENTRYPOINT ["java", "-jar", "app.jar"]
