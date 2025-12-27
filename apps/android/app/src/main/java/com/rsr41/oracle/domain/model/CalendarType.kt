package com.rsr41.oracle.domain.model

enum class CalendarType(val apiValue: String, val displayName: String) {
    SOLAR("solar", "양력"),
    LUNAR("lunar", "음력");

    companion object {
        fun fromApiValue(value: String): CalendarType = entries.find { it.apiValue == value } ?: SOLAR
    }
}
