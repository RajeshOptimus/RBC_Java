# Use the official Maven image
FROM maven:3.8.4-openjdk-11 AS build

# Set the working directory
WORKDIR /app

# Copy only the pom.xml file to cache dependencies
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline

# Copy the source code
COPY src src

# Build the project
RUN mvn clean install

# Use a smaller base image for the runtime
FROM openjdk:11-jre-slim

# Set the working directory
WORKDIR /app

# Copy the JAR file from the build image
COPY --from=build /app/target/*.jar app.jar

# Expose the port your application will run on
EXPOSE 8081

# Command to run the application
CMD ["java", "-jar", "app.jar"]
