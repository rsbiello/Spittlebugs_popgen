#!/bin/bash

# ========================================
# Flye 2.9 - PacBio assembly
# ========================================
# Load Conda and activate Flye environment
source ~/anaconda3/etc/profile.d/conda.sh
conda activate flye

# Input PacBio subreads (raw)
CCS1=./raw_data/pacbio/sample_1.subreads.fastq.gz
CCS2=./raw_data/pacbio/sample_2.subreads.fastq.gz

# Output directory for Flye assembly
OUTDIR=./assembly/flye_run_1
mkdir -p "$OUTDIR"

# Run Flye assembly
flye --pacbio-raw "$CCS1" "$CCS2" \
     --out-dir "$OUTDIR" \
     --threads 24 \
     --scaffold \
     --iterations 2
