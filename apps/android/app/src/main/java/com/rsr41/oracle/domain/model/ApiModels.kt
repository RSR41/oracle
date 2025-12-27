package com.rsr41.oracle.domain.model

data class TagStatus(
    val token: String,
    val status: TagStatusType,
    val boundProfileId: String?
)

enum class TagStatusType {
    ACTIVE, INACTIVE, REVOKED, UNKNOWN;
    companion object {
        fun fromString(value: String): TagStatusType = when (value.lowercase()) {
            "active" -> ACTIVE
            "inactive" -> INACTIVE
            "revoked" -> REVOKED
            else -> UNKNOWN
        }
    }
}

data class ProfileInput(
    val birthDate: String,
    val birthTime: String?,
    val timeUnknown: Boolean,
    val calendarType: CalendarType,
    val gender: Gender
)

data class Profile(
    val id: String,
    val name: String,
    val birthDate: String,
    val birthTime: String?,
    val timeUnknown: Boolean,
    val calendarType: CalendarType,
    val gender: Gender
)

data class CheckInResult(
    val dateKey: String,
    val unlocked: Boolean,
    val alreadyCheckedIn: Boolean
)

data class TodayReport(
    val dateKey: String,
    val preview: String,
    val full: String?,
    val unlocked: Boolean
)

data class FaceResult(
    val dateKey: String,
    val summaryText: String,
    val flags: List<String>
)
