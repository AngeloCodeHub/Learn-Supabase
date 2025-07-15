
# 指定宿主與container資料映射
docker run --name vol1 -it -v D:\WorkSpace\supabase\voldata:/data alpine ash

# 指定container與container資料映射
docker run --name vol2 -it -v /data alpine ash
docker run --name vol3 -it --volumes-from vol2 alpine ash

docker volume create myvol
docker run --name vol4 -it -v myvol:/data alpine ash

docker rm vol4
docker volume rm myvol

docker cp .\DOC-docker.txt vol2:/data

docker run --name websrv -d -p 9090:80 nginx

docker exec -it websrv bash

docker cp .\html.html websrv:/usr/share/nginx/html

docker container run --name nodeENV -it node:current-alpine3.22 ash

docker run --rm --name test -v .\:/app -w /app node:current-alpine3.22 nodetest.js

docker run --name prj1 -it -v .\:/app -w /app -p 8001:3000 node:current-alpine3.22 ash


