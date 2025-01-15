docker stop psqlcont && docker rm psqlcont
docker volume rm psqlVolume && docker volume create --name psqlVolume
docker run -v /root/docker-entrypoint-initdb.d:/docker-entrypoint-initdb.d -v psqlVolume:/var/lib/postgresql/data --name="psqlcont" -e POSTGRES_PASSWORD=12345 -d -p 5432:5432 postgres:15
sleep 10s
docker ps -a
docker logs psqlcont
