package com.biblecontentmedia.adventist.api.adventistappapi.service

import com.biblecontentmedia.adventist.api.grpc.Bible
import com.biblecontentmedia.adventist.api.grpc.BibleServiceGrpcKt
import com.biblecontentmedia.adventist.api.grpc.verseResponse // Import the DSL factory
import net.devh.boot.grpc.server.service.GrpcService

@GrpcService
class BibleGrpcService : BibleServiceGrpcKt.BibleServiceCoroutineImplBase() {

    override suspend fun getVerse(request: Bible.VerseRequest): Bible.VerseResponse {
        return verseResponse {
            content = "In the beginning God created the heaven and the earth."
            citation = "Genesis 1:1 (${request.version}) Leroy Boski 1"
        }
    }
}