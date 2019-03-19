clc;clear;
%   step 1 :read composed video
composed_path = 'Shoot/composed/shining_cartoon.m4v';
composedObj = VideoReader(composed_path);
composed_frame = 1;

Height = composedObj.Height;
Width = composedObj.Width;
sample_ratio = 4;
half_height = ceil(Height/sample_ratio);
half_width = ceil(Width/sample_ratio);
pixel_length = half_height*half_width;
%   half_composed_frame is half of composed video frames 
half_composed_frame = ceil(composedObj.NumberOfFrames/2);
composedArray = zeros(half_height, half_width, composed_frame,'uint8');
composedObj = VideoReader(composed_path);
for k = 1:composed_frame
    temp = rgb2gray(read(composedObj,composed_frame+k));
    composedArray(:,:,k) = temp(1:sample_ratio:Height,1:sample_ratio:Width);
end

%   step 2 :read meterial key frames
material_keyframes_path = fullfile('Keyframes','material');
keyframesFiles = dir(strcat(material_keyframes_path)); 
numfiles = length(keyframesFiles);
temp = cell(numfiles,1);
keyframesStruct = struct('shootName',temp,'minMean',temp,'value',0);
for k = 1:numfiles
    single_material_keyframes_path = fullfile(material_keyframes_path,keyframesFiles(k).name);
    singleKeyframesFiles = dir(strcat(single_material_keyframes_path,'/*JPG'));
    singleKeyframes = length(singleKeyframesFiles);
    allKeyframesMean = zeros(singleKeyframes,1);
%     caculate min_delta_mean key frames at each file
    for j = 1:singleKeyframes
        jpg_path = fullfile(single_material_keyframes_path,singleKeyframesFiles(j).name);
        temp1 = rgb2gray(imread(jpg_path)); 
        if size(temp1,1) ~= Height
            ptime = size(temp1,1)/Height;
            temp1_scaled = temp1(1:(sample_ratio*ptime):(Height*ptime),...
            1:(sample_ratio*ptime):(Width*ptime));
        else
            temp1_scaled = temp1(1:sample_ratio:Height,...
            1:sample_ratio:Width);
        end
        diff = imabsdiff(composedArray(:,:,1),temp1_scaled);
        allKeyframesMean(j,1) = mean2(diff);
    end
    keyframesStruct(k).shootName = keyframesFiles(k).name;
    keyframesStruct(k).minMean = min(allKeyframesMean);
end
    