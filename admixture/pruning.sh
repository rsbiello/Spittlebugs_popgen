#!/bin/bash

# Load PLINK2
source package /path/to/software/plink-2.0.0

# Input / output variables
VCF=dataset.vcf.gz
OUT=dataset.filtered

# ----------------------------------------
# Linkage disequilibrium (LD) pruning
# Identify SNPs to keep
# ----------------------------------------
plink2 \
  --vcf "$VCF" \
  --double-id \
  --allow-extra-chr \
  --set-missing-var-ids @:# \
  --indep-pairwise 50 10 0.1 \
  --out "$OUT"

# ----------------------------------------
# Prune dataset and generate PLINK BED files
# ----------------------------------------
plink2 \
  --vcf "$VCF" \
  --double-id \
  --allow-extra-chr \
  --set-missing-var-ids @:# \
  --extract "$OUT.prune.in" \
  --make-bed \
  --out "$OUT"

# ----------------------------------------
# Fix chromosome codes for ADMIXTURE
# ADMIXTURE requires numeric chromosome IDs
# ----------------------------------------
awk '{$1=0; print $0}' "$OUT.bim" > "$OUT.bim.tmp"
mv "$OUT.bim.tmp" "$OUT.bim"
