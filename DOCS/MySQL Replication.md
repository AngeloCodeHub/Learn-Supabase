# Replication
# MySQL 複寫筆記

- [複寫（replica）敘述（statement）官方文件](https://dev.mysql.com/doc/refman/8.0/en/sql-replication-statements.html)
- [Chapter 19 Replication官方文件](https://dev.mysql.com/doc/refman/8.0/en/replication.html)
- [The Binary Log 官方文件](https://dev.mysql.com/doc/refman/8.0/en/binary-log.html)
- [MySQL :: MySQL 8.4 Reference Manual :: 19.1.6.4 Binary Logging Options and Variables](https://dev.mysql.com/doc/refman/8.4/en/replication-options-binary-log.html)
- [MySQL :: MySQL 5.7 Reference Manual :: 13.4.2.1 CHANGE MASTER TO Statement](https://dev.mysql.com/doc/refman/5.7/en/change-master-to.html)
- [MySQL :: MySQL 8.4 Reference Manual :: 6.5.4 mysqldump — A Database Backup Program](https://dev.mysql.com/doc/refman/8.4/en/mysqldump.html#option_mysqldump_no-create-info)
- [Perplexity－Slave 修復](https://www.perplexity.ai/search/mysql-server-you-yi-ge-fu-xie-4O3klN_DTSOcLTdBgAzm6A)

## 原理與相關指令

- 原理：由 slave 發起向 master 讀取 binlog
- binary log 是位在 master
- 設定主從式replica應以master-slave單向思考比較簡單，否則在設定雙向時常常會搞不清流程
- 有些指令只能在mysql.exe使用，無法在phpMyadmin用

```sql
-- 查看此Server的serverID
SELECT @@server_id;
-- master指令
SHOW MASTER STATUS;
SHOW MASTER STATUS\G
SHOW variables like '%log_bin%';
SHOW variables like 'max_binlog_size';
SHOW binary logs;
-- 清掉與重設binlog為初始狀態（謹慎使用）
RESET MASTER

-- slave指令
SHOW SLAVE STATUS;
STOP SLAVE;
START SLAVE;

-- 清空slave（需要重新設定）
reset slave all;

-- 查看所有資料表
SHOW tables;
-- 刪除資料表的欄位
ALTER TABLE member DROP updateTime;
-- 修改楠梓資料表欄位屬性
ALTER TABLE `member` CHANGE `Mem_LastLogin` `Mem_LastLogin` DATETIME on update CURRENT_TIMESTAMP NULL DEFAULT NULL COMMENT '最後登錄#19#1#17';
```

---

### replication流程

![展示圖](https://www.xn--djroe106hl2fyz1bszc.online/wp-content/uploads/2025/10/MySQL-Replication.webp)

1. master資料改變寫入Binary Log
2. Binlog dump進Relay Log
3. slave比對Relay Log寫進slave資料庫

---

### replication設定

1. 確保master、slave資料一致
2. master端my.ini
    
    ```powershell
    # 設定此台id，id在主從式是唯一
    server-id=1
    # 啟用binlog功能
    log-bin=mysql-bin
    expire_logs_days=0
    max_binlog_size=500G
    binlog_do_db=muticount
    binlog-format=ROW
    auto-increment-offset = 1
    
    # 重啟mysql服務
    Get-Service 服務名稱
    Restart-Service 服務名稱
    # RESET MASTER將binlog回復到序列00001
    # master重啟binlog都會多一個序列，slave會自動判斷
    ```
    
3. slave端指定要複寫資料表，my.ini
    
    ```powershell
    replicate-do-table=DB.Table
    ```
    
4. master端新增一組replica帳號（slave主機的帳號密碼與host）給slave使用
    
    ```sql
    # 北半球repl密碼：Egbf7983
    GRANT REPLICATION SLAVE ON *.* TO 帳號@host IDENTIFIED BY '密碼文字';
    ```
    
5. slave端設定master的資訊
    
    ```sql
    stop slave;
    # 從slave設定一個串流連接master等待master dump
    CHANGE MASTER TO MASTER_HOST = 'host',
    MASTER_USER = '帳號',
    MASTER_PASSWORD = '密碼文字',
    MASTER_LOG_FILE = 'mysql-bin.000001',
    MASTER_LOG_POS = 120;
    start slave;
    ```
    

---

### 資料庫與資料表備份與還原指令 兩張架構一樣的資料表雙向合併

處理重複的記錄（已經非重複的資料刪除）

1. 有一方Mem_LastLogin為null：選擇非null一方寫入synced
2. 兩方Mem_LastLogin都是null：則隨便選擇一放寫入synced
3. 兩方Mem_LastLogin都非null：選擇時間比較大的一方寫入
4. 兩方Mem_LastLogin都非null：時間一樣

---