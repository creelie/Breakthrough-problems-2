"""LP margin of a within-block set A for the two-block shapes (Turturean's phase 1).
P_k = R(k) - s^(k) >= t, s >= 0 symmetric, sum_{d != 0} s(d) = S0 (n-4 even, n-1 odd)."""
import numpy as np
from scipy.optimize import linprog
def setup(n):
    v = 2*n-1; P = (v-1)//2
    C = np.array([[2*np.cos(2*np.pi*k*h/v) for h in range(1, P+1)] for k in range(1, P+1)])
    return v, P, C
def Ahat(v, P, A):
    a = np.zeros(v); a[list(A)] = 1
    return np.real(np.fft.fft(a))[1:P+1]
def margin(n, A, C=None):
    v, P, C0 = setup(n)
    if C is None: C = C0
    Ah = Ahat(v, P, A)
    if n % 2 == 0: R = n-2-Ah**2-3*Ah; S0 = n-4
    else: R = n-1-Ah**2-Ah; S0 = n-1
    # variables s_1..s_P, t ; maximize t
    # constraints: C s + t <= R ; sum 2 s = S0 ; s >= 0
    c = np.zeros(P+1); c[-1] = -1
    Aub = np.hstack([C, np.ones((P, 1))]); bub = R
    Aeq = np.hstack([2*np.ones((1, P)), np.zeros((1, 1))]); beq = [S0]
    res = linprog(c, A_ub=Aub, b_ub=bub, A_eq=Aeq, b_eq=beq, bounds=[(0, None)]*P+[(None, None)], method='highs')
    return res.x[-1] if res.status == 0 else None, (res.x[:P] if res.status == 0 else None)
