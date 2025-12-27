# tools/apply_android_mvp.ps1
# 목적:
# - Android Studio가 만든 기본 프로젝트(app/build.gradle.kts, AndroidManifest.xml)가 존재할 때
# - 내가 원하는 "MVP 구조 + 전체 Kotlin 코드"를 apps/android 아래에 자동 생성/덮어쓰기

$ErrorActionPreference = "Stop"

# 루트(oracle) 경로 계산
$root = Split-Path $PSScriptRoot -Parent
$androidRoot = Join-Path $root "apps\android"

Write-Host "ROOT: $root"
Write-Host "ANDROID_ROOT: $androidRoot"

# 1) 기본 프로젝트 존재 확인
$appGradle = Join-Path $androidRoot "app\build.gradle.kts"
$manifest  = Join-Path $androidRoot "app\src\main\AndroidManifest.xml"

if (!(Test-Path $appGradle) -or !(Test-Path $manifest)) {
  Write-Host "[X] Android 기본 프로젝트가 아직 없습니다."
  Write-Host "=> Android Studio로 먼저 Empty(Compose) 프로젝트를 아래 경로에 생성하세요:"
  Write-Host "   $androidRoot"
  Write-Host "=> 그 다음 다시 이 스크립트를 실행하세요."
  exit 1
}

# 2) namespace(패키지) 자동 감지: app/build.gradle.kts에서 namespace 추출
$gradleText = Get-Content $appGradle -Raw
$ns = $null
if ($gradleText -match 'namespace\s*=\s*"([^"]+)"') { $ns = $Matches[1] }
if (-not $ns) { $ns = "com.rsr41.oracle" } # 못 찾으면 기본값
Write-Host "[OK] namespace = $ns"

