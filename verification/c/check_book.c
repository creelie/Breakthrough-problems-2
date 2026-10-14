/* check_book.c -- independent check of the lower bound R(B_66, B_67) > 266.
 *
 * Reads n, v and the sets A, B from data/n67.json (a minimal reader for that file), builds the
 * adjacency matrix of the two-block circulant graph Gamma(A, B) on Z_v x {0,1}:
 *     (x,0)~(y,0) iff y-x in A,   (x,1)~(y,1) iff y-x in C = Z_v \ (A u {0}),   (x,0)~(y,1) iff y-x in B,
 * and checks by direct counting over all pairs of vertices that the graph is simple and
 * (2n-2)-regular, that every edge lies in at most n-2 triangles (no book B_{n-1}), and that every
 * non-adjacent pair has at most n-1 common non-neighbours (no B_n in the complement).
 * It also prints, for each d != 0, the number f(d) = N_AA(d) + N_BB(d) and the slack
 * n-1-[d in A]-f(d), summarised by value.
 *
 * Build and run:  cc -O2 -Wall -Wextra -o check_book verification/c/check_book.c
 *                 ./check_book data/n67.json
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXV 1024

static int read_file(const char *path, char **out) {
    FILE *f = fopen(path, "rb");
    if (!f) return -1;
    fseek(f, 0, SEEK_END);
    long len = ftell(f);
    fseek(f, 0, SEEK_SET);
    char *buf = malloc((size_t)len + 1);
    if (!buf || fread(buf, 1, (size_t)len, f) != (size_t)len) { fclose(f); return -1; }
    buf[len] = 0;
    fclose(f);
    *out = buf;
    return 0;
}

/* value of an integer key, e.g. "n": 67 */
static int int_key(const char *s, const char *key) {
    char pat[64];
    snprintf(pat, sizeof pat, "\"%s\":", key);
    const char *p = strstr(s, pat);
    if (!p) { fprintf(stderr, "missing key %s\n", key); exit(2); }
    return atoi(p + strlen(pat));
}

/* integers of a list key, e.g. "A": [1, 3, ...]; returns the count */
static int list_key(const char *s, const char *key, int *vals, int max) {
    char pat[64];
    snprintf(pat, sizeof pat, "\"%s\":", key);
    const char *p = strstr(s, pat);
    if (!p) { fprintf(stderr, "missing key %s\n", key); exit(2); }
    p = strchr(p, '[');
    const char *e = strchr(p, ']');
    int k = 0;
    while (p && p < e) {
        while (p < e && (*p < '0' || *p > '9')) p++;
        if (p >= e) break;
        if (k == max) { fprintf(stderr, "list %s too long\n", key); exit(2); }
        vals[k++] = (int)strtol(p, (char **)&p, 10);
    }
    return k;
}

static unsigned char G[2 * MAXV][2 * MAXV];

int main(int argc, char **argv) {
    const char *path = argc > 1 ? argv[1] : "data/n67.json";
    char *s;
    if (read_file(path, &s)) { fprintf(stderr, "cannot read %s\n", path); return 2; }
    int n = int_key(s, "n"), v = int_key(s, "v");
    static int Av[MAXV], Bv[MAXV];
    int na = list_key(s, "A", Av, MAXV), nb = list_key(s, "B", Bv, MAXV);
    if (v != 2 * n - 1 || v > MAXV) { fprintf(stderr, "bad n, v\n"); return 1; }
    if (na != n - 1 || nb != n - 1) { fprintf(stderr, "|A| = %d, |B| = %d, expected %d\n", na, nb, n - 1); return 1; }

    static unsigned char inA[MAXV], inB[MAXV], inC[MAXV];
    for (int i = 0; i < na; i++) inA[Av[i] % v] = 1;
    for (int i = 0; i < nb; i++) inB[Bv[i] % v] = 1;
    if (inA[0]) { fprintf(stderr, "0 in A\n"); return 1; }
    for (int d = 1; d < v; d++) {
        if (inA[d] != inA[v - d]) { fprintf(stderr, "A not symmetric at %d\n", d); return 1; }
        inC[d] = !inA[d];
    }

    int N = 2 * v;
    for (int p = 0; p < N; p++)
        for (int q = 0; q < N; q++) {
            int x = p % v, i = p / v, y = q % v, j = q / v, e;
            if (i == j) e = (p != q) && (i == 0 ? inA[(y - x + v) % v] : inC[(y - x + v) % v]);
            else if (i == 0) e = inB[(y - x + v) % v];
            else e = inB[(x - y + v) % v];
            G[p][q] = (unsigned char)e;
        }

    for (int p = 0; p < N; p++) {
        int deg = 0;
        if (G[p][p]) { fprintf(stderr, "loop at %d\n", p); return 1; }
        for (int q = 0; q < N; q++) {
            deg += G[p][q];
            if (G[p][q] != G[q][p]) { fprintf(stderr, "not symmetric at %d %d\n", p, q); return 1; }
        }
        if (deg != 2 * n - 2) { fprintf(stderr, "vertex %d has degree %d\n", p, deg); return 1; }
    }

    long pairs = 0, edges = 0;
    int max_cn = 0, max_cnn = 0;
    for (int p = 0; p < N; p++)
        for (int q = p + 1; q < N; q++) {
            int cn = 0, cnn = 0;
            for (int z = 0; z < N; z++) {
                if (z == p || z == q) continue;
                if (G[p][z] && G[q][z]) cn++;
                if (!G[p][z] && !G[q][z]) cnn++;
            }
            pairs++;
            if (G[p][q]) { edges++; if (cn > max_cn) max_cn = cn; }
            else if (cnn > max_cnn) max_cnn = cnn;
        }

    int slack_count[8] = {0};
    for (int d = 1; d < v; d++) {
        int f = 0;
        for (int y = 0; y < v; y++) {
            if (inA[y] && inA[(y + d) % v]) f++;
            if (inB[y] && inB[(y + d) % v]) f++;
        }
        int sl = n - 1 - inA[d] - f;
        if (sl < 0) { fprintf(stderr, "inequality (*) fails at d = %d\n", d); return 1; }
        if (sl < 8) slack_count[sl]++;
    }

    printf("n = %d, v = %d: %d vertices, %ld edges, %ld pairs, %d-regular\n", n, v, N, edges, pairs, 2 * n - 2);
    printf("max common neighbours of an edge: %d (bound %d)\n", max_cn, n - 2);
    printf("max common non-neighbours of a non-edge: %d (bound %d)\n", max_cnn, n - 1);
    printf("slack of (*) over d != 0:");
    for (int k = 0; k < 8; k++) if (slack_count[k]) printf("  %d at slack %d", slack_count[k], k);
    printf("\n");
    if (max_cn > n - 2 || max_cnn > n - 1) { printf("FAIL\n"); return 1; }
    printf("OK: no B_%d in Gamma(A,B), no B_%d in its complement, R(B_%d,B_%d) > %d\n", n - 1, n, n - 1, n, N);
    free(s);
    return 0;
}
