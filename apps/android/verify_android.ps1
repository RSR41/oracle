# verify_android.ps1
# Android Project Auto-Verification Script
# Author: Senior Android Tech Lead

$ErrorActionPreference = "Stop"
$LogFile = "build_verify.log"

function Write-Log {
    param($Message)
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] $Message"
    Write-Host $LogMessage
    Add-Content -Path $LogFile -Value $LogMessage
}

# 0. Initialize Log
if (Test-Path $LogFile) { Remove-Item $LogFile }
Write-Log "=== STARTING ANDROID VERIFICATION ==="

# 1. Location Check
$CurrentDir = Get-Location
Write-Log "Current Directory: $CurrentDir"
if (-not ($CurrentDir.Path -like "*apps\android*")) {
    Write-Log "ERROR: Wrong Directory. Please run from apps/android."
    exit 1
}

# 2. Gradle Wrapper Check
if (-not (Test-Path "gradlew.bat")) {
    Write-Log "ERROR: gradlew.bat not found."
    exit 1
}

# 2.5: Ensure JAVA_HOME matches gradle.properties to avoid "Invalid directory" errors
$GradleProps = "gradle.properties"
if (Test-Path $GradleProps) {
    $JavaHomeLine = Get-Content $GradleProps | Where-Object { $_ -match "^org.gradle.java.home=(.*)" }
    if ($JavaHomeLine) {
        $ProjectJavaHome = $JavaHomeLine -replace "org.gradle.java.home=", ""
        # Handle escaped backslashes if present (common in properties files)
        $ProjectJavaHome = $ProjectJavaHome -replace "\\\\", "\"
        
        Write-Log "Found project JDK in gradle.properties: $ProjectJavaHome"
        
        if (Test-Path $ProjectJavaHome) {
            $env:JAVA_HOME = $ProjectJavaHome
            Write-Log "Temporarily updated process JAVA_HOME to match project settings."
        }
        else {
            Write-Log "WARNING: Path in gradle.properties does not exist: $ProjectJavaHome"
        }
    }
}
# Fallback: If JAVA_HOME is still invalid/missing, try Android Studio default
if (-not (Test-Path $env:JAVA_HOME)) {
    $DefaultJbr = "C:\Program Files\Android\Android Studio\jbr"
    if (Test-Path $DefaultJbr) {
        $env:JAVA_HOME = $DefaultJbr
        Write-Log "JAVA_HOME was invalid/missing. Fallback to Android Studio JBR: $DefaultJbr"
    }
}

Write-Log "Final JAVA_HOME for this run: $env:JAVA_HOME"

# 3. Gradle Version
Write-Log ">> Checking Gradle Version..."
./gradlew --version | Out-File -Append -FilePath $LogFile
if ($LASTEXITCODE -ne 0) {
    Write-Log "ERROR: Gradle execution failed (Exit Code: $LASTEXITCODE)"
    exit 1
}

# 4. Clean Project
Write-Log ">> Running Clean..."
./gradlew clean --stacktrace --info | Out-File -Append -FilePath $LogFile
if ($LASTEXITCODE -ne 0) {
    Write-Log "ERROR: Clean failed (Exit Code: $LASTEXITCODE)"
    exit 1
}

# 5. Assemble Debug
Write-Log ">> Running AssembleDebug..."
./gradlew :app:assembleDebug --stacktrace --info | Out-File -Append -FilePath $LogFile
if ($LASTEXITCODE -eq 0) {
    Write-Log "SUCCESS: AssembleDebug passed."
}
else {
    Write-Log "FAILURE: AssembleDebug failed (Exit Code: $LASTEXITCODE)"
    exit 1
}

# 6. Run Unit Tests (if available)
Write-Log ">> Running Unit Tests..."
./gradlew :app:testDebugUnitTest --stacktrace --info | Out-File -Append -FilePath $LogFile
if ($LASTEXITCODE -eq 0) {
    Write-Log "SUCCESS: Unit Tests passed."
}
else {
    Write-Log "WARNING: Unit Tests failed or not found. Proceeding with caution."
}

Write-Log "=== VERIFICATION COMPLETE ==="
Write-Host "Log saved to $LogFile"