# 3) 경로 계산
$pkgPath = $ns.Replace(".", "\")
$javaBase = Join-Path $androidRoot ("app\src\main\java\" + $pkgPath)

function Write-TextFile($path, $content) {
  $dir = Split-Path $path -Parent
  if (!(Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  Set-Content -Path $path -Value $content -Encoding utf8
  Write-Host "WROTE: $path"
}

# 4) 디렉터리 구조 생성
$dirs = @(
  "$javaBase\di",
  "$javaBase\data\local",
  "$javaBase\data\remote\dto",
  "$javaBase\data\repository",
  "$javaBase\ui",
  "$javaBase\ui\navigation",
  "$javaBase\ui\screens",
  "$javaBase\ui\components",
  (Join-Path $androidRoot "app\src\main\res\values")
)

foreach ($d in $dirs) {
  if (!(Test-Path $d)) { New-Item -ItemType Directory -Force -Path $d | Out-Null }
}

# ------------------------------------------------------------
# 5) Kotlin/Resource 파일 생성(= 너가 원한 트리 구조 + MVP 코드)
# ------------------------------------------------------------

# (A) UI Entry
Write-TextFile (Join-Path $javaBase "ui\MainActivity.kt") @"
package $ns.ui

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import $ns.ui.navigation.OracleApp

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContent {
            Surface(color = MaterialTheme.colorScheme.background) {
                OracleApp()
            }
        }
    }
}
"@

# (B) Navigation (라이브러리 없이 state로 MVP 구현)
Write-TextFile (Join-Path $javaBase "ui\navigation\NavGraph.kt") @"
package $ns.ui.navigation

import androidx.compose.runtime.*
import $ns.data.local.PreferencesManager
import $ns.data.repository.OracleRepository
import $ns.ui.screens.*

private enum class Route { Splash, Profile, MainTabs }
private enum class Tab { Home, Fortune, Tarot, Weather, Amulet }

@Composable
fun OracleApp() {
    val prefs = remember { PreferencesManager() }
    val repo = remember { OracleRepository(prefs) }

    var route by remember { mutableStateOf(Route.Splash) }
    var selectedTab by remember { mutableStateOf(Tab.Home) }

    when (route) {
        Route.Splash -> SplashScreen(
            prefs = prefs,
            onGoProfile = { route = Route.Profile },
            onGoMain = {
                route = Route.MainTabs
                selectedTab = Tab.Home
            }
        )

        Route.Profile -> ProfileScreen(
            prefs = prefs,
            onSaved = {
                route = Route.MainTabs
                selectedTab = Tab.Home
            }
        )

        Route.MainTabs -> MainTabsScaffold(
            selectedTab = selectedTab,
            onSelectTab = { selectedTab = it },
            repo = repo,
            prefs = prefs
        )
    }
}

@Composable
private fun MainTabsScaffold(
    selectedTab: Tab,
    onSelectTab: (Tab) -> Unit,
    repo: OracleRepository,
    prefs: PreferencesManager
) {
    when (selectedTab) {
        Tab.Home -> HomeScreen(repo = repo, onGoFortune = { onSelectTab(Tab.Fortune) })
        Tab.Fortune -> FortuneScreen(repo = repo)
        Tab.Tarot -> TarotScreen()
        Tab.Weather -> WeatherScreen()
        Tab.Amulet -> AmuletScreen()
    }

    BottomTabs(
        selectedTab = selectedTab,
        onSelectTab = onSelectTab
    )
}
"@

Write-TextFile (Join-Path $javaBase "ui\navigation\BottomTabs.kt") @"
package $ns.ui.navigation

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier

private enum class Tab { Home, Fortune, Tarot, Weather, Amulet }

@Composable
fun BottomTabs(
    selectedTab: Any,
    onSelectTab: (Any) -> Unit
) {
    // NavGraph.kt 내부 enum(Tab)과 이름을 맞추기 위해 문자열 기반으로 처리(의존성 최소화)
    val current = selectedTab.toString()

    Spacer(Modifier.height(56.dp))
    Surface(tonalElevation = 2.dp) {
        NavigationBar {
            NavigationBarItem(
                selected = current.contains("Home"),
                onClick = { onSelectTab(Enum.valueOf(Class.forName("$ns.ui.navigation.NavGraphKt\$Tab") as Class<Enum<*>>, "Home")) },
                icon = { },
                label = { Text("홈") }
            )
            NavigationBarItem(
                selected = current.contains("Fortune"),
                onClick = { onSelectTab(Enum.valueOf(Class.forName("$ns.ui.navigation.NavGraphKt\$Tab") as Class<Enum<*>>, "Fortune")) },
                icon = { },
                label = { Text("운세") }
            )
            NavigationBarItem(
                selected = current.contains("Tarot"),
                onClick = { onSelectTab(Enum.valueOf(Class.forName("$ns.ui.navigation.NavGraphKt\$Tab") as Class<Enum<*>>, "Tarot")) },
                icon = { },
                label = { Text("타로") }
            )
            NavigationBarItem(
                selected = current.contains("Weather"),
                onClick = { onSelectTab(Enum.valueOf(Class.forName("$ns.ui.navigation.NavGraphKt\$Tab") as Class<Enum<*>>, "Weather")) },
                icon = { },
                label = { Text("날씨") }
            )
            NavigationBarItem(
                selected = current.contains("Amulet"),
                onClick = { onSelectTab(Enum.valueOf(Class.forName("$ns.ui.navigation.NavGraphKt\$Tab") as Class<Enum<*>>, "Amulet")) },
                icon = { },
                label = { Text("부적") }
            )
        }
    }
}
"@

# (C) Local Storage (SharedPreferences 기반: 추가 라이브러리 없이 100% 빌드 안정)
Write-TextFile (Join-Path $javaBase "data\local\PreferencesManager.kt") @"
package $ns.data.local

import android.content.Context
import android.content.SharedPreferences
import $ns.ui.screens.AppContext

data class UserProfile(
    val birthDate: String,
    val birthTime: String,
    val timeUnknown: Boolean,
    val calendarType: String, // solar/lunar
    val gender: String        // male/female/unspecified
)

data class DailyFortune(
    val dateKey: String,
    val score: Int,
    val preview: String,
    val full: String,
    val unlocked: Boolean,
    val love: Int,
    val career: Int,
    val health: Int,
    val money: Int
)

class PreferencesManager {

    private fun prefs(): SharedPreferences {
        val ctx: Context = AppContext.require()
        return ctx.getSharedPreferences("oracle_prefs", Context.MODE_PRIVATE)
    }

    fun hasProfile(): Boolean {
        return prefs().getString("birthDate", "").orEmpty().isNotBlank()
    }

    fun saveProfile(profile: UserProfile) {
        prefs().edit()
            .putString("birthDate", profile.birthDate)
            .putString("birthTime", profile.birthTime)
            .putBoolean("timeUnknown", profile.timeUnknown)
            .putString("calendarType", profile.calendarType)
            .putString("gender", profile.gender)
            .apply()
    }

    fun loadProfile(): UserProfile? {
        val birthDate = prefs().getString("birthDate", "").orEmpty()
        if (birthDate.isBlank()) return null
        return UserProfile(
            birthDate = birthDate,
            birthTime = prefs().getString("birthTime", "").orEmpty(),
            timeUnknown = prefs().getBoolean("timeUnknown", true),
            calendarType = prefs().getString("calendarType", "solar").orEmpty(),
            gender = prefs().getString("gender", "unspecified").orEmpty()
        )
    }

    fun saveTodayFortune(f: DailyFortune) {
        prefs().edit()
            .putString("today_dateKey", f.dateKey)
            .putInt("today_score", f.score)
            .putString("today_preview", f.preview)
            .putString("today_full", f.full)
            .putBoolean("today_unlocked", f.unlocked)
            .putInt("today_love", f.love)
            .putInt("today_career", f.career)
            .putInt("today_health", f.health)
            .putInt("today_money", f.money)
            .apply()
    }

    fun loadTodayFortune(dateKey: String): DailyFortune? {
        val savedKey = prefs().getString("today_dateKey", "").orEmpty()
        if (savedKey != dateKey) return null

        return DailyFortune(
            dateKey = savedKey,
            score = prefs().getInt("today_score", 0),
            preview = prefs().getString("today_preview", "").orEmpty(),
            full = prefs().getString("today_full", "").orEmpty(),
            unlocked = prefs().getBoolean("today_unlocked", false),
            love = prefs().getInt("today_love", 0),
            career = prefs().getInt("today_career", 0),
            health = prefs().getInt("today_health", 0),
            money = prefs().getInt("today_money", 0)
        )
    }

    fun lastCheckinDate(): String {
        return prefs().getString("last_checkin_date", "").orEmpty()
    }

    fun setLastCheckinDate(dateKey: String) {
        prefs().edit().putString("last_checkin_date", dateKey).apply()
    }
}
"@

# (D) Repository (운세 생성/체크인)
Write-TextFile (Join-Path $javaBase "data\repository\OracleRepository.kt") @"
package $ns.data.repository

import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import $ns.data.local.DailyFortune
import $ns.data.local.PreferencesManager

class OracleRepository(
    private val prefs: PreferencesManager
) {
    fun todayDateKey(): String {
        val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.KOREA)
        return sdf.format(Date())
    }

    fun getTodayFortune(): DailyFortune {
        val dateKey = todayDateKey()

        // 저장된 오늘 운세가 있으면 그대로 사용
        val cached = prefs.loadTodayFortune(dateKey)
        if (cached != null) return cached

        // 없으면 생성(결정적 생성: dateKey 기반)
        val seed = dateKey.hashCode()
        val score = 60 + kotlin.math.abs(seed % 41) // 60~100
        val love = 40 + kotlin.math.abs((seed * 3) % 61)    // 40~100
        val career = 40 + kotlin.math.abs((seed * 5) % 61)
        val health = 40 + kotlin.math.abs((seed * 7) % 61)
        val money = 40 + kotlin.math.abs((seed * 11) % 61)

        val preview = "오늘은 긍정적인 에너지가 가득한 날입니다."
        val fullLocked = "전체 운세는 체크인 후 열립니다."
        val unlocked = prefs.lastCheckinDate() == dateKey

        val full = if (unlocked) {
            "사소한 일은 OK!\n작은 기회가 커질 수 있으니 대화와 약속을 지켜보세요.\n금전운은 무리하지 말고 지출을 정리하면 좋아요."
        } else fullLocked

        val fortune = DailyFortune(
            dateKey = dateKey,
            score = score,
            preview = preview,
            full = full,
            unlocked = unlocked,
            love = love,
            career = career,
            health = health,
            money = money
        )

        prefs.saveTodayFortune(fortune)
        return fortune
    }

    fun checkinUnlock(): DailyFortune {
        val dateKey = todayDateKey()
        prefs.setLastCheckinDate(dateKey)

        val current = getTodayFortune()
        val unlockedFull = "체크인 완료!\n오늘의 운세 전체가 열렸습니다.\n사소한 일은 OK, 중요한 선택은 천천히 확인하세요."

        val updated = current.copy(
            unlocked = true,
            full = unlockedFull
        )
        prefs.saveTodayFortune(updated)
        return updated
    }
}
"@

# (E) AppContext (SharedPreferences를 위해 전역 Context 제공)
Write-TextFile (Join-Path $javaBase "ui\screens\AppContext.kt") @"
package $ns.ui.screens

import android.app.Application
import android.content.Context

object AppContext {
    private var app: Application? = null

    fun init(application: Application) {
        app = application
    }

    fun require(): Context {
        return app ?: error("AppContext가 초기화되지 않았습니다. (AppContext.init 호출 필요)")
    }
}
"@

# (F) OracleApplication (선택: Context 초기화)
Write-TextFile (Join-Path $javaBase "OracleApplication.kt") @"
package $ns

import android.app.Application
import $ns.ui.screens.AppContext

class OracleApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        AppContext.init(this)
    }
}
"@

