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
ref_db=$1
qry_fasta=$2
filtering_db=$3
out_dir=$4

### Blast Parameter Settings ###
#E_VALUE=0.0000000001 
P_IDTY=0.90
#Q_COV_IDTY=0.90
MAX_HSPS=10



blast_file=${out_dir}/blast.txt
sorted_file=${out_dir}/blast_sorted.txt
echo "Blasting the Longest Isoforms  ${TIMESTAMP}"
${HOME}/miniconda2/bin/blastn -num_threads 80 -perc_identity ${P_IDTY} -filtering_db $3 -soft_masking true -lcase_masking -query ${qry_fasta} -db ${ref_db} -outfmt "6 qseqid qstart qend qlen length sseqid sstart send slen pident evalue bitscore" -out ${blast_file}

#awk '{if($3 > $2 ){print $0}else{ print $1"\t"$3"\t"$2"\t"$4"\t"$5"\t"$6"\t"$8"\t"$7"\t"$9"\t"$10"\t"$11"\t"$12}}' ${blast_file} | ${HOME}/bin/l-sort '-k1,1 -V -k2,2n -k6,6 -V -k7,7n -k5,5nr' - ${sorted_file}

#if [[ $(stat -c%s ${blast_file}) -ge $(stat -c%s ${sorted_file}) ]]; then
#   echo "Error : Sorting the blast alignments "
#   exit 1
#fi

exit 0
