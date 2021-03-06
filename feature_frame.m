clear all;
% result = [];
% result2 = [];

%scio.savemat('Train_data.mat', {'train_ref':df['file_ref'] , 'train_dis':df['file_dis']})
%scio.savemat('Train_dmos.mat', {'train_dmos':df['dmos'] })

%scio.savemat('Test_data.mat', {'test_ref':df['file_ref'] , 'test_dis':df['file_dis']})
%scio.savemat('Test_dmos.mat', {'test_dmos':df['dmos'] })

load (fullfile('data','Train_data.mat'));
load (fullfile('data','Test_data.mat'));
load (fullfile('data','Train_dmos.mat'));
load (fullfile('data','Test_dmos.mat'));

Train_path = '';
Test_path = '';

addpath('AVMAF')

for i = 1:length(train_ref)
    ref_img_path = train_ref(i,1:end-4);
    dis_img_path = train_dis(i,1:end-4);
    for j = 1:10
        pic = num2str(j-1,'%03d');
        ref_img = fullfile(Train_path,ref_img_path,strcat(pic,'.png'));
        dis_img = fullfile(Train_path,dis_img_path,strcat(pic,'.png'));
        ref = (rgb2gray(imread(ref_img)));
        dis = (rgb2gray(imread(dis_img)));
        vifp_feat(j,:)=VIFP_feat(ref,dis);
    end
    vifp_feat_train(i,:) = mean(vifp_feat,1);
end

for i = 1:length(test_ref)
    ref_img_path = test_ref(i,1:end-4);
    dis_img_path = test_dis(i,1:end-4);
    for j = 1:10
        pic = num2str(j-1,'%03d');
        ref_img = fullfile(Test_path,ref_img_path,strcat(pic,'.png'));
        dis_img = fullfile(Test_path,dis_img_path,strcat(pic,'.png'));
        ref = (rgb2gray(imread(ref_img)));
        dis = (rgb2gray(imread(dis_img)));
        vifp_feat(j,:)=VIFP_feat(ref,dis);
    end
    vifp_feat_test(i,:) = mean(vifp_feat,1);
end

save(fullfile('feature','train_feature.mat'), 'vifp_feat_train')
save(fullfile('feature','test_feature.mat'), 'vifp_feat_test')





% file_path_name = strcat('./NR/',nr,'/');
% if exist(file_path_name)==0   %žÃÎÄŒþŒÐ²»ŽæÔÚ£¬ÔòÖ±œÓŽŽœš
%         mkdir(file_path_name);
% end
% addpath(strcat('./NRIQA/FeatureExtraction/DSIQA/',nr));
% %addpath('C:\Users\Orange\Desktop\NRIQA\higradeRelease\higradeRelease');
% %cd ;
% %save('E:\taowang\NR\BRISQUE\test.mat', 'test_region_path')
% %  for j = 1:1500 %ÖðÒ»¶ÁÈ¡ÍŒÏñ
% %             image_name = strcat('/media/twang/storage/ICME/',picture,'/',strrep(train_path(j,:),'\','/'));% ÍŒÏñÃû
% %             disp(image_name);% ÏÔÊŸÕýÔÚŽŠÀíµÄÍŒÏñÃû
% %             img = (rgb2gray(imread(image_name)));
% %             feat =  CPBD_compute(img);
% %             feat0 = reshape(feat',1,size(feat,1)*size(feat,2));
% %             % local mean and variance
% %             result = [result;feat0];
% %             %result = [result; ee];
% %             %ÍŒÏñŽŠÀí¹ý³Ì Ê¡ÂÔ 
% %  end
% % 
% % save(strcat(file_path_name,'train_',type,'_feature.mat'), 'result')
%   for j = 1:300 %ÖðÒ»¶ÁÈ¡ÍŒÏñ
%             image_name = strcat('/media/twang/storage/ICME/',picture,'/',strrep(test_path(j,:),'\','/'));% ÍŒÏñÃû
%             disp(image_name);% ÏÔÊŸÕýÔÚŽŠÀíµÄÍŒÏñÃû
%             %img = double(rgb2gray(imread(image_name)));
%             img = imread(image_name);
%             feat =bible_index(img);
%             %feat0 = reshape(feat',1,size(feat,1)*size(feat,2));
%             % local mean and variance
%             result2 = [result2;feat];
%             %result = [result; ee];
%             %ÍŒÏñŽŠÀí¹ý³Ì Ê¡ÂÔ
%   end
% save(strcat(file_path_name,'test_',type,'_feature.mat'), 'result2')