# (G) Screens
Write-TextFile (Join-Path $javaBase "ui\screens\SplashScreen.kt") @"
package $ns.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.delay
import $ns.data.local.PreferencesManager

@Composable
fun SplashScreen(
    prefs: PreferencesManager,
    onGoProfile: () -> Unit,
    onGoMain: () -> Unit
) {
    LaunchedEffect(Unit) {
        delay(450)
        if (prefs.hasProfile()) onGoMain() else onGoProfile()
    }

    Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            Text("Oracle", style = MaterialTheme.typography.headlineMedium)
            Spacer(Modifier.height(6.dp))
            Text("사주 · 운세 · 타로", style = MaterialTheme.typography.bodyMedium)
        }
    }
}
"@

Write-TextFile (Join-Path $javaBase "ui\screens\ProfileScreen.kt") @"
package $ns.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import $ns.data.local.PreferencesManager
import $ns.data.local.UserProfile

@Composable
fun ProfileScreen(
    prefs: PreferencesManager,
    onSaved: () -> Unit
) {
    var birthDate by remember { mutableStateOf("") } // YYYY-MM-DD
    var birthTime by remember { mutableStateOf("") } // HH:MM
    var timeUnknown by remember { mutableStateOf(true) }
    var calendarType by remember { mutableStateOf("solar") } // solar/lunar
    var gender by remember { mutableStateOf("unspecified") } // male/female/unspecified
    var error by remember { mutableStateOf<String?>(null) }

    Column(Modifier.fillMaxSize().padding(16.dp)) {
        Text("프로필 입력", style = MaterialTheme.typography.headlineSmall)
        Spacer(Modifier.height(12.dp))

        OutlinedTextField(
            value = birthDate,
            onValueChange = { birthDate = it },
            label = { Text("생년월일 (YYYY-MM-DD)") },
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(Modifier.height(10.dp))

        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
            Text("태어난 시간 모름")
            Switch(checked = timeUnknown, onCheckedChange = { timeUnknown = it })
        }

        Spacer(Modifier.height(10.dp))
        OutlinedTextField(
            value = birthTime,
            onValueChange = { birthTime = it },
            label = { Text("태어난 시간 (HH:MM)") },
            enabled = !timeUnknown,
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(Modifier.height(10.dp))

        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
            Text("양/음력")
            Row {
                FilterChip(
                    selected = calendarType == "solar",
                    onClick = { calendarType = "solar" },
                    label = { Text("양력") }
                )
                Spacer(Modifier.width(8.dp))
                FilterChip(
                    selected = calendarType == "lunar",
                    onClick = { calendarType = "lunar" },
                    label = { Text("음력") }
                )
            }
        }

        Spacer(Modifier.height(10.dp))

        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
            Text("성별")
            Row {
                FilterChip(
                    selected = gender == "male",
                    onClick = { gender = "male" },
                    label = { Text("남") }
                )
                Spacer(Modifier.width(8.dp))
                FilterChip(
                    selected = gender == "female",
                    onClick = { gender = "female" },
                    label = { Text("여") }
                )
                Spacer(Modifier.width(8.dp))
                FilterChip(
                    selected = gender == "unspecified",
                    onClick = { gender = "unspecified" },
                    label = { Text("선택안함") }
                )
            }
        }

        Spacer(Modifier.height(14.dp))

        if (error != null) {
            Text(error!!, color = MaterialTheme.colorScheme.error)
            Spacer(Modifier.height(8.dp))
        }

        Button(
            onClick = {
                error = null
                if (birthDate.isBlank()) {
                    error = "생년월일을 입력해주세요."
                    return@Button
                }
                val profile = UserProfile(
                    birthDate = birthDate.trim(),
                    birthTime = if (timeUnknown) "" else birthTime.trim(),
                    timeUnknown = timeUnknown,
                    calendarType = calendarType,
                    gender = gender
                )
                prefs.saveProfile(profile)
                onSaved()
            },
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("저장하고 시작하기")
        }

        Spacer(Modifier.height(12.dp))
        Text("MVP 단계: 프로필 저장 + 오늘 운세 표시까지 먼저 구현합니다.")
    }
}
"@

