
# dump（複製）遠端資料庫至本地資料庫

$Myenv = (Get-Content -Path ".\Confidential\env.json") | ConvertFrom-Json

$dumpEXE = $Myenv[2].MySQLBin + "mysqldump.exe"
$clientEXE = $Myenv[2].MySQLBin + "mysql.exe"
$iniFlile = $Myenv[2].MySQLINI
$DBname = $Myenv[2].DBName
# $tableName = $Myenv[2].tableName

# & $dumpEXE --defaults-file=$iniFlile $DBname $tableName

# $DBfile= Get-Content -Path ".\build\member.sql"
# $DBfile | & $clientEXE --defaults-file=$iniFlile;

# 合成
& $dumpEXE --defaults-file=$iniFlile $DBname | & $clientEXE --defaults-file=$iniFlile --user root;

# write-host $iniFlile
# write-host $dumpEXE


