"""open_values.py -- the values n <= 100 that no published construction covers (footnote 1 of the paper).

Covered (see PRIORITY-CHECK.md for the sources):
  Wesley:      n <= 20, and 2n-1 a prime power = 1 (mod 4)
  Turturean:   n <= 56 and 57, 61, 63, 69, 71, 75, 77, 79, 83, 85, 87, 91, 95, 97, 99
               (with the Szekeres family: 4n-1 a prime = 3 (mod 8))
  Chung-Du-Wesley: n-1 a prime power = 1 (mod 4), n = 46, n = 66 (conference graphs);
               2n-1 a prime power = 3 (mod 8) (doubled Legendre pairs);
               n = (q^2-q+2)/4 for prime powers q = 3 (mod 4), q >= 7 (Yamada-Pott designs)
  Price:       n = 70
  Chung-Du-Wesley, Station data v2 (24 August 2026): the finite certificate for n = 67
The script prints the remaining values and checks them against the footnote of preprint/main.tex.
"""
import os
import re

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


def prime_power(q):
    if q < 2:
        return False
    p = next(d for d in range(2, q + 1) if q % d == 0)
    while q % p == 0:
        q //= p
    return q == 1


def prime(q):
    return q > 1 and all(q % d for d in range(2, int(q ** 0.5) + 1))


covered = set(range(1, 57)) | {57, 61, 63, 69, 71, 75, 77, 79, 83, 85, 87, 91, 95, 97, 99} | {46, 66, 67, 70}
covered |= {(q * q - q + 2) // 4 for q in range(7, 40) if prime_power(q) and q % 4 == 3}
for n in range(1, 101):
    if prime_power(2 * n - 1) and (2 * n - 1) % 4 == 1:
        covered.add(n)
    if prime_power(n - 1) and (n - 1) % 4 == 1:
        covered.add(n)
    if prime_power(2 * n - 1) and (2 * n - 1) % 8 == 3:
        covered.add(n)
    if prime(4 * n - 1) and (4 * n - 1) % 8 == 3:
        covered.add(n)
open_n = [n for n in range(1, 101) if n not in covered]
print("open, n <= 100:", ", ".join(map(str, open_n)))
tex = open(os.path.join(ROOT, "preprint", "main.tex")).read()
fn = re.search(r"none of the constructions cited here covers are (.*?)\. This list", tex, re.S).group(1)
assert [int(x) for x in re.findall(r"\d+", fn)] == open_n, "footnote 1 does not match"
assert 67 not in open_n
print("footnote 1 of the paper matches")
