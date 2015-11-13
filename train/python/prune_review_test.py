# -*- coding: utf-8 -*-

import argparse

def load_review_train(inputFile):
    User = set()
    Business = set()
    with open(inputFile) as fin:
        for line in fin:
            if line.find('# user_id') >= 0: continue
            row = line.strip('\n').split('\t')
            user_id = row[0]
            business_id = row[1]
            User.add(user_id)
            Business.add(business_id)
    return User, Business

def prune_review_test(inputFile, outputFile, Train_User, Train_Business):
    with open(inputFile) as fin, open(outputFile, 'w') as fout:
        for line in fin:
            if line.find('# user_id') >= 0:
                fout.write(line) # header 
                continue
            row = line.strip('\n').split('\t')
            user_id = row[0]
            business_id = row[1]
            if user_id in Train_User and business_id in Train_Business:
                fout.write(line)  

def main(args):
    review_train_file = args.review_train
    review_test_file = args.review_test
    review_test_pruned_file = args.review_test_pruned
    User, Business = load_review_train(review_train_file)
    prune_review_test(review_test_file, review_test_pruned_file, User, Business)
    
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process yelp tip data')
    parser.add_argument('--review_train', metavar='FILE', required = True, help='train data')
    parser.add_argument('--review_test', metavar='FILE', required = True, help='test data')
    parser.add_argument('--review_test_pruned', metavar='FILE', required = True, help='test data')
    args = parser.parse_args()
    main(args)
