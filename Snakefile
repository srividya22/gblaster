import os
import pandas as pd

configfile: "config.yaml"

ref = config['ref']
gff = config['gff']
repeats = config['repeats']
#query = [ os.path.basename(f) for f in config['query'] ]
query = config['query'] 

outdir = config['outdir']
logs_dir = config['logsdir']

scripts_path = config['scripts_path']
blast_exe = config['blast_exe']
bedtools = config['bedtools']

os.makedirs(outdir, exist_ok=True)
os.makedirs(logs_dir, exist_ok=True)

exe=['blastn', 'bedtools']

def exists(exe):
  for i in exe:   
      if not any(os.access(os.path.join(path, i), os.X_OK) for path in os.environ["PATH"].split(os.pathsep)):
         print("{0} not found in path".format(i))
         sys.exit()

#def basename(file):
#    return "".join(file.split(".")[:-1])

def basename(file): 
    return "".join(file.split("/")[-1].split(".")[:-1])

fnames = list(map(basename,query))

print(query)     
print(fnames)
exists(exe)

rule all:
    input:
        os.path.join(outdir,"report.txt")

rule getLongestTranscripts:
    input:
        spath = scripts_path,
        gff3 = gff
    output:
        os.path.join(outdir, "longest_transcripts.bed")
    log:
        os.path.join(logs_dir , "getLongestTranscripts.log")
    shell:
        "({input.spath}/getLongestIsoform.sh {input.gff3} {output}) 2> {log}"

rule extractTranscripts:
    input:
        ref = ref,
        bed = os.path.join(outdir, "longest_transcripts.bed")
    output:
        os.path.join(outdir, "longest_transcripts.fasta")
    log:
        os.path.join(logs_dir , "extractTranscripts.log")
    shell:
        "( bedtools getfasta -fi {input.ref} -bed {input.bed} -name -s > {output} ) 2> {log}"

rule makeRefDB:
    input:
        expand("{q}",q = query)               
    output:
        expand("{q}.nhr",q = query)
    log:
        expand("{logs}/{fname}_makeRefDB.log",logs= logs_dir,fname=fnames)
    shell:
        "( makeblastdb -dbtype nucl -in {input} -parse_seqids ) 2> {log}"

rule makeRepDB:
    input:
        repeats 
    output:
        repeats + ".nhr"
    log:
        os.path.join(logs_dir , "repeats_makeRepDB.log")
    shell:
        "( makeblastdb -dbtype nucl -in {input} -parse_seqids ) 2> {log}"

rule blast_queries:
    input:
        spath=scripts_path,
        q = os.path.join(outdir, "longest_transcripts.fasta"), 
        ref = expand("{q}",q = query) ,
        refdb = expand("{q}.nhr",q = query) ,
        repeats= repeats,
        repDB= repeats + ".nhr"
    output:
        bd = expand("{out}/{fname}",out=outdir,fname=fnames),
        bf = expand("{out}/{fname}/blast.txt",out=outdir,fname=fnames)
    log:
        expand("{logs}/{fname}_blast.log",logs= logs_dir,fname=fnames)
    shell:
        "( {input.spath}/blast.sh {input.ref} {input.q} {input.repeats} {output.bd} ) 2> {log}"

rule counts_genes:
    input:
       spath=scripts_path,
       f = expand("{out}/{fname}/blast.txt",out=outdir,fname=fnames)
    output:
       counts = expand("{out}/{fname}/counts.txt",out=outdir,fname=fnames),
       coords = expand("{out}/{fname}/coords.txt",out=outdir,fname=fnames)
    shell:
       "( {input.spath}/create_counts.sh 0.95 {input.f} {output.counts} {output.coords} )"   

rule report:
    input:
       spath=scripts_path,
       counts = " ".join(expand("{out}/{fname}/counts.txt",out=outdir,fname=fnames))
    output:
        os.path.join(outdir,"report.txt")
    shell:
       "( {input.spath}/calculate_stats.sh {input.counts} > {output} )" 
