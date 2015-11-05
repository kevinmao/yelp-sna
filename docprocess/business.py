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
HEADER = ['# business_id', 'name', 'latitude', 'longitude', 'stars', 'review_count', 'city', 'state', 'categories']

def process(inputFile, outputFile):
    with open(inputFile) as fin, open(outputFile, 'w') as fout:
        fout.write('\t'.join(HEADER))
        fout.write('\n')
        for line in fin:
            line_contents = json.loads(line)
            business_id = line_contents['business_id']
            name = line_contents['name']
            latitude = line_contents['latitude']
            longitude = line_contents['longitude']
            stars = line_contents['stars']
            review_count = line_contents['review_count']
            city = line_contents['city']
            state = line_contents['state']
            categories = line_contents['categories']
            merged_categories = '|'.join(categories)

            fout.write('\t'.join([
                                  business_id,
                                  name,
                                  str(latitude),
                                  str(longitude),
                                  str(stars),
                                  str(review_count),
                                  city,
                                  state,
                                  merged_categories
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
