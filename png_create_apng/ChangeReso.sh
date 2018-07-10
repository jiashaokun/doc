#!/bin/bash

dir=$(ls -l ./ |awk '!/^d/ {print $NF}' |grep -i "\.png" )
 
for files in $dir
do
    echo "${files%.*}"
    ffmpeg -i $files -s 150x98 -r 10 -filter_complex "[0:v]format=rgba" "${files%.*}".apng -y
    #break
done 
