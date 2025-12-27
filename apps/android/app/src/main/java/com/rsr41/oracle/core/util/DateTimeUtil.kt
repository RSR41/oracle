package com.rsr41.oracle.core.util

import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * 날짜/시간 포맷팅 유틸리티
 */
object DateTimeUtil {
    
    /**
     * 현재 날짜를 yyyy-MM-dd 형식으로 반환
     */
    fun getCurrentDateString(): String {
        val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
        return sdf.format(Date())
    }

    /**
     * 현재 시간을 HH:mm 형식으로 반환
     */
    fun getCurrentTimeString(): String {
        val sdf = SimpleDateFormat("HH:mm", Locale.getDefault())
        return sdf.format(Date())
    }

    /**
     * 밀리초를 yyyy-MM-dd HH:mm 형식으로 변환
     */
    fun formatMillisToDateTime(millis: Long): String {
        val sdf = SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.getDefault())
        return sdf.format(Date(millis))
    }

    /**
     * 밀리초를 yyyy-MM-dd 형식으로 변환
     */
    fun formatMillisToDate(millis: Long): String {
        val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
        return sdf.format(Date(millis))
    }
}
