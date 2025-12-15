#!/bin/bash

# ----------------------------------------
# Load software
# Trim Galore 0.5.0_dev
source package /path/to/software/trim_galore-0.5.0_dev

# FastQC 0.11.8
source /path/to/software/fastqc-0.11.8
# ----------------------------------------

# Sample ID
ID=sample_name

# Input FASTQ files (paired-end)
R1=./raw_data/${ID}_1.fq.gz
R2=./raw_data/${ID}_2.fq.gz

# Output directory
OUT=./trimmed_reads/

# Run Trim Galore with FastQC
trim_galore -q 20 \
  --phred33 \
  --paired \
  --illumina \
  --length 75 \
  --output_dir "$OUT" \
  --fastqc "$R1" "$R2"
