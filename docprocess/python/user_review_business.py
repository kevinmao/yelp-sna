# -*- coding: utf-8 -*-

import argparse
from collections import defaultdict
from itertools import combinations
import operator

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
    
def user_business_review_edges(user_dict,
                               business_dict,
                               review_file, 
                               user_business_review_edges_file):
    edge_set = set()
    with open(review_file) as fin:
        for line in fin:
            if line.find('# user_id') >= 0: continue
            line_contents = line.strip('\n').split('\t')
            user_id = line_contents[0]
            business_id = line_contents[1]
            if user_id not in user_dict: continue
            if business_id not in business_dict: continue
            e = [user_dict[user_id], business_dict[business_id]]
            g = tuple(e)
            edge_set.add(g)

    edge_set_sorted = sorted(edge_set, key=operator.itemgetter(0, 1))
    with open(user_business_review_edges_file, 'w') as fout:
        fout.write('\t'.join(HEADER_UB))
        fout.write('\n')
        for e1, e2 in edge_set_sorted:
            fout.write('\t'.join([str(e1),str(e2)]))
            fout.write('\n')

def user_user_review_edges(user_dict,
                           business_dict,
                           review_file,
                           user_user_review_edges_file):
    groupby_business = defaultdict(list)
    with open(review_file) as fin:
        for line in fin:
            if line.find('# user_id') >= 0: continue
            line_contents = line.strip('\n').split('\t')
            user_id = line_contents[0]
            business_id = line_contents[1]
            if user_id not in user_dict: continue
            if business_id not in business_dict: continue
            uid = user_dict[user_id]
            bid = business_dict[business_id]
            groupby_business[bid].append(uid)

    edge_set = set()
    for bid in groupby_business.keys():
        L = list(set(groupby_business[bid]))
        if len(L) < 2: continue
        E = list(combinations(L,2))
        for e in E:
            edge_set.add(e)

    edge_set_sorted = sorted(edge_set, key=operator.itemgetter(0, 1))
    with open(user_user_review_edges_file, 'w') as fout:
        fout.write('\t'.join(HEADER_UU))
        fout.write('\n')
        for e1, e2 in edge_set_sorted:
            fout.write('\t'.join([str(e1),str(e2)]))
            fout.write('\n')


def business_business_review_edges(user_dict,
                                   business_dict,
                                   review_file,
                                   business_business_review_edges_file):
    groupby_user = defaultdict(list)
    with open(review_file) as fin:
        for line in fin:
            if line.find('# user_id') >= 0: continue
            line_contents = line.strip('\n').split('\t')
            user_id = line_contents[0]
            business_id = line_contents[1]
            if user_id not in user_dict: continue
            if business_id not in business_dict: continue
            uid = user_dict[user_id]
            bid = business_dict[business_id]
            groupby_user[uid].append(bid)

    edge_set = set()
    for uid in groupby_user.keys():
        L = list(set(groupby_user[uid]))
        if len(L) < 2: continue
        E = list(combinations(L,2))
        for e in E:
            edge_set.add(e)

    edge_set_sorted = sorted(edge_set, key=operator.itemgetter(0, 1))
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
    
    USER_DICT = load_user_keys(user_keys_file)
    BUSINESS_DICT = load_business_keys(business_keys_file)
    
    # user-business    
    user_business_review_edges(USER_DICT,
                               BUSINESS_DICT,
                               review_file,
                               user_business_review_edges_file
                               )   

    """
    # user-user    
    user_user_review_edges(USER_DICT,
                           BUSINESS_DICT,
                           review_file,
                           user_user_review_edges_file)

    # business business    
    business_business_review_edges(USER_DICT,
                                   BUSINESS_DICT,
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
