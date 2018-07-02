#!/usr/bin/env bash

files=${1}

for i in `ls ${files}`; 
    do 
      #name=$( dirname ${i} | rev | cut -f1 -d "/" | rev ) ; 
      name=$( dirname ${i} | rev | cut -f1 -d "/" | rev | cut -f2 -d"_") ; 
      echo ${i}
      ../scripts/create_counts.sh 0.95 ${i} ./${name}_counts.txt ./${name}_coords.txt;  
    done
