# Stage 1: Build
FROM gradle:8-jdk21 AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src

# CRITICAL FIX: Run 'bootJar' specifically to ensure the executable manifest is generated
RUN gradle clean bootJar -x test --no-daemon

# Stage 2: Run
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# Safely copy the executable JAR.
# We target 'build/libs/app.jar' because we set this name in build.gradle.kts
COPY --from=build /home/gradle/src/build/libs/app.jar /app/app.jar

EXPOSE 8080

# The Entrypoint uses 'exec' to handle process signals correctly,
# preventing the "frozen logs" issue by allowing old containers to shut down properly.
ENTRYPOINT ["sh", "-c", "exec java -jar /app/app.jar --spring.profiles.active=${SPRING_PROFILES_ACTIVE:-dev} --grpc.server.port=${MY_GRPC_PORT:-9091}"]