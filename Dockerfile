# Stage 1: Build the JAR
FROM gradle:8-jdk21 AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
# Skip tests to speed up the build for now
RUN gradle build -x test --no-daemon

# Stage 2: Run the JAR
# We use eclipse-temurin because openjdk:21-slim is no longer available
FROM eclipse-temurin:21-jre-jammy
EXPOSE 8080
EXPOSE 9091
EXPOSE 9092

RUN mkdir /app
# Note: Ensure your build output JAR name matches. Usually, it's 'project-name-0.0.1-SNAPSHOT.jar'
COPY --from=build /home/gradle/src/build/libs/*.jar /app/spring-boot-application.jar

# This entrypoint ensures Environment Variables like MY_GRPC_PORT override properties
ENTRYPOINT ["java", "-jar", "/app/spring-boot-application.jar"]