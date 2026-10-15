#!/bin/bash
# Two-phase search for a two-block circulant book Ramsey graph on Z_{2n-1} x {0,1}.
# usage: drive.sh n job minutes_total minutes_per_A workers
# For each new within-block set A: either SEL=lp, phaseA (Fourier softmin) -> alp.py (LP margin),
# or SEL=ils (default), `workers` parallel runs of phaseH (iterated local search on the slack-volume
# score) for HSEC seconds, keeping the best; then `workers` parallel runs of bsa (cross set B)
# for minutes_per_A minutes; with BALG=bwls the cross set is searched by bwls (weighted local search)
# instead of bsa.
# Environment: SEL, HSEC, HR, HTOL, ASTEPS, ALPSTEPS, BALG, BSTEPS, T0, T1, MU, PF, BWK, BWTEN, BWRHO, BWRS.
set -u
cd "$(dirname "$0")"
n=$1; job=$2; total=$3; perA=$4; W=$5
end=$(( $(date +%s) + total*60 )); k=0
mkdir -p out
while [ $(( end - $(date +%s) )) -gt 300 ]; do
  seed=$(( job*1000 + k )); k=$((k+1))
  if [ "${SEL:-ils}" = lp ]; then
    ./phaseA $n $seed ${ASTEPS:-3000000} 2.0 0.5 0.01 1 out/A > /dev/null
    python3 alp.py $n $seed ${ALPSTEPS:-20000} out/A_${n}_${seed}_0.txt out/LA_${n}_${seed}.txt > /dev/null
    g=""
  else
    for w in $(seq 1 $W); do
      ./phaseH $n $(( seed*10 + w )) ${HSEC:-300} ${HR:-4} ${HTOL:-1.0} out/H_${n}_${seed}_${w}.txt > out/H_${n}_${seed}_${w}.log &
    done
    wait
    best=$(sort -k3 -g -r out/H_${n}_${seed}_*.log | head -1)
    cp "$(echo "$best" | awk '{print $1}')" out/LA_${n}_${seed}.txt
    g=" G $(echo "$best" | awk '{print $3}')"
  fi
  m=$(python3 mkcap.py $n out/LA_${n}_${seed}.txt out/LS_${n}_${seed}.txt)
  left=$(( end - $(date +%s) )); t=$(( perA*60 < left ? perA*60 : left ))
  echo "$(date -u +%H:%M) n $n A seed $seed$g LP margin $m; B search ${t}s on $W workers"
  for w in $(seq 1 $W); do
    if [ "${BALG:-bsa}" = bwls ]; then
      ( cd out && timeout $(( t + 60 )) ../bwls $n $(( seed*10 + w )) LA_${n}_${seed}.txt $t \
          ${BWK:-8} ${BWTEN:-5} ${BWRHO:-0.2} ${BWRS:-100000} > log_${n}_${seed}_${w}.txt ) &
    else
      ( cd out && timeout $t ../bsa $n $(( seed*10 + w )) LA_${n}_${seed}.txt LS_${n}_${seed}.txt \
          ${BSTEPS:-10000000} 1000000 ${T0:-1.0} ${T1:-0.05} ${MU:-0} ${PF:-0.3} > log_${n}_${seed}_${w}.txt ) &
    fi
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
