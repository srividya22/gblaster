#!/usr/bin/env bash
# Script to find counts per genes
#
# Author:  Srividya Ramakrishnan
# Affiliation : Johns Hopkins University

files="$@"

echo "Writing report on the gene counts"
date
for i in ${files}; 
do 
  echo $( echo $( basename ${i}) |  cut -f1 -d "_" ); 
  awk '{a[$2]++}END{for(i in a){print i" Copy genes\t"a[i]}}' $i ; 
done
