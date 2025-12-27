package com.rsr41.oracle.core.util

import android.util.Log

/**
 * 날짜/시간 유효성 검증 유틸리티
 */
object ValidationUtil {
    private const val TAG = "ValidationUtil"

    /**
     * yyyy-MM-dd 형식의 날짜 문자열 유효성 검증
     * @return Pair<Boolean, String?> - (유효여부, 에러메시지)
     */
    fun validateDate(dateStr: String): Pair<Boolean, String?> {
        if (dateStr.isBlank()) {
            Log.w(TAG, "Date validation failed: empty string")
            return Pair(false, "날짜를 입력해주세요")
        }

        val regex = Regex("""^\d{4}-\d{2}-\d{2}$""")
        if (!regex.matches(dateStr)) {
            Log.w(TAG, "Date validation failed: invalid format - $dateStr")
            return Pair(false, "날짜 형식이 올바르지 않습니다 (yyyy-MM-dd)")
        }

        val parts = dateStr.split("-")
        val year = parts[0].toIntOrNull() ?: return Pair(false, "연도가 올바르지 않습니다")
        val month = parts[1].toIntOrNull() ?: return Pair(false, "월이 올바르지 않습니다")
        val day = parts[2].toIntOrNull() ?: return Pair(false, "일이 올바르지 않습니다")

        if (year < 1900 || year > 2100) {
            Log.w(TAG, "Date validation failed: year out of range - $year")
            return Pair(false, "연도는 1900~2100 사이여야 합니다")
        }
        if (month < 1 || month > 12) {
            Log.w(TAG, "Date validation failed: month out of range - $month")
            return Pair(false, "월은 1~12 사이여야 합니다")
        }

        val maxDay = when (month) {
            1, 3, 5, 7, 8, 10, 12 -> 31
            4, 6, 9, 11 -> 30
            2 -> if (isLeapYear(year)) 29 else 28
            else -> 31
        }

        if (day < 1 || day > maxDay) {
            Log.w(TAG, "Date validation failed: day out of range - $day for month $month")
            return Pair(false, "일이 올바르지 않습니다 (${month}월은 1~${maxDay}일)")
        }

        Log.d(TAG, "Date validation passed: $dateStr")
        return Pair(true, null)
    }

    /**
     * HH:mm 형식의 시간 문자열 유효성 검증
     * 빈 문자열은 "시간 미입력"으로 허용
     * @return Pair<Boolean, String?> - (유효여부, 에러메시지)
     */
    fun validateTime(timeStr: String): Pair<Boolean, String?> {
        if (timeStr.isBlank()) {
            // 시간 미입력은 허용
            Log.d(TAG, "Time validation: empty (allowed)")
            return Pair(true, null)
        }

        val regex = Regex("""^\d{2}:\d{2}$""")
        if (!regex.matches(timeStr)) {
            Log.w(TAG, "Time validation failed: invalid format - $timeStr")
            return Pair(false, "시간 형식이 올바르지 않습니다 (HH:mm)")
        }

        val parts = timeStr.split(":")
        val hour = parts[0].toIntOrNull() ?: return Pair(false, "시간이 올바르지 않습니다")
        val minute = parts[1].toIntOrNull() ?: return Pair(false, "분이 올바르지 않습니다")

        if (hour < 0 || hour > 23) {
            Log.w(TAG, "Time validation failed: hour out of range - $hour")
            return Pair(false, "시간은 00~23 사이여야 합니다")
        }
        if (minute < 0 || minute > 59) {
            Log.w(TAG, "Time validation failed: minute out of range - $minute")
            return Pair(false, "분은 00~59 사이여야 합니다")
        }

        Log.d(TAG, "Time validation passed: $timeStr")
        return Pair(true, null)
    }

    private fun isLeapYear(year: Int): Boolean {
        return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
    }
}
