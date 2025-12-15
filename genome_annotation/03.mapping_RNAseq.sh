#!/bin/bash

# ----------------------------------------
# Load software
# HISAT2 2.1.0
source package /path/to/software/hisat2-2.1.0

# Samtools 1.10
source package /path/to/software/samtools-1.10
# ----------------------------------------

# Sample ID
ID=sample_name

# Input FASTQ files (paired-end)
R1=./trimmed_reads/${ID}_1.fq.gz
R2=./trimmed_reads/${ID}_2.fq.gz

# Align reads to HISAT2 index
hisat2 -q --dta-cufflinks -p 4 \
  -x example_species_v1 \
  -1 "$R1" -2 "$R2" \
  -S "$ID".sam

# Convert SAM to BAM
samtools view -b -o "$ID".bam "$ID".sam

# Create temporary directory for sorting
mkdir -p "$ID"_tmp

# Sort BAM file
samtools sort -o ./BAM_sorted/"$ID".sorted.bam \
  -T ./"$ID"_tmp/aln.sorted \
  --threads 4 -m 80G \
  "$ID".bam

# Index sorted BAM (BAI)
samtools index -b ./BAM_sorted/"$ID".sorted.bam

# Index sorted BAM (CSI, optional)
samtools index -c ./BAM_sorted/"$ID".sorted.bam
