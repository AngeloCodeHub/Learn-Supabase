# 遷移筆記

## pgloader工具遷移
  1. 使用 WSL
  2. 確認 Windows host IP，WSL裡面 127.0.0.1 是本身 VM
     ```BASH
     # 檢查是否可達
     nc -vz 127.0.0.1 3306
     # 查看Windows host主機
     cat /etc/resolv.conf | grep nameserver
     # ip方式查看Gateway
     ip route
     ```
  3. 狀況題：Windows 防火牆需開啟，mysql（8.4.7） 新版即使開啟native_password會出現unsurport，舊版5.6沒此問題
  4. pgloader遷移指令，遷移後會有一個與mysql資料庫同名schema
     ```Bash
     pgloader mysql://username:password@192.168.1.252:3306/db_name postgresql://postgres:postgres@172.28.192.1:54322/postgres
     ```
  5. 轉移db_name至public schema，supabase只能看到public schema
     ```Sql
     do $$
declare
  r record;
begin
  for r in
    select tablename
    from pg_tables
    where schemaname = 'db_name'
  loop
    execute format(
      'alter table db_name.%I set schema public;',
      r.tablename
    );
  end loop;
end $$;

     ```

## ref
- [MySQL 遷移至 Postgres](https://chatgpt.com/share/6949e9a0-a8a0-8006-92af-5885099ff145)
- [MySQL 遷移至 Supabase](https://chatgpt.com/share/6949e9d8-c504-8006-8490-c8999e81a4a3)
- [Netcat（Linux nc 指令）網路管理者工具實用範例 – G. T. Wang](https://blog.gtwang.org/linux/linux-utility-netcat-examples/)
- [dimitri/pgloader](https://github.com/dimitri/pgloader?tab=readme-ov-file)
