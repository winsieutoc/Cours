%patch centr� en i et j et de la taille sizeP
function [ p ] = myPatch( image, sizeP, sizeT, i, j)
    %MYPATCH Summary of this function goes here
    %   Detailed explanation goes here

%%%%%%%%%%%%% ESSAI GESTION DES BORDS %%%%%%%%%%%%%%%%%%%%%%%  
%     b = fix(sizeP/2);
% 
%     if isequal(i,1) && isequal(j,1)
%         p = image(i:i+(sizeP-1), j:j+(sizeP-1), :);
%     elseif isequal(i,1) && j<sizeT
%         p = image(i:i+(sizeP-1), j-b:j+b, :);
%     elseif isequal(j,1) && i<sizeT
%         p = image(i-b:i+b, j:j+(sizeP-1), :);
%         
%     elseif isequal(i,1) && isequal(j,sizeT)
%         p = image(i:i+(sizeP-1), j-(b*2):j, :);
%     elseif isequal(j,1) && isequal(i,sizeT)
%         p = image(i-(b*2):i, j:j+(sizeP-1), :);
%         
%     elseif isequal(i,sizeT) && isequal(j,sizeT)
%         p = image(i-(b*2):i, j-(b*2):j, :);
%     elseif isequal(i,sizeT) && j>1
%         p = image(i-(b*2):i, j-b:j+b, :);
%     elseif isequal(j,sizeT) && i>1
%         p = image(i-b:i+b, j-(b*2):j, :);
%         
%     else
%         p = image(i-b:i+b, j-b:j+b, :);
%     end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    p = image(i-sizeP:i+sizeP, j-sizeP:j+sizeP, :);

end

