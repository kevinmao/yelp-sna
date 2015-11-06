# -*- coding: utf-8 -*-

import argparse
import simplejson as json

"""
{
    'type': 'business',
    'business_id': (encrypted business id),
    'name': (business name),
    'neighborhoods': [(hood names)],
    'full_address': (localized address),
    'city': (city),
    'state': (state),
    'latitude': latitude,
    'longitude': longitude,
    'stars': (star rating, rounded to half-stars),
    'review_count': review count,
    'categories': [(localized category names)]
    'open': True / False (corresponds to closed, not business hours),
    'hours': {
        (day_of_week): {
            'open': (HH:MM),
            'close': (HH:MM)
        },
        ...
    },
    'attributes': {
        (attribute_name): (attribute_value),
        ...
    },
}

"""
HEADER = ['# business_id', 'business_str_id', 'name']
    
def process(inputFile, outputFile, startid):
    with open(inputFile) as fin, open(outputFile, 'w') as fout:
        fout.write('\t'.join(HEADER))
        fout.write('\n')
        i = startid
        for line in fin:
            line_contents = json.loads(line)
            business_id = line_contents['business_id']
            name = line_contents['name']
            fout.write('\t'.join([
                                  str(i),
                                  business_id,
                                  name,
                                  ]
                                 ).encode('utf-8'))
            fout.write('\n')
            i += 1

def main(args):
    inputFile = args.input
    outputFile = args.output
    startid = args.startid
    process(inputFile, outputFile, startid)   

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process yelp tip data')
    parser.add_argument('--input', metavar='FILE', required = True,
                        help='input file in json format')
    parser.add_argument('--output', metavar='FILE', required = True, 
                        help='output file in tsv format')
    parser.add_argument('--startid', metavar='N', type=int, default = 400000,
                        help='start node id')    
    args = parser.parse_args()
    main(args)
