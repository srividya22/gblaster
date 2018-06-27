#!/usr/bin/env bash
# Script to find counts per genes
#
# Author:  Srividya Ramakrishnan
# Affiliation : Johns Hopkins University

#qseqid qstart qend qlen length sseqid sstart send slen pident evalue bitscore
#awk -F'\t' 'function abs(x){return ((x < 0.0) ? -x : x)} {if (abs($9) < 500) print $0}'

PERCENT=$1
bfile=$2
outfile=$3

echo "Calculating counts per gene"
date
awk -v x=${PERCENT} '$5 > ($4 * x) {print $1}' ${bfile} | awk '{a[$1]++} END { for (i in a){print i"\t"a[i]}}' > ${outfile}
date
echo "Done ! Calculated counts per gene"

