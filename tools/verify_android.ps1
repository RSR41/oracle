$ErrorActionPreference = "Stop"

Write-Host "🚀 Starting Android Verification..." -ForegroundColor Cyan

$projectRoot = Resolve-Path "apps/android"
Push-Location $projectRoot

try {
    Write-Host "`n🧹 Cleaning project..." -ForegroundColor Yellow
    ./gradlew clean
    if ($LASTEXITCODE -ne 0) { throw "Clean failed" }

    Write-Host "`n🔨 Building Debug APK..." -ForegroundColor Yellow
    ./gradlew :app:assembleDebug
    if ($LASTEXITCODE -ne 0) { throw "Build failed" }

    Write-Host "`n🧪 Running Unit Tests..." -ForegroundColor Yellow
    ./gradlew :app:testDebugUnitTest
    if ($LASTEXITCODE -ne 0) { throw "Unit Tests failed" }

    Write-Host "`n🔍 Running Lint..." -ForegroundColor Yellow
    ./gradlew :app:lintDebug
    if ($LASTEXITCODE -ne 0) { throw "Lint failed" }

    Write-Host "`n✅ Verification SUCCESS!" -ForegroundColor Green
}
catch {
    Write-Host "`n❌ Verification FAILED: $_" -ForegroundColor Red
    exit 1
}
finally {
    Pop-Location
}
