% Unsupervised adaptive key frame extraction

function generate_key_frame_by_paper(Path)
    [filepath,name,ext] = fileparts(Path);
    % step 1
%     inputfilename = 'shining_woman';
    % vidobj = VideoReader(strcat('Shoot/material/','shining_woman','.m4v'));
    vidobj = VideoReader(Path); 
    tic
    N = vidobj.NumberofFrames;
%   N = ceil(N/2);
    Height = vidobj.Height;
    Width = vidobj.Width;
    
    sample_ratio = 4;
    half_height = ceil(Height/sample_ratio);
    half_width = ceil(Width/sample_ratio);
    
    subsize = 8;
    Fsize = subsize * sample_ratio;
    F = zeros(N,ceil(Height/Fsize)*ceil(Width/Fsize)*2);
    fun_m = @(block_struct) mean2(block_struct.data);
    fun_sigma = @(block_struct) std2(block_struct.data);
    
    parfor i=1:N
        k = read(vidobj,i);
        temp = rgb2gray(k);
        fr = temp(1:sample_ratio:Height,1:sample_ratio:Width);
        m = blockproc(fr,[subsize subsize],fun_m);
        sigma = blockproc(fr,[subsize subsize],fun_sigma);
        f = vertcat(m(:),sigma(:))';
        F(i,:) = normalize(f,'range');
    end

    % step 2 
    T = 1.5;
    saveKeyframesPath = fullfile('Keyframes',name);
    if ~ exist(saveKeyframesPath,'dir')
        mkdir(saveKeyframesPath)
    end
    clear omega;
    Nc = 1;
    omega{Nc} = [1]; 
    D = length(omega{end});
    C = omega{end}(ceil(D/2));
    for i = 2:N
        if i == N
            C = ceil(D/(D+1)+1/(D+1)*i);
        end
        Mindis = zeros(1,Nc);
        for k = 1:Nc
            D = length(omega{k});
            C = omega{k}(ceil(D/2));
            Mindis(k) = sqrt(sum((F(C,:)-F(i,:)).^2));
        end
        [coes, num] = min(Mindis);
        if  coes < T
            omega{num}(end+1) = i;
        else
            Nc = Nc+1;
            omega{Nc} = i;
        end
    end
    % write keyframes
    for i = 1:Nc
        L = length(omega{i});
        if L > N/Nc
            num = omega{i}(ceil(L/2));
            filename = fullfile(saveKeyframesPath, sprintf('frame_%05d.JPG', num)); 
            I = read(vidobj,num);
            imwrite(I, filename);
        end
    end
    toc
end