clear; close all; clc;clear 
dbstop if error         % for debugging: trigger a debug point when an error
%rng('default');
%curdir = cd;
%addpath('C:\Users\Orange\Desktop\LowLightEnhancementTest1\Enhancement\compare\')

% save(fullfile(feature,'train_feature.mat'), 'vifp_feat_train')
% save(fullfile(feature,'test_feature.mat'), 'vifp_feat_test')

load(fullfile('features','ms_ssim_train_feature.mat'));
load(fullfile('features','ms_ssim_test_feature.mat'));
load(fullfile('data','Train_dmos.mat'));
load(fullfile('data','Test_dmos.mat'));
FeatureTrain = ms_ssim_train_feature;
FeatureTrain(isnan(FeatureTrain)) = 1;
LabelTrain = train_dmos;
FeatureTest = ms_ssim_test_feature;
FeatureTest(isnan(FeatureTest)) = 1;
LabelTest = test_dmos;

CurrentPath = pwd;
svmdir = 'AVMAF\SVM';
cd(svmdir);


% train the model using SVR
%eval(['FeatureTrain = ',database_name,'_train_',num2str(i-1),'_',feature_name,';'])


fid = fopen('train_ind.txt','w');
for itr_im = 1:size(FeatureTrain,1)
    fprintf(fid,'%d ',LabelTrain(itr_im));
    for itr_param = 1:size(FeatureTrain,2)
        fprintf(fid,'%d:%f ',itr_param,FeatureTrain(itr_im,itr_param));
    end
    fprintf(fid,'\n');
end
fclose(fid);
if(exist('train_scale','file'))
    delete train_scale
end
system('svm-scale -l -1 -u 1 -s range train_ind.txt > train_scale');
system('svm-train -b 1 -s 3 -g 0.05 -c 1 -q train_scale model');

% test
%eval(['FeatureTest = ',database_name,'_test_',num2str(i-1),'_',feature_name,';'])


mos=ones(size(FeatureTest,1),1);
fid = fopen('test_ind.txt','w');
for itr_im = 1:size(FeatureTest,1)
    fprintf(fid,'%d ',mos(itr_im));
    for itr_param = 1:size(FeatureTest,2)
        fprintf(fid,'%d:%f ',itr_param,FeatureTest(itr_im,itr_param));
    end
    fprintf(fid,'\n');
end
fclose(fid);
delete test_ind_scaled
system('svm-scale -r range test_ind.txt >> test_ind_scaled');
system('svm-predict  -b 1  test_ind_scaled model output.txt>dump');
load output.txt;
cd(CurrentPath);
Score = output;

SROCC = corr(LabelTest, Score,'type','Spearman');
PLCC = corr(LabelTest, Score, 'type','Pearson');
KROCC = corr(LabelTest, Score, 'type','Kendall');
RMSE = sqrt(mean((LabelTest-Score).^2));

result = [SROCC, PLCC, KROCC, RMSE]

%n_epoch = 1;
%load similar.mat;

%result_feature = [result(:,1:39)];
%
%result_feature = [result(:,1:2) result(:,24) result(:,27)  result(:,34:39) result(:,40:41) result(:,46) result(:,47)];
%load result.mat;
%result_feature = [result(:,1:2) result(:,15:20) result(:,36:39) result(:,21:22) result(:,26) result(:,27:29)];


% load train and testing features
%load([database_name,'_train_',num2str(i-1),'_',feature_name,'.mat'])
%load([database_name,'_test_',num2str(i-1),'_',feature_name,'.mat'])

% load train and testing score
%load(['F:\OneDrive\Code\AuthenticIQA\database_file_ten\',database_name,'_train_',num2str(i-1),'.mat']);
%load(['F:\OneDrive\Code\AuthenticIQA\database_file_ten\',database_name,'_test_',num2str(i-1),'.mat']);

% train the model using SVR
%eval(['FeatureTrain = ',database_name,'_train_',num2str(i-1),'_',feature_name,';'])


