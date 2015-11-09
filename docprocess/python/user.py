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
HEADER = ['# user_id', 'name', 'review_count', 'average_stars', 'friends', 'fans', 'votes.funny', 'votes.useful', 'votes.cool', 'yelping_since']

def process(inputFile, outputFile):
    with open(inputFile) as fin, open(outputFile, 'w') as fout:
        fout.write('\t'.join(HEADER))
        fout.write('\n')
        for line in fin:
            line_contents = json.loads(line)
            user_id = line_contents['user_id']
            name = line_contents['name']
            review_count = line_contents['review_count']
            average_stars = line_contents['average_stars']
            friends = len(line_contents['friends'])
            fans = line_contents['fans']
            votes_funny = line_contents['votes']['funny']
            votes_useful = line_contents['votes']['useful']
            votes_cool = line_contents['votes']['cool']
            yelping_since = line_contents['yelping_since']

            fout.write('\t'.join([
                                  user_id,
                                  name,
                                  str(review_count),
                                  str(average_stars),
                                  str(friends),
                                  str(fans),
                                  str(votes_funny),
                                  str(votes_useful),
                                  str(votes_cool),
                                  str(yelping_since),
                                  ]
                                 ).encode('utf-8'))
            fout.write('\n')

def main(args):
    inputFile = args.input
    outputFile = args.output
    process(inputFile, outputFile)   

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process yelp tip data')
    parser.add_argument('--input', metavar='FILE', required = True,
                        help='input file in json format')
    parser.add_argument('--output', metavar='FILE', required = True, 
                        help='output file in tsv format')
    args = parser.parse_args()
    main(args)
