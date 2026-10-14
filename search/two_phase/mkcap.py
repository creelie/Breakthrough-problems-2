"""Write the LP slack target for an A file: python3 mkcap.py n Afile Sfile -> prints margin"""
import sys
from lpscore import margin
n = int(sys.argv[1]); A = {int(x) for x in open(sys.argv[2]).read().split()}
t, s = margin(n, A)
open(sys.argv[3], 'w').write(' '.join('%.6f' % x for x in s) + '\n'); print('%.3f' % t)
