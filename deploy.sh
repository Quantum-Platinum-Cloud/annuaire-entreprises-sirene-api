#!/bin/sh

mkdir -p ./database-data

if [ $(docker ps -f name=blue -q) ]
then
    ENV="green"
    OLD="blue"
else
    ENV="blue"
    OLD="green"
fi

echo "Starting "$ENV" container"
docker-compose -f docker-compose-$ENV.yml build --no-cache
docker-compose -f docker-compose-$ENV.yml --project-name=$ENV up --build -d

while [ $(docker ps --filter "health=healthy" | grep $ENV | wc -l) = 0 ]
do
    sleep 5s
    echo "Waiting..."
    sudo du -sc database-data/
done

echo "Container up and healthy"

echo "Stopping "$OLD" container"
docker-compose -f docker-compose-$OLD.yml --project-name=$OLD down
