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

%Train_path = '';
%Test_path = '';
video_path = '';

% train_ref = ['UGC0499_1280x720_30_crf_27.mp4'];
% train_dis = ['UGC0499_1280x720_30_crf_27.mp4'];
addpath('AVMAF')

for i = 1:length(train_ref)
    ref_video = train_ref(i,:);
    dis_video = train_dis(i,:);
    ref_obj = VideoReader(fullfile(video_path,ref_video));
    dis_obj = VideoReader(fullfile(video_path,dis_video));
    for j = 1:1:ref_obj.NumberOfFrames
        ref_img = read(ref_obj, j);
        ref_img = rgb2gray(ref_img);
        dis_img = read(dis_obj, j);
        dis_img = rgb2gray(dis_img);
        vifp_feat(j,:)=VIFP_feat(ref_img,dis_img);
    end
    vifp_feat_train(i,:) = mean(vifp_feat,1);
end

for i = 1:length(test_ref)
    ref_video = test_ref(i,:);
    dis_video = test_dis(i,:);
    ref_obj = VideoReader(fullfile(video_path,ref_video));
    dis_obj = VideoReader(fullfile(video_path,dis_video));
    for j = 1:1:ref_obj.NumberOfFrames
        ref_img = read(ref_obj, j);
        ref_img = rgb2gray(ref_img);
        dis_img = read(dis_obj, j);
        dis_img = rgb2gray(dis_img);
        vifp_feat(j,:)=VIFP_feat(ref,dis);
    end
    vifp_feat_test(i,:) = mean(vifp_feat,1);
end
save(fullfile('feature','train_feature.mat'), 'vifp_feat_train')
save(fullfile('feature','test_feature.mat'), 'vifp_feat_test')


