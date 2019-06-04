#!/bin/bash


touch ./traefik/acme.json

chmod 600 ./traefik/acme.json 

docker network create proxy

docker-compose up -d