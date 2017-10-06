% TP1
%ASTUCE
%transformer les images en double

%%%%%%%%%%%%%%%%%%% TEXTURE SYNTHESIS %%%%%%%%%%%%%%%%%%
close all
clear

S = imread('text1.jpg');
S = im2double(S);
sizeS = size(S);

sizeP = 3;
patch = randPatch(S,sizeP);
figure
imagesc(patch)

T = zeros(sizeS);
sizeT = size(T);
%calcul du centre de T
%fonction fix() permet d'avoir la partie entière de la division euclidienne
centerX = fix(sizeS(1) / 2) - fix(sizeP / 2);
centerY = fix(sizeS(2) / 2) - fix(sizeP / 2);
%On place le patch au centre de T
T(centerX-1:centerX+1, centerY-1:centerY+1, :) = patch;
figure
imagesc(T)

%création du Mask
M = T;
M(M > 0) = 1;
M = squeeze(M(:,:,1));

se = strel('square', sizeP);
coordImin = 0;
coordJmin = 0;
while M(M==0)==0
    %dilatation afin d'avoir le contour de pixel au tour de la texture T
    L = M - imdilate(M,se);
    sizeL = size(L);
    %k un tableau à 1 dimension permettant d'avoir les coordonnées dans L
    %ou le pixel vaux -1
    k = find(L==-1);
    for w=1:size(k)
        %coordonnée ou il y a un -1 dans L
        [x,y] = ind2sub(sizeL, k(w));
        minSSD = -1;
        %pseudo gestion des bords
        if(x+sizeP<sizeS(1) && x-sizeP>0 && y-sizeP>0 && y+sizeP<sizeS(2))
            %selection de patch dans T
            patchT = myPatch(T,sizeP,sizeT(1),x,y).*M(x-sizeP:x+sizeP, y-sizeP:y+sizeP);
            %parcours de la texture d'origine
            for i=1+sizeP:sizeS(1)-sizeP
                for j=1+sizeP:sizeS(2)-sizeP
                    %selection de patch dans la texture d'origine
                    patchS = myPatch(S,sizeP,sizeS(1),i,j).*M(x-sizeP:x+sizeP, y-sizeP:y+sizeP);
                    %calcul de la SSD
                    ssd = SSD(patchT, patchS);
                    if(ssd<minSSD || minSSD == -1)
                        minSSD = ssd;
                        coordImin = i;
                        coordJmin = j;
                    end
                end
            end
            %coloration du pixel
            T(x,y,:) = S(coordImin,coordJmin,:);
            M(x,y,:) = 1;

            imagesc(T)
            drawnow
        end
    end
end