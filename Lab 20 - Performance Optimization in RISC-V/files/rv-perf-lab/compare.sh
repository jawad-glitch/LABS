#!/bin/bash
ROOT=$(cd "$(dirname "$0")" && pwd)
cd "$ROOT" || exit 1

FILES=(
 profiles/dot_product_baseline.txt
 profiles/dot_product_optimized.txt
 profiles/row_sum_baseline.txt
 profiles/row_sum_optimized.txt
)
for f in "${FILES[@]}"; do
    if [ ! -s "$f" ]; then
        echo "ERROR: Missing or empty profile: $f" >&2
        exit 1
    fi
done

get_value() {
    awk -F': ' -v key="$2" '$1==key {print $2; exit}' "$1"
}
get_mnemonic() {
    awk -v key="$2" '$1==key {print $2; exit}' "$1"
}
get_pair() {
    awk -v b="$1" -v o="$2" 'BEGIN {printf "%.0f", o-b}'
}
make_table() {
    local title="$1" base="$2" opt="$3"
    local bs os bc oc bl ol bm om ba oa bt ot delta
    bs=$(get_value "$base" "Size bytes")
    os=$(get_value "$opt" "Size bytes")
    bc=$(get_value "$base" "Static instructions")
    oc=$(get_value "$opt" "Static instructions")
    bl=$(get_mnemonic "$base" "lw"); ol=$(get_mnemonic "$opt" "lw")
    bm=$(get_mnemonic "$base" "mul"); om=$(get_mnemonic "$opt" "mul")
    ba=$(get_mnemonic "$base" "add"); oa=$(get_mnemonic "$opt" "add")
    bai=$(get_mnemonic "$base" "addi"); oai=$(get_mnemonic "$opt" "addi")
    ba=${ba:-0}; oa=${oa:-0}; bai=${bai:-0}; oai=${oai:-0}
    ba=$((ba+bai)); oa=$((oa+oai))
    bt=$(get_value "$base" "Wall-clock seconds")
    ot=$(get_value "$opt" "Wall-clock seconds")

    printf '\n%s\n' "$title"
    printf '%-34s | %12s | %12s | %12s\n' "Metric" "Baseline" "Optimized" "Delta"
    printf '%s\n' "--------------------------------------------------------------------------------"
    printf '%-34s | %12s | %12s | %12s\n' "Binary size (bytes)" "$bs" "$os" "$(get_pair "$bs" "$os")"
    printf '%-34s | %12s | %12s | %12s\n' "Static instruction count" "$bc" "$oc" "$(get_pair "$bc" "$oc")"
    printf '%-34s | %12s | %12s | %12s\n' "lw instruction count" "${bl:-0}" "${ol:-0}" "$(get_pair "${bl:-0}" "${ol:-0}")"
    printf '%-34s | %12s | %12s | %12s\n' "mul instruction count" "${bm:-0}" "${om:-0}" "$(get_pair "${bm:-0}" "${om:-0}")"
    printf '%-34s | %12s | %12s | %12s\n' "add/addi instruction count" "$ba" "$oa" "$(get_pair "$ba" "$oa")"

    delta=$(awk -v b="$bt" -v o="$ot" 'BEGIN {
        if(b>0) printf "%.2f%% reduction", (b-o)*100/b
        else print "N/A"
    }')
    printf '%-34s | %12s | %12s | %12s\n' "Emulated wall-clock time (sec)" "$bt" "$ot" "$delta"
}

OUT=$(mktemp)
{
    make_table "DOT PRODUCT COMPARISON" \
        profiles/dot_product_baseline.txt profiles/dot_product_optimized.txt
    make_table "ROW SUM COMPARISON" \
        profiles/row_sum_baseline.txt profiles/row_sum_optimized.txt
    echo
    echo "Note: instruction frequencies are static disassembly counts, not dynamic execution counts."
    echo "QEMU wall-clock measurements are host-dependent and may be below timer resolution."
} > "$OUT"

mkdir -p results
cp "$OUT" results/comparison.txt
cat "$OUT"
rm -f "$OUT"
