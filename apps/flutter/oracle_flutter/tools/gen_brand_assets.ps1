# gen_brand_assets.ps1
# Generates placeholder icon and splash screen for Flutter branding tools.

$brandPath = "C:\Users\qkrtj\destiny\oracle\apps\flutter\oracle_flutter\assets\brand"
if (!(Test-Path $brandPath)) {
    New-Item -ItemType Directory -Path $brandPath -Force
    Write-Host "Created directory: $brandPath"
}

function Generate-Placeholder([string]$File, [int]$Size, [string]$Label) {
    $fullPath = Join-Path $brandPath $File
    Write-Host "Generating placeholder: $fullPath ($Size x $Size)"
    
    # We use PowerShell's Drawing assembly to create a simple PNG
    Add-Type -AssemblyName System.Drawing
    $bmp = New-Object System.Drawing.Bitmap($Size, $Size)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    
    # Background: Warm Neutral (App Theme color)
    $color = [System.Drawing.ColorTranslator]::FromHtml("#F5F1E9")
    $g.Clear($color)
    
    # Text
    $font = New-Object System.Drawing.Font("Arial", ($Size / 10))
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Gray)
    $format = New-Object System.Drawing.StringFormat
    $format.Alignment = [System.Drawing.StringAlignment]::Center
    $format.LineAlignment = [System.Drawing.StringAlignment]::Center
    
    $rect = New-Object System.Drawing.RectangleF(0, 0, $Size, $Size)
    $g.DrawString($Label, $font, $brush, $rect, $format)
    
    $bmp.Save($fullPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    Write-Host "Saved: $File"
}

try {
    # App Icon (1024x1024)
    Generate-Placeholder "app_icon.png" 1024 "Oracle Icon"
    
    # Splash Screen (2048x2048 for high res)
    Generate-Placeholder "splash.png" 2048 "Oracle Splash"
    
    Write-Host "`nSuccessfully generated placeholder assets in assets/brand/" -ForegroundColor Green
} catch {
    Write-Error "Failed to generate assets: $_"
}
