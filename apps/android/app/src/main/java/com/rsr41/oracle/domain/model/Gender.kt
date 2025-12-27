package com.rsr41.oracle.domain.model

enum class Gender(val apiValue: String, val displayName: String) {
    MALE("male", "남성"),
    FEMALE("female", "여성");

    companion object {
        fun fromApiValue(value: String): Gender = entries.find { it.apiValue == value } ?: MALE
    }
}
