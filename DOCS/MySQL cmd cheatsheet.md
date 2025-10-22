# MySQL cmd cheatsheet

```sql
-- 查詢所有使用者
SELECT User,Host FROM mysql.user;
-- 選擇資料庫來操作
USE muticount;
-- Table改名
RENAME TABLE member TO member1;
-- 複製資料表member1的結構到資料表member
CREATE TABLE member1 LIKE member;
-- 我是誰
select user();
-- 清空資料表的資料（結構不清）
TRUNCATE TABLE member;
```

[6.5.1 mysql — The MySQL Command-Line Client](https://dev.mysql.com/doc/refman/8.0/en/mysql.html)

[MySQL Lock : Table Lock與Row Lock](https://www.mysql.tw/2018/06/mysql-lock-table-lockrow-lock.html)

[15.3.6 LOCK TABLES and UNLOCK TABLES Statements](https://dev.mysql.com/doc/refman/8.0/en/lock-tables.html)

- 備份資料庫
PWSH（[mysqldump.exe](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html)）
參數：[hex-blob](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html#option_mysqldump_hex-blob)、[insert-ignore](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html#option_mysqldump_insert-ignore)、[skip-triggers](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html#option_mysqldump_triggers)、[no-create-info](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html#option_mysqldump_no-create-info)
    
```powershell
mysqldump.exe --host="host" --user=root --password=MyPass --default-character-set=utf8 --hex-blob dbName --insert-ignore=FALSE --result-file="D:\demo.sql"
    # 只要dump某個資料表，dbName後面空格加上Table名稱
    # dbName dbTable
```
    
- 回復資料庫
phpMyadmin：需要先建立一空資料庫，並選擇匯入
PWSH（mysql.exe）
    
```powershell
Get-Content *.sql | mysql.exe --host="host" --user=root --password=MyPass --database=dbName --default-character-set=utf8
```