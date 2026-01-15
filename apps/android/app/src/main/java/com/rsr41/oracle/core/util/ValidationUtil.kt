package com.rsr41.oracle.core.util

import android.util.Log

/**
 * Validates date and time strings.
 * Returns Pair(Boolean, String?) errors.
 */
object ValidationUtil {
    private const val TAG = "ValidationUtil"

    fun validateDate(dateStr: String): Pair<Boolean, String?> {
        if (dateStr.isBlank()) {
            return Pair(false, "Please enter a date")
        }

        val regex = Regex("""^\d{4}-\d{2}-\d{2}$""")
        if (!regex.matches(dateStr)) {
            return Pair(false, "Invalid date format (yyyy-MM-dd)")
        }

        val parts = dateStr.split("-")
        val year = parts[0].toIntOrNull() ?: return Pair(false, "Invalid year")
        val month = parts[1].toIntOrNull() ?: return Pair(false, "Invalid month")
        val day = parts[2].toIntOrNull() ?: return Pair(false, "Invalid day")

        if (year < 1900 || year > 2100) {
            return Pair(false, "Year must be 1900-2100")
        }
        if (month < 1 || month > 12) {
            return Pair(false, "Month must be 1-12")
        }

        val maxDay = when (month) {
            1, 3, 5, 7, 8, 10, 12 -> 31
            4, 6, 9, 11 -> 30
            2 -> if (isLeapYear(year)) 29 else 28
            else -> 31
        }

        if (day < 1 || day > maxDay) {
            return Pair(false, "Day out of range")
        }

        return Pair(true, null)
    }

    fun validateTime(timeStr: String): Pair<Boolean, String?> {
        if (timeStr.isBlank()) {
            return Pair(true, null)
        }

        val regex = Regex("""^\d{2}:\d{2}$""")
        if (!regex.matches(timeStr)) {
            return Pair(false, "Invalid time format (HH:mm)")
        }

        val parts = timeStr.split(":")
        val hour = parts[0].toIntOrNull() ?: return Pair(false, "Invalid hour")
        val minute = parts[1].toIntOrNull() ?: return Pair(false, "Invalid minute")

        if (hour < 0 || hour > 23) {
            return Pair(false, "Hour must be 00-23")
        }
        if (minute < 0 || minute > 59) {
            return Pair(false, "Minute must be 00-59")
        }

        return Pair(true, null)
    }

    private fun isLeapYear(year: Int): Boolean {
        return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
    }
}
