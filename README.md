# gblaster
Estimate Reference Gene Copy Numbers in a Draft Assembly.

Pipeline Steps:  
1. Identify the longest transcripts from SL3.0  
2. Create blastdb for the query fasta files  
3. Create blastdb for repeats  
4. Run blastn queries of the longest transcripts against the references  
5. Filter blast hits with atleast 90 percent identity and  95 percent covered  
6. Report gene counts and bed file of the transcripts aligned  
7. Generate report  

