#!/usr/bin/env bash
# Script to find counts per genes
#
# Author:  Srividya Ramakrishnan
# Affiliation : Johns Hopkins University

#qseqid qstart qend qlen length sseqid sstart send slen pident evalue bitscore
#awk -F'\t' 'function abs(x){return ((x < 0.0) ? -x : x)} {if (abs($9) < 500) print $0}'

PERCENT=$1
bfile=$2
countfile=$3
coordsfile=$4

echo "Calculating counts per gene"
date
awk -v x=${PERCENT} '$5 > ($4 * x) {print $1}' ${bfile} | awk '{a[$1]++} END { for (i in a){print i"\t"a[i]}}' > ${countfile}
#echo -e "#Sequenc_Id\tStart\tEnd\tRef_TranscriptID\tStart\tEnd\tAlignment_length" > ${coordsfile} 
awk -v x=${PERCENT} '$5 > ($4 * x) {print $6"\t"$7"\t"$8"\t"$1"\t"$2"\t"$3"\t"$5}' ${bfile} | sort -k1,1 -V -k2,2n > ${coordsfile}  
sed -i '1s/^/#Sequenc_Id\tStart\tEnd\tRef_TranscriptID\tStart\tEnd\tAlignment_length\n/' ${coordsfile}

date
echo "Done ! Calculated counts per gene"
