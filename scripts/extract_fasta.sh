#!/bin/bash
#submit_script.sh
#$ -V                      # Inherit the submission environment
#$ -cwd                    # Start job in submission directory
#$ -e $JOB_NAME.e$JOB_ID   # Combine stderr and stdout
#$ -o $JOB_NAME.o$JOB_ID   # Name of the output file (eg. myMPI.oJobID)
#$ -m bes                  # Email at Begin and End of job or if suspended

TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
ref=$1
bed=$2
out_file=$3

exe=`which bedtools`
date
${exe} getfasta -fi ${out_file} -bed ${bed} -fo ${out_file} -name -s
date
