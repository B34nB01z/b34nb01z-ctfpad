#!/bin/sh
 
set -eu
 
echo "Checking DB connection ..."
 
i=0
until [ $i -ge 10 ]
do
  nc -z app-db 3306 && break
 
  i=$(( i + 1 ))
 
  echo "$i: Waiting for DB 1 second ..."
  sleep 1
done
 
if [ $i -eq 10 ]
then
  echo "DB connection refused, terminating ..."
  exit 1
fi
 
echo "DB is up ..."
 
/app
