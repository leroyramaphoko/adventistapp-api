import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import com.google.protobuf.gradle.*

plugins {
    kotlin("jvm") version "2.1.0"
    kotlin("plugin.spring") version "2.1.0"
    id("org.springframework.boot") version "3.4.1" // Changed to 3.4.1 as 4.0.1 is very new/unstable
    id("io.spring.dependency-management") version "1.1.7"
    id("com.google.protobuf") version "0.9.4"
}

group = "com.biblecontentmedia.adventist.api"
version = "0.0.1-SNAPSHOT"

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}

repositories {
    mavenCentral()
}

val protobufVersion = "3.25.5"
val grpcJavaVersion = "1.63.0"
val grpcKotlinVersion = "1.5.0"

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("org.jetbrains.kotlin:kotlin-reflect")
    implementation("net.devh:grpc-server-spring-boot-starter:3.1.0.RELEASE")
    implementation("com.google.protobuf:protobuf-kotlin:$protobufVersion")
    implementation("com.google.protobuf:protobuf-java:$protobufVersion")
    implementation("io.grpc:grpc-protobuf:$grpcJavaVersion")
    implementation("io.grpc:grpc-stub:$grpcJavaVersion")
    implementation("io.grpc:grpc-netty-shaded:$grpcJavaVersion")
    implementation("io.grpc:grpc-kotlin-stub:$grpcKotlinVersion")
    implementation("jakarta.annotation:jakarta.annotation-api:3.0.0")
    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testImplementation("org.jetbrains.kotlin:kotlin-test-junit5")
}

// Ensure the JAR has a manifest pointing to your Main class
springBoot {
    mainClass.set("com.biblecontentmedia.adventist.api.adventistappapi.AdventistAppApiApplicationKt")
}

tasks.named<org.springframework.boot.gradle.tasks.bundling.BootJar>("bootJar") {
    archiveFileName.set("app.jar")
}

// protobuf and sourceSet config remains same as your previous version...
protobuf {
    protoc { artifact = "com.google.protobuf:protoc:$protobufVersion" }
    plugins {
        id("grpc") { artifact = "io.grpc:protoc-gen-grpc-java:$grpcJavaVersion" }
        id("grpckt") { artifact = "io.grpc:protoc-gen-grpc-kotlin:$grpcKotlinVersion:jdk8@jar" }
    }
    generateProtoTasks {
        all().forEach { task ->
            task.plugins { id("grpc"); id("grpckt") }
            task.builtins { id("kotlin") }
        }
    }
}

kotlin {
    compilerOptions {
        freeCompilerArgs.addAll("-Xjsr305=strict")
        jvmTarget.set(JvmTarget.JVM_21)
    }
}

sourceSets {
    main {
        java { srcDirs("build/generated/source/proto/main/java", "build/generated/source/proto/main/grpc") }
        kotlin { srcDirs("src/main/kotlin", "build/generated/source/proto/main/kotlin", "build/generated/source/proto/main/grpckt") }
    }
}