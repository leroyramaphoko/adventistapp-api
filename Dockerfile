# Stage 1: Build
FROM gradle:8-jdk21 AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src

# 'clean' ensures old 'Leroy-less' code is deleted before building
RUN gradle clean build -x test --no-daemon

# Stage 2: Run
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# The [!plain] pattern is the 'script' way to ensure only the real code is copied
COPY --from=build /home/gradle/src/build/libs/*[!plain].jar /app/app.jar

EXPOSE 8080

# The Shell Form ensures Dokploy variables like $MY_GRPC_PORT are injected
ENTRYPOINT echo "Starting App... Profile: $SPRING_PROFILES_ACTIVE" && \
           exec java -jar /app/app.jar \
           --spring.profiles.active=${SPRING_PROFILES_ACTIVE:-dev} \
           --grpc.server.port=${MY_GRPC_PORT:-9091}