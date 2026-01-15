# Stage 1: Build the JAR
FROM gradle:8-jdk21 AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
# Added 'clean' to the command to ensure no old code is left over
RUN gradle clean build -x test --no-daemon

# Stage 2: Run the JAR
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# Refined to ignore the '-plain.jar' which is likely causing the 'no change' issue
COPY --from=build /home/gradle/src/build/libs/*[!plain].jar /app/app.jar

EXPOSE 8080

# Keeping your Shell Form since you confirmed it works with your variables
ENTRYPOINT echo "Starting App... Profile: $SPRING_PROFILES_ACTIVE, gRPC Port: $MY_GRPC_PORT" && \
           java -jar /app/app.jar \
           --spring.profiles.active=${SPRING_PROFILES_ACTIVE:-dev} \
           --grpc.server.port=${MY_GRPC_PORT:-9091}