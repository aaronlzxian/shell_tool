#!/usr/bin/env bash
echo "======== start remove docker containers ========"
docker container rm $(docker container ls -a -q)
echo "======== end remove docker containers ========"


echo "======== start remove docker image ========"
docker image rm $(docker image ls -a -q)
echo "======== end remove docker image ========"


echo "======== start remove docker volume ========"
docker volume rm $(docker volume ls -q)
echo "======== end remove docker volume ========"

echo "======== start remove network ========"
docker network rm $(docker network ls -q)
echo "======== end remove network ========"


#if image has dependent child images error 使用下面这条语句 since是镜像id
#docker image inspect --format='{{.RepoTags}} {{.Id}} {{.Parent}}' $(docker image ls -q --filter since=0341d5bf6654)

#if image is referenced in multiple repositories error 使用 docker rmi $tag
#docker rmi 0341d5bf6654

echo "======== start clean docker containers logs ========"

logs=$(find /var/lib/docker/containers/ -name *-json.log*)

for log in $logs
        do
                echo "clean logs : $log"
                cat /dev/null > $log
        done

echo "======== end clean docker containers logs ========"


