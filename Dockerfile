# Stage 1: Build the JAR
FROM gradle:8-jdk21 AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
# Skip tests to speed up the build for now
RUN gradle build -x test --no-daemon

# Stage 2: Run the JAR
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# Copy only the executable JAR
COPY --from=build /home/gradle/src/build/libs/*SNAPSHOT.jar /app/app.jar

# Only expose the base web port.
# gRPC ports are handled dynamically by Dokploy environment variables.
EXPOSE 8080

# Using Shell Form so $SPRING_PROFILES_ACTIVE and $MY_GRPC_PORT expand correctly
ENTRYPOINT echo "Starting App... Profile: $SPRING_PROFILES_ACTIVE, gRPC Port: $MY_GRPC_PORT" && \
           java -jar /app/app.jar \
           --spring.profiles.active=$SPRING_PROFILES_ACTIVE \
           --grpc.server.port=$MY_GRPC_PORT