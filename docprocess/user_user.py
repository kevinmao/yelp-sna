# -*- coding: utf-8 -*-

import argparse
import simplejson as json
import operator

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
HEADER = ['# user_id', 'friend_id']

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
    
def user_user_edges(user_file, user_keys_file, user_user_edges_file):
    user_dict = load_user_keys(user_keys_file)
    edge_set = set()

    with open(user_file) as fin:
        for line in fin:
            line_contents = json.loads(line)
            user_id = line_contents['user_id']
            friends = line_contents['friends']
            for fuid in friends:
                e = sorted([user_dict[user_id], user_dict[fuid]])
                g = tuple(e)
                edge_set.add(g)

    edge_set_sorted = sorted(edge_set, key=operator.itemgetter(0, 1))
    with open(user_user_edges_file, 'w') as fout:
        fout.write('\t'.join(HEADER))
        fout.write('\n')
        for e in edge_set_sorted:
            fout.write('\t'.join([str(e[0]),str(e[1])]))
            fout.write('\n')

def main(args):
    user_file = args.user
    user_keys_file = args.user_keys
    user_user_edges_file = args.user_user_edges
    user_user_edges(user_file, user_keys_file, user_user_edges_file)   

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process yelp tip data')
    parser.add_argument('--user', metavar='FILE', required = True,
                        help='user file in json format')
    parser.add_argument('--user_keys', metavar='FILE', required = True, 
                        help='user_keys file in tsv format')
    parser.add_argument('--user_user_edges', metavar='FILE', required = True, 
                        help='user_user_edges file in tsv format')
    args = parser.parse_args()
    main(args)
