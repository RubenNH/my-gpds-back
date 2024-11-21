# Stage 1: Build the application
FROM maven:3.8.5-openjdk-17 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml and the src directory into the container
COPY pom.xml .

RUN mvn dependency:go-offline -B

COPY . .

# Run Maven to build the JAR file
RUN mvn clean package -DskipTests

# Stage 2: Run the application
FROM openjdk:17-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the generated JAR file from the build stag
COPY --from=build /app/target/gpds-autos-0.0.1-SNAPSHOT.jar ./app.jar

# Expose the port the app will run on
EXPOSE 8080

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
