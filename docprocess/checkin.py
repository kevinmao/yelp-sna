# -*- coding: utf-8 -*-

import argparse
import simplejson as json
from collections import defaultdict

"""
{
    'type': 'checkin',
    'business_id': (encrypted business id),
    'checkin_info': {
        '0-0': (number of checkins from 00:00 to 01:00 on all Sundays),
        '1-0': (number of checkins from 01:00 to 02:00 on all Sundays),
        ...
        '14-4': (number of checkins from 14:00 to 15:00 on all Thursdays),
        ...
        '23-6': (number of checkins from 23:00 to 00:00 on all Saturdays)
    }, # if there was no checkin for a hour-day block it will not be in the dict
}

"""
HEADER = ['# business_id', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']

def process(inputFile, outputFile):
    with open(inputFile) as fin, open(outputFile, 'w') as fout:
        fout.write('\t'.join(HEADER))
        fout.write('\n')
        for line in fin:
            L = defaultdict(int)
            line_contents = json.loads(line)
            business_id = line_contents['business_id']
            checkin_info = line_contents['checkin_info']
            for period in checkin_info:
                [k, v] = period.split('-')[0:2]
                L[v] += checkin_info[period]

            fout.write('\t'.join([
                                  business_id,
                                  str(L['0']),
                                  str(L['1']),
                                  str(L['2']),
                                  str(L['3']),
                                  str(L['4']),
                                  str(L['5']),
                                  str(L['6']),
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
