# Stage 1: Build
FROM gradle:8-jdk21 AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
# Clean ensures no old JARs are lying around
RUN gradle clean build -x test --no-daemon

# Stage 2: Run
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# [!plain] is the critical fix. It tells Docker:
# "Copy the JAR that does NOT have the word 'plain' in its name."
COPY --from=build /home/gradle/src/build/libs/*[!plain].jar /app/app.jar

EXPOSE 8080

# Keep your working Entrypoint
ENTRYPOINT ["sh", "-c", "exec java -jar /app/app.jar --spring.profiles.active=${SPRING_PROFILES_ACTIVE:-dev} --grpc.server.port=${MY_GRPC_PORT:-9091}"]