param(
    [string]$DeviceId = ""
)

$ErrorActionPreference = "Stop"
$adb = Join-Path $env:LOCALAPPDATA "Android\Sdk\platform-tools\adb.exe"

if (-not (Test-Path -LiteralPath $adb)) {
    throw "ADB was not found at: $adb"
}

if ([string]::IsNullOrWhiteSpace($DeviceId)) {
    $DeviceId = (& $adb devices) |
        Select-String "\sdevice$" |
        ForEach-Object { ($_ -split "\s+")[0] } |
        Select-Object -First 1
}

if ([string]::IsNullOrWhiteSpace($DeviceId)) {
    throw "No Android device is connected and authorized."
}

Write-Host "Connecting device $DeviceId to Laravel on port 8000..."
& $adb -s $DeviceId reverse tcp:8000 tcp:8000
if ($LASTEXITCODE -ne 0) {
    throw "ADB reverse failed. Reconnect the USB cable and authorize debugging."
}

Write-Host "Starting Flutter on $DeviceId..."
flutter run -d $DeviceId
