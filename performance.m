clear; close all; clc;clear 
dbstop if error         % for debugging: trigger a debug point when an error
%rng('default');
%curdir = cd;
%addpath('C:\Users\Orange\Desktop\LowLightEnhancementTest1\Enhancement\compare\')
type = 'region';
nr = 'NIQE';

load(strcat('E:\taowang\NR\',nr,'\train_',type,'_feature.mat'));
FeatureTrain = result;
FeatureTrain(isnan(FeatureTrain)==1) = 0
load(strcat('E:\taowang\NR\',nr,'\test_',type,'_feature.mat'));
FeatureTest = result2;
FeatureTest(isnan(FeatureTest)==1) = 0
load(strcat('train_',type,'.mat'));
load(strcat('test_',type,'.mat'));
if type == 'region' 
    LableTrain = train_region_score;
    LableTest = test_region_score;
else
    LableTrain = train_global_score;
    LableTest = test_global_score;
end

svmdir = 'E:\taowang\RESVM\SVM\SVM';
cd(svmdir);
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


fid = fopen('train_ind.txt','w');
for itr_im = 1:size(FeatureTrain,1)
    fprintf(fid,'%d ',LableTrain(itr_im));
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
Score = output;

all_srcc=[];
all_plcc = [];
for i = 1:20
    gt_scores = LableTest((i-1)*15+1:i*15);
    pred_scores = Score((i-1)*15+1:i*15);

    SRCC = corr(pred_scores,gt_scores,'type','Spearman');
    PLCC = corr(gt_scores,pred_scores, 'type','Pearson');


    all_srcc = [all_srcc,SRCC];
    all_plcc = [all_plcc,PLCC];
end



%cd(curdir)


acc = [];
for i =1:20
    gt_scores = LableTest((i-1)*15+1:i*15);
    pred_scores = Score((i-1)*15+1:i*15);
    total = 0;
    num = 0;
    for j=1:14
        for k=j+1:15
            total =total+1;
            if(gt_scores(j) >= gt_scores(k) && pred_scores(j) >= pred_scores(k)) || (gt_scores(j) < gt_scores(k) && pred_scores(j) < pred_scores(k))
                num =num+ 1;
            end
        end
    end
    single_acc = num/total;
    acc=[acc,single_acc];
end
mean_acc = mean(acc);
aaaaa = [mean(all_srcc),mean(all_plcc),mean_acc];