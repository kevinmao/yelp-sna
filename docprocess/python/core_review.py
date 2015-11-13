# -*- coding: utf-8 -*-

import argparse
from collections import defaultdict

MIN_DEGREE = 5

def ub_core_train(inputFile):
    User = set()
    Business = set()
    UserDegree = defaultdict(int)
    BusinessDegree = defaultdict(int)
    with open(inputFile) as fin:
        for line in fin:
            if line.find('# user_id') >= 0: continue
            row = line.strip('\n').split('\t')
            user_id = row[0]
            business_id = row[1]
            User.add(user_id)
            Business.add(business_id)
            UserDegree[user_id] += 1
            BusinessDegree[business_id] += 1
    # core user
    print len(User), len(Business)
    Core_User = set()
    for u in User:
        if UserDegree[u] < MIN_DEGREE: continue
        Core_User.add(u)
    # core business
    Core_Business = set()
    for b in Business:
        if BusinessDegree[b] < MIN_DEGREE: continue
        Core_Business.add(b)
    print len(Core_User), len(Core_Business)
    return Core_User, Core_Business

def core_data(inputFile, outputFile, Core_User, Core_Business):
    with open(inputFile) as fin, open(outputFile, 'w') as fout:
        for line in fin:
            if line.find('# user_id') >= 0:
                fout.write(line) # header 
                continue
            row = line.strip('\n').split('\t')
            user_id = row[0]
            business_id = row[1]
            if user_id in Core_User and business_id in Core_Business:
                fout.write(line)  

def core_review_test(inputFile, outputFile, Train_User, Train_Business):
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
    review_train_core_file = args.review_train_core
    review_test_core_file = args.review_test_core
    
    Core_User, Core_Business = ub_core_train(review_train_file)
    core_data(review_train_file, review_train_core_file, Core_User, Core_Business)
    core_data(review_test_file, review_test_core_file, Core_User, Core_Business)
    
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process yelp tip data')
    parser.add_argument('--review_train', metavar='FILE', required = True, help='train data')
    parser.add_argument('--review_test', metavar='FILE', required = True, help='test data')
    parser.add_argument('--review_train_core', metavar='FILE', required = True, help='test data')
    parser.add_argument('--review_test_core', metavar='FILE', required = True, help='test data')
    args = parser.parse_args()
    main(args)
