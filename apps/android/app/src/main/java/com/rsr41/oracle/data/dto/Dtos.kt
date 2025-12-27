package com.rsr41.oracle.data.dto

import kotlinx.serialization.Serializable

@Serializable
data class TagStatusDto(
    val token: String,
    val status: String,
    val boundProfileId: String? = null
)

@Serializable
data class CreateProfileRequest(
    val birthDate: String,
    val birthTime: String?,
    val timeUnknown: Boolean,
    val calendarType: String,
    val gender: String
)

@Serializable
data class CreateProfileResponse(
    val profileId: String
)

@Serializable
data class CheckInRequest(
    val profileId: String,
    val token: String? = null
)

@Serializable
data class CheckInResponse(
    val dateKey: String,
    val unlocked: Boolean,
    val alreadyCheckedIn: Boolean
)

@Serializable
data class TodayReportRequest(
    val profileId: String,
    val token: String? = null
)

@Serializable
data class TodayReportResponse(
    val dateKey: String,
    val preview: String,
    val full: String? = null,
    val unlocked: Boolean
)

@Serializable
data class FaceUploadResponse(
    val dateKey: String,
    val summaryText: String,
    val flags: List<String> = emptyList()
)
