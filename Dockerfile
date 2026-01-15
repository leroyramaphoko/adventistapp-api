FROM gradle:8-jdk21 AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
# Use the full build command to ensure a fresh jar
RUN gradle clean build -x test --no-daemon

FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# This specific pattern ensures we only get the executable jar, not the -plain.jar
COPY --from=build /home/gradle/src/build/libs/*[!plain].jar /app/app.jar

EXPOSE 8080

# This form is the most compatible with Dokploy environment variables
ENTRYPOINT ["sh", "-c", "exec java -jar /app/app.jar --spring.profiles.active=${SPRING_PROFILES_ACTIVE:-dev} --grpc.server.port=${MY_GRPC_PORT:-9091}"]