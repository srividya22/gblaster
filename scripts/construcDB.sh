#!/bin/bash
#submit_script.sh
                           # The following are options passed to qsub
#$ -V                      # Inherit the submission environment
#$ -cwd                    # Start job in submission directory
#$ -e $JOB_NAME.e$JOB_ID   # Combine stderr and stdout
#$ -o $JOB_NAME.o$JOB_ID   # Name of the output file (eg. myMPI.oJobID)
#$ -m bes                  # Email at Begin and End of job or if suspended
#$ -l m_mem_free=10g
#$ -pe openmpi 10

TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
ref_fasta=$1
out_dir=$2

echo "Making blastdb for Ref:  $1 , ${TIMESTAMP}"
${HOME}/miniconda2/bin/makeblastdb -in ${1} -dbtype nucl -parse_seqids

echo "Making blastdb Completed:  $1 , ${TIMESTAMP}"
exit 0
