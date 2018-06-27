import os
import pandas as pd

configfile: "config.yaml"

ref = config['ref']
gff = config['gff']
repeats = config['repeats']
#query = [ os.path.basename(f) for f in config['query'] ]
query = config['query'] 

outdir = config['outdir']
logs_dir = config['logs_dir']

scripts_path = config['scripts_path']
blast_exe = config['blast_exe']
bedtools = config['bedtools']

os.makedirs(outdir, exist_ok=True)
os.makedirs(logs_dir, exist_ok=True)

rule all:
    input:
        os.path.join(outdir,"report.txt")


rule getLongestTranscripts:
    input:
        spath=scripts_path,
        gff3=gff
    output:
        os.path.join(outdir, "longest_transcripts.bed")
    log:
        os.path.join(logs_dir , "getLongestTranscripts.log")
    shell:
        "( {input.spath}/getLongestIsoform.sh {input} {output}) 2> {log}"

rule extractTranscripts:
    input:
        ref = ref,
        bed= os.path.join(outdir, "longest_transcripts.bed")
    output:
        os.path.join(outdir, "longest_transcripts.fasta")
    log:
        os.path.join(logs_dir , "extractTranscripts.log")
    shell:
        "( bedtools_exe getfasta -fi {input.ref} -bed {input.bed} -name -s > {output} ) 2> {log}"

rule makeRefDB:
    input:
        os.path.join(outdir, "longest_transcripts.fasta")
    output:
        os.path.join(outdir, "longest_transcripts.fasta.nhr")
    log:
        os.path.join(logs_dir , "makeRefDB.log")
    shell:
        "( makeblastdb -dbtype nucl -in {input} -parse_seqids ) 2> {log}"

rule makeRepDB:
    input:
        repeats 
    output:
        repeats + ".nhr"
    log:
        os.path.join(logs_dir , "makeRepDB.log")
    shell:
        "( makeblastdb -dbtype nucl -in {input} -parse_seqids ) 2> {log}"

rule blast_queries:
    input:
        spath=scripts_path,
        ref= os.path.join(outdir, "longest_transcripts.fasta"), 
        refdb= os.path.join(outdir, "longest_transcripts.fasta.nhr"), 
        repeats= repeats,
        repDB= repeats + ".nhr" ,
        query=expand("{sample}", sample=query)
    output:
        expand(os.path.join(outdir,os.path.basename({sample})),sample=query)
    shell:
        "( {input.spath}/blast.sh {input.ref} {input.query} {input.repeats} {output} )"

rule report:
    input:
        expand("".format(outdir,os.path.basename({sample})),sample=query)
    output:
        os.path.join(outdir,"report.txt")
    run:
        from snakemake.utils import report
        with open(input[0]) as vcf:
            n_calls = sum(1 for l in vcf if not l.startswith("#"))

        report("""
        An example variant calling workflow
        ===================================

        Reads were mapped to the Yeast
        reference genome and variants were called jointly with
        SAMtools/BCFtools.

        This resulted in {n_calls} variants (see Table T1_).
        """, output[0], T1=input[0])
