# 說明

`Slave_IO_Running: No` 導致同步錯誤，原始碼
```Powershell
.\src\FixSlave.ps1
```
## 步驟

1. 記下 master 資訊（File、Posistion）
   ```sql
   show master status \G
   ```
2. 執行 `FixSlave.ps1` ，同步table資料與備份
3. slave 重新設定 File與Posistion
   檔案：.\_env\Rep-slave設定.sql

## 注意事項

- 特別注意同步方向
