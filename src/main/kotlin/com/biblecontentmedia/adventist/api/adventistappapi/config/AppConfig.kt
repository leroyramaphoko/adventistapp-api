package com.biblecontentmedia.adventist.api.adventistappapi.config

import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Component

@Component
class AppConfig {
    @Value("\${spring.profiles.active:dev}")
    val environment: String = ""

    @Value("\${app.version:1.0.0}")
    val version: String = ""

    fun isDev() = environment.equals("dev", ignoreCase = true)
    fun isProd() = environment.equals("prod", ignoreCase = true)
}