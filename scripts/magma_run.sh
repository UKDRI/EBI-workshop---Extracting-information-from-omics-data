#!/bin/bash

WORK_DIR="~/2024-03-29_ebi_workshop/data/magma"
cd $WORK_DIR
export WORK_DIR

# Populate Set_Annot_Files array with files matching '*.magma.txt'
Set_Annot_Files=(${WORK_DIR}/*.magma.txt)
# Populate Gene_Results_Files array with files matching '*.genes.raw'
Gene_Results_Files=(${WORK_DIR}/*.genes.raw)

# Function to run magma with given files and output prefix
run_magma() {
    local Set_Annot_File=$1
    local Gene_Results_File=$2
    local annot_name=$(basename "${Set_Annot_File}" .magma.txt)
    local gene_name=$(basename "${Gene_Results_File}" .genes.raw)
    local Output_Prefix="./results/${annot_name}_${gene_name}"

    # Run magma command
    magma \
        --gene-results $Gene_Results_File \
        --set-annot $Set_Annot_File \
        --out $Output_Prefix
}

# Export the function so it can be used by parallel
export -f run_magma

# Use parallel to run the combinations
parallel run_magma ::: "${Set_Annot_Files[@]}" ::: "${Gene_Results_Files[@]}"
