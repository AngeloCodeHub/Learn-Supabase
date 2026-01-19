Import-Dotenv

$MySQLDump = $env:MySQLDump
$MySQLClient = $env:MySQLClient

$ini_src = ".\_env\POS-Nanzi-sync.ini"
$ini_dst = ".\_env\POS-Fengshan-sync.ini"
$DBfile

& $MySQLDump --defaults-file=$ini_src muticount member
$DBfile = Get-Content -Path .\build\member.sql

$DBfile | & $MySQLClient --defaults-file=$ini_dst;
