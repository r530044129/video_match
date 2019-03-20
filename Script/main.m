
% 生成关键帧图
% path = '/Volumes/张仁杰的硬盘/BFA/AKLD/DAY3_20171111';
all_keyframes(path);

% a1 = '/Volumes/张仁杰的硬盘/test/电话短.m4v'
% a2 = '/Volumes/张仁杰的硬盘/BFA/AKLD/DAY1_20171109/Video/Keyframes'
% 从a2的关键帧群中查找a1
aa = scan_all_keyframes_struct(a1,a2);

% 再用findLocation定位