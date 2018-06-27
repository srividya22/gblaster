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
custom_lib=$2
out_dir=$3

### Repeat Parameter Settings #
echo "split up ref"
/seq/schatz/sramakri/sources/gblaster/scripts/explode_fasta.pl ${ref_fasta} ${out_dir}

echo "Repeat masking genome  ${TIMESTAMP}"
${HOME}/bin/RepeatMasker -pa 40 -lib ${custom_lib} ${out_dir}/*.fa -dir ${out_dir}

exit 0
