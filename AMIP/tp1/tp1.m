% TP1

%ASTUCE
%transformer les images en double

close all
clear

S = imread('text1.jpg');
S = im2double(S);
sizeS = size(S);

sizeT = [32, 32];
T = zeros(sizeT(1), sizeT(2), 3);

nbP = 3;
patch = randPatch(S,nbP);

figure
imagesc(patch)

centerW = sizeT(1) / 2;
centerH = sizeT(2) / 2;

T(centerW-1:centerW+1, centerH-1:centerH+1, :) = patch;

figure
imagesc(T)

M = T;
M(M > 0) = 1;

se = strel('square', nbP);
minSSD = 9000;

while M(M==0)==0
    L = M - imdilate(M,se);
    sizeL = size(L);
    for x=1:sizeL(1)
        for y=1:sizeL(2)
            if L(x,y,:) == -1
                for i=1:sizeS(1)
                    for j=1:sizeS(2)
                        coordImin = i
                        coordJmin = j
                        if(i==0 | j==0)
                            patch1 = myPatch(S,nbP,i+1,j+1);
                        end
                        if(i==32 | j==32)
                            patch1 = myPatch(S,nbP,i-1,j-1);
                        end
%                         if(j==0)
%                             patch1 = myPatch(S,nbP,i,j+1);
%                         end
%                         if(j==32)
%                             patch1 = myPatch(S,nbP,i,j-1);
%                         end
                        patch2 = myPatch(T,nbP,x,y);
                        ssd = SSD(patch, patch);
                        if(ssd<minSSD)
                            minSSD = ssd;
                            coordImin = i
                            coordJmin = j
                        end
                    end
                end
                T(x,y) = S(coordImin,coordJmin);
            end
        end
    end 
end