%selection de patch aléatoire
function [ p ] = randPatch(image, sizeP)
    %RANDPATCH Summary of this function goes here
    %   Detailed explanation goes here
    sizeI = size(image);
    x = randi(sizeI(1));
    y = randi(sizeI(2));

    p = image(randi(x-sizeP+1)+(0:sizeP-1),randi(y-sizeP+1)+(0:sizeP-1),:);

end