Write-TextFile (Join-Path $javaBase "ui\screens\HomeScreen.kt") @"
package $ns.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import $ns.data.repository.OracleRepository
import $ns.ui.components.FortuneCard

@Composable
fun HomeScreen(
    repo: OracleRepository,
    onGoFortune: () -> Unit
) {
    val fortune = remember { repo.getTodayFortune() }

    Column(Modifier.fillMaxSize().padding(16.dp)) {
        Text("Oracle", style = MaterialTheme.typography.headlineSmall)
        Spacer(Modifier.height(12.dp))

        FortuneCard(
            score = fortune.score,
            preview = fortune.preview,
            unlocked = fortune.unlocked,
            onClickDetail = onGoFortune
        )

        Spacer(Modifier.height(12.dp))
        Card(Modifier.fillMaxWidth()) {
            Column(Modifier.padding(16.dp)) {
                Text("추천 콘텐츠", style = MaterialTheme.typography.titleMedium)
                Spacer(Modifier.height(8.dp))
                Text("• 손재주가 좋은 성향입니다\n• 오늘은 긍정적인 에너지가 가득한 날\n• 따뜻한 음료가 운을 돕습니다")
            }
        }
    }
}
"@

Write-TextFile (Join-Path $javaBase "ui\screens\FortuneScreen.kt") @"
package $ns.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import $ns.data.repository.OracleRepository

