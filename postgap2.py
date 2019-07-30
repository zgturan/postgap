import os
import cPickle
import pandas as pd
import numpy as np
import collections
import glob
import os

post_dir_result='heatmap_blocks'
os.chdir(os.path.join('..',post_dir_result))

df=pd.read_csv(post_dir_result+str('.tsv'), sep="\t")

for a in range(df.shape[0]):
    out = []
    with open(df.ix[a][0],'r') as f:
        res_out = cPickle.load(f)
        for i in range(len(res_out)):
            gene= res_out[i].gene.name
            CLPP = res_out[i].collocation_posterior
            for tissue, clpp in CLPP.items():
                out.append([gene, tissue, clpp])
                dff = pd.DataFrame(out)
        print(df.ix[a][0])
        dff.to_csv(df.ix[a][0] + '.csv',index=True, encoding='utf-8')

      
