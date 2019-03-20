function all_keyframes(path)
    tic
    % path = '/Volumes/���ʽܵ�Ӳ��/BFA/AKLD/DAY3_20171111';
    waitFiles = dir(strcat(path,'/A*'));
    numfiles = length(waitFiles);

    h=waitbar(0,'please wait');
    for k = 1:numfiles
        filePath = fullfile(path,waitFiles(k).name);
        generate_key_frame_by_paper(filePath);
        str=['������...',num2str(k/numfiles*100),'%'];
        waitbar(k/(numfiles),h,str)
    end
    delete(h);
    toc
end