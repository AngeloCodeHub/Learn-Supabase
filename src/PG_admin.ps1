Import-Dotenv

$psql = ($env:postgresBin) + "\psql.exe"

# & $psql --help > .\build\psql-help.txt
# & $psql -h localhost -p 54322 -U postgres
& $psql -h localhost -p 54322 -U postgres
