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
  This repository: n = 58 (preprint58/main.tex, data/n58.json)
The script prints the values that were open before n = 58 was settled and those that remain, and
checks them against footnote 1 of preprint58/main.tex and of preprint/main.tex respectively.
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
before = [n for n in range(1, 101) if n not in covered]
open_n = [n for n in before if n != 58]
print("open, n <= 100, before n = 58:", ", ".join(map(str, before)))
print("open, n <= 100, now:", ", ".join(map(str, open_n)))
assert before[0] == 58 and all(n in covered for n in range(1, 58))
tex58 = open(os.path.join(ROOT, "preprint58", "main.tex")).read()
fn = re.search(r"none of the constructions cited here covers were (.*?)\. This list", tex58, re.S).group(1)
assert [int(x) for x in re.findall(r"\d+", fn)] == before, "footnote 1 of preprint58/main.tex does not match"
print("footnote 1 of preprint58/main.tex matches")
tex = open(os.path.join(ROOT, "preprint", "main.tex")).read()
fn = re.search(r"none of the constructions cited here covers are (.*?); the value \$n=58\$ is settled", tex, re.S).group(1)
assert [int(x) for x in re.findall(r"\d+", fn)] == open_n, "footnote 1 of preprint/main.tex does not match"
assert 67 not in open_n
print("footnote 1 of preprint/main.tex matches")
