
$pg_dump = "C:\Program Files\PostgreSQL\18\bin\pg_dump.exe"

& $pg_dump "postgresql://postgres:postgres@127.0.0.1:54322/postgres" `
  --schema=public `
  -f public_backup.sql

pnpm supabase db dump --db-url "postgresql://postgres:postgres@127.0.0.1:54322/postgres" -f schema.sql
pnpm supabase db dump --db-url "postgresql://postgres:postgres@127.0.0.1:54322/postgres" -f data.sql --use-copy --data-only
