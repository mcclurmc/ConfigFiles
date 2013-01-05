#!/bin/bash

# This file parses files named "links", which have the format:
# <filename> <link location>
# We then create a link to each conf file in the appropriate location.

for f in $(find -name links); do
  d=$(pwd)/$(dirname $f)
  #echo "dir: $d"
  cat $f | while read line; do
    file=${d}/$(echo ${line} | cut -d\  -f1)
    link=$(echo ${line} | cut -d\  -f2)
    link=$(eval echo ${link}) # to expand ~
    echo "Linking ${link} -> ${file}"
    ln -sf ${file} ${link}
  done
done

# Lazy copy-paste for sudo links
for f in $(find -name sudo); do
  d=$(pwd)/$(dirname $f)
  #echo "dir: $d"
  cat $f | while read line; do
    file=${d}/$(echo ${line} | cut -d\  -f1)
    link=$(echo ${line} | cut -d\  -f2)
    link=$(eval echo ${link}) # to expand ~
    echo "Linking ${link} -> ${file}"
    sudo ln -sf ${file} ${link}
  done
done
