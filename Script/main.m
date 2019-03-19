clc;clear;
%   step 1 :read meterial video
tic;
materialObj = VideoReader('Shoot/material/shining_material.m4v');

Height = materialObj.Height;
Width = materialObj.Width;
sample_ratio = 4;
half_height = ceil(Height/sample_ratio);
half_width = ceil(Width/sample_ratio);
materialFrame = materialObj.NumberOfFrames;
materialObj = VideoReader('Shoot/material/shining_material.m4v');

materialArray = zeros(half_height, half_width, materialFrame);
k = 1;
while hasFrame(materialObj)
    temp = rgb2gray(readFrame(materialObj));
    materialArray(:,:,k) = temp(1:sample_ratio:Height,1:sample_ratio:Width);
    k = k+1;
end

%   step 2 :read composed video
composedObj = VideoReader('Shoot/composed/shining_color_change.m4v');
composed_frame = 15;
%   half_composed_frame is half of composed video frames 
half_composed_frame = ceil(composedObj.NumberOfFrames/2);
composedArray = zeros(half_height, half_width, composed_frame);

composedObj = VideoReader('Shoot/composed/shining_color_change.m4v');
for k = 1:composed_frame
    temp = rgb2gray(read(composedObj,composed_frame+k));
    composedArray(:,:,k) = temp(1:sample_ratio:Height,1:sample_ratio:Width);
end

%	step 3 :use each composed frame to reduce each frames of material
coefs = zeros(composed_frame,1);
pitch_frames = zeros(composed_frame,1);
for i = 1:composed_frame
    delta = zeros(half_height, half_width, materialFrame);
    for j = 2:materialFrame
        delta(:,:,j) = abs(composedArray(:,:,i)-materialArray(:,:,j));
    end
    single_delta = mean(mean(delta));
    [coefs(i), pitch_frames(i)] = min(single_delta(2:end));
    pitch_frames(i) = pitch_frames(i)+1;
end

%     step 4 :show the results
for i = 1:composed_frame
    disp(strcat('=====ºÏ³ÉÖ¡µÚ ', int2str(half_composed_frame+i), 'Ö¡Æ¥ÅäËØ²ÄµÚ', int2str(pitch_frames(i)), 'Ö¡====='));
end
toc;