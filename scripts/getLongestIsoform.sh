#!/usr/bin/env bash

###############
# Identify the Longest isoforms of genes from gff3
# Usage : getLongestIsoform.sh <gff3_file> > <output_file>

# Inout : GFF3
# Output : Bed file with longest transcripts


# author: Srividya Ramakrishnan
# Johns Hopkins University
###############

FEATURE="mRNA"

gff3_file=$1
output_file=$2

if [ $# -lt 2 ]; then
    # TODO: print usage
    echo "Usage : getLongestIsoform.sh <gff3_file> <output_file>"
    exit 1
fi

sed '/#/ d' ${gff3_file}  | \
    sed 's/[;,=]/\t/g' | \
    awk -v x=${FEATURE} '$3 == x{print $1"\t"$4"\t"$5"\t"$12"\t"$5-$4}' | \
    awk '$5 > max[$4] { max[$4]=$5; row[$4]=$0 } END { for (i in row) print row[i] }' | sort -k1,1 -V -k2,2n > ${output_file}

echo "Done! Extracted Longest Isoforms from GFF3"
exit 0
