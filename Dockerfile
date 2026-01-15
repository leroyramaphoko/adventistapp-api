# Stage 1: Build the JAR
FROM gradle:8-jdk21 AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle build -x test --no-daemon

# Stage 2: Run the JAR
FROM eclipse-temurin:21-jre-jammy
EXPOSE 8080
EXPOSE 9091
EXPOSE 9092

WORKDIR /app

# Safer way: Copy all and we will specify the one to run,
# or use a standard build name in gradle.
COPY --from=build /home/gradle/src/build/libs/*.jar ./

# This entrypoint prints the info, then finds the correct JAR (excluding plain) to run
ENTRYPOINT ["sh", "-c", "echo 'Starting App... Profile: ${SPRING_PROFILES_ACTIVE}, gRPC Port: ${MY_GRPC_PORT}' && java -jar $(ls *[!plain].jar | head -n 1) --spring.profiles.active=${SPRING_PROFILES_ACTIVE} --grpc.server.port=${MY_GRPC_PORT}"]