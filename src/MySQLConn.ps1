Import-Dotenv
$MySQLDump = $env:MySQLDump
$MySQLClient = $env:MySQLClient
$iniFlile = ".\_env\DC2.ini"

& $MySQLClient --defaults-file=$iniFlile