@Composable
fun FortuneScreen(repo: OracleRepository) {
    var fortune by remember { mutableStateOf(repo.getTodayFortune()) }

    Column(Modifier.fillMaxSize().padding(16.dp)) {
        Text("운세", style = MaterialTheme.typography.headlineSmall)
        Spacer(Modifier.height(12.dp))

        Card(Modifier.fillMaxWidth()) {
            Column(Modifier.padding(16.dp)) {
                Text("오늘의 점수", style = MaterialTheme.typography.titleMedium)
                Spacer(Modifier.height(6.dp))
                Text("\${fortune.score}점", style = MaterialTheme.typography.headlineMedium)
                Spacer(Modifier.height(6.dp))
                Text("사소한 일은 OK", style = MaterialTheme.typography.bodyMedium)
            }
        }

        Spacer(Modifier.height(12.dp))

        Card(Modifier.fillMaxWidth()) {
            Column(Modifier.padding(16.dp)) {
                Text("오늘의 운세", style = MaterialTheme.typography.titleMedium)
                Spacer(Modifier.height(8.dp))
                Text(fortune.preview)

                Spacer(Modifier.height(12.dp))

                if (!fortune.unlocked) {
                    Text("🔒 전체 운세는 체크인 후 열립니다.")
                    Spacer(Modifier.height(8.dp))
                    Button(
                        onClick = { fortune = repo.checkinUnlock() },
                        modifier = Modifier.fillMaxWidth()
                    ) { Text("체크인하고 전체 보기") }
                } else {
                    Divider()
                    Spacer(Modifier.height(8.dp))
                    Text(fortune.full)
                }
            }
        }

        Spacer(Modifier.height(12.dp))

        Card(Modifier.fillMaxWidth()) {
            Column(Modifier.padding(16.dp)) {
                Text("카테고리", style = MaterialTheme.typography.titleMedium)
                Spacer(Modifier.height(8.dp))
                Text("연애운: \${fortune.love}")
                Text("직장/학업운: \${fortune.career}")
                Text("건강운: \${fortune.health}")
                Text("금전운: \${fortune.money}")
            }
        }
    }
}
"@

