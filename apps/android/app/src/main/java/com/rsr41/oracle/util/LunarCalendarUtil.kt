package com.rsr41.oracle.util

import android.icu.util.ChineseCalendar
import android.icu.util.Calendar
import java.time.LocalDate

data class LunarDate(
    val year: Int,
    val month: Int, // 1-12
    val day: Int,
    val isLeapMonth: Boolean
)

object LunarCalendarUtil {

    /**
     * Convert Solar (Gregorian) date to Lunar date
     */
    fun solarToLunar(date: LocalDate): LunarDate {
        val calendar = ChineseCalendar()
        calendar.set(date.year, date.monthValue - 1, date.dayOfMonth)
        
        val lunarYear = calendar.get(ChineseCalendar.EXTENDED_YEAR) - 2637
        val lunarMonth = calendar.get(ChineseCalendar.MONTH) + 1
        val lunarDay = calendar.get(ChineseCalendar.DAY_OF_MONTH)
        val isLeap = calendar.get(ChineseCalendar.IS_LEAP_MONTH) == 1
        
        return LunarDate(lunarYear, lunarMonth, lunarDay, isLeap)
    }

    /**
     * Convert Lunar date to Solar (Gregorian) date
     * @param year Lunar Year (e.g. 2024)
     * @param month Lunar Month (1-12)
     * @param day Lunar Day (1-30)
     * @param isLeapMonth Whether this month is a leap month
     */
    fun lunarToSolar(year: Int, month: Int, day: Int, isLeapMonth: Boolean): LocalDate {
        val calendar = ChineseCalendar()
        calendar.set(ChineseCalendar.EXTENDED_YEAR, year + 2637)
        calendar.set(ChineseCalendar.MONTH, month - 1)
        calendar.set(ChineseCalendar.IS_LEAP_MONTH, if (isLeapMonth) 1 else 0)
        calendar.set(ChineseCalendar.DAY_OF_MONTH, day)
        
        // Compute time to update fields
        calendar.timeInMillis
        
        val solarYear = calendar.get(Calendar.YEAR)
        val solarMonth = calendar.get(Calendar.MONTH) + 1
        val solarDay = calendar.get(Calendar.DAY_OF_MONTH)
        
        return LocalDate.of(solarYear, solarMonth, solarDay)
    }
}
