# ============================================================
# tools/verify_android.ps1
# Oracle Android App - Build Verification Script
# ============================================================
# 사용법: .\tools\verify_android.ps1
# ============================================================

$ErrorActionPreference = "Continue"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$androidDir = Join-Path $repoRoot "apps\android"
$logsDir = Join-Path $repoRoot "logs"

Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Oracle Android Build Verification" -ForegroundColor Cyan
Write-Host " Android Dir: $androidDir" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

# Create logs directory
if (-not (Test-Path $logsDir)) {
    New-Item -ItemType Directory -Path $logsDir -Force | Out-Null
}

$logFile = Join-Path $logsDir "android_verify.log"
"Oracle Android Build Verification - $(Get-Date)" | Out-File $logFile

# Helper function
function Write-Log {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
    $Message | Out-File $logFile -Append
}

# Step 1: Check environment
Write-Log "`n[1/5] Checking environment..." "Yellow"

# Check JAVA_HOME
if ($env:JAVA_HOME) {
    Write-Log "  JAVA_HOME: $env:JAVA_HOME" "Green"
} else {
    Write-Log "  WARNING: JAVA_HOME not set" "Yellow"
    Write-Log "  Android Studio uses embedded JDK, but terminal builds may fail" "Yellow"
}

# Check Android SDK
if ($env:ANDROID_HOME) {
    Write-Log "  ANDROID_HOME: $env:ANDROID_HOME" "Green"
} elseif ($env:ANDROID_SDK_ROOT) {
    Write-Log "  ANDROID_SDK_ROOT: $env:ANDROID_SDK_ROOT" "Green"
} else {
    Write-Log "  WARNING: ANDROID_HOME/ANDROID_SDK_ROOT not set" "Yellow"
}

# Step 2: Check gradlew exists
Write-Log "`n[2/5] Checking Gradle wrapper..." "Yellow"
$gradlew = Join-Path $androidDir "gradlew.bat"
if (Test-Path $gradlew) {
    Write-Log "  gradlew.bat found" "Green"
} else {
    Write-Log "  ERROR: gradlew.bat not found at $gradlew" "Red"
    Write-Log "  Run 'gradle wrapper' in apps/android directory" "Red"
    exit 1
}

# Step 3: Clean build
Write-Log "`n[3/5] Running Gradle clean..." "Yellow"
Push-Location $androidDir
try {
    $cleanResult = & .\gradlew.bat clean 2>&1
    $cleanResult | Out-File $logFile -Append
    if ($LASTEXITCODE -eq 0) {
        Write-Log "  Clean successful" "Green"
    } else {
        Write-Log "  Clean failed (exit code: $LASTEXITCODE)" "Red"
    }
} catch {
    Write-Log "  Clean error: $_" "Red"
}

# Step 4: Assemble Debug
Write-Log "`n[4/5] Running assembleDebug..." "Yellow"
try {
    $buildResult = & .\gradlew.bat :app:assembleDebug --stacktrace 2>&1
    $buildResult | Out-File $logFile -Append
    
    if ($LASTEXITCODE -eq 0) {
        Write-Log "  Build successful!" "Green"
        $apkPath = Join-Path $androidDir "app\build\outputs\apk\debug\app-debug.apk"
        if (Test-Path $apkPath) {
            Write-Log "  APK: $apkPath" "Green"
        }
    } else {
        Write-Log "  Build failed (exit code: $LASTEXITCODE)" "Red"
        
        # Parse common errors
        $buildOutput = $buildResult -join "`n"
        
        if ($buildOutput -match "JAVA_HOME") {
            Write-Log "`n  >>> FIX: Set JAVA_HOME environment variable" "Magenta"
            Write-Log "  >>> In Android Studio: File > Settings > Build > Gradle > Gradle JDK" "Magenta"
        }
        if ($buildOutput -match "Unresolved reference") {
            Write-Log "`n  >>> FIX: Missing import or dependency" "Magenta"
            Write-Log "  >>> Check the error for which class/function is missing" "Magenta"
        }
        if ($buildOutput -match "SDK location not found") {
            Write-Log "`n  >>> FIX: Create local.properties with sdk.dir" "Magenta"
            Write-Log "  >>> Example: sdk.dir=C:\\Users\\YOUR_NAME\\AppData\\Local\\Android\\Sdk" "Magenta"
        }
        if ($buildOutput -match "Could not resolve") {
            Write-Log "`n  >>> FIX: Network or dependency resolution issue" "Magenta"
            Write-Log "  >>> Try: File > Invalidate Caches in Android Studio" "Magenta"
        }
    }
} catch {
    Write-Log "  Build error: $_" "Red"
}

# Step 5: Run lint (optional)
Write-Log "`n[5/5] Running lint..." "Yellow"
try {
    $lintResult = & .\gradlew.bat :app:lint 2>&1
    $lintResult | Out-File $logFile -Append
    if ($LASTEXITCODE -eq 0) {
        Write-Log "  Lint passed" "Green"
    } else {
        Write-Log "  Lint has warnings (check report)" "Yellow"
    }
} catch {
    Write-Log "  Lint error: $_" "Yellow"
}

Pop-Location

# Summary
Write-Log "`n============================================" "Cyan"
Write-Log " Verification Complete" "Cyan"
Write-Log " Log file: $logFile" "Cyan"
Write-Log "============================================" "Cyan"

Write-Log "`nNext steps:" "Yellow"
Write-Log "  1. Open Android Studio: apps/android" "White"
Write-Log "  2. Sync Project with Gradle Files" "White"
Write-Log "  3. Run on emulator or device" "White"
Write-Log "`nIf build failed, see: docs/DEBUG_PLAYBOOK_ANDROID.md" "White"
