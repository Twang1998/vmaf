import pandas as pd
import scipy.io as scio


df = pd.read_csv('UGCTrain_dmos.csv')

scio.savemat('Train_data.mat', {'train_ref':df['file_ref'] , 'train_dis':df['file_dis']})
scio.savemat('Train_dmos.mat', {'train_dmos':df['dmos'] })

df = pd.read_csv('UGCTest_dmos.csv')

scio.savemat('Test_data.mat', {'test_ref':df['file_ref'] , 'test_dis':df['file_dis']})
scio.savemat('Test_dmos.mat', {'test_dmos':df['dmos'] })