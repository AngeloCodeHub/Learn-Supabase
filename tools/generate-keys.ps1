param (
  [switch]$Force
)

$ErrorActionPreference = 'Stop'

function Get-RandomBytes {
  param ([int]$Count)
  $Bytes = New-Object byte[] -ArgumentList $Count
  [System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($Bytes)
  return $Bytes
}

function New-RandomHex {
  param ([int]$ByteCount)
  $Bytes = Get-RandomBytes -Count $ByteCount
  return [Convert]::ToHexString($Bytes).ToLower()
}

function New-RandomBase64 {
  param ([int]$ByteCount)
  $Bytes = Get-RandomBytes -Count $ByteCount
  return [Convert]::ToBase64String($Bytes)
}

function ConvertTo-Base64Url {
  param ([string]$InputString)
  $Bytes = [System.Text.Encoding]::UTF8.GetBytes($InputString)
  $Base64 = [Convert]::ToBase64String($Bytes)
  return $Base64 -replace '\+', '-' -replace '/', '_' -replace '=', ''
}

function ConvertTo-Base64UrlFromBytes {
  param ([byte[]]$Bytes)
  $Base64 = [Convert]::ToBase64String($Bytes)
  return $Base64 -replace '\+', '-' -replace '/', '_' -replace '=', ''
}

function New-JwtToken {
  param (
    [string]$PayloadJson,
    [string]$SecretRaw
  )

  $HeaderJson = '{"alg":"HS256","typ":"JWT"}'
    
  $HeaderEncoded = ConvertTo-Base64Url -InputString $HeaderJson
  $PayloadEncoded = ConvertTo-Base64Url -InputString $PayloadJson
    
  $UnsignedToken = "$HeaderEncoded.$PayloadEncoded"
    
  $SecretBytes = [System.Text.Encoding]::UTF8.GetBytes($SecretRaw)
  $HMAC = [System.Security.Cryptography.HMACSHA256]::new($SecretBytes)
  $SignatureBytes = $HMAC.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($UnsignedToken))
  $SignatureEncoded = ConvertTo-Base64UrlFromBytes -Bytes $SignatureBytes
    
  return "$UnsignedToken.$SignatureEncoded"
}

# --- Main Logic ---

$JwtSecret = New-RandomBase64 -ByteCount 30

$Iat = [DateTimeOffset]::Now.ToUnixTimeSeconds()
$Exp = $Iat + (5 * 365 * 24 * 3600) # 5 years approx (ignoring leap years logic from bash simple calc)

# Bash calc: exp=$((iat + 5 * 3600 * 24 * 365))
# This is explicitly 5 * 365 days.

$AnonPayload = '{"role":"anon","iss":"supabase","iat":' + $Iat + ',"exp":' + $Exp + '}'
$ServiceRolePayload = '{"role":"service_role","iss":"supabase","iat":' + $Iat + ',"exp":' + $Exp + '}'

$AnonKey = New-JwtToken -PayloadJson $AnonPayload -SecretRaw $JwtSecret
$ServiceRoleKey = New-JwtToken -PayloadJson $ServiceRolePayload -SecretRaw $JwtSecret

$SecretKeyBase = New-RandomBase64 -ByteCount 48
$VaultEncKey = New-RandomHex -ByteCount 16
$PgMetaCryptoKey = New-RandomBase64 -ByteCount 24

$LogflarePublicAccessToken = New-RandomBase64 -ByteCount 24
$LogflarePrivateAccessToken = New-RandomBase64 -ByteCount 24

$S3ProtocolAccessKeyId = New-RandomHex -ByteCount 16
$S3ProtocolAccessKeySecret = New-RandomHex -ByteCount 32

$PostgresPassword = New-RandomHex -ByteCount 16
$DashboardPassword = New-RandomHex -ByteCount 16

Write-Host ""
Write-Host "JWT_SECRET=$JwtSecret"
Write-Host ""
Write-Host "ANON_KEY=$AnonKey"
Write-Host "SERVICE_ROLE_KEY=$ServiceRoleKey"
Write-Host ""
Write-Host "SECRET_KEY_BASE=$SecretKeyBase"
Write-Host "VAULT_ENC_KEY=$VaultEncKey"
Write-Host "PG_META_CRYPTO_KEY=$PgMetaCryptoKey"
Write-Host "LOGFLARE_PUBLIC_ACCESS_TOKEN=$LogflarePublicAccessToken"
Write-Host "LOGFLARE_PRIVATE_ACCESS_TOKEN=$LogflarePrivateAccessToken"
Write-Host "S3_PROTOCOL_ACCESS_KEY_ID=$S3ProtocolAccessKeyId"
Write-Host "S3_PROTOCOL_ACCESS_KEY_SECRET=$S3ProtocolAccessKeySecret"
Write-Host ""
Write-Host "POSTGRES_PASSWORD=$PostgresPassword"
Write-Host "DASHBOARD_PASSWORD=$DashboardPassword"
Write-Host ""

