#!/bin/bash

# ----------------------------------------
# Load Conda and activate Portcullis environment
# ----------------------------------------
source ~/anaconda3/etc/profile.d/conda.sh
conda activate portcullis

# Sample ID
ID=sample_name

# Reference genome
REF=./reference/species_v1.fa

# Sorted BAM file from HISAT2 alignment
BAM=./BAM_sorted/hisat2.${ID}.sorted.bam

# ----------------------------------------
# Portcullis workflow
# ----------------------------------------

# Step 1: Prepare BAM
srun portcullis prep -o 1_prep/"$ID" "$REF" "$BAM"

# Step 2: Junction extraction
srun portcullis junc -t 16 -o 2_junc/"$ID" 1_prep/"$ID"

# Step 3: Filter junctions
srun portcullis filt -t 16 -o 3_filt/"$ID" \
  1_prep/"$ID" 2_junc/"$ID".junctions.tab

# Step 4: Filter BAM based on junctions
srun portcullis bamfilt -o 4_BAM_filt/"$ID".junc_filt.bam \
  3_filt/"$ID".pass.junctions.tab \
  1_prep/"$ID"/portcullis.sorted.alignments.bam
