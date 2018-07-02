#!/usr/bin/env python 

import pandas as pd
import numpy as np
import os
import argparse
from functools import reduce

def createDT(files):
   """ Function to create pandas dataframes """
   dfs = []
   for fname in files: 
       if os.path.isfile(fname):
	     df = pd.read_table(fname, sep='\t',names=['id', 'count'],index_col=0, header=None)
             dfs.append(df)
       else:
    	     print("File : {0} does not exist ! ignoring file .. ".format(fname))
   return dfs 

def concatDFs(dfs):
    """ Function to concat a list of dataframes based on first columns """
    df = pd.concat(dfs,axis=1).fillna(0)
    df['count']=df['count'].apply(np.int64)
    return df


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Merge gene counts')
    parser.add_argument('-in',dest='input',nargs='+',required=True,help='Gene Counts files')
    parser.add_argument('-out',dest='out', required=True,help='path to dem')
    args = parser.parse_args()
    if not vars(args):
    	parser.print_help()
    	parser.exit(1)

    dfs=createDT(args.input)
    df=concatDFs(dfs)
    df.to_csv(args.out,index=True,sep='\t',header=False)
