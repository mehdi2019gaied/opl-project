#from doopl.factory import *
#import os
#from os.path import dirname, abspath, join

#DATADIR=join(dirname(abspath(__file__)),'data')
#mod="test.mod"
#dat=join(DATADIR,"essai.dat")
#gen_dir=os.path.join(DATADIR,"generated")

#if not os.path.isdir(gen_dir):
   # os.makedirs(gen_dir)

#with create_opl_model(model=mod) as opl:
    #opl.run()

    #print(opl)
    #print(opl.objective_value)
    #print(opl.get_table("InVolumeThroughHubonTestRes"))
    #print(opl.get_table("OutVolumeThroughHubonTestRes"))
    #print(opl.report) 
    
    

#This example shows how to run an OPL model, get a post processing IloTupleSet as a pandas df and iterate on it.

from doopl.factory import *
import os
from os.path import dirname, abspath, join

DATADIR = join(dirname(abspath(__file__)), 'data')

mod = "test.mod"

with create_opl_model(model=mod) as opl:
    opl.run()

    list = opl.get_table("solution")
    for t in list.itertuples(index=False):
        print(t)