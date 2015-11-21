# -*- coding: utf-8 -*-

import snap
import argparse

def main(args):
    review_file = args.review
    review_maxwcc_file = args.review_maxwcc

    # load graph
    G = snap.LoadEdgeList(snap.PUNGraph, review_file, 0, 1)
    
    # get wcc
    MxWcc = snap.GetMxWcc(G)
    
    # save 
    snap.SaveEdgeList(MxWcc, review_maxwcc_file)
    
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process yelp tip data')
    parser.add_argument('--review', metavar='FILE', required = True, help='train data')
    parser.add_argument('--review_maxwcc', metavar='FILE', required = True, help='test data')
    args = parser.parse_args()
    main(args)
