#!/usr/bin/env bash
# Runs N runs of a cargo command on a control and custom toolchain to compare
# incremental build times

## @User please configure these for your project ##

CONTROL_TOOLCHAIN="stable"
CUSTOM_TOOLCHAIN="kapstable"

CONTROL_TARGETDIR="target-stable"
CUSTOM_TARGETDIR="target-kap"

# The files that will be 'touch'ed to simulate a code change
FILES_TO_TOUCH=(
    "substrate/primitives/weights/src/lib.rs"
)
# Number of iterations/runs to perform
N=10

ENV="SKIP_WASM_BUILD=1"
export $ENV


## Can remain unchanged ##

CARGO="cargo"
CMD="check"
CONTROL_CARGO_CMD="$CARGO "+$CONTROL_TOOLCHAIN" $CMD --target-dir $CONTROL_TARGETDIR --timings"
CUSTOM_CARGO_CMD="$CARGO "+$CUSTOM_TOOLCHAIN" $CMD --target-dir $CUSTOM_TARGETDIR --timings"

TIMESTAMP=$(date +"%Y-%m-%d_%H:%M:%S")
OUTDIR="benchmark_out.${TIMESTAMP}"
mkdir "$OUTDIR"
mkdir "$OUTDIR/$CUSTOM_TOOLCHAIN"
mkdir "$OUTDIR/$CONTROL_TOOLCHAIN"

# Perform a full build
echo "Performing full build of $CONTROL_TOOLCHAIN..."
$CONTROL_CARGO_CMD &> "$OUTDIR/$CONTROL_TOOLCHAIN/full_build.out"
echo "Performing full build of $CUSTOM_TOOLCHAIN..."
$CUSTOM_CARGO_CMD &> "$OUTDIR/$CUSTOM_TOOLCHAIN/full_build.out"

t2s() {
   sed 's/d/*24*3600 +/g; s/h/*3600 +/g; s/m/*60 +/g; s/s/\+/g; s/+[ ]*$//g' <<< "$1" | bc
}

total_control_secs=0
total_custom_secs=0
# Repeat N times:
for i in $(seq 1 $N); do
    echo "Iteration $i of $N:"

    # 1. Make a small code change
    for file in ${FILES_TO_TOUCH[@]}; do
        touch $file
    done
    
    # 2. Perform an incremental build
    # 2a. ... on the control toolchain
    cargo_outfile="$OUTDIR/$CONTROL_TOOLCHAIN/run_$i.out"
    $CONTROL_CARGO_CMD &> $cargo_outfile
    time_str=$(tail -n1 "$cargo_outfile" | sed 's/.* in //')
    runtime_control_secs=$(t2s "$time_str")
    total_control_secs=$(bc -l <<< "scale=2; $total_control_secs + $runtime_control_secs")
    avg_control_secs=$(bc -l <<< "scale=2; $total_control_secs/$i")
    echo "$CONTROL_TOOLCHAIN incremental runtime:"
    echo "  Running average: $avg_control_secs s"
    echo "  Most recent: $runtime_control_secs s"

    # 2b. ... on the custom toolchain
    cargo_outfile="$OUTDIR/$CUSTOM_TOOLCHAIN/run_$i.out"
    $CUSTOM_CARGO_CMD &> $cargo_outfile
    time_str=$(tail -n1 "$cargo_outfile" | sed 's/.* in //')
    runtime_custom_secs=$(t2s "$time_str")
    total_custom_secs=$(bc -l <<< "scale=2; $total_custom_secs + $runtime_custom_secs")
    avg_custom_secs=$(bc -l <<< "scale=2; $total_custom_secs/$i")
    echo "$CUSTOM_TOOLCHAIN incremental runtime:"
    echo "  Running average: $avg_custom_secs s"
    echo "  Most recent: $runtime_custom_secs s"
    echo ""
done

# Report results
echo "$CONTROL_TOOLCHAIN avg incremental runtime: $avg_control_secs s"
echo "$CUSTOM_TOOLCHAIN avg incremental runtime: $avg_custom_secs s"

