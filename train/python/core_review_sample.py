# -*- coding: utf-8 -*-

import random
import argparse
from collections import defaultdict

MIN_DEGREE = 5
SAMPLE_RATE = 0.01
random.seed(50)

def select_user(inputFile):
    SelectedUser = set()
    with open(inputFile) as fin:
        for line in fin:
            if line.find('# user_id') >= 0: continue
            row = line.strip('\n').split('\t')
            user_id = row[0]
            if random.random() < SAMPLE_RATE:
                SelectedUser.add(user_id)
    return SelectedUser

def ub_core_train(inputFile, SelectedUser):
    User = set()
    Business = set()
    Edge = set()
    UserDegree = defaultdict(int)
    BusinessDegree = defaultdict(int)
    with open(inputFile) as fin:
        for line in fin:
            if line.find('# user_id') >= 0: continue
            row = line.strip('\n').split('\t')
            user_id = row[0]
            business_id = row[1]
            e = (user_id, business_id)
            if user_id not in SelectedUser: continue
            User.add(user_id)
            Business.add(business_id)
            Edge.add(e)
            UserDegree[user_id] += 1
            BusinessDegree[business_id] += 1
    # core user
    print "len(User), len(Business) = %d, %d" % (len(User), len(Business))
    Core_User = set()
    for u in User:
        if UserDegree[u] < MIN_DEGREE: continue
        Core_User.add(u)
    # core business
    Core_Business = set()
    for b in Business:
        if BusinessDegree[b] < MIN_DEGREE: continue
        Core_Business.add(b)
    print "len(Core_User), len(Core_Business) = %d, %d" % (len(Core_User), len(Core_Business))
    return Core_User, Core_Business, Edge

def core_review_train(inputFile, outputFile, Core_User, Core_Business):
    seen_edge = set()
    with open(inputFile) as fin, open(outputFile, 'w') as fout:
        for line in fin:
            if line.find('# user_id') >= 0:
                fout.write(line) # header 
                continue
            row = line.strip('\n').split('\t')
            user_id = row[0]
            business_id = row[1]
            e = (user_id, business_id)
            if e in seen_edge: continue
            if user_id in Core_User and business_id in Core_Business:
                seen_edge.add(e)
                fout.write(line)  

def core_review_test(inputFile, outputFile, Train_User, Train_Business, Train_Edge):
    seen_edge = set()
    with open(inputFile) as fin, open(outputFile, 'w') as fout:
        for line in fin:
            if line.find('# user_id') >= 0:
                fout.write(line) # header 
                continue
            row = line.strip('\n').split('\t')
            user_id = row[0]
            business_id = row[1]
            e = (user_id, business_id)
            if e in Train_Edge: continue
            if e in seen_edge: continue
            if user_id in Train_User and business_id in Train_Business:
                seen_edge.add(e)
                fout.write(line)  

def main(args):
    review_train_file = args.review_train
    review_test_file = args.review_test
    review_train_core_file = args.review_train_core
    review_test_core_file = args.review_test_core
    
    SelectedUser = select_user(review_train_file)
    Core_User, Core_Business, Core_Edge = ub_core_train(review_train_file, SelectedUser)
    core_review_train(review_train_file, review_train_core_file, Core_User, Core_Business)
    core_review_test(review_test_file, review_test_core_file, Core_User, Core_Business, Core_Edge)
    
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process yelp tip data')
    parser.add_argument('--review_train', metavar='FILE', required = True, help='train data')
    parser.add_argument('--review_test', metavar='FILE', required = True, help='test data')
    parser.add_argument('--review_train_core', metavar='FILE', required = True, help='test data')
    parser.add_argument('--review_test_core', metavar='FILE', required = True, help='test data')
    args = parser.parse_args()
    main(args)
