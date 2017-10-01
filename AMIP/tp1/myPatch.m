function [ p ] = myPatch( image, sizeP, i, j )
    %MYPATCH Summary of this function goes here
    %   Detailed explanation goes here
    x = i;
    y = j;

    p = image(randi(x-sizeP+1)+(0:sizeP-1),randi(y-sizeP+1)+(0:sizeP-1),:);

end

