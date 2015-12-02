# -*- coding: utf-8 -*-

import argparse

"""
transform ub_similarity.tsv data to libmf test data format
"""
def create_output(input_file, output_file):
    with open(input_file, 'r') as fin, open(output_file, 'w') as fout:
        for line in fin:
            if line.find('# user_id') >= 0: continue
            row = line.strip('\n').split('\t')
            u = row[0]
            b = row[1]
            fout.write('\t'.join([str(u), str(b), '0'])) # dummy score
            fout.write('\n')

def main(args):
    input_file = args.input
    output_file = args.output
    create_output(input_file, output_file)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process yelp data')
    parser.add_argument('--input', metavar='FILE', required = True, help='input file in tsv format')
    parser.add_argument('--output', metavar='FILE', required = True, help='output file in tsv format')
    args = parser.parse_args()
    main(args)
    