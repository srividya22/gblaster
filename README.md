# gblaster
Estimate Reference Gene Copy Numbers in a Draft Assembly.

Pipeline Steps:
Identify the longest transcripts from SL3.0
Create blastdb for the query fasta files
Create blastdb for repeats
Run blastn queries of the longest transcripts against the references
Filter blast hits with atleast 90 percent identity and  95 percent covered
Report gene counts and bed file of the transcripts aligned
Generate report

