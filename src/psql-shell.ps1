
$path_psql = "C:\Program Files\PostgreSQL\18\bin\psql.exe"

# =========================================
# PostgreSQL 互動式連接腳本
# =========================================

# 預設值設定
$default_host = "localhost"
$default_db = "postgres"
$default_port = 5432
$default_username = "postgres"

# 顯示標題
Write-Host "`n" -ForegroundColor Green
Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   PostgreSQL 互動式連接工具          ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# 1. Host 輸入
$host_input = Read-Host "Host (預設: $default_host)"
$psql_host = if ([string]::IsNullOrEmpty($host_input)) { $default_host } else { $host_input }

# 2. Database 輸入
$db_input = Read-Host "Database (預設: $default_db)"
$psql_db = if ([string]::IsNullOrEmpty($db_input)) { $default_db } else { $db_input }

# 3. Port 輸入
$port_input = Read-Host "Port (預設: $default_port)"
$psql_port = if ([string]::IsNullOrEmpty($port_input)) { $default_port } else { $port_input }

# 4. Username 輸入
$username_input = Read-Host "Username (預設: $default_username)"
$psql_username = if ([string]::IsNullOrEmpty($username_input)) { $default_username } else { $username_input }

# 顯示連接信息
Write-Host "`n" -ForegroundColor Green
Write-Host "──────────────────────────────────────" -ForegroundColor Yellow
Write-Host "連接信息:" -ForegroundColor Yellow
Write-Host "  Host    : $psql_host" -ForegroundColor White
Write-Host "  Database: $psql_db" -ForegroundColor White
Write-Host "  Port    : $psql_port" -ForegroundColor White
Write-Host "  Username: $psql_username" -ForegroundColor White
Write-Host "──────────────────────────────────────`n" -ForegroundColor Yellow

# 執行 psql 連接
& $path_psql -h $psql_host -p $psql_port -U $psql_username -d $psql_db
