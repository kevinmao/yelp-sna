# -*- coding: utf-8 -*-

import argparse
import operator

HEADER_UB = ['# user_id', 'business_id', 'stars']

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
    edge_set = []
    with open(review_file) as fin:
        for line in fin:
            if line.find('# user_id') >= 0: continue
            line_contents = line.strip('\n').split('\t')
            user_id = line_contents[0]
            business_id = line_contents[1]
            stars = int(line_contents[2])
            if user_id not in user_dict: continue
            if business_id not in business_dict: continue
            e = [user_dict[user_id], business_dict[business_id], stars]
            g = tuple(e)
            edge_set.append(g)

    edge_set_sorted = sorted(edge_set, key=operator.itemgetter(0, 1))
    with open(user_business_review_edges_file, 'w') as fout:
        fout.write('\t'.join(HEADER_UB))
        fout.write('\n')
        for e1, e2, e3 in edge_set_sorted:
            fout.write('\t'.join([str(e1),str(e2),str(e3)]))
            fout.write('\n')

def main(args):
    user_keys_file = args.user_keys
    business_keys_file = args.business_keys
    review_file = args.review
    user_business_review_edges_file = args.user_business_review_edges
    
    USER_DICT = load_user_keys(user_keys_file)
    BUSINESS_DICT = load_business_keys(business_keys_file)
    
    # user-business    
    user_business_review_edges(USER_DICT,
                               BUSINESS_DICT,
                               review_file,
                               user_business_review_edges_file
                               )   

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process yelp tip data')
    parser.add_argument('--user_keys', metavar='FILE', required = True, 
                        help='user_keys file in tsv format')
    parser.add_argument('--business_keys', metavar='FILE', required = True, 
                        help='business_keys file in tsv format')
    parser.add_argument('--review', metavar='FILE', required = True, 
                        help='review file in tsv format')
    parser.add_argument('--user_business_review_edges', metavar='FILE', required = True, 
                        help='user_business_review_edges file in tsv format')
    args = parser.parse_args()
    main(args)
