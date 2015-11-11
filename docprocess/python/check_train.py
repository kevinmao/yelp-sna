# -*- coding: utf-8 -*-

import argparse

""" check overlap of (user, review) pairs in train and test data sets """

def checker(inputFile):
    S = set()
    with open(inputFile) as fin:
        for line in fin:
            if line.find('# business_id') >= 0: continue
            line_contents = line.strip('\n').split('\t')
            user_id = line_contents[0]
            business_id = line_contents[1]
            e = (user_id, business_id)
            S.add(e)
    return S

def main(args):
    train_data_file = args.train_data
    test_data_file = args.test_data

    Train = checker(train_data_file)
    Test = checker(test_data_file)
    Common = Train & Test
        
    print "Train.(user, review) = ",len(Train)
    print "Test.(user, review) = ",len(Test)
    print "Common.(user, review) = ",len(Common)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process yelp tip data')
    parser.add_argument('--train_data', metavar='FILE', required = True, help='train data')
    parser.add_argument('--test_data', metavar='FILE', required = True, help='test data')
    args = parser.parse_args()
    main(args)
