package com.biblecontentmedia.adventist.api.adventistappapi.service

import com.biblecontentmedia.adventist.api.grpc.Bible
import com.biblecontentmedia.adventist.api.grpc.BibleServiceGrpcKt
import net.devh.boot.grpc.server.service.GrpcService

@GrpcService
class BibleGrpcService : BibleServiceGrpcKt.BibleServiceCoroutineImplBase() {

    override suspend fun getVerse(request: Bible.VerseRequest): Bible.VerseResponse {
        return Bible.VerseResponse.newBuilder()
            .setContent("In the beginning God created the heaven and the earth.")
            .setCitation("Genesis 1:1 (${request.version})")
            .build()
    }
}