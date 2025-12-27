package com.rsr41.oracle.domain.model

data class BirthInfo(
    val date: String, // yyyy-MM-dd
    val time: String, // HH:mm or ""
    val gender: Gender,
    val calendarType: CalendarType
)
