% -This is for finding frames location.
% -Use part of composed shoot ,like a few frames,to pitch all
%  the material shoot one by one. Find out the min mean delta
%  of certain location's frame.

clc;clear;
%   step 1 :read meterial video
tic;
material_path = 'Shoot/material/shining_drive.m4v';
materialObj = VideoReader(material_path);
Height = materialObj.Height;
Width = materialObj.Width;
sample_ratio = 8;
half_height = ceil(Height/sample_ratio);
half_width = ceil(Width/sample_ratio);
materialFrame = materialObj.NumberOfFrames;
materialObj = VideoReader(material_path);

materialArray = zeros(half_height, half_width, materialFrame, 'uint8');
k = 1;
while hasFrame(materialObj)
    temp = rgb2gray(readFrame(materialObj));
    materialArray(:,:,k) = temp(1:sample_ratio:Height,1:sample_ratio:Width);
    k = k+1;
end
% 3d to 2d
temp = permute(materialArray,[3 2 1]);
materialArray = reshape(temp,[materialFrame, half_height*half_width]);

%   step 2 :read composed video
composed_path = 'Shoot/composed/shining_cartoon.m4v';
composedObj = VideoReader(composed_path);
composed_frame = 4;
%   half_composed_frame is half of composed video frames 
half_composed_frame = ceil(composedObj.NumberOfFrames/2);
composedArray = zeros(half_height, half_width, composed_frame, 'uint8');

composedObj = VideoReader(composed_path);
for k = 1:composed_frame
    temp = rgb2gray(read(composedObj,composed_frame+k));
    composedArray(:,:,k) = temp(1:sample_ratio:Height,1:sample_ratio:Width);
end
% 3d to 2d
temp = permute(composedArray,[3 2 1]);
composedArray = reshape(temp,[composed_frame, half_height*half_width]);

%	step 3 :use each composed frame to reduce each frames of material
coefs = zeros(composed_frame,1);
pitch_frames = zeros(composed_frame,1);
for i = 1:composed_frame
    single_composed_frame = composedArray(i,:);
    delta = abs(double(materialArray) - double(single_composed_frame));
    mean_delta = mean(delta,2);
    [coefs(i), pitch_frames(i)] = min(mean_delta(1:end-1));
end  

%     step 4 :show the results
for i = 1:composed_frame
    disp(strcat('=====合成帧第 ', int2str(half_composed_frame+i), ...
    '帧匹配素材第', int2str(pitch_frames(i)), '帧，均增值',int2str(coefs(i)),'====='));
end
toc;