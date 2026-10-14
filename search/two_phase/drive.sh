#!/bin/bash
# Two-phase search for a two-block circulant book Ramsey graph on Z_{2n-1} x {0,1}.
# usage: drive.sh n job minutes_total minutes_per_A workers
# For each new within-block set A: phaseA (Fourier softmin) -> alp.py (LP margin) ->
# `workers` parallel runs of bsa (cross set B) for minutes_per_A minutes.
# Environment: ASTEPS, ALPSTEPS, BSTEPS, T0, T1, MU, PF.
set -u
cd "$(dirname "$0")"
n=$1; job=$2; total=$3; perA=$4; W=$5
end=$(( $(date +%s) + total*60 )); k=0
mkdir -p out
while [ $(( end - $(date +%s) )) -gt 300 ]; do
  seed=$(( job*1000 + k )); k=$((k+1))
  ./phaseA $n $seed ${ASTEPS:-3000000} 2.0 0.5 0.01 1 out/A > /dev/null
  python3 alp.py $n $seed ${ALPSTEPS:-20000} out/A_${n}_${seed}_0.txt out/LA_${n}_${seed}.txt > /dev/null
  m=$(python3 mkcap.py $n out/LA_${n}_${seed}.txt out/LS_${n}_${seed}.txt)
  left=$(( end - $(date +%s) )); t=$(( perA*60 < left ? perA*60 : left ))
  echo "$(date -u +%H:%M) n $n A seed $seed LP margin $m; B search ${t}s on $W workers"
  for w in $(seq 1 $W); do
    ( cd out && timeout $t ../bsa $n $(( seed*10 + w )) LA_${n}_${seed}.txt LS_${n}_${seed}.txt \
        ${BSTEPS:-10000000} 1000000 ${T0:-1.0} ${T1:-0.05} ${MU:-0} ${PF:-0.3} > log_${n}_${seed}_${w}.txt ) &
  done
  wait
  nres=$(cat out/log_${n}_${seed}_*.txt | grep -c '^restart' || true)
  least=$(cat out/log_${n}_${seed}_*.txt | awk '/^restart/{print $4}' | sort -n | head -1)
  hist=$(cat out/log_${n}_${seed}_*.txt | awk '/^restart/{print $4}' | sort -n | uniq -c | head -4 | awk '{printf "%s at excess %s; ", $1, $2}')
  echo "    $nres restarts, least excess ${least:-none}: $hist"
  if ls out/bsol_${n}_*.txt > /dev/null 2>&1; then
    echo "SOLUTION FOUND"
    for f in out/bsol_${n}_*.txt; do python3 check.py $f; cat $f; done
    exit 0
  fi
done
echo "no solution in this job"
