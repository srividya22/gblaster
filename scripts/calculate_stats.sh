#!/usr/bin/env bash
# Script to find counts per genes
#
# Author:  Srividya Ramakrishnan
# Affiliation : Johns Hopkins University

files="$@"

#echo "Gene Copy Number Statistics for : " $( echo $( basename ${i}) |  cut -f1 -d "_" ); 
echo "########################################################"
echo "# Gene Copy number Statistics report "
echo "# Created on : `date` "
echo "########################################################"
echo -e "\n"
echo -e "Assembly\tTotal\tSingle_Copy\t2_Copies\t3-5_Copies\t5-10_Copies\t10-20_Copies\t>20_Copies"
for i in ${files}; 
do 
  #awk '{a[$2]++}END{for(i in a){print i" Copy genes\t"a[i]}}' $i ; 
  assembly=$( echo $( basename ${i}) |  cut -f1 -d "_" ) 
  total=$( awk '{count++}END{print count }' $i )
  single=$( awk '$2 == 1 {count++}END{print count }' $i )  
  double=$( awk '$2 == 2 {count++}END{print count }' $i )  
  three2Five=$( awk '$2 > 2 && $2 <= 5 {count++}END{print count }' $i )  
  five2Ten=$( awk '$2 > 5 && $2 <= 10 {count++}END{print count }' $i )  
  ten2Twenty=$( awk '$2 > 10 && $2 <= 20 {count++}END{print count }' $i )  
  gtTwenty=$( awk '$2 > 10 && $2 <= 20 {count++}END{print count }' $i )  
  echo -e "${assembly}\t${total}\t${single}\t${double}\t${three2Five}\t${five2Ten}\t${ten2Twenty}\t${gtTwenty}" 
done
