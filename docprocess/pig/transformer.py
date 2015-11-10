#!/usr/bin/python

import sys
import re
from itertools import combinations

def reducer(s):
    s = re.sub(r"{\(", "", s)
    s = re.sub(r"\)}", "", s)
    s = re.sub(r"(?i)NULL", "", s)
    s = re.sub(r"\),\(", ",", s)
    A = s.split(',')
    B = sorted(set(A))
    return B

for line in sys.stdin:
    row = line.strip('\n').split('\t')
    row = [ str(e) for e in row ]
    sid = row[0]
    B   = reducer(row[1])
    C = list(combinations(B,2))
    for e in C:
        L = [ e[0], e[1], sid ]
        print '\t'.join(L)
