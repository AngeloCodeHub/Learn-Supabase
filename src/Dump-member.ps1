# dump（複製）遠端資料庫至本地資料庫

Import-Dotenv
$MySQLDump = $env:MySQLDump
$MySQLClient = $env:MySQLClient

$iniFlile = ".\_env\POS-LocalDB-sync.ini"
$DBfile = Get-Content -Path ".\build\member.sql"
# $DBname=".\build\member.sql"

& $MySQLDump --defaults-file=$iniFlile muticount member
$DBfile | & $MySQLClient --defaults-file=$iniFlile muticount

# 合成指令，不儲存實體檔案
# & $MySQLDump --defaults-file=$iniFlile $DBname | & $MySQLClient --defaults-file=$iniFlile --user root;
