#!/bin/bash

# ADMIXTURE
source package /path/to/software/admixture-1.3.0

# Parameters
OUT=dataset.filtered
BED=dataset.filtered.bed
THREADS=16
REPS=20

# Run ADMIXTURE for K = 1 to 10, with 20 replicates each
for K in {1..10}; do
  for replicate in $(seq 1 "$REPS"); do
    admixture -s time --cv=10 "$BED" "$K" -j"$THREADS" \
      | tee "log_K${K}_rep${replicate}.out"

    mv "${OUT}.${K}.Q" "${OUT}.K${K}_rep${replicate}.Q"
    mv "${OUT}.${K}.P" "${OUT}.K${K}_rep${replicate}.P"
  done
done
