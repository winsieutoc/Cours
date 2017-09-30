function [ res ] = SSD( patch1, patch2 )
%SSD Summary of this function goes here
%   Detailed explanation goes here

res = sum(sum(patch1-patch2).^2);

end

