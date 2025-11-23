# ---------- STAGE 1: BUILD THE APPLICATION ----------
FROM maven:3.9.5-eclipse-temurin-17 AS build

WORKDIR /app

# Copy Maven project files
COPY pom.xml ./
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build jar (skip tests for faster build)
RUN mvn clean package -DskipTests


# ---------- STAGE 2: RUN THE APPLICATION ----------
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy generated JAR from build stage
COPY --from=build /app/target/jsp-gram-0.0.1-SNAPSHOT.jar app.jar

# Expose Spring Boot port
EXPOSE 80

# Start application
ENTRYPOINT ["java", "-jar", "app.jar"]
