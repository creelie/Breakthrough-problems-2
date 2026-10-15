"""gen_figures.py -- write the TikZ sources of the figures of the two papers.

For each paper (preprint/: n = 67, v = 133 = 7 x 19; preprint58/: n = 58, v = 115 = 5 x 23):
  figures/torus.tex   Z_v = Z_P x Z_Q drawn on a shaded torus, twice: the set A (left) and the
                      set B (right) of data/nN.json.
  figures/slack.tex   the slack bound(d) - f(d) of the inequality (*) for every nonzero d, on the
                      P x Q grid of residues (d mod P, d mod Q); bound(d) = n - 1 - [d in A] for odd n
                      and n + 1 - 3[d in A] for even n.

Usage: python3 scripts/gen_figures.py   (run from the repository root)
"""
import json
import math
import os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PAPERS = [("n67.json", "preprint", 7, 19), ("n58.json", "preprint58", 5, 23)]

HEAD = r"""\documentclass[tikz,border=4pt]{standalone}
\usepackage[T1]{fontenc}
\usepackage{lmodern}
\usepackage{amsmath,amssymb}
\begin{document}
"""


def rgb(c):
    return "{rgb,1:red,%.3f;green,%.3f;blue,%.3f}" % c


# ---------------------------------------------------------------- torus
R0, R1 = 3.0, 1.15          # major and minor radius
TILT = 1.05                 # rotation about the x-axis (radians)
LIGHT = (-0.35, 0.55, 0.76)  # light direction in view coordinates
ln = math.sqrt(sum(t * t for t in LIGHT))
LIGHT = tuple(t / ln for t in LIGHT)


def world(theta, phi, r=R1):
    rr = R0 + r * math.cos(theta)
    return (rr * math.cos(phi), rr * math.sin(phi), r * math.sin(theta))


def view(p):
    x, y, z = p
    c, s = math.cos(TILT), math.sin(TILT)
    return (x, y * c - z * s, y * s + z * c)   # (screen x, screen y, depth towards viewer)


def normal(theta, phi):
    return view((math.cos(theta) * math.cos(phi), math.cos(theta) * math.sin(phi), math.sin(theta)))


def torus_items(dx, colour_of, base):
    """Quads of the shaded surface and the 133 marked points, as (depth, tikz) pairs."""
    items = []
    NT, NP = 40, 96
    for i in range(NT):
        for j in range(NP):
            t0, t1 = 2 * math.pi * i / NT, 2 * math.pi * (i + 1) / NT
            p0, p1 = 2 * math.pi * j / NP, 2 * math.pi * (j + 1) / NP
            nrm = normal((t0 + t1) / 2, (p0 + p1) / 2)
            if nrm[2] < -0.02:
                continue
            corners = [view(world(a, b)) for a, b in ((t0, p0), (t1, p0), (t1, p1), (t0, p1))]
            depth = sum(c[2] for c in corners) / 4
            lam = max(0.0, sum(a * b for a, b in zip(nrm, LIGHT)))
            spec = lam ** 24
            shade = 0.38 + 0.62 * lam
            col = tuple(min(1.0, base[k] * shade + 0.35 * spec) for k in range(3))
            path = " -- ".join("(%.3f,%.3f)" % (c[0] + dx, c[1]) for c in corners)
            items.append((depth, "\\fill[color=%s,draw=%s,line width=0.05pt] %s -- cycle;"
                          % (rgb(col), rgb(col), path)))
    for x in range(v):
        theta = 2 * math.pi * (x % P) / P
        phi = 2 * math.pi * (x % Q) / Q
        nrm = normal(theta, phi)
        if nrm[2] < 0.05:
            continue
        p = view(world(theta, phi, R1 + 0.09))
        col, rad = colour_of(x)
        items.append((p[2] + 0.25, "\\shade[ball color=%s] (%.3f,%.3f) circle (%.3f);"
                      % (col, p[0] + dx, p[1], rad)))
    return items


def colour_A(x):
    if x == 0:
        return "black", 0.13
    return ("blue!70!cyan", 0.12) if x in A else ("orange!90!red", 0.12)


def colour_B(x):
    return ("green!55!black", 0.12) if x in B else ("gray!45", 0.085)


def bound(d):
    return n + 1 - 3 * (d in A) if n % 2 == 0 else n - 1 - (d in A)


