function [ a ] = assoAB( image, sizeP, x, y )
%ASSOAB Summary of this function goes here
%   Detailed explanation goes here

    a = image(randi(x-sizeP+1)+(0:sizeP-1),randi(y-sizeP+1)+(0:sizeP-1),:);

end

