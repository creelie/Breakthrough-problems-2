"""audit_axioms.py -- read the output of `lake env lean Check.lean` and check that each of the five
main theorems rests only on the standard axioms (no sorry, no native_decide, whose proofs would show
the axiom Lean.ofReduceBool).

Usage: python3 scripts/audit_axioms.py lean-check.txt
"""
import re
import sys

ALLOWED = {"propext", "Classical.choice", "Quot.sound"}
EXPECTED = ["no_red_book", "no_blue_book", "adj_symm", "adj_irrefl", "lower_bound"]

text = open(sys.argv[1]).read()
if "sorryAx" in text or "error" in text:
    sys.exit("audit: sorry or error in the output")
found = re.findall(r"^'(\S+)' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)", text, re.M)
bad = 0
names = []
for name, axioms in found:
    used = {a.strip() for a in axioms.split(",") if a.strip()}
    extra = used - ALLOWED
    names.append(name.split(".")[-1])
    print(f"{name}: {'standard axioms only' if not extra else 'not allowed: ' + ', '.join(sorted(extra))}"
          f" ({', '.join(sorted(used)) or 'none'})")
    bad += bool(extra)
if names != EXPECTED:
    sys.exit(f"audit: expected the theorems {EXPECTED}, found {names}")
if bad:
    sys.exit("audit: unexpected axioms")
print(f"axiom audit: {len(found)} theorems, standard axioms only")
