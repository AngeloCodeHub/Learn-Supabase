# Remove all Docker containers
docker container rm -f $(docker container ls -aq)

#
docker container run -it --name ch03lab diamol/ch03-lab:2e
docker container run -it -e TARGET="google.com" -e INTERVAL=5000 ping-test
docker container run --name iotd -d -p 800:80 --network nat javaimage
docker container run --name accesslog -d -p 800:80 --network nat access-log

# Build Docker image
docker image build -t ping-test .
docker image build -t ping-test:v2 .
docker image build -t access-log .
docker image history ping-test
docker image ls -f reference=diamol/golang -f reference=image-gallery

docker system df

docker network create nat
docker network ls

# 本機registry伺服器
docker container run -d -p 5000:5000 --name registry --restart=always registry:2

# 1. 先幫現有的 Image 打上正確的標籤
# 格式：docker tag [來源Image] [你的DockerID]/[倉庫名稱]:[標籤]
docker tag access-log:latest your_docker_id/access-log:latest
# 2. 推送正確命名的 Image
docker push your_docker_id/access-log:latest

docker container run --name rn1 diamol/ch06-random-number
docker container run --name rn2 diamol/ch06-random-number

docker container run --name todo1 -d -p 8010:80 diamol/ch06-todo-list
docker container inspect --format='{{.Mounts}}' todo1
docker volume ls

docker image pull diamol/ch03-web-ping

docker container run --name web-ping -d diamol/ch03-web-ping

docker run --name LearnNextJS -p 3000:3000 learn-nextjs:latest

docker compose --env-file .env up -d

docker run -d $(
	--name learn-nextjs
)
-p 3000:3000 $(
	--env-file .env
)
learn-nextjs-nextjs-app:latest

docker compose exec nextjs-app sh -lc "printenv | grep -E 'AUTH_SECRET|POSTGRES_URL|NEXT_PUBLIC_SUPABASE_URL'"
docker compose exec nextjs-app wget -q -O- http://supabase_kong_Learn-Supabase:8000/rest/v1/ | head -20
docker compose logs -f nextjs-app

# 進入容器Linux內部
docker exec -it a4e27a271164 /bin/bash

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
