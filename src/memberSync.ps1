<#
會員資料庫同步程式
先把master slave設定好，再執行此程式
刪除member_Nan、member_Fen
#>

# 必須新增資料庫

Import-Dotenv

$MySQLDump = $env:MySQLDump
$MySQLClient = $env:MySQLClient
$ini_Nan = ".\_env\POS-Nanzi-sync.ini"
$ini_Feng = ".\_env\POS-Fengshan-sync.ini"
$ini_Local = ".\_env\POS-LocalDB-sync.ini"
$DBfile

# member truncate（用於 member 資料表已經存在）
# & $MySQLClient -u root -e "truncate table muticount.member;"

# dump 資料至本地（nan）
& $MySQLDump --defaults-file=$ini_Nan muticount member
$DBfile = Get-Content -Path .\build\member_nan.sql
$DBfile | & $MySQLClient --defaults-file=$ini_Local;
& $MySQLClient --defaults-file=$ini_Local -e "RENAME TABLE member TO member_nan;"
& $MySQLClient --defaults-file=$ini_Local -e "CREATE TABLE member LIKE member_nan;"

# dump 資料至本地（fengshan）
& $MySQLDump --defaults-file=$ini_Feng muticount member
$DBfile = Get-Content -Path .\build\member_fen.sql
$DBfile | & $MySQLClient --defaults-file=$ini_Local;
& $MySQLClient --defaults-file=$ini_Local -e "RENAME TABLE member TO member_fen;"
& $MySQLClient --defaults-file=$ini_Local -e "CREATE TABLE member LIKE member_fen;"

# 在本地端合併會員資料
Get-Content .\src\memberSync.sql | & $MySQLClient --defaults-file=$ini_Local

# 回復會員資料庫（楠梓）
& $MySQLClient --defaults-file=$ini_Nan muticount -e "truncate table muticount.member;"
& $MySQLDump --defaults-file=$ini_Local muticount member | & $MySQLClient --defaults-file=$ini_Nan

# 回復會員資料庫（鳳山）
& $MySQLClient --defaults-file=$ini_Feng muticount -e "truncate table muticount.member;"
& $MySQLDump --defaults-file=$ini_Local muticount member | & $MySQLClient --defaults-file=$ini_Feng

# start slave
