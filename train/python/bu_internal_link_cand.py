# -*- coding: utf-8 -*-

import argparse
from collections import defaultdict

def load_ub_graph(inputFile):
    print "load_ub_graph"
    user_set = set()
    business_set = set()
    bu_edge_set = set()
    bu_neighbor_dict = defaultdict(list)
    with open(inputFile) as fin:
        for line in fin:
            if line.find('# user_id') >= 0: continue
            row = line.strip('\n').split('\t')
            user_id = int(row[0])
            business_id = int(row[1])
            e = (business_id, user_id)
            user_set.add(user_id)
            business_set.add(business_id)
            bu_edge_set.add(e)
            bu_neighbor_dict[user_id].append(business_id)
    return user_set,business_set,bu_edge_set,bu_neighbor_dict      

def load_bb_graph(inputFile):
    print "load_bb_graph"
    bb_edge_set = set()
    with open(inputFile) as fin:
        for line in fin:
            if line.find('# user1_id') >= 0: continue
            row = line.strip('\n').split('\t')
            business1_id = int(row[0])
            business2_id = int(row[1])
            e1 = (business1_id, business2_id) 
            e2 = (business2_id, business1_id)
            bb_edge_set.add(e1)
            bb_edge_set.add(e2)
    return bb_edge_set        
    
def create_internal_link_candidates(user_set,
                                    business_set,
                                    bu_edge_set,
                                    bu_neighbor_dict,
                                    bb_edge_set):
    print "create_internal_link_candidates"
    print "user_set = ", len(user_set)
    print "business_set = ", len(business_set)
    print "bu_edge_set = ", len(bu_edge_set)
    print "bu_neighbor_dict = ", len(bu_neighbor_dict)
    print "bb_edge_set = ", len(bb_edge_set)
    S = set()
    for b in business_set:
        for u in user_set:
            g = (b, u)
            if g in bu_edge_set: continue
            internal = True
            for a in bu_neighbor_dict[u]:
                if b == a: continue
                if not (b, a) in bb_edge_set:
                    internal = False
                    break
            if internal == True:
                S.add(g)
    print "S = ", len(S)
    return S            

def main(args):
    ub_review_train_edges_file = args.ub_review_train_edges
    bb_review_train_edges_file = args.bb_review_train_edges
    internal_link_candidates_file = args.internal_link_candidates
    
    user_set,business_set,bu_edge_set,bu_neighbor_dict = load_ub_graph(ub_review_train_edges_file)
    bb_edge_set = load_bb_graph(bb_review_train_edges_file)
    
    S = create_internal_link_candidates(user_set,
                                    business_set,
                                    bu_edge_set,
                                    bu_neighbor_dict,
                                    bb_edge_set)
    with open(internal_link_candidates_file, 'w') as fout:
        for e in S:
            L = list(e)
            L = [ str(a) for a in L ]
            fout.write('\t'.join(L) + '\n')

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process yelp tip data')
    parser.add_argument('--ub_review_train_edges', metavar='FILE', required = True, 
                        help='ub_review_train_edges file in tsv format')
    parser.add_argument('--bb_review_train_edges', metavar='FILE', required = True, 
                        help='bb_review_train_edges file in tsv format')
    parser.add_argument('--internal_link_candidates', metavar='FILE', required = True, 
                        help='internal_link_candidates file in tsv format')
    args = parser.parse_args()
    main(args)
