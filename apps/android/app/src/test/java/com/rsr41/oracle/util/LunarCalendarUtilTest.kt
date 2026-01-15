package com.rsr41.oracle.util

import org.junit.Assert.assertEquals
import org.junit.Test
import java.time.LocalDate

class LunarCalendarUtilTest {

    // Test vectors based on reliable sources (e.g. KASI or standard converters)
    // 2023 Lunar Leap Month: Month 2 is leap (Yun-dal 2wol) -> Checking accuracy
    // Actually 2023 had leap month 2 following regular month 2.
    // Solar 2023-03-22 is Lunar 2023-02-01 (Leap)

    @Test
    fun testSolarToLunar_NormalDate() {
        // Seollal 2024: Solar 2024-02-10 -> Lunar 2024-01-01
        val solar = LocalDate.of(2024, 2, 10)
        val lunar = LunarCalendarUtil.solarToLunar(solar)
        
        assertEquals(2024, lunar.year)
        assertEquals(1, lunar.month)
        assertEquals(1, lunar.day)
        assertEquals(false, lunar.isLeapMonth)
    }

    @Test
    fun testLunarToSolar_NormalDate() {
        // Seollal 2024: Lunar 2024-01-01 -> Solar 2024-02-10
        val solar = LunarCalendarUtil.lunarToSolar(2024, 1, 1, false)
        
        assertEquals(2024, solar.year)
        assertEquals(2, solar.monthValue)
        assertEquals(10, solar.dayOfMonth)
    }

    @Test
    fun testSolarToLunar_LeapMonth() {
        // 2023 has Leap Month 2
        // Solar 2023-03-22 corresponds to Lunar 2023-02-01 (Leap)
        val solar = LocalDate.of(2023, 3, 22)
        val lunar = LunarCalendarUtil.solarToLunar(solar)
        
        assertEquals(2023, lunar.year)
        assertEquals(2, lunar.month)
        assertEquals(1, lunar.day)
        assertEquals(true, lunar.isLeapMonth)
    }

    @Test
    fun testLunarToSolar_LeapMonth() {
        // Lunar 2023-02-01 (Leap) -> Solar 2023-03-22
        val solar = LunarCalendarUtil.lunarToSolar(2023, 2, 1, true)
        
        assertEquals(2023, solar.year)
        assertEquals(3, solar.monthValue)
        assertEquals(22, solar.dayOfMonth)
    }

    @Test
    fun testSolarToLunar_BeforeLeapMonth() {
        // Solar 2023-03-21 -> Lunar 2023-02-30 (Non-Leap)
        val solar = LocalDate.of(2023, 3, 21)
        val lunar = LunarCalendarUtil.solarToLunar(solar)
        
        assertEquals(2023, lunar.year)
        assertEquals(2, lunar.month)
        assertEquals(30, lunar.day)
        assertEquals(false, lunar.isLeapMonth)
    }

    @Test
    fun testRoundTrip_VariousDates() {
        val dates = listOf(
            LocalDate.of(1990, 1, 1),
            LocalDate.of(2000, 12, 31),
            LocalDate.of(2024, 2, 29), // Leap year solar
            LocalDate.of(2023, 5, 5),
            LocalDate.of(1980, 8, 15)
        )

        for (solar in dates) {
            val lunar = LunarCalendarUtil.solarToLunar(solar)
            val solarBack = LunarCalendarUtil.lunarToSolar(lunar.year, lunar.month, lunar.day, lunar.isLeapMonth)
            assertEquals("Round trip failed for $solar", solar, solarBack)
        }
    }
    
    @Test
    fun testRoundTrip_LeapMonthCases() {
        // 2020 Leap Month 4
        // 2023 Leap Month 2
        // 2025 Leap Month 6
        
        // Solar 2020-05-23 -> Lunar 2020-04-01 (Leap)
        val solarLeap2020 = LocalDate.of(2020, 5, 23)
        val lunar2020 = LunarCalendarUtil.solarToLunar(solarLeap2020)
        assertEquals(true, lunar2020.isLeapMonth)
        val back2020 = LunarCalendarUtil.lunarToSolar(lunar2020.year, lunar2020.month, lunar2020.day, lunar2020.isLeapMonth)
        assertEquals(solarLeap2020, back2020)
        
        // Solar 2025-07-25 -> Lunar 2025-06-01 (Leap)
        val solarLeap2025 = LocalDate.of(2025, 7, 25)
        val lunar2025 = LunarCalendarUtil.solarToLunar(solarLeap2025)
        assertEquals(true, lunar2025.isLeapMonth)
        val back2025 = LunarCalendarUtil.lunarToSolar(lunar2025.year, lunar2025.month, lunar2025.day, lunar2025.isLeapMonth)
        assertEquals(solarLeap2025, back2025)
    }
}
