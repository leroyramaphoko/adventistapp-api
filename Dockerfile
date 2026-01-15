# Stage 1: Build
FROM gradle:8-jdk21 AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src

# 'clean' is the magic word to stop 'frozen' logs by forcing a fresh compile
RUN gradle clean build -x test --no-daemon

# Stage 2: Run
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# The [!plain] pattern guarantees the container doesn't load an empty shell
COPY --from=build /home/gradle/src/build/libs/*[!plain].jar /app/app.jar

EXPOSE 8080

# 'exec' ensures the app handles signals correctly so Dokploy can kill it and restart it
ENTRYPOINT ["sh", "-c", "exec java -jar /app/app.jar --spring.profiles.active=${SPRING_PROFILES_ACTIVE:-dev} --grpc.server.port=${MY_GRPC_PORT:-9091}"]