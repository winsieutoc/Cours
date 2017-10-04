% TP1

%ASTUCE
%transformer les images en double
close all
clear

S = imread('text1.jpg');
S = im2double(S);
sizeS = size(S);

sizeP = 3;
patch = randPatch(S,sizeP);
figure
imagesc(patch)

sizeT = [98, 98];
T = zeros(sizeT(1), sizeT(2), 3);
centerX = fix(sizeT(1) / 2) - fix(sizeP / 2);
centerY = fix(sizeT(2) / 2) - fix(sizeP / 2);
T(centerX-1:centerX+1, centerY-1:centerY+1, :) = patch;
figure
imagesc(T)

M = T;
M(M > 0) = 1;
M = squeeze(M(:,:,1));

se = strel('square', sizeP);
coordImin = 0;
coordJmin = 0;
while M(M==0)==0
    L = M - imdilate(M,se);
    sizeL = size(L);
    k = find(L==-1);
    for w=1:size(k)
        [x,y] = ind2sub(sizeL, k(w));
        minSSD = -1;
        if(x+sizeP<sizeS(1) && x-sizeP>0 && y-sizeP>0 && y+sizeP<sizeS(2))
            patchT = myPatch(T,sizeP,sizeT(1),x,y).*M(x-sizeP:x+sizeP, y-sizeP:y+sizeP);
            for i=1+sizeP:sizeS(1)-sizeP
                for j=1+sizeP:sizeS(2)-sizeP
                    patchS = myPatch(S,sizeP,sizeS(1),i,j).*M(x-sizeP:x+sizeP, y-sizeP:y+sizeP);
                    ssd = SSD(patchT, patchS);
                    if(ssd<minSSD || minSSD == -1)
                        minSSD = ssd;
                        coordImin = i;
                        coordJmin = j;
                    end
                end
            end
            T(x,y,:) = S(coordImin,coordJmin,:);
            M(x,y,:) = 1;

            imagesc(T)
            drawnow
        end
    end
end