 # Stage 1: Build the JAR
 FROM gradle:8-jdk21 AS build
 COPY --chown=gradle:gradle . /home/gradle/src
 WORKDIR /home/gradle/src
 RUN gradle build -x test --no-daemon

 # Stage 2: Run the JAR
 FROM openjdk:21-slim
 EXPOSE 8080
 EXPOSE 9091
 EXPOSE 9092

 RUN mkdir /app
 COPY --from=build /home/gradle/src/build/libs/*.jar /app/spring-boot-application.jar

 # This ensures the environment variable is used at runtime
 ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app/spring-boot-application.jar"]