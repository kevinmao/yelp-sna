# -*- coding: utf-8 -*-

import argparse
import simplejson as json

"""
{
    'type': 'tip',
    'text': (tip text),
    'business_id': (encrypted business id),
    'user_id': (encrypted user id),
    'date': (date, formatted like '2012-03-14'),
    'likes': (count),
}
"""
HEADER = ['# user_id', 'business_id', 'likes', 'date']

def process(inputFile, outputFile):
    with open(inputFile) as fin, open(outputFile, 'w') as fout:
        fout.write('\t'.join(HEADER))
        fout.write('\n')
        for line in fin:
            line_contents = json.loads(line)
            user_id = line_contents['user_id']
            business_id = line_contents['business_id']
            likes = line_contents['likes']
            date = line_contents['date']
            fout.write('\t'.join([
                                  user_id,
                                  business_id,
                                  str(likes),
                                  str(date),
                                  ]
                                 ))
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
