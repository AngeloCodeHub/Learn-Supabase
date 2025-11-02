<#
會員資料庫同步程式
先把master slave設定好，再執行此程式
刪除member_Nan、member_Fen
#>

Import-Dotenv
$MySQLDump = $env:MySQLDump
$MySQLClient = $env:MySQLClient
$ini_Nan = ".\_env\POS-Nanzi-sync.ini"
$ini_Feng = ".\_env\POS-Fengshan-sync.ini"
$ini_Local = ".\_env\POS-LocalDB-sync.ini"

# member truncate
# & $MySQLClient -u root -e "truncate table muticount.member;"

# dump 會員資料至本地（nan）
& $MySQLDump --defaults-file=$ini_Nan "muticount" "member" | & $MySQLClient --defaults-file=$ini_Nan;
& $MySQLClient --defaults-file=$ini_Nan -e "RENAME TABLE muticount.member TO muticount.member_Nan;"
& $MySQLClient --defaults-file=$ini_Nan -e "CREATE TABLE muticount.member LIKE muticount.member_Nan;"

# dump 會員資料至本地（fengshan）
& $MySQLDump --defaults-file=$ini_Feng "muticount" "member" | & $MySQLClient --defaults-file=$ini_Feng;
& $MySQLClient --defaults-file=$ini_Feng -e "RENAME TABLE muticount.member TO muticount.member_fen;"
& $MySQLClient --defaults-file=$ini_Feng -e "CREATE TABLE muticount.member LIKE muticount.member_fen;"

# 在本地端合併會員資料
# Get-Content .\src\memberSync.sql | & $MySQLClient --defaults-file=$ini_Local

# 回復會員資料庫（楠梓）
# & $MySQLClient --host=$remoteHost_Nati -u $userName_Nati --password=$password_Nati muticount -e "truncate table muticount.member;"
# & $MySQLDump --user=root --password=Egbf7983 --default-character-set=utf8 `
#     --insert-ignore=FALSE --skip-triggers --no-create-info "muticount" "member" | & $MySQLClient --host="pos-01" -u $userName_Nati `
#     --password=$password_Nati muticount --default-character-set=utf8;

# 回復會員資料庫（鳳山）
# & $MySQLClient --host=$remoteHost_Fensheng -u $userName_Fensheng --password=$password_Fensheng muticount -e "truncate table muticount.member;"
# & $MySQLDump --user=root --password=Egbf7983 --default-character-set=utf8 `
#     --insert-ignore=FALSE --skip-triggers --no-create-info "muticount" "member" | & $MySQLClient --host=$remoteHost_Fensheng -u $userName_Fensheng `
#     --password=$password_Fensheng muticount --default-character-set=utf8;

# start slave
