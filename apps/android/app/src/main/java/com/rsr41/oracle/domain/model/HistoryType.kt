package com.rsr41.oracle.domain.model

/**
 * 히스토리 유형
 */
enum class HistoryType {
    SAJU_FORTUNE,
    MANSE_DAEUN,
    MANSE_SEUN,
    MANSE_WOLUN,
    COMPATIBILITY,
    TAROT,
    FACE,
    DREAM;

    companion object {
        fun fromString(value: String): HistoryType = try {
            valueOf(value)
        } catch (e: Exception) {
            SAJU_FORTUNE
        }
    }
}
