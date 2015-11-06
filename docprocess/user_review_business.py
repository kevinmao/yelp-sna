# -*- coding: utf-8 -*-

import argparse
import simplejson as json
import operator
from collections import defaultdict
from itertools import combinations

HEADER_UB = ['# user_id', 'business_id']
HEADER_UU = ['# user_id', 'user_id']
HEADER_BB = ['# business_id', 'business_id']

def load_user_keys(inputFile):
    user_dict = {}
    with open(inputFile) as fin:
        for line in fin:
            if line.find('# user_id') >= 0: continue
            line_contents = line.strip('\n').split('\t')
            user_id = int(line_contents[0])
            user_str_id = line_contents[1]
            user_dict[user_str_id] = user_id
    return user_dict        

def load_business_keys(inputFile):
    business_dict = {}
    with open(inputFile) as fin:
        for line in fin:
            if line.find('# business_id') >= 0: continue
            line_contents = line.strip('\n').split('\t')
            business_id = int(line_contents[0])
            business_str_id = line_contents[1]
            business_dict[business_str_id] = business_id
    return business_dict        
    
def user_business_review_edges(user_keys_file, 
                               business_keys_file, 
                               review_file, 
                               user_business_review_edges_file):
    print "user_business_review_edges"
    user_dict = load_user_keys(user_keys_file)
    business_dict = load_business_keys(business_keys_file)
    edge_set = set()

    print "user_business_review_edges:111"
    with open(review_file) as fin:
        for line in fin:
            if line.find('# user_id') >= 0: continue
            line_contents = line.strip('\n').split('\t')
            user_id = line_contents[0]
            business_id = line_contents[1]
            e = [user_dict[user_id], business_dict[business_id]]
            g = tuple(e)
            edge_set.add(g)

    print "user_business_review_edges:222", len(edge_set)
    #edge_set_sorted = sorted(edge_set, key=operator.itemgetter(0, 1))
    edge_set_sorted = edge_set
    with open(user_business_review_edges_file, 'w') as fout:
        fout.write('\t'.join(HEADER_UB))
        fout.write('\n')
        for e1, e2 in edge_set_sorted:
            fout.write('\t'.join([str(e1),str(e2)]))
            fout.write('\n')

def user_user_review_edges(user_keys_file,
                           business_keys_file,
                           review_file,
                           user_user_review_edges_file):
    print "user_user_review_edges"
    user_dict = load_user_keys(user_keys_file)
    business_dict = load_business_keys(business_keys_file)
    groupby_business = defaultdict(list)

    print "user_user_review_edges:111"
    with open(review_file) as fin:
        for line in fin:
            if line.find('# user_id') >= 0: continue
            line_contents = line.strip('\n').split('\t')
            user_id = line_contents[0]
            business_id = line_contents[1]
            groupby_business[business_id].append(user_id)

    print "user_user_review_edges:222"
    edge_set = set()
    for biz in groupby_business:
        U = list(set(groupby_business[biz]))
        if len(U) < 2: continue
        E = list(combinations(U,2))
        for e1, e2 in E:
            e = [user_dict[e1], user_dict[e2]]
            g = tuple(sorted(e))
            edge_set.add(g)

    print "user_user_review_edges:333", len(edge_set)
    #edge_set_sorted = sorted(edge_set, key=operator.itemgetter(0, 1))
    edge_set_sorted = edge_set
    with open(user_user_review_edges_file, 'w') as fout:
        fout.write('\t'.join(HEADER_UU))
        fout.write('\n')
        for e in edge_set_sorted:
            fout.write('\t'.join([str(e1),str(e2)]))
            fout.write('\n')


def business_business_review_edges(user_keys_file,
                           business_keys_file,
                           review_file,
                           business_business_review_edges_file):
    print "business_business_review_edges"
    user_dict = load_user_keys(user_keys_file)
    business_dict = load_business_keys(business_keys_file)
    groupby_user = defaultdict(list)

    print "business_business_review_edges:111"
    with open(review_file) as fin:
        for line in fin:
            if line.find('# user_id') >= 0: continue
            line_contents = line.strip('\n').split('\t')
            user_id = line_contents[0]
            business_id = line_contents[1]
            groupby_user[user_id].append(business_id)

    print "business_business_review_edges:222"
    edge_set = set()
    for usr in groupby_user:
        B = list(set(groupby_user[usr]))
        if len(B) < 2: continue
        E = list(combinations(B,2))
        for e1, e2 in E:
            e = [business_dict[e1], business_dict[e2]]
            g = tuple(sorted(e))
            edge_set.add(g)

    print "business_business_review_edges:333", len(edge_set)
    #edge_set_sorted = sorted(edge_set, key=operator.itemgetter(0, 1))
    edge_set_sorted = edge_set
    with open(business_business_review_edges_file, 'w') as fout:
        fout.write('\t'.join(HEADER_BB))
        fout.write('\n')
        for e1, e2 in edge_set_sorted:
            fout.write('\t'.join([str(e1),str(e2)]))
            fout.write('\n')

def main(args):
    user_keys_file = args.user_keys
    business_keys_file = args.business_keys
    review_file = args.review
    user_user_review_edges_file = args.user_user_review_edges
    business_business_review_edges_file = args.business_business_review_edges
    user_business_review_edges_file = args.user_business_review_edges
    
    """
    # user-user    
    user_user_review_edges(user_keys_file,
                           business_keys_file,
                           review_file,
                           user_user_review_edges_file)

    """
    # user-business    
    user_business_review_edges(user_keys_file, 
                               business_keys_file, 
                               review_file,
                               user_business_review_edges_file
                               )   

    """
    # business business    
    business_business_review_edges(user_keys_file,
                           business_keys_file,
                           review_file,
                           business_business_review_edges_file)
    """

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process yelp tip data')
    parser.add_argument('--user_keys', metavar='FILE', required = True, 
                        help='user_keys file in tsv format')
    parser.add_argument('--business_keys', metavar='FILE', required = True, 
                        help='business_keys file in tsv format')
    parser.add_argument('--review', metavar='FILE', required = True, 
                        help='review file in tsv format')
    parser.add_argument('--user_user_review_edges', metavar='FILE', required = True, 
                        help='user_user_review_edges file in tsv format')
    parser.add_argument('--user_business_review_edges', metavar='FILE', required = True, 
                        help='user_business_review_edges file in tsv format')
    parser.add_argument('--business_business_review_edges', metavar='FILE', required = True, 
                        help='business_business_review_edges file in tsv format')
    args = parser.parse_args()
    main(args)
