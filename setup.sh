#!/usr/bin/env sh

# Create conda environment and install neccessary packages
conda create --name gB -c bioconda python=3.6 snakemake blast bedtools

# Activate the environment
source activate gB
