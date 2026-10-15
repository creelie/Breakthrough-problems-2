"""audit_axioms.py -- read the output of `lake env lean Check.lean` and check that the five main
theorems for n = 67 and the five for n = 58, with the upper bounds and the values
R(B_{n-1}, B_n) = 4n - 1 for both, rest only on the standard axioms (no sorry, no native_decide,
whose proofs would show the axiom Lean.ofReduceBool).

Usage: python3 scripts/audit_axioms.py lean-check.txt
"""
import re
import sys

ALLOWED = {"propext", "Classical.choice", "Quot.sound"}
EXPECTED = [f"BookRamsey.{m}.{t}" for m in ("N67", "N58")
            for t in ("no_red_book", "no_blue_book", "adj_symm", "adj_irrefl", "lower_bound")]
EXPECTED += [f"BookRamsey.{t}{n}" for n in (67, 58) for t in ("upper", "lower", "book_ramsey_")]

text = open(sys.argv[1]).read()
if "sorryAx" in text or "error" in text:
    sys.exit("audit: sorry or error in the output")
found = re.findall(r"^'(\S+)' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)", text, re.M)
bad = 0
names = []
for name, axioms in found:
    used = {a.strip() for a in axioms.split(",") if a.strip()}
    extra = used - ALLOWED
    names.append(name)
    print(f"{name}: {'standard axioms only' if not extra else 'not allowed: ' + ', '.join(sorted(extra))}"
          f" ({', '.join(sorted(used)) or 'none'})")
    bad += bool(extra)
if names != EXPECTED:
    sys.exit(f"audit: expected the theorems {EXPECTED}, found {names}")
if bad:
    sys.exit("audit: unexpected axioms")
print(f"axiom audit: {len(found)} theorems, standard axioms only")
