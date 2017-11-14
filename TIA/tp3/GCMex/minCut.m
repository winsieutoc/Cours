%tp3

%%%%%%%%%%%%%%%%%%%%%% MINCUT %%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear

A = imread('text1.jpg');
A = im2double(A);
sizeA = size(A);
widthSize = Size(A,1);
heightSize = Size(A,2);

B = A;
sizeB = sizeA;

overlap = 8;

M = zeros((widthSize-overlap)+widthSize, heightSize);
sizeM = size(M);

firstPartM = a(:, heightSize-overlap+1:heightSize,:);
secondPartM = a(:, 1:overlap, :);

overlapErr = overlapError(firstPartM, secondPartM);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%labelcost: delta c = ( 0 1 )
%                     ( 1 0 )
