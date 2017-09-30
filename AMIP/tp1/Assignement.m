close all
clear

S = imread('text1.jpg');
S = im2double(S);

sizeT = [32, 32];
T = zeros(sizeT(1), sizeT(2), 3);

sizeS = size(S);

n = sizeS(1);
m = sizeS(2);

L = 3;

patch = S(randi(n-L+1)+(0:L-1),randi(m-L+1)+(0:L-1),:);

figure
imagesc(patch)

centerW = sizeT(1) / 2;
centerH = sizeT(2) / 2;

T(centerW-1:centerW+1, centerH-1:centerH+1, :) = patch;

figure
imagesc(T)

M = T;
M(M > 0) = 1;

figure
imagesc(M)

se = strel('square', L);
min = -1;

while M(M==0)==0
    L = M - imdilate(M,se);
    sizeL = size(L);
    for x=1:sizeL(1)
        for y=1:sizeL(2)
            if L(x,y,:) == -1
                for i=1:sizeS(1)
                    for j=1:sizeS(2)
                        if (i==0 || j==0)
                            patch1 = S(i-1:i+1,j-1:j+1);
                            ssd = SSD(patch1, myPatch());
                        end
                    end
                end
            end
        end
    end 
end

%while M(M == 0)
% for q=1:4
% 
%   L = M - imdilate(M, se);
%   for x=1:size(L)(1)
%     for y=1:size(L)(2)
%       if L(x,y,:) == 1
%         for i=1:size(S)(1)
%           for j=1:size(S)(2)
%             SSD(S(i,j), T(x,y));
%             min = SSD;
%           end
%         end
%       
% 
% end

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