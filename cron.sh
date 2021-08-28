imageName=proxy-to-proxy
containerIds=$(docker ps -a | grep "$imageName" | awk '{ print $1 }')
docker stop $containerIds
docker rm $containerIds
docker rmi "$imageName"
bash run.sh
