# -*- coding: utf-8 -*-

import sys
from collections import defaultdict

ub_review_train_edges = sys.argv[1]
bb_review_train_edges = sys.argv[2]

# load ub-graph
bu_neighbor_dict = defaultdict(list)
with open(ub_review_train_edges) as fin:
    for line in fin:
        if line.find('# user') >= 0: continue
        row = line.strip('\n').split('\t')
        user_id = int(row[0])
        business_id = int(row[1])
        bu_neighbor_dict[user_id].append(business_id)

# load uu-graph
bb_edge_set = set()
with open(bb_review_train_edges) as fin:
    for line in fin:
        if line.find('common_reviews') >= 0: continue
        row = line.strip('\n').split('\t')
        business1_id = int(row[0])
        business2_id = int(row[1])
        e1 = (business1_id, business2_id) 
        e2 = (business2_id, business1_id)
        bb_edge_set.add(e1)
        bb_edge_set.add(e2)

# streaming
for line in sys.stdin:
    row = line.strip('\n').split('\t')
    b = int(row[0])
    u = int(row[1])
    internal = True
    for a in bu_neighbor_dict[u]:
        if b == a: continue
        if not (b, a) in bb_edge_set:
            internal = False
            break
    if internal == True:
        print '\t'.join(row)
