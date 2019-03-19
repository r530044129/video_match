
vidobj = VideoReader('Shoot/material/shining_snow.m4v');   
N = vidobj.NumberofFrames;
Height = vidobj.Height;
Width = vidobj.Width;
subsize = 8;
F = zeros(N,ceil(Height/subsize)*ceil(Width/subsize)*2);
tic
for i=1:N
    k=read(vidobj,i);
    fr=rgb2gray(k);
    fun_m = @(block_struct) mean2(block_struct.data);
    fun_sigma = @(block_struct) std2(block_struct.data);
    m = blockproc(fr,[subsize subsize],fun_m);
    sigma = blockproc(fr,[subsize subsize],fun_sigma);
    f = vertcat(m(:),sigma(:))';
    F(i,:) = normalize(f,'range');
end
toc