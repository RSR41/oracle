package com.rsr41.oracle.domain.model

/**
 * 앱 지원 언어
 */
enum class AppLanguage(val code: String, val displayName: String) {
    KOREAN("ko", "한국어"),
    ENGLISH("en", "English"),
    SYSTEM("system", "System");  // 시스템 언어 따름
    
    companion object {
        fun fromCode(code: String): AppLanguage {
            return entries.find { it.code == code } ?: SYSTEM
        }
    }
}
