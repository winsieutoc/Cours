%tp2

%%%%%%%%%%%%%%%%%%%%%% PatchMatch %%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear

A = imread('a.png');
A = im2double(A);
sizeA = size(A);

figure(1)
imagesc(A)

B = imread('b.png');
B = im2double(B);
sizeB = size(B);

figure(2)
imagesc(B)

sizePix = 1;
sizePatch = 3;

C = zeros(sizeA);
sizeC = size(A);

NNF = zeros(sizeA(1),sizeA(2),2);
sizeNNF = size(NNF);

% Initialisation de la NNF
for x=1+sizePatch:sizeA(1)-sizePatch
    for y=1+sizePatch:sizeA(2)-sizePatch
        xB = randi([sizePatch sizeB(1)-sizePatch],1);
        yB = randi([sizePatch sizeB(2)-sizePatch],1);
        %association du pixel A(x,y) à B(xB,yB)
        pB = assoAB(B,sizePix,xB,yB);
        NNF(x,y,1)=xB;
        NNF(x,y,2)=yB;
        C(x,y,:)= pB;
    end
end

figure(3)
imagesc(C)

%calcul du nombre de pixels avant et après le centre du patch
sizePatchHalf = fix(sizePatch/2);

for passage=1:1
    %initialisation des information pour le passage de gauche à droite et
    %de haut en bas
    if(mod(passage,2)==1)
        step = 1;
        startX = 1+(sizePatch+1);
        toX = sizeNNF(1)-(sizePatch+1);
        startY = 1+(sizePatch+1);
        toY = sizeNNF(2)-(sizePatch+1);
    %initialisation des information pour le passage de droite à gauche et
    %de bas en haut
    elseif(mod(passage,2)==0)
        step = -1;
        toX = 1+(sizePatch+1);
        startX = sizeNNF(1)-(sizePatch+1);
        toY = 1+(sizePatch+1);
        startY = sizeNNF(2)-(sizePatch+1);
    end
    for x=startX:step:toX
       for y=startY:step:toY
           %recupération des coordonnées dans la NNF des voisins de A(x,y) 
           xBMid = NNF(x, y, 1);
           yBMid = NNF(x, y, 2);
           xBNextHori = NNF(x, y-step, 1);
           yBNextHori = NNF(x, y-step, 2);
           xBNextVert = NNF(x-step, y, 1);
           yBNextVert = NNF(x-step, y, 2);

           %création des patchs
           patchA = myPatch(A,sizePatch,x,y);
           patchMid = myPatch(B,sizePatch,xBMid,yBMid);
           patchNextHori = myPatch(B,sizePatch,xBNextHori,yBNextHori-step);
           patchNextVert = myPatch(B,sizePatch,xBNextVert-step,yBNextVert);
    
           %calcul des ssd
           ssdMid = SSD(patchA,patchMid);
           ssdNextHori = SSD(patchA,patchNextHori);
           ssdNextVert = SSD(patchA,patchNextVert);

           %calcul de la ssd minimal
           minSSD = min([ssdMid ssdNextHori ssdNextVert]);

           %recherche de la ssd minimal et mise à jours de NNF
           if(minSSD == ssdMid)
               C(x-fix(sizePatch/2):x+fix(sizePatch/2),y-fix(sizePatch/2):y+fix(sizePatch/2),:) = patchMid;
               NNF(x,y,1)=xBMid;
               NNF(x,y,2)=yBMid;
           elseif(minSSD == ssdNextHori)
               C(x-fix(sizePatch/2):x+fix(sizePatch/2),y-fix(sizePatch/2):y+fix(sizePatch/2),:) = patchNextHori;
               NNF(x,y,1)=xBNextHori;
               NNF(x,y,2)=yBNextHori;
           elseif(minSSD == ssdNextVert)
               C(x-fix(sizePatch/2):x+fix(sizePatch/2),y-fix(sizePatch/2):y+fix(sizePatch/2),:) = patchNextVert;
               NNF(x,y,1)=xBNextVert;
               NNF(x,y,2)=yBNextVert;
           end
       end
    end
end

imagesc(C)
