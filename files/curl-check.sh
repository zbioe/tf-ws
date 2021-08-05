#!/bin/bash

set -euo pipefail

ip=${1:-}
expected=${2:-}
protocol=${3:-}
attempt=0
max_attempts=26
tempf=$(mktemp)

echo "Test $max_attempts attempts to server be up"
while test $attempt -lt $max_attempts
do
  curl -k -m3 $protocol://$ip > $tempf && break || true
  let "attempt=attempt+1"
  echo "Failed attempt: [$attempt/$max_attempts]"
  echo "waiting for server be up"
  sleep 3s
  continue
done

body="$(cat $tempf)"
rm "$tempf"

test $attempt -lt $max_attempts

echo "$body" | grep -q "$expected"

echo "check $protocol with success"
