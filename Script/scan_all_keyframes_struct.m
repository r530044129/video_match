function keyframesStruct = scan_all_keyframes_struct(composed_path, material_keyframes_path)
    %   step 1 :read composed video
%     composed_path = '/Volumes/张仁杰的硬盘/test/电话短.m4v';

% a1 = '/Volumes/张仁杰的硬盘/test/电话短.m4v'
% a2 = '/Volumes/张仁杰的硬盘/BFA/AKLD/DAY1_20171109/Video/Keyframes'

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
        temp1 = rgb2gray(read(composedObj,composed_frame+k));
        composedArray(:,:,k) = temp1(1:sample_ratio:Height,1:sample_ratio:Width);
    end

    %   step 2 :read meterial key frames
%     material_keyframes_path = 'Keyframes/material';
    % files name start at 'A'
    keyframesFiles = dir(strcat(material_keyframes_path,'/A*')); 
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
            temp2 = rgb2gray(imread(jpg_path)); 
            if Height == 402 && size(temp2,1) == 540
                temp2 = temp2(70:(70+402-1),:);
            end
            temp2_scaled = temp2(1:sample_ratio:Height,1:sample_ratio:Width);
%             if size(temp1,1) ~= Height
%                 ptime = size(temp1,1)/Height;
%                 temp3_scaled = temp3(1:(sample_ratio*ptime):(Height*ptime),...
%                 1:(sample_ratio*ptime):(Width*ptime));
%             else
%                 temp3_scaled = temp3(1:sample_ratio:Height,...
%                 1:sample_ratio:Width);
%             end
            diff = imabsdiff(composedArray(:,:,1),temp2_scaled);
            allKeyframesMean(j,1) = mean2(diff);
        end
        keyframesStruct(k).shootName = keyframesFiles(k).name;
        keyframesStruct(k).minMean = min(allKeyframesMean);
    end
end
    