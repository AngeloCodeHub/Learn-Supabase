
$Myenv = (Get-Content -Path ".\env.json") | ConvertFrom-Json
$MySQLexe = $Myenv[2].MySQL + "mysql.exe"
$MyINI_Feng = ".\Confidential\MyINI\Feng.ini"
$MyINI_Nan = ".\Confidential\MyINI\Nan.ini"

Get-Content ".\Confidential\SQL\POS-Delete.sql" | & $MySQLexe --defaults-file=$MyINI_Feng
Get-Content ".\Confidential\SQL\POS-Delete.sql" | & $MySQLexe --defaults-file=$MyINI_Nan
# & $MySQLexe --defaults-file=$MyINI_Feng -e "show databases;"

# Write-Host $MySQLexe

