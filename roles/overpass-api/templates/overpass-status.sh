#!/bin/bash

VERSION=/data/project/overpass/database/osm_base_version

if [ -s $VERSION ]; then
  {
    DB_DATE=$(date +%s --utc -d "$(cat $VERSION | sed s/\\\\//g)")
    CUR_DATE=$(date -u +%s)
    LAG=$(($CUR_DATE - $DB_DATE))
  }
fi

while read line; do
  echo $line | grep 'Number of not yet opened connections' >> /dev/null
  if [ $? == 0 ]; then
    WAITING=$(echo $line | awk '{ print $7; }')
  fi
  echo $line | grep 'Number of connected clients' >> /dev/null
  if [ $? == 0 ]; then
    ACTIVE=$(echo $line | awk '{ print $5; }')
  fi
  echo $line | grep 'Counter of started' >> /dev/null
  if [ $? == 0 ]; then
    STARTED=$(echo $line | awk '{ print $5; }')
  fi
  echo $line | grep 'Counter of finished' >> /dev/null
  if [ $? == 0 ]; then
    FINISHED=$(echo $line | awk '{ print $5; }')
  fi
  echo $line | grep 'Average claimed space' >> /dev/null
  if [ $? == 0 ]; then
    MEMORY=$(echo $line | awk '{ print $4; }')
  fi
  echo $line | grep 'Average claimed time units' >> /dev/null
  if [ $? == 0 ]; then
    TIMEOUT=$(echo $line | awk '{ print $5; }')
  fi
done <<< $(dispatcher --osm-base --status)



if [ $LAG ]; then
  echo "overpass-api database_lag=$LAG"
fi

echo "overpass-api connections_active=$ACTIVE,connections_waiting=$WAITING"
echo "overpass-api requests_started=$STARTED,requests_finished=$FINISHED"
echo "overpass-api memory_used=$MEMORY"
echo "overpass-api timeout=$TIMEOUT"
