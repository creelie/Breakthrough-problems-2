"""Expand plan.json into the job matrix of .github/workflows/search-two-phase.yml."""
import json, os
here = os.path.dirname(os.path.abspath(__file__))
plan = json.load(open(os.path.join(here, 'plan.json')))
include, job = [], plan.get('first_job', 1)
for r in plan['runs']:
    for _ in range(r['jobs']):
        include.append({'n': r['n'], 'job': job, 'minutes': r['minutes'], 'perA': r['perA'],
                        'bsteps': r['bsteps'], 'alpsteps': r.get('alpsteps', 20000),
                        't0': r.get('t0', 1.0), 't1': r.get('t1', 0.05), 'mu': r.get('mu', 0),
                        'pf': r.get('pf', 0.3), 'sel': r.get('sel', 'ils'),
                        'hsec': r.get('hsec', 120), 'balg': r.get('balg', 'bsa'),
                        'bwk': r.get('bwk', 8), 'bwten': r.get('bwten', 5),
                        'bwrho': r.get('bwrho', 0.2), 'bwrs': r.get('bwrs', 100000)})
        job += 1
print('matrix=' + json.dumps({'include': include}))
