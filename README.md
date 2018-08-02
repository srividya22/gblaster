# gblaster
Estimate Reference Gene Copy Numbers in a Draft Assembly.

### Pipeline Steps:  
1. Identify the longest transcripts from the reference genome.  
2. Create blastdb for the query fasta files  
3. Create blastdb for repeats  
4. Run blastn queries of the longest transcripts against the references  
5. Filter blast hits with atleast 90 percent identity and  95 percent covered  
6. Report gene counts and bed file of the transcripts aligned  
7. Generate report  

### Requirements & Installation:
1. Install Miniconda following the steps the link : https://conda.io/docs/user-guide/install/linux.html.
2. Install Snakemake using command : conda install -c bioconda -c conda-forge snakemake
3. Install BLAST+ Suite : conda install -c bioconda blast
4. Install bedtools : conda install -c bioconda bedtools

### Steps to run the pipeline:
1. Clone github repository : git clone https://github.com/srividya22/gblaster.git ; cd gblaster
2. Fill the config.yaml file with paths to the reference genome, query genomes , output directory , logs directory.
3. Once you are done run ./submit_snakemake.sh

### Output:
1. report.txt in the output filepath 
### Example output:
https://github.com/srividya22/gblaster/blob/master/test/maize_comparison_stats.txt 
