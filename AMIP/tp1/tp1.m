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

T((sizeT(1)-nbP+1)/2: (sizeT(1)+nbP-1)/2,(sizeT(2)-nbP+1)/2: (sizeT(2)+nbP-1)/2, :) = patch;

figure
imagesc(T)

M = T;
M(M > 0) = 1;

se = strel('square', nbP);
coordImin = 0;
coordJmin = 0;

while M(M==0)==0
    L = M - imdilate(M,se);
    sizeL = size(L);
    figure(4)
    imagesc(M)
    drawnow
    k = find(L==-1);
    for w=1:size(k)
        [x,y] = ind2sub(sizeL, k(w));
        minSSD = -1;
        if(x + nbP < sizeS(1) && x - nbP > 0 && y - nbP >0 && y + nbP < sizeS(2))
            x
            y
            patchT = myPatch(T,nbP,sizeT(1),x,y);
            for i=1:sizeS(1)
                for j=1:sizeS(2)
                    patchS = myPatch(S,nbP,sizeS(1),i,j);
                    ssd = SSD(patchS, patchT);
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

            imagesc(M)
            drawnow
        end
    end
    premierwhilefini=1
end