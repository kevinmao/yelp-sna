# -*- coding: utf-8 -*-

import sys
from collections import defaultdict

ub_review_train_edges = sys.argv[1]
uu_review_train_edges = sys.argv[2]

# load ub-graph
ub_neighbor_dict = defaultdict(list)
with open(ub_review_train_edges) as fin:
    for line in fin:
        if line.find('# user') >= 0: continue
        row = line.strip('\n').split('\t')
        user_id = int(row[0])
        business_id = int(row[1])
        ub_neighbor_dict[business_id].append(user_id)

# load uu-graph
uu_edge_set = set()
with open(uu_review_train_edges) as fin:
    for line in fin:
        if line.find('common_reviews') >= 0: continue
        row = line.strip('\n').split('\t')
        user1_id = int(row[0])
        user2_id = int(row[1])
        e1 = (user1_id, user2_id) 
        e2 = (user2_id, user1_id)
        uu_edge_set.add(e1)
        uu_edge_set.add(e2)

# streaming
for line in sys.stdin:
    row = line.strip('\n').split('\t')
    u = int(row[0])
    b = int(row[1])
    internal = True
    for v in ub_neighbor_dict[b]:
        if u == v: continue
        if not (u, v) in uu_edge_set:
            internal = False
            break
    if internal == True:
        print '\t'.join(row)
