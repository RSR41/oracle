package com.rsr41.oracle.data.local

import android.content.Context
import android.content.SharedPreferences
import android.util.Log
import com.rsr41.oracle.domain.model.BirthInfo
import com.rsr41.oracle.domain.model.CalendarType
import com.rsr41.oracle.domain.model.Gender
import com.rsr41.oracle.domain.model.HistoryItem
import com.rsr41.oracle.domain.model.SajuResult
import org.json.JSONArray
import org.json.JSONObject

/**
 * SharedPreferences 기반 로컬 저장소 매니저
 * - 설정값, 히스토리, 마지막 결과 저장/로드
 * - JSON 파싱 실패 시 안전하게 기본값 반환
 */
class PreferencesManager(context: Context) {
    private val prefs: SharedPreferences = context.getSharedPreferences("oracle_prefs", Context.MODE_PRIVATE)

    companion object {
        private const val TAG = "PreferencesManager"
        private const val KEY_CALENDAR_TYPE = "default_calendar_type"
        private const val KEY_HISTORY = "history_list"
        private const val KEY_LAST_RESULT = "last_result"
        private const val MAX_HISTORY_SIZE = 10
    }

    // ===== 설정값 =====

    fun loadDefaultCalendarType(): CalendarType {
        val typeStr = prefs.getString(KEY_CALENDAR_TYPE, CalendarType.SOLAR.name)
        return try {
            val type = CalendarType.valueOf(typeStr ?: CalendarType.SOLAR.name)
            Log.d(TAG, "Loaded default calendar type: $type")
            type
        } catch (e: Exception) {
            Log.e(TAG, "Failed to load calendar type, using default SOLAR", e)
            CalendarType.SOLAR
        }
    }

    fun saveDefaultCalendarType(type: CalendarType) {
        prefs.edit().putString(KEY_CALENDAR_TYPE, type.name).apply()
        Log.d(TAG, "Saved default calendar type: $type")
    }

    // ===== 히스토리 =====

    fun loadHistory(): List<HistoryItem> {
        val jsonStr = prefs.getString(KEY_HISTORY, "[]")
        val list = parseHistoryList(jsonStr ?: "[]")
        Log.d(TAG, "Loaded history: ${list.size} items")
        return list
    }

    fun appendHistory(item: HistoryItem) {
        val currentList = loadHistory().toMutableList()
        currentList.add(0, item) // 최신이 앞
        while (currentList.size > MAX_HISTORY_SIZE) {
            currentList.removeAt(currentList.lastIndex)
        }
        saveHistoryList(currentList)
        Log.d(TAG, "Appended history item: ${item.id}, total: ${currentList.size}")
    }

    fun deleteHistoryItem(id: String) {
        val currentList = loadHistory().toMutableList()
        val removed = currentList.removeAll { it.id == id }
        if (removed) {
            saveHistoryList(currentList)
            Log.d(TAG, "Deleted history item: $id")
        } else {
            Log.w(TAG, "History item not found for deletion: $id")
        }
    }

    fun clearHistory() {
        prefs.edit().remove(KEY_HISTORY).apply()
        Log.d(TAG, "Cleared all history")
    }

    private fun saveHistoryList(list: List<HistoryItem>) {
        val jsonStr = serializeHistoryList(list)
        prefs.edit().putString(KEY_HISTORY, jsonStr).apply()
    }

    // ===== 마지막 결과 =====

    fun loadLastResult(): HistoryItem? {
        val jsonStr = prefs.getString(KEY_LAST_RESULT, null) ?: return null
        return try {
            val item = parseHistoryItem(JSONObject(jsonStr))
            Log.d(TAG, "Loaded last result: ${item.id}")
            item
        } catch (e: Exception) {
            Log.e(TAG, "Failed to parse last result, returning null", e)
            null
        }
    }

    fun saveLastResult(item: HistoryItem) {
        val jsonStr = serializeHistoryItem(item).toString()
        prefs.edit().putString(KEY_LAST_RESULT, jsonStr).apply()
        Log.d(TAG, "Saved last result: ${item.id}")
    }

    // ===== JSON 직렬화/역직렬화 =====

    private fun serializeHistoryList(list: List<HistoryItem>): String {
        val jsonArray = JSONArray()
        list.forEach { jsonArray.put(serializeHistoryItem(it)) }
        return jsonArray.toString()
    }

    private fun parseHistoryList(jsonStr: String): List<HistoryItem> {
        val list = mutableListOf<HistoryItem>()
        try {
            val jsonArray = JSONArray(jsonStr)
            for (i in 0 until jsonArray.length()) {
                try {
                    list.add(parseHistoryItem(jsonArray.getJSONObject(i)))
                } catch (e: Exception) {
                    Log.e(TAG, "Failed to parse history item at index $i, skipping", e)
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to parse history list, returning empty list", e)
        }
        return list
    }

    private fun serializeHistoryItem(item: HistoryItem): JSONObject {
        val obj = JSONObject()
        obj.put("id", item.id)
        
        val birthObj = JSONObject()
        birthObj.put("date", item.birthInfo.date)
        birthObj.put("time", item.birthInfo.time)
        birthObj.put("gender", item.birthInfo.gender.name)
        birthObj.put("calendarType", item.birthInfo.calendarType.name)
        obj.put("birthInfo", birthObj)

        val resultObj = JSONObject()
        resultObj.put("summaryToday", item.result.summaryToday)
        resultObj.put("pillars", item.result.pillars)
        resultObj.put("generatedAtMillis", item.result.generatedAtMillis)
        obj.put("result", resultObj)
        
        return obj
    }

    private fun parseHistoryItem(obj: JSONObject): HistoryItem {
        val id = obj.getString("id")
        
        val birthObj = obj.getJSONObject("birthInfo")
        val birthInfo = BirthInfo(
            date = birthObj.getString("date"),
            time = birthObj.optString("time", ""),
            gender = Gender.valueOf(birthObj.getString("gender")),
            calendarType = CalendarType.valueOf(birthObj.getString("calendarType"))
        )

        val resultObj = obj.getJSONObject("result")
        val result = SajuResult(
            summaryToday = resultObj.getString("summaryToday"),
            pillars = resultObj.getString("pillars"),
            generatedAtMillis = resultObj.getLong("generatedAtMillis")
        )

        return HistoryItem(id, birthInfo, result)
    }
}
