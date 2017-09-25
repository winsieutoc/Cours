% TP1

%ASTUCE
%transformer les images en double

mat1 = imread('text1.jpg');
mat2 = imread('text2.png');

sizeP = 9;

p1 = patchImg(mat1, sizeP-1);
p2 = patchImg(mat1, sizeP-1);
p3 = patchImg(mat1, sizeP-1);
p4 = patchImg(mat1, sizeP-1);


