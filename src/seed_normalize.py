# coding: utf-8
import lzma
import os
import sys
import unicodedata

if __name__ == '__main__':
    seeds_dir = sys.argv[1]
    #seeds_dir = '/tmp/mecab-ipadic-neologd/seed/'
    files = os.listdir(seeds_dir)
    for file in files:
        if 'xz' in file:
            print('normalizing mecab seed...', file)
            f = lzma.open(seeds_dir + file, 'rb')
            lines = f.readlines()
            f.close()

            with lzma.open(seeds_dir + file, 'w') as f:
                for line in lines:
                    norm_text = unicodedata.normalize('NFKC', line.decode()).lower()
                    f.write(norm_text.encode('utf-8'))
