package com.rsr41.oracle.data.local

import android.content.Context
import android.content.SharedPreferences
import android.util.Log
import com.rsr41.oracle.domain.model.BirthInfo
import com.rsr41.oracle.domain.model.CalendarType
import com.rsr41.oracle.domain.model.Gender
import com.rsr41.oracle.domain.model.HistoryItem
import com.rsr41.oracle.domain.model.HistoryRecord
import com.rsr41.oracle.domain.model.HistoryType
import com.rsr41.oracle.domain.model.Profile
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
        private const val KEY_PROFILES = "profiles_list"
        private const val KEY_HISTORY_RECORDS = "history_records_list"
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

    // ===== 프로필 (Local only) =====

    fun loadProfiles(): List<Profile> {
        val jsonStr = prefs.getString(KEY_PROFILES, "[]")
        return parseProfileList(jsonStr ?: "[]")
    }

    fun saveProfile(profile: Profile) {
        val currentList = loadProfiles().toMutableList()
        val index = currentList.indexOfFirst { it.id == profile.id }
        if (index >= 0) {
            currentList[index] = profile
        } else {
            currentList.add(profile)
        }
        saveProfileList(currentList)
    }

    fun deleteProfile(id: String) {
        val currentList = loadProfiles().toMutableList()
        if (currentList.removeAll { it.id == id }) {
            saveProfileList(currentList)
        }
    }

    private fun saveProfileList(list: List<Profile>) {
        val jsonArray = JSONArray()
        list.forEach { jsonArray.put(serializeProfile(it)) }
        prefs.edit().putString(KEY_PROFILES, jsonArray.toString()).apply()
    }

    private fun parseProfileList(jsonStr: String): List<Profile> {
        val list = mutableListOf<Profile>()
        try {
            val jsonArray = JSONArray(jsonStr)
            for (i in 0 until jsonArray.length()) {
                list.add(parseProfile(jsonArray.getJSONObject(i)))
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to parse profile list", e)
        }
        return list
    }

    private fun serializeProfile(p: Profile): JSONObject {
        val obj = JSONObject()
        obj.put("id", p.id)
        obj.put("nickname", p.nickname)
        obj.put("birthDate", p.birthDate)
        obj.put("birthTime", p.birthTime)
        obj.put("timeUnknown", p.timeUnknown)
        obj.put("calendarType", p.calendarType.name)
        obj.put("gender", p.gender.name)
        obj.put("createdAt", p.createdAt)
        return obj
    }

    private fun parseProfile(obj: JSONObject): Profile {
        return Profile(
            id = obj.getString("id"),
            nickname = obj.getString("nickname"),
            birthDate = obj.getString("birthDate"),
            birthTime = obj.optString("birthTime", null),
            timeUnknown = obj.optBoolean("timeUnknown", false),
            calendarType = CalendarType.valueOf(obj.getString("calendarType")),
            gender = Gender.valueOf(obj.getString("gender")),
            createdAt = obj.optLong("createdAt", System.currentTimeMillis())
        )
    }

    // ===== 히스토리 (Enhanced) =====

    fun loadHistoryRecords(): List<HistoryRecord> {
        val jsonStr = prefs.getString(KEY_HISTORY_RECORDS, "[]")
        return parseHistoryRecordList(jsonStr ?: "[]")
    }

    fun appendHistoryRecord(record: HistoryRecord) {
        val currentList = loadHistoryRecords().toMutableList()
        currentList.add(0, record)
        while (currentList.size > MAX_HISTORY_SIZE) {
            currentList.removeAt(currentList.lastIndex)
        }
        saveHistoryRecordList(currentList)
    }

    fun deleteHistoryRecord(id: String) {
        val currentList = loadHistoryRecords().toMutableList()
        if (currentList.removeAll { it.id == id }) {
            saveHistoryRecordList(currentList)
        }
    }

    fun clearAllHistoryRecords() {
        prefs.edit().remove(KEY_HISTORY_RECORDS).apply()
    }

    private fun saveHistoryRecordList(list: List<HistoryRecord>) {
        val jsonArray = JSONArray()
        list.forEach { jsonArray.put(serializeHistoryRecord(it)) }
        prefs.edit().putString(KEY_HISTORY_RECORDS, jsonArray.toString()).apply()
    }

    private fun parseHistoryRecordList(jsonStr: String): List<HistoryRecord> {
        val list = mutableListOf<HistoryRecord>()
        try {
            val jsonArray = JSONArray(jsonStr)
            for (i in 0 until jsonArray.length()) {
                list.add(parseHistoryRecord(jsonArray.getJSONObject(i)))
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to parse history records list", e)
        }
        return list
    }

    private fun serializeHistoryRecord(r: HistoryRecord): JSONObject {
        val obj = JSONObject()
        obj.put("id", r.id)
        obj.put("type", r.type.name)
        obj.put("title", r.title)
        obj.put("summary", r.summary)
        obj.put("payload", r.payload)
        obj.put("profileId", r.profileId)
        obj.put("partnerProfileId", r.partnerProfileId)
        obj.put("createdAt", r.createdAt)
        return obj
    }

    private fun parseHistoryRecord(obj: JSONObject): HistoryRecord {
        return HistoryRecord(
            id = obj.getString("id"),
            type = HistoryType.fromString(obj.getString("type")),
            title = obj.getString("title"),
            summary = obj.getString("summary"),
            payload = obj.getString("payload"),
            profileId = obj.optString("profileId", null),
            partnerProfileId = obj.optString("partnerProfileId", null),
            createdAt = obj.getLong("createdAt")
        )
    }

    // ===== 레거시 히스토리 (Compatibility) =====

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

    // ===== JSON 직렬화/역직렬화 (Legacy) =====

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
