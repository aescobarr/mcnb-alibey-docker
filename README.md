SHORT VERSION

cd docker_djangoref
docker-compose build
docker-compose up

go to http:127.0.0.1:1337


USEFUL COMMANDS

# build image using contents of /home/webuser/dev/docker/djangoref_db
docker build -t djangoref_db .
# build image using contents of /home/webuser/dev/docker/docker_djangoref
docker build -t docker_djangoref .
# shell to docker_djangoref image
docker run -it docker_djangoref:latest /bin/bash
# build from docker-compose.yml
docker-compose build
# start from docker-compose.yml
docker-compose up
# shell to running container
docker ps
docker exec -it <mycontainer> /bin/bash

