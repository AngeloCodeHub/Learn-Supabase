
$Myenv = (Get-Content -Path ".\Confidential\env.json") | ConvertFrom-Json
$MySQLexe = $Myenv[2].MySQLBin + "mysql.exe"
$iniFlile = $Myenv[2].MySQLINI

& $MySQLexe --defaults-file=$iniFlile

# Write-Host $MySQLexe