Write-TextFile (Join-Path $javaBase "ui\screens\TarotScreen.kt") @"
package $ns.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@Composable
fun TarotScreen() {
    Column(Modifier.fillMaxSize().padding(16.dp)) {
        Text("타로", style = MaterialTheme.typography.headlineSmall)
        Spacer(Modifier.height(8.dp))
        Text("MVP 단계: 타로 화면은 UI 자리만 먼저 잡습니다.")
    }
}
"@

Write-TextFile (Join-Path $javaBase "ui\screens\WeatherScreen.kt") @"
package $ns.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@Composable
fun WeatherScreen() {
    Column(Modifier.fillMaxSize().padding(16.dp)) {
        Text("날씨", style = MaterialTheme.typography.headlineSmall)
        Spacer(Modifier.height(8.dp))
        Text("MVP 단계: 날씨 화면은 UI 자리만 먼저 잡습니다.")
    }
}
"@

Write-TextFile (Join-Path $javaBase "ui\screens\AmuletScreen.kt") @"
package $ns.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@Composable
fun AmuletScreen() {
    Column(Modifier.fillMaxSize().padding(16.dp)) {
        Text("부적", style = MaterialTheme.typography.headlineSmall)
        Spacer(Modifier.height(8.dp))
        Text("MVP 단계: 부적(상품/장바구니/주문)은 Phase 2에서 붙입니다.")
    }
}
"@

# (H) Components
Write-TextFile (Join-Path $javaBase "ui\components\FortuneCard.kt") @"
package $ns.ui.components

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@Composable
fun FortuneCard(
    score: Int,
    preview: String,
    unlocked: Boolean,
    onClickDetail: () -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth().clickable { onClickDetail() }
    ) {
        Column(Modifier.padding(16.dp)) {
            Text("오늘의 운세", style = MaterialTheme.typography.titleMedium)
            Spacer(Modifier.height(8.dp))
            Text("\${score}점", style = MaterialTheme.typography.headlineMedium)
            Spacer(Modifier.height(8.dp))
            Text(preview, style = MaterialTheme.typography.bodyMedium)
            Spacer(Modifier.height(8.dp))
            Text(if (unlocked) "전체 운세 열림" else "전체 운세 잠김(체크인 필요)")
        }
    }
}
"@

# (I) strings.xml (한국어 기본)
Write-TextFile (Join-Path $androidRoot "app\src\main\res\values\strings.xml") @"
<resources>
    <string name="app_name">Oracle</string>
</resources>
"@

Write-Host "`n[OK] MVP 파일 생성 완료."
Write-Host "다음 단계:"
Write-Host "1) AndroidManifest.xml에 OracleApplication 적용(선택)"
Write-Host "2) Android Studio에서 Sync 후 Run"