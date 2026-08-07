# Build one Abseil pin into a local prefix (Windows MSVC x64 + Ninja).
param(
  [string]$Pin = "20260107.1",
  [string]$Prefix = "",
  [string]$BuildDir = ""
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
if (-not $Prefix) { $Prefix = Join-Path $Root "prefix\$Pin" }
if (-not $BuildDir) { $BuildDir = Join-Path $Root "build\$Pin" }

Write-Host "AbseilPin build Pin=$Pin Prefix=$Prefix"

New-Item -ItemType Directory -Force -Path $Prefix | Out-Null
New-Item -ItemType Directory -Force -Path $BuildDir | Out-Null

$cmakeArgs = @(
  "-S", $Root,
  "-B", $BuildDir,
  "-G", "Ninja",
  "-DCMAKE_BUILD_TYPE=Release",
  "-DCMAKE_CXX_STANDARD=20",
  "-DABSL_PIN_ID=$Pin",
  "-DCMAKE_INSTALL_PREFIX=$Prefix"
)

& cmake @cmakeArgs
if ($LASTEXITCODE -ne 0) { throw "cmake configure failed" }
& cmake --build $BuildDir --config Release
if ($LASTEXITCODE -ne 0) { throw "cmake build failed" }
& cmake --install $BuildDir --config Release
if ($LASTEXITCODE -ne 0) { throw "cmake install failed" }

$dll = Join-Path $Prefix "bin\abseil_dll.dll"
if (-not (Test-Path $dll)) {
  # Some layouts put runtime next to lib
  $alt = Get-ChildItem -Path $Prefix -Recurse -Filter "abseil_dll.dll" -ErrorAction SilentlyContinue | Select-Object -First 1
  if ($alt) { Write-Host "Found $($alt.FullName)" } else { throw "abseil_dll.dll not found under $Prefix" }
} else {
  Write-Host "OK $dll"
}

Write-Host "Done. Use: -DMPS_ABSEIL_PIN_PREFIX=$Prefix"
