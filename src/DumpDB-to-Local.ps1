# dump（複製）遠端資料庫至本地資料庫
# 腳本位置: src/DumpDB-to-Local.ps1

$ErrorActionPreference = "Stop"

# 取得腳本所在目錄與專案根目錄
$ScriptDir = $PSScriptRoot
$ProjectRoot = Split-Path $ScriptDir -Parent

# 設定檔案路徑
$EnvPath = Join-Path $ProjectRoot ".env"
$IniPath = Join-Path $ProjectRoot "_env\dump-all-DB.ini"

# 載入 .env 檔案的函式
function ImportEnvFile {
  param($Path)
  if (Test-Path $Path) {
    $lines = Get-Content $Path
    foreach ($line in $lines) {
      # 跳過註解與空行
      if ($line -match '^\s*#') { continue }
      if ($line -match '^\s*$') { continue }
            
      if ($line -match '^([^=]+)=(.*)$') {
        $key = $matches[1].Trim()
        $value = $matches[2].Trim()
        # 移除引號
        if ($value -match '^"(.*)"$') { $value = $matches[1] }
        elseif ($value -match "^'(.*)'$") { $value = $matches[1] }
        # 處理路徑中的雙反斜線 (例如 C:\\wamp64 -> C:\wamp64)
        $value = $value -replace '\\\\', '\'
                
        [Environment]::SetEnvironmentVariable($key, $value, "Process")
      }
    }
  }
  else {
    Write-Warning ".env 檔案未找到: $Path"
  }
}

# 執行載入環境變數
ImportEnvFile -Path $EnvPath

# 取得執行檔路徑
$MySQLDump = $env:MySQLDump
$MySQLClient = $env:MySQLClient

# 驗證路徑是否存在
if (-not $MySQLDump -or -not (Test-Path $MySQLDump)) {
  Write-Error "找不到 mysqldump (請檢查 .env): '$MySQLDump'"
}
if (-not $MySQLClient -or -not (Test-Path $MySQLClient)) {
  Write-Error "找不到 mysql client (請檢查 .env): '$MySQLClient'"
}
if (-not (Test-Path $IniPath)) {
  Write-Error "找不到設定檔 INI: '$IniPath'"
}

# 資料庫名稱 (根據 INI 設定判斷為 muticount)
$DatabaseName = "muticount"

Write-Host "開始將遠端資料庫複製到本地..."
Write-Host "來源 (mysqldump): $DatabaseName (設定檔: $IniPath)"
Write-Host "目標 (mysql): Localhost (設定檔: $IniPath)"

# 組合指令
# 使用 cmd /c 來處理 pipe，避免 PowerShell 編碼問題
# mysqldump 讀取 [mysqldump] 設定，mysql 讀取 [mysql] 設定
$Command = "`"$MySQLDump`" --defaults-extra-file=`"$IniPath`" $DatabaseName | `"$MySQLClient`" --defaults-extra-file=`"$IniPath`""

Write-Host "執行指令: $Command"

# 執行
cmd /c $Command

if ($LASTEXITCODE -eq 0) {
  Write-Host "資料庫複製完成。" -ForegroundColor Green
}
else {
  Write-Error "資料庫複製失敗，Exit Code: $LASTEXITCODE"
}
