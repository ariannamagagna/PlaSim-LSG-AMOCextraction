#!/bin/bash

# Usage: ./amocextraction.sh <base_path> <base_name> <block_start> <block_end> <traj_number>

# Pass arguments:
BASE_PATH="$1"
BASE_NAME="$2"
BLOCK_START="$3"
BLOCK_END="$4"
N_TRAJ="$5"

BASE_DIR="${BASE_PATH}/diag"
FINAL_OUTPUT="${BASE_DIR}/amoc_ensemble_yearmean.txt"
rm -f "$FINAL_OUTPUT"

for BLOCK in $(seq -w "$BLOCK_START" "$BLOCK_END"); do
    TAR_FILE="${BASE_DIR}/${BASE_NAME}_diag_block_${BLOCK}.tar"
    BLOCK_PATH="${BASE_DIR}/block_${BLOCK}"
    YEARMEAN_FILE="${BLOCK_PATH}/amoc_yearmean_${BLOCK}.txt"

    if [[ -f "$TAR_FILE" ]]; then
        mkdir -p "$BLOCK_PATH"
        tar -xf "$TAR_FILE" -C "$BLOCK_PATH"
        echo "Extracted $TAR_FILE into $BLOCK_PATH"
    else
        echo "Missing tar: $TAR_FILE — skipping extraction"
    fi

    rm -f "$YEARMEAN_FILE"

    for TRAJ in $(seq -w 0001 "$N_TRAJ"); do
        TRAJ_FILE="${BLOCK_PATH}/${BASE_NAME}_diag.${TRAJ}.${BLOCK}"
        if [[ -f "$TRAJ_FILE" ]]; then
            grep "ATL max" "$TRAJ_FILE" | cut -c 30-37 > moc_values.txt
            awk '{ sum += $1 } END { if (NR > 0) print sum/NR }' moc_values.txt >> "$YEARMEAN_FILE"
        else
            echo "0.0" >> "$YEARMEAN_FILE"
        fi
    done

    if [[ -f "$YEARMEAN_FILE" ]]; then
        mean=$(awk '{s+=$1} END{if(NR>0) print s/NR}' "$YEARMEAN_FILE")
        echo "$mean" >> "$FINAL_OUTPUT"
    else
        echo "0.0" >> "$FINAL_OUTPUT"
    fi
done

echo "AMOC extraction complete. Final ensemble file saved to $FINAL_OUTPUT"
