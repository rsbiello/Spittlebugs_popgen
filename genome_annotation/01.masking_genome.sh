#!/bin/bash

# ========================================
# RepeatMasker 4.0.7
# ========================================
source package /path/to/software/repeatmasker-4.0.7

# Reference genome
REF=./reference/species_v1.fa

# Working directory for RepeatMasker
WD=./masking/repeatmasker_run
mkdir -p "$WD"
cd "$WD"

# Run RepeatMasker
RepeatMasker -pa 16 \        # Number of threads
  -e ncbi \                  # Engine
  -s \                       # Sensitive mode
  -species insecta \         # Species-specific library
  -xsmall \                  # Mask repeats as lowercase
  -gff "$REF"                # Output GFF annotations


# ========================================
# RepeatModeler 2.0.2a
# ========================================
source ~/anaconda3/etc/profile.d/conda.sh
conda activate RepeatModeler

# Load RECON
source package /path/to/software/recon-1.08

# Working directory for RepeatModeler
WD=./masking/repeatmodeler_run
mkdir -p "$WD"
cd "$WD"

# Build the RepeatModeler database
BuildDatabase -name "species" -engine ncbi "$REF"

# Run RepeatModeler
RepeatModeler -engine ncbi \
  -pa 16 \
  -trf_prgm /path/to/trf409.linux64 \
  -database species


# ========================================
# Merge RepeatMasker and RepeatModeler outputs with ReannTE
# ========================================
export PERL5LIB=/path/to/custom_perl_mods:$PERL5LIB
source /path/to/software/bioperl-1.6.923

MASKER=./masking/repeatmasker_run/repeatmasker.insecta.fa
MODELLER=./masking/repeatmodeler_run/consensi.fa.classified

WD=./masking/merged
mkdir -p "$WD"
cd "$WD"

~/ReannTE/ReannTE-master/ReannTE_MergeFasta.pl \
  -a "$MASKER" \
  -b "$MODELLER" \
  -RM /path/to/repeatmasker/4.0.7/bin/ \
  -CheckLow 80


# ========================================
# TETools 1.0 RepeatMasker run
# ========================================
source package /path/to/software/TETtools-1.0

# Library from RepeatModeler (post-merge or filtered)
LIB=./masking/repeatmodeler_run/consensi.classified.nolow.fa

WD=./masking/repeatmasker_merged_run
mkdir -p "$WD"
cd "$WD"

# Run RepeatMasker with TETools library
RepeatMasker -pa 8 \
  -dir . \
  -trf_prgm /path/to/trf409.linux64 \
  -xsmall \
  -a \
  -no_is \
  -e ncbi \
  -s \
  -gff \
  -lib "$LIB" \
  "$REF"
