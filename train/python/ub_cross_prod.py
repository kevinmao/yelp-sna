# -*- coding: utf-8 -*-

import argparse

HEADER_UB = ['# user_id', 'business_id', 'stars']

def load_ub_core_train(inputFile):
    User = set()
    Business = set()
    Edge = set()
    with open(inputFile) as fin:
        for line in fin:
            if line.find('# user_id') >= 0: continue
            row = line.strip('\n').split('\t')
            user_id = row[0]
            business_id = row[1]
            e = (user_id, business_id)
            User.add(user_id)
            Business.add(business_id)
            Edge.add(e)
    return User, Business, Edge

def create_ub_cross_prod(Train_User,
                         Train_Business,
                         Train_Edge,
                         ub_cross_prod_file):
    with open(ub_cross_prod_file, 'w') as fout:
        #fout.write('\t'.join(HEADER_UB))
        #fout.write('\n')
        for u in Train_User:
            for b in Train_Business:
                e = (u, b)
                if e in Train_Edge: continue
                fout.write('\t'.join([str(u), str(b), '1'])) # dummy score
                fout.write('\n')

def main(args):
    review_train_core_file = args.review_train_core
    ub_cross_prod_file = args.ub_cross_prod
    
    User, Business, Edge = load_ub_core_train(review_train_core_file)
    # user-business    
    create_ub_cross_prod(User, Business, Edge, ub_cross_prod_file)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process yelp tip data')
    parser.add_argument('--review_train_core', metavar='FILE', required = True, 
                        help='review_train_core file in tsv format')
    parser.add_argument('--ub_cross_prod', metavar='FILE', required = True, 
                        help='ub_cross_prod file in tsv format')
    args = parser.parse_args()
    main(args)
