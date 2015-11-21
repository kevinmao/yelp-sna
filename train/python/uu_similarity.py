import argparse
import operator
import snap
import numpy as np
from collections import defaultdict

HEADER = ['# user_id', 
          'business_id', 
          'gamma_u1',
          'gamma_u2',
          'sim_common_nbr',
          'sim_pref',
          'sim_jaccard',
          'sim_cosine',
          'sim_overlap',
          'sim_adamic',
          'sim_delta',
          ]

def load_ub_core_train(inputFile):
    User = set()
    Business = set()
    GroupByUser = defaultdict(set)
    with open(inputFile) as fin:
        for line in fin:
            if line.find('# user_id') >= 0: continue
            row = line.strip('\n').split('\t')
            uid = int(row[0])
            bid = int(row[1])
            User.add(uid)
            Business.add(bid)
            GroupByUser[uid].add(bid)
    return User, Business, GroupByUser
    
def get_co_reviewer(G, User):
    co_reviewer_dict = defaultdict(set)
    for NI in G.Nodes():
        v = NI.GetId()
        NbrVec = snap.TIntV()
        snap.GetNodesAtHop(G, v, 2, NbrVec)
        if v in User:
            co_reviewer_dict[v] |= set(NbrVec)
    return co_reviewer_dict

def Adamic_Adar(S, co_reviewer_dict):
    score = 0.0
    for u in S:
        nbrVec = co_reviewer_dict[u]
        if len(nbrVec) < 1: continue
        score += 1.0/np.log(len(nbrVec))
    return score    

def Delta(S, co_reviewer_dict):
    score = 0.0
    for u in S:
        nbrVec = co_reviewer_dict[u]
        a = len(nbrVec)
        if a < 1: continue
        score += 1.0/(a*(a-1))
    return score    
            
def cal_sim(outputFile, User, Business, GroupByUser, co_reviewer_dict):
    fout =  open(outputFile, 'w')
    fout.write('\t'.join(HEADER))
    fout.write('\n')
    for u1 in User:
        coreviewers = co_reviewer_dict[u1]
        u1_biz = GroupByUser[u1]
        gamma_u1 = len(u1_biz)
        if gamma_u1 == 0: continue
        for u2 in coreviewers: 
            if u1 == u2: continue
            u2_biz = GroupByUser[u2]
            gamma_u2 = len(u2_biz)
            if gamma_u2 == 0: continue
            neighbors = u1_biz & u2_biz
            sim_common_nbr = len(neighbors)
            if sim_common_nbr == 0: continue
            sim_pref = gamma_u1 * gamma_u2
            sim_jaccard = 1.0*sim_common_nbr / (gamma_u1 + gamma_u2)
            sim_cosine = 1.0*sim_common_nbr / (gamma_u1 * gamma_u2)
            sim_overlap = 1.0*sim_common_nbr / min([gamma_u1, gamma_u2])
            sim_adamic = Adamic_Adar(neighbors, co_reviewer_dict)
            sim_delta = Delta(neighbors, co_reviewer_dict)
            L = [u1,
                 u2,
                 gamma_u1,
                 gamma_u2,
                 sim_common_nbr,
                 sim_pref,
                 sim_jaccard,
                 sim_cosine,
                 sim_overlap,
                 sim_adamic,
                 sim_delta,
                 ]
            L = [ str(e) for e in L ]
            fout.write('\t'.join(L))
            fout.write('\n')
    fout.close()        
            
def main(args):
    review_train_core_file = args.review_train_core
    ub_similarity_file = args.ub_similarity
    
    # Load graphs
    G = snap.LoadEdgeList(snap.PUNGraph, review_train_core_file, 0, 1)
    
    # load file
    User, Business, GroupByUser = load_ub_core_train(review_train_core_file)
    
    # get co-reviewer
    co_reviewer_dict = get_co_reviewer(G, User)
    
    # calculate metrics
    cal_sim(ub_similarity_file, User, Business, GroupByUser, co_reviewer_dict)
    
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process yelp tip data')
    parser.add_argument('--review_train_core', metavar='FILE', required = True, 
                        help='review_train_core file in tsv format')
    parser.add_argument('--ub_similarity', metavar='FILE', required = True, 
                        help='ub_similarity file in tsv format')
    args = parser.parse_args()
    main(args)
