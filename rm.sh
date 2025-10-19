docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker rmi $(docker images -q)
docker volume rm $(docker volume ls -qf dangling=true)
docker network prune -f
docker builder prune -f
docker system df
docker network ls