def write_torus():
    items = torus_items(0.0, colour_A, (0.80, 0.84, 0.92))
    items += torus_items(8.6, colour_B, (0.86, 0.86, 0.82))
    items.sort(key=lambda t: t[0])
    body = [r"\begin{tikzpicture}[line join=round]"]
    body += [s for _, s in items]
    # captions under each torus
    body.append(r"\node[font=\small] at (0,-3.55) {$A$ (blue) and $C=\mathbb{Z}_{%d}\setminus(A\cup\{0\})$ (orange)};" % v)
    body.append(r"\node[font=\small] at (8.6,-3.55) {$B$ (green) and its complement (gray)};")
    body.append(r"\node[font=\footnotesize,gray!40!black] at (4.3,2.95) {position of $x$: angle $2\pi x/%d$ around the tube, angle $2\pi x/%d$ around the axis};" % (P, Q))
    body.append(r"\end{tikzpicture}")
    with open(os.path.join(FIG, "torus.tex"), "w") as f:
        f.write(HEAD + "\n".join(body) + "\n\\end{document}\n")


# ---------------------------------------------------------------- slack grid
def N(X, Y, d):
    return len(X & {(y + d) % v for y in Y})


def write_slack():
    cell = 0.52
    cols = {0: (0.93, 0.95, 0.98), 1: (0.62, 0.76, 0.92), 2: (0.20, 0.42, 0.72)}
    body = [r"\begin{tikzpicture}[font=\footnotesize]"]
    for d in range(v):
        i, j = d % P, d % Q
        x0, y0 = j * cell, (P - 1 - i) * cell
        if d == 0:
            body.append("\\fill[black!80] (%.3f,%.3f) rectangle +(%.3f,%.3f);" % (x0, y0, cell, cell))
            continue
        f = N(A, A, d) + N(B, B, d)
        s = bound(d) - f
        assert s >= 0
        body.append("\\fill[color=%s] (%.3f,%.3f) rectangle +(%.3f,%.3f);" % (rgb(cols[s]), x0, y0, cell, cell))
        if d in A:
            body.append("\\fill[color=%s] (%.3f,%.3f) circle (0.075);"
                        % ("white" if s == 2 else "black!75", x0 + cell / 2, y0 + cell / 2))
    for j in range(Q + 1):
        body.append("\\draw[white,line width=0.6pt] (%.3f,0) -- (%.3f,%.3f);" % (j * cell, j * cell, P * cell))
    for i in range(P + 1):
        body.append("\\draw[white,line width=0.6pt] (0,%.3f) -- (%.3f,%.3f);" % (i * cell, Q * cell, i * cell))
    for j in range(Q):
        body.append("\\node[gray!30!black] at (%.3f,%.3f) {%d};" % (j * cell + cell / 2, P * cell + 0.22, j))
    for i in range(P):
        body.append("\\node[gray!30!black] at (-0.25,%.3f) {%d};" % ((P - 1 - i) * cell + cell / 2, i))
    body.append("\\node[gray!30!black] at (%.3f,%.3f) {$d \\bmod %d$};" % (Q * cell / 2, P * cell + 0.6, Q))
    body.append("\\node[gray!30!black,rotate=90] at (-0.75,%.3f) {$d \\bmod %d$};" % (P * cell / 2, P))
    lx = Q * cell + 0.6
    top = max(P * cell, 3.0)
    for s in (0, 1, 2):
        y = top - 0.75 - 0.6 * s
        body.append("\\fill[color=%s] (%.3f,%.3f) rectangle +(0.4,0.4);" % (rgb(cols[s]), lx, y))
        body.append("\\node[anchor=west] at (%.3f,%.3f) {slack %d};" % (lx + 0.5, y + 0.2, s))
    y = top - 0.75 - 1.8
    body.append("\\fill[black!75] (%.3f,%.3f) circle (0.075);" % (lx + 0.2, y + 0.2))
    body.append("\\node[anchor=west] at (%.3f,%.3f) {$d\\in A$};" % (lx + 0.5, y + 0.2))
    body.append(r"\end{tikzpicture}")
    with open(os.path.join(FIG, "slack.tex"), "w") as f:
        f.write(HEAD + "\n".join(body) + "\n\\end{document}\n")


if __name__ == "__main__":
    for data, paper, P, Q in PAPERS:
        DATA = json.load(open(os.path.join(ROOT, "data", data)))
        n, v = DATA["n"], DATA["v"]
        A, B = set(DATA["A"]), set(DATA["B"])
        assert P * Q == v
        FIG = os.path.join(ROOT, paper, "figures")
        os.makedirs(FIG, exist_ok=True)
        write_torus()
        write_slack()
        print(f"wrote {paper}/figures/torus.tex and {paper}/figures/slack.tex")