# Check for non-interactive execution
# [Console]::IsInputRedirected can be unreliable in some environments.
# We also check [Environment]::UserInteractive.
$IsInteractive = [Environment]::UserInteractive -and (-not [Console]::IsInputRedirected)

if (-not $IsInteractive) {
  # If we are in Antigravity/Agent environment, we might want to skip or allow.
  # But for the user, if they run it in a terminal, $IsInteractive should be true.
  # We will log a warning instead of exiting immediately if we can't be sure, 
  # but for now let's keep it somewhat strict but slightly relaxed.
  Write-Debug "Might be running non-interactively. IsInputRedirected: $([Console]::IsInputRedirected)"
}

# Assume .env is in the parent directory of this script's directory?
# The original script does not cd. It works where it runs.
# However, usually scripts in `tools/` might want to target `../.env` or `.env` in current dir.
# The user's prompt shows the file is in `tools/generate-keys.ps1` and `.env` is in root.
# So if we run from root: `tools/generate-keys.ps1`, then `.env` is in `./.env`.
# If we run from tools: `.env` is in `../.env`.
# The original script relies on user CWD. 
# "Update .env file? ... sed ... .env" -> assumes .env in CWD.
# I will stick to CWD to match original behavior.

# Locate .env file
$EnvFilePath = Join-Path (Get-Location) ".env"
if (-not (Test-Path $EnvFilePath)) {
  # Try parent directory (if script is in tools/)
  $ParentDirEnv = Join-Path (Split-Path $PSScriptRoot -Parent) ".env"
  if (Test-Path $ParentDirEnv) {
    $EnvFilePath = $ParentDirEnv
  }
}

if (-not (Test-Path $EnvFilePath)) {
  Write-Warning "No .env file found at $EnvFilePath or in the workspace root. Skipping update."
  exit 0
}

Write-Host "Found .env at: $EnvFilePath"

if ($Force -or $IsInteractive) {
  if (-not $Force) {
    $Confirmation = Read-Host "Update .env file? (y/N)"
    if ($Confirmation -notmatch '^[Yy]') {
      Write-Host "Not updating .env"
      exit 0
    }
  }
}
else {
  Write-Host "Running non-interactively. Skipping .env update (use -Force to bypass)."
  exit 0
}

Write-Host "Updating .env..."

Copy-Item $EnvFilePath -Destination "$EnvFilePath.old" -Force

$EnvContent = Get-Content $EnvFilePath -Raw

function Update-EnvVar {
  param ($Content, $Name, $Value)
  $Pattern = "(?m)^$Name=.*$"
  $Replacement = "$Name=$Value"
  if ($Content -match $Pattern) {
    return [Regex]::Replace($Content, $Pattern, $Replacement)
  }
  else {
    # If not found, append it. Ensure there's a newline before if needed.
    if ($Content -and $Content.Length -gt 0 -and $Content[-1] -ne "`n") {
      $Content += "`r`n"
    }
    return $Content + $Replacement + "`r`n"
  }
}

$EnvContent = Update-EnvVar $EnvContent "JWT_SECRET" $JwtSecret
$EnvContent = Update-EnvVar $EnvContent "ANON_KEY" $AnonKey
$EnvContent = Update-EnvVar $EnvContent "SERVICE_ROLE_KEY" $ServiceRoleKey
$EnvContent = Update-EnvVar $EnvContent "SECRET_KEY_BASE" $SecretKeyBase
$EnvContent = Update-EnvVar $EnvContent "VAULT_ENC_KEY" $VaultEncKey
$EnvContent = Update-EnvVar $EnvContent "PG_META_CRYPTO_KEY" $PgMetaCryptoKey
$EnvContent = Update-EnvVar $EnvContent "LOGFLARE_PUBLIC_ACCESS_TOKEN" $LogflarePublicAccessToken
$EnvContent = Update-EnvVar $EnvContent "LOGFLARE_PRIVATE_ACCESS_TOKEN" $LogflarePrivateAccessToken
$EnvContent = Update-EnvVar $EnvContent "S3_PROTOCOL_ACCESS_KEY_ID" $S3ProtocolAccessKeyId
$EnvContent = Update-EnvVar $EnvContent "S3_PROTOCOL_ACCESS_KEY_SECRET" $S3ProtocolAccessKeySecret
$EnvContent = Update-EnvVar $EnvContent "POSTGRES_PASSWORD" $PostgresPassword
$EnvContent = Update-EnvVar $EnvContent "DASHBOARD_PASSWORD" $DashboardPassword

# Write back with no newline at end to avoid growing file indefinitely if we repeated this?
# Set-Content adds a newline by default. -NoNewline prevents it, but if raw had one, we might lose or keep it.
# Raw content usually includes the final newline.
Set-Content -Path $EnvFilePath -Value $EnvContent -NoNewline -Encoding utf8

Write-Host "Done."
