package com.biblecontentmedia.adventist.api.adventistappapi.service

import com.biblecontentmedia.adventist.api.grpc.Bible
import com.biblecontentmedia.adventist.api.grpc.BibleServiceGrpcKt
import com.biblecontentmedia.adventist.api.grpc.verseResponse // Import the DSL factory
import net.devh.boot.grpc.server.service.GrpcService

@GrpcService
class BibleGrpcService : BibleServiceGrpcKt.BibleServiceCoroutineImplBase() {

    override suspend fun getVerse(request: Bible.VerseRequest): Bible.VerseResponse {
        return verseResponse {
            content = "For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life."
            citation = "John 3:16 (${request.version})"
        }
    }
}