close all
clear

S = imread('text1.jpg');
S = im2double(S);

sizeT = [128, 128];
T = zeros(sizeT(1), sizeT(2), 3);

n = size(S)(1);
m = size(S)(2);

L = 3;

patch = S(randi(n-L+1)+(0:L-1),randi(m-L+1)+(0:L-1),:);

figure
imshow(patch)

centerW = size(T)(1) / 2;
centerH = size(T)(2) / 2;

T(centerW-1:centerW+1, centerH-1:centerH+1, :) = patch;

figure
imshow(T)

M = T;
M(M > 0) = 1;

figure
imshow(M)

%L = M - imdilate(M);
%
%figure 
%imshow(L)

se = strel('square', L);
min = 0;
%while M(M == 0)
for q=1:4

  L = M - imdilate(M, se);
  for x=1:size(L)(1)
    for y=1:size(L)(2)
      if L(x,y,:) == 1
        for i=1:size(S)(1)
          for j=1:size(S)(2)
            SSD(S(i,j), T(x,y));
            min = SSD;
          end
        end
      

end

%M = zeros(sizeT(1), sizeT(2), 3);
%
%for i=1:sizeT(1)
%  for j=1:sizeT(2)
%    if T(i,j,:) > 0
%      M(i,j,:) = 1;
%    end
%  end
%end
%
%figure
%imshow(M)