package com.biblecontentmedia.adventist.api.adventistappapi.service

import com.biblecontentmedia.adventist.api.grpc.BibleServiceGrpcKt
import com.biblecontentmedia.adventist.api.grpc.VerseRequest
import com.biblecontentmedia.adventist.api.grpc.VerseResponse
import net.devh.boot.grpc.server.service.GrpcService

@GrpcService
class BibleGrpcService : BibleServiceGrpcKt.BibleServiceCoroutineImplBase() {

    override suspend fun getVerse(request: VerseRequest): VerseResponse {
        // For now, returning a hardcoded response as requested.
        // Later, you will query your database here.
        return VerseResponse.newBuilder()
            .setContent("In the beginning God created the heaven and the earth.")
            .setCitation("Genesis 1:1 (${request.version})")
            .build()
    }
}