function F = divide_frame(f)
    height = size(f,1);
    width = size(f,2);
%     calculate the mean and the std of 8*8 subframes
    F = zeros(1,ceil(height/8)*ceil(width/8)*2);
    k = 1;
    for h = 1:8:height
        for w = 1:8:width
            F(k) = mean2(f(h:h+7,w:w+7));
            F(k+1) = std2(f(h:h+7,w:w+7));
            k = k+2;
        end
    end
end

