# -*- coding: utf-8 -*-

import argparse
from collections import defaultdict

def load_ub_graph(inputFile):
    print "load_ub_graph"
    user_set = set()
    business_set = set()
    ub_edge_set = set()
    ub_neighbor_dict = defaultdict(list)
    with open(inputFile) as fin:
        for line in fin:
            if line.find('# user_id') >= 0: continue
            line_contents = line.strip('\n').split('\t')
            user_id = int(line_contents[0])
            business_id = int(line_contents[1])
            e = (user_id, business_id)
            user_set.add(user_id)
            business_set.add(business_id)
            ub_edge_set.add(e)
            ub_neighbor_dict[business_id].append(user_id)
    return user_set,business_set,ub_edge_set,ub_neighbor_dict      

def load_uu_graph(inputFile):
    print "load_uu_graph"
    uu_edge_set = set()
    with open(inputFile) as fin:
        for line in fin:
            if line.find('# user1_id') >= 0: continue
            line_contents = line.strip('\n').split('\t')
            user1_id = int(line_contents[0])
            user2_id = int(line_contents[1])
            e1 = (user1_id, user2_id) 
            e2 = (user2_id, user1_id)
            uu_edge_set.add(e1)
            uu_edge_set.add(e2)
    return uu_edge_set        
    
def create_internal_link_candidates(user_set,
                                    business_set,
                                    ub_edge_set,
                                    ub_neighbor_dict,
                                    uu_edge_set):
    print "create_internal_link_candidates"
    print "user_set = ", len(user_set)
    print "business_set = ", len(business_set)
    print "ub_edge_set = ", len(ub_edge_set)
    print "ub_neighbor_dict = ", len(ub_neighbor_dict)
    print "uu_edge_set = ", len(uu_edge_set)
    S = set()
    for u in user_set:
        for b in business_set:
            g = (u,b)
            if g in ub_edge_set: continue
            internal = True
            for v in ub_neighbor_dict[b]:
                if u == v: continue
                if not (u, v) in uu_edge_set:
                    internal = False
                    break
            if internal == True:
                S.add(g)
    print "S = ", len(S)
    return S            

def main(args):
    ub_review_train_edges_file = args.ub_review_train_edges
    uu_review_train_edges_file = args.uu_review_train_edges
    internal_link_candidates_file = args.internal_link_candidates
    
    user_set,business_set,ub_edge_set,ub_neighbor_dict = load_ub_graph(ub_review_train_edges_file)
    uu_edge_set = load_uu_graph(uu_review_train_edges_file)
    
    S = create_internal_link_candidates(user_set,
                                    business_set,
                                    ub_edge_set,
                                    ub_neighbor_dict,
                                    uu_edge_set)
    with open(internal_link_candidates_file, 'w') as fout:
        for e in S:
            L = list(e)
            L = [ str(a) for a in L ]
            fout.write('\t'.join(L) + '\n')

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process yelp tip data')
    parser.add_argument('--ub_review_train_edges', metavar='FILE', required = True, 
                        help='ub_review_train_edges file in tsv format')
    parser.add_argument('--uu_review_train_edges', metavar='FILE', required = True, 
                        help='uu_review_train_edges file in tsv format')
    parser.add_argument('--internal_link_candidates', metavar='FILE', required = True, 
                        help='internal_link_candidates file in tsv format')
    args = parser.parse_args()
    main(args)
