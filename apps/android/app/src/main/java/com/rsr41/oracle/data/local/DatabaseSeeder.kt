package com.rsr41.oracle.data.local

import android.content.Context
import android.util.Log
import com.rsr41.oracle.data.local.entity.DreamInterpretationEntity
import com.rsr41.oracle.data.local.entity.SajuContentEntity
import com.rsr41.oracle.data.local.entity.TarotCardEntity
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.json.JSONArray
import org.json.JSONObject

/**
 * 데이터베이스 Seeder
 * - 첫 실행 시 assets에서 seed 데이터를 로드하여 Room DB에 저장
 */
class DatabaseSeeder(
    private val context: Context,
    private val database: OracleDatabase
) {
    companion object {
        private const val TAG = "DatabaseSeeder"
        private const val PREF_NAME = "database_seeder"
        private const val KEY_SEEDED = "data_seeded_v2"
    }
    
    private val prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)
    
    /**
     * seed 데이터가 필요한지 확인하고 필요하면 import
     */
    suspend fun seedIfNeeded() {
        if (prefs.getBoolean(KEY_SEEDED, false)) {
            Log.d(TAG, "Database already seeded, skipping")
            return
        }
        
        withContext(Dispatchers.IO) {
            try {
                seedTarotCards()
                seedSajuContent()
                seedDreamInterpretations()
                
                prefs.edit().putBoolean(KEY_SEEDED, true).apply()
                Log.d(TAG, "Database seeding completed successfully")
            } catch (e: Exception) {
                Log.e(TAG, "Error seeding database", e)
            }
        }
    }
    
    private suspend fun seedTarotCards() {
        val count = database.tarotCardDao().getCount()
        if (count > 0) {
            Log.d(TAG, "Tarot cards already exist ($count), skipping")
            return
        }
        
        val json = loadJsonFromAssets("seed/tarot_cards.json") ?: return
        val cards = mutableListOf<TarotCardEntity>()
        
        val jsonArray = JSONArray(json)
        for (i in 0 until jsonArray.length()) {
            val obj = jsonArray.getJSONObject(i)
            cards.add(parseTarotCard(obj))
        }
        
        database.tarotCardDao().insertAll(cards)
        Log.d(TAG, "Seeded ${cards.size} tarot cards")
    }
    
    private suspend fun seedSajuContent() {
        val count = database.sajuContentDao().getCount()
        if (count > 0) {
            Log.d(TAG, "Saju content already exists ($count), skipping")
            return
        }
        
        val json = loadJsonFromAssets("seed/saju_content.json") ?: return
        val content = mutableListOf<SajuContentEntity>()
        
        val jsonArray = JSONArray(json)
        for (i in 0 until jsonArray.length()) {
            val obj = jsonArray.getJSONObject(i)
            content.add(parseSajuContent(obj))
        }
        
        database.sajuContentDao().insertAll(content)
        Log.d(TAG, "Seeded ${content.size} saju content items")
    }
    
    private suspend fun seedDreamInterpretations() {
        val count = database.dreamDao().getCount()
        if (count > 0) {
            Log.d(TAG, "Dream interpretations already exist ($count), skipping")
            return
        }
        
        val json = loadJsonFromAssets("seed/dream_interpretations.json") ?: return
        val dreams = mutableListOf<DreamInterpretationEntity>()
        
        val jsonArray = JSONArray(json)
        for (i in 0 until jsonArray.length()) {
            val obj = jsonArray.getJSONObject(i)
            dreams.add(parseDreamInterpretation(obj))
        }
        
        database.dreamDao().insertAll(dreams)
        Log.d(TAG, "Seeded ${dreams.size} dream interpretations")
    }
    
    private fun loadJsonFromAssets(fileName: String): String? {
        return try {
            context.assets.open(fileName).bufferedReader().use { it.readText() }
        } catch (e: Exception) {
            Log.e(TAG, "Error loading $fileName from assets", e)
            null
        }
    }
    
    private fun parseTarotCard(obj: JSONObject): TarotCardEntity {
        return TarotCardEntity(
            id = obj.getString("id"),
            nameKo = obj.getString("nameKo"),
            nameEn = obj.getString("nameEn"),
            category = obj.getString("category"),
            number = obj.getInt("number"),
            uprightMeaningKo = obj.getString("uprightMeaningKo"),
            uprightMeaningEn = obj.getString("uprightMeaningEn"),
            reversedMeaningKo = obj.getString("reversedMeaningKo"),
            reversedMeaningEn = obj.getString("reversedMeaningEn"),
            keywordsKo = obj.optString("keywordsKo", ""),
            keywordsEn = obj.optString("keywordsEn", ""),
            imagePath = obj.optString("imagePath", "")
        )
    }
    
    private fun parseSajuContent(obj: JSONObject): SajuContentEntity {
        return SajuContentEntity(
            id = obj.getString("id"),
            type = obj.getString("type"),
            code = obj.getString("code"),
            nameKo = obj.getString("nameKo"),
            nameEn = obj.getString("nameEn"),
            descriptionKo = obj.getString("descriptionKo"),
            descriptionEn = obj.getString("descriptionEn"),
            attributeKo = obj.optString("attributeKo", ""),
            attributeEn = obj.optString("attributeEn", ""),
            imagePath = obj.optString("imagePath", "")
        )
    }
    
    private fun parseDreamInterpretation(obj: JSONObject): DreamInterpretationEntity {
        return DreamInterpretationEntity(
            id = obj.getString("id"),
            keywordKo = obj.getString("keywordKo"),
            keywordEn = obj.getString("keywordEn"),
            category = obj.getString("category"),
            synonymsKo = obj.optString("synonymsKo", ""),
            synonymsEn = obj.optString("synonymsEn", ""),
            interpretationKo = obj.getString("interpretationKo"),
            interpretationEn = obj.getString("interpretationEn"),
            isGoodDream = if (obj.isNull("isGoodDream")) null else obj.getBoolean("isGoodDream"),
            relatedKeywordsKo = obj.optString("relatedKeywordsKo", ""),
            relatedKeywordsEn = obj.optString("relatedKeywordsEn", "")
        )
    }
}
