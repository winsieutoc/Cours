%patch centré en i et j et de la taille sizeP
function [ p ] = myPatch( image, sizeP, sizeT, i, j)
    %MYPATCH Summary of this function goes here
    %   Detailed explanation goes here
    
    p = image(i-sizeP:i+sizeP, j-sizeP:j+sizeP, :);

end

