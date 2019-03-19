%% Key Frame Extraction
% Written by Armaan Kohli
% the following program preforms key frame extraction by taking the
% histogram difference between two frames, then testing how much the two
% frames differ, and then extracting frames 
% type == 0 is material; else if composed; 

function generate_key_frame(Path,inputfilename,type)
%     Path = '/Volumes/ÕÅÈÊ½ÜµÄÓ²ÅÌ/test/';
%     inputfilename = 'A012C017_171111_R2G2.mov';
%     Path = strcat('Shoot/material/',inputfilename,'.m4v');  %Video Name  
    vidobj = VideoReader(strcat(Path, inputfilename));   

    % loop through frames to determine mean and stddev
    N=vidobj.NumberofFrames;            
    for i=1:N
        k=read( vidobj,i);          
            if(i~=vidobj.NumberOfFrames);
                j=read(vidobj,i+1);
                fr1=rgb2gray(k);  % conversion to grayscale 
                fr2=rgb2gray(j);
                Hfr1=imhist(fr1);  % calculates histogram of image
                Hfr2=imhist(fr2);
                diff=imabsdiff(Hfr1,Hfr2); % Difference between the two images
                in=sum(diff);
                X(i)=in;
            end
    end
    % extracts frames from threshold cacluated from the std. dev and mean
    mean=mean2(X);
    std=std2(X);
    time = 4;
    threshold=mean+std*time;
    if type == 0
        saveKeyframesPath = fullfile('Keyframes','material',inputfilename);
    else
        saveKeyframesPath = fullfile('Keyframes','composed',inputfilename);
    end
    
    if ~exist(saveKeyframesPath)
        mkdir(saveKeyframesPath)
    end
    for i=1:N
        p=read(vidobj,i);
            if(i~=vidobj.NumberOfFrames)
                j=read(vidobj,i+1);
                fr1=rgb2gray(p);  
                fr2=rgb2gray(j);
                Hfr1=imhist(fr1);  
                Hfr2=imhist(fr2);
                diff=imabsdiff(Hfr1,Hfr2);
                in=sum(diff);
                if(in>threshold)  
                    filename = fullfile(saveKeyframesPath, sprintf('frame_%05d.JPG', i));  
                    imwrite(j, filename);
                end 
            end
    end 
end