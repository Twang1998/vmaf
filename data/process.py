import pandas as pd
import scipy.io as scio
import numpy as np


df = pd.read_csv('UGCTrain_dmos.csv')

scio.savemat('Train_data.mat', {'train_ref':np.array(df['file_ref']).tolist() , 'train_dis':np.array(df['file_dis']).tolist()})
scio.savemat('Train_dmos.mat', {'train_dmos':np.array(df['dmos']).reshape(6400,1).tolist() })

df = pd.read_csv('UGCTest_dmos.csv')

scio.savemat('Test_data.mat', {'test_ref':np.array(df['file_ref']).tolist() , 'test_dis':np.array(df['file_dis']).tolist()})
scio.savemat('Test_dmos.mat', {'test_dmos':np.array(df['dmos']).reshape(800,1).tolist() })