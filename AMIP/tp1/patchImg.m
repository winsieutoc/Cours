function [ p ] = patchImg(mat, sizeP)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    sizeI = size(mat);
    x = randi(sizeI(1));
    y = randi(sizeI(2));
%     
%     if x > (sizeI(1)-sizeP)
%         x = sizeI(1)-sizeP;
%     
%     elseif y > (sizeI(2)-sizeP)
%         y = sizeI(2)-sizeP;
%     end
    
    p = mat(x:x+sizeP, y:y+sizeP);
    
end
   