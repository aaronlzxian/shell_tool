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