<#
.SYNOPSIS
    Oracle Store Submission Readiness Verification Script
.DESCRIPTION
    Checks for placeholders, signing config, and flutter analyze.
.EXAMPLE
    .\verify_store_ready.ps1
#>

param(
    [switch]$SkipFlutterAnalyze
)

$ErrorActionPreference = "Continue"
$RepoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$FlutterAppRoot = Join-Path $RepoRoot "apps\flutter\oracle_flutter"
$DocsRoot = Join-Path $RepoRoot "docs"
$AndroidRoot = Join-Path $FlutterAppRoot "android"

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Oracle Store Submission Verify" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

$allPassed = $true

# =============================================
# 1. Legal Doc Placeholders
# =============================================
Write-Host "[1/5] Checking usage of TODO(FILL_ME)..." -ForegroundColor Yellow

$legalPath = Join-Path $DocsRoot "legal"
$placeholders = Select-String -Path "$legalPath\*.md" -Pattern "TODO\(FILL_ME\)" -ErrorAction SilentlyContinue

if ($placeholders) {
    Write-Host "  [FAIL] Placeholders found:" -ForegroundColor Red
    $placeholders | ForEach-Object {
        Write-Host "     $($_.Filename):$($_.LineNumber)" -ForegroundColor Gray
    }
    $allPassed = $false
}
else {
    Write-Host "  [PASS] No TODO(FILL_ME) found." -ForegroundColor Green
}

# =============================================
# 2. GitHub Username (app_urls.dart)
# =============================================
Write-Host ""
Write-Host "[2/5] Checking YOUR_USERNAME in app_urls.dart..." -ForegroundColor Yellow

$appUrlsPath = Join-Path $FlutterAppRoot "lib\app\config\app_urls.dart"
if (Test-Path $appUrlsPath) {
    $yourUsername = Select-String -Path $appUrlsPath -Pattern "YOUR_USERNAME" -ErrorAction SilentlyContinue
    if ($yourUsername) {
        Write-Host "  [FAIL] YOUR_USERNAME found." -ForegroundColor Red
        Write-Host "     Please replace it with a real username or placeholder." -ForegroundColor Gray
        $allPassed = $false
    }
    else {
        Write-Host "  [PASS] YOUR_USERNAME replaced." -ForegroundColor Green
    }
}
else {
    Write-Host "  [WARN] app_urls.dart not found." -ForegroundColor Yellow
}

# =============================================
# 3. Android key.properties
# =============================================
Write-Host ""
Write-Host "[3/5] Checking Android signing config..." -ForegroundColor Yellow

$keyPropsPath = Join-Path $AndroidRoot "key.properties"
$keystorePath = Join-Path $FlutterAppRoot "oracle-release.jks"

if (Test-Path $keyPropsPath) {
    Write-Host "  [PASS] key.properties exists." -ForegroundColor Green
    
    $keyPropsContent = Get-Content $keyPropsPath -Raw
    if ($keyPropsContent -match "YOUR_") {
        Write-Host "  [WARN] key.properties contains 'YOUR_' placeholder." -ForegroundColor Yellow
    }
}
else {
    Write-Host "  [FAIL] key.properties missing." -ForegroundColor Red
    $allPassed = $false
}

if (Test-Path $keystorePath) {
    Write-Host "  [PASS] oracle-release.jks exists (dummy/real)." -ForegroundColor Green
}
else {
    Write-Host "  [WARN] oracle-release.jks missing. (Needed for build)" -ForegroundColor Yellow
}

# =============================================
# 4. .gitignore
# =============================================
Write-Host ""
Write-Host "[4/5] Checking .gitignore..." -ForegroundColor Yellow

$androidGitignore = Join-Path $AndroidRoot ".gitignore"
if (Test-Path $androidGitignore) {
    $gitignoreContent = Get-Content $androidGitignore -Raw
    
    $checks = @(
        @{ Pattern = "key\.properties"; Name = "key.properties" },
        @{ Pattern = "\*\.jks"; Name = "*.jks" },
        @{ Pattern = "\*\.keystore"; Name = "*.keystore" }
    )
    
    $allIgnored = $true
    foreach ($check in $checks) {
        if ($gitignoreContent -match $check.Pattern) {
            Write-Host "  [PASS] $($check.Name) is ignored." -ForegroundColor Green
        }
        else {
            Write-Host "  [FAIL] $($check.Name) is NOT ignored." -ForegroundColor Red
            $allIgnored = $false
        }
    }
    
    if (-not $allIgnored) {
        $allPassed = $false
    }
}
else {
    Write-Host "  [WARN] android/.gitignore not found." -ForegroundColor Yellow
}

# =============================================
# 5. Flutter Analyze
# =============================================
Write-Host ""
Write-Host "[5/5] Running flutter analyze..." -ForegroundColor Yellow

if ($SkipFlutterAnalyze) {
    Write-Host "  [SKIP] Skipped by argument." -ForegroundColor Gray
}
else {
    Push-Location $FlutterAppRoot
    try {
        $analyzeResult = flutter analyze 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [PASS] No issues found." -ForegroundColor Green
        }
        else {
            Write-Host "  [FAIL] Issues found." -ForegroundColor Red
            # $analyzeResult | Select-Object -Last 5 | ForEach-Object { Write-Host "     $_" -ForegroundColor Gray }
            $allPassed = $false
        }
    }
    catch {
        Write-Host "  [WARN] flutter command failed." -ForegroundColor Yellow
    }
    Pop-Location
}

# =============================================
# Final Result
# =============================================
Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan

if ($allPassed) {
    Write-Host "  [SUCCESS] Ready for Store Submission!" -ForegroundColor Green
}
else {
    Write-Host "  [FAILURE] Please fix the issues above." -ForegroundColor Red
}

Write-Host "=====================================" -ForegroundColor Cyan
