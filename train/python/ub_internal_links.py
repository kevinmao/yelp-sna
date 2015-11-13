# -*- coding: utf-8 -*-

import argparse

HEADER_UB = ['# user_id', 'business_id', 'true_rating']
def load_ub_test_graph(inputFile):
    ub_test_edge_set = set()
    ub_test_edge_weight_dict = {}
    with open(inputFile) as fin:
        for line in fin:
            if line.find('# user_id') >= 0: continue
            row = line.strip('\n').split('\t')
            user_id = int(row[0])
            business_id = int(row[1])
            stars = int(row[2])
            e = (user_id, business_id)
            ub_test_edge_set.add(e)
            ub_test_edge_weight_dict[e] = stars
    return ub_test_edge_set, ub_test_edge_weight_dict     

def load_ub_internal_link_candidates(inputFile):
    ub_il_cand_edge_set = set()
    with open(inputFile) as fin:
        for line in fin:
            if line.find('# user_id') >= 0: continue
            row = line.strip('\n').split('\t')
            user_id = int(row[0])
            business_id = int(row[1])
            e = (user_id, business_id)
            ub_il_cand_edge_set.add(e)
    return ub_il_cand_edge_set        
    
def create_ub_internal_links(ub_test_edge_set,
                             ub_test_edge_weight_dict,
                             ub_il_cand_edge_set,
                             outputFile):
    
    with open(outputFile, 'w') as fout:
        fout.write('\t'.join(HEADER_UB))
        fout.write('\n')
        for e in ub_il_cand_edge_set:
            if e not in ub_test_edge_set: continue
            L = list(e)
            L.append(ub_test_edge_weight_dict[e])
            L = [ str(a) for a in L ]
            fout.write('\t'.join(L) + '\n')


    
def main(args):
    ub_review_test_edges_file = args.ub_review_test_edges
    ub_internal_link_candidates_file = args.ub_internal_link_candidates
    ub_internal_links_file = args.ub_internal_links
    
    ub_test_edge_set, ub_test_edge_weight_dict = load_ub_test_graph(ub_review_test_edges_file)
    ub_il_cand_edge_set = load_ub_internal_link_candidates(ub_internal_link_candidates_file)
    create_ub_internal_links(ub_test_edge_set,
                                 ub_test_edge_weight_dict,
                                 ub_il_cand_edge_set,
                                 ub_internal_links_file)  
    
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process yelp tip data')
    parser.add_argument('--ub_review_test_edges', metavar='FILE', required = True, 
                        help='ub_review_test_edges file in tsv format')
    parser.add_argument('--ub_internal_link_candidates', metavar='FILE', required = True, 
                        help='ub_internal_link_candidates file in tsv format')
    parser.add_argument('--ub_internal_links', metavar='FILE', required = True, 
                        help='ub_internal_links file in tsv format')
    args = parser.parse_args()
    main(args)
