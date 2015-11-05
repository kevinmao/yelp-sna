# -*- coding: utf-8 -*-

import argparse
import simplejson as json

"""
{
    'type': 'user',
    'user_id': (encrypted user id),
    'name': (first name),
    'review_count': (review count),
    'average_stars': (floating point average, like 4.31),
    'votes': {(vote type): (count)},
    'friends': [(friend user_ids)],
    'elite': [(years_elite)],
    'yelping_since': (date, formatted like '2012-03'),
    'compliments': {
        (compliment_type): (num_compliments_of_this_type),
        ...
    },
    'fans': (num_fans),
}

"""
HEADER = ['# user_id', 'user_str_id', 'name']
HEADER2 = ['# user_id', 'friend_id']

def user_key(inputFile, outputFile):
    with open(inputFile) as fin, open(outputFile, 'w') as fout:
        fout.write('\t'.join(HEADER))
        fout.write('\n')
        i = 0
        for line in fin:
            line_contents = json.loads(line)
            user_id = line_contents['user_id']
            name = line_contents['name']
            fout.write('\t'.join([
                                  str(i),
                                  user_id,
                                  name,
                                  ]
                                 ).encode('utf-8'))
            fout.write('\n')
            i += 1

def user_user_edges(inputFile, outputFile):
    unique_users = {}
    with open(inputFile) as fin:
        i = 0
        for line in fin:
            line_contents = json.loads(line)
            user_id = line_contents['user_id']
            unique_users[user_id] = str(i)
            i += 1

    seen_edges = set()
    with open(inputFile) as fin, open(outputFile, 'w') as fout:
        fout.write('\t'.join(HEADER2))
        fout.write('\n')
        for line in fin:
            line_contents = json.loads(line)
            user_id = line_contents['user_id']
            friends = line_contents['friends']
            for fuid in friends:
                if fuid not in unique_users: continue
                e = sorted([unique_users[user_id], unique_users[fuid]])
                g = tuple(e)
                if g in seen_edges: continue
                fout.write('\t'.join([
                                      unique_users[user_id],
                                      unique_users[fuid],
                                      ]
                                     ).encode('utf-8'))
                fout.write('\n')
                seen_edges.add(g)

def user_key_superset(inputFile, outputFile):
    user_dict = []
    unique_users = set()
    with open(inputFile) as fin:
        for line in fin:
            line_contents = json.loads(line)
            user_id = line_contents['user_id']
            name = line_contents['name']
            friends = line_contents['friends']
            user_dict.append((user_id, name))
            unique_users.add(user_id)
            for f in friends:
                unique_users.add(f)
    
    # double check
    L = [ uid for (uid, uname) in user_dict ]
    unknown_users = unique_users - set(L)
    print len(unknown_users)
    print len(unique_users)
    print len(user_dict)
    i = 0
    with open(outputFile, 'w') as fout:
        fout.write('\t'.join(HEADER))
        fout.write('\n')
        for uid, uname in user_dict:
            fout.write('\t'.join([
                                  str(i),
                                  uid,
                                  uname,
                                  ]
                                 ).encode('utf-8'))
            fout.write('\n')
            i += 1

        for uid in unknown_users:
            fout.write('\t'.join([
                                  str(i),
                                  uid,
                                  'NA',
                                  ]
                                 ).encode('utf-8'))
            fout.write('\n')
            i += 1

def main(args):
    inputFile = args.input
    outputFile = args.output
    output_superset = args.output_superset
    output_user_user = args.output_user_user
    user_key(inputFile, outputFile)   
    # user_key_superset(inputFile, output_superset)   
    user_user_edges(inputFile, output_user_user)   

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process yelp tip data')
    parser.add_argument('--input', metavar='FILE', required = True,
                        help='input file in json format')
    parser.add_argument('--output', metavar='FILE', required = True, 
                        help='output file in tsv format')
    parser.add_argument('--output_superset', metavar='FILE', required = False, 
                        help='output_superset file in tsv format')
    parser.add_argument('--output_user_user', metavar='FILE', required = False, 
                        help='output_user_user file in tsv format')
    args = parser.parse_args()
    main(args)
