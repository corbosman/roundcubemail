#!/bin/bash


# exit on error
set -e

#hosts=( roundcube12.xs4all.net )
hosts=( roundcube1.xs4all.net roundcube3.xs4all.net roundcube4.xs4all.net roundcube5.xs4all.net roundcube6.xs4all.net roundcube7.xs4all.net roundcube8.xs4all.net roundcube9.xs4all.net roundcube10.xs4all.net roundcube11.xs4all.net  roundcube12.xs4all.net )

while getopts "st" opt; do
  case $opt in
    t) TEST=1 ;;
    *) echo "Usage: $0 -t  (-t to test)"; exit;;
  esac
done

if [ "$TEST" == "1" ]; then
  N="-n";
  echo -e "\n\nTesting Deploy\n\n"
else 
  N=""
  echo -e "\n\nDeploying to Production\n\n"
fi

# first see if all hosts are up

for host in "${hosts[@]}"
do
  ssh -o StrictHostKeyChecking=no roundcube@$host "date"	
done

# now actually sync

for host in "${hosts[@]}"
do
  rsync $N -avH -O --delete --exclude=SQL --exclude=.deploy --exclude=.gitdeploy.conf --exclude=deploy --exclude=.git --exclude=storing.inc --exclude=.gitignore --exclude=.gitmodules --exclude=bin /data/WWW/roundcube-accept.xs4all.net/ roundcube@$host:/data/WWW/release-1.0/
done