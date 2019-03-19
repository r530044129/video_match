clc;clear;
%   step 1 :read composed video
composed_path = 'Shoot/composed/shining_color_change.m4v';
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
jpegFiles = dir(strcat(material_keyframes_path,'/*.JPG')); 
numfiles = length(jpegFiles);
material_keyframes = cell(numfiles, 2);

for k = 1:numfiles 
  jpg_path = fullfile(material_keyframes_path,jpegFiles(k).name);
  temp1 = rgb2gray(imread(jpg_path)); 
  material_keyframes{k, 1} = temp1(1:sample_ratio:Height,1:sample_ratio:Width);
%   temp2 = temp1(1:sample_ratio:Height,1:sample_ratio:Width);
%   material_keyframes{k, 1} = reshape(permute(temp2,[2 1]),[1 pixel_length]);

%   use each composed frame to reduce each key frame of material
  temp2 = abs(composedArray(:,:,1) - material_keyframes{k, 1});
  material_keyframes{k, 2} = mean(mean(temp2));
end
material_keyframes{:, 2}
