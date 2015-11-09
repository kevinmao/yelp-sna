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
    
def process(inputFile, outputFile):
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
