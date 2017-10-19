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

for x=1+sizePatch:sizeA(1)-sizePatch
    for y=1+sizePatch:sizeA(2)-sizePatch
        xB = randi([sizePatch sizeB(1)-sizePatch],1);
        yB = randi([sizePatch sizeB(2)-sizePatch],1);
        pB = assoAB(B,sizePix,xB,yB);
        NNF(x,y,1)=xB;
        NNF(x,y,2)=yB;
        C(x,y,:)= pB;
    end
end

figure(3)
imagesc(C)

for passage=1:10
    if(mod(passage,2)==1)
        step = 1;
        startX = 1+(sizePatch+1);
        toX = sizeNNF(1)-(sizePatch+1);
        startY = 1+(sizePatch+1);
        toY = sizeNNF(2)-(sizePatch+1);
    elseif(mod(passage,2)==0)
        step = -1;
        toX = 1+(sizePatch+1);
        startX = sizeNNF(1)-(sizePatch+1);
        toY = 1+(sizePatch+1);
        startY = sizeNNF(2)-(sizePatch+1);
    end
    for x=startX:step:toX
       for y=startY:step:toY
           xBMid = NNF(x, y, 1);
           yBMid = NNF(x, y, 2);
           xBNextHori = NNF(x, y-step, 1);
           yBNextHori = NNF(x, y-step, 2);
           xBNextVert = NNF(x-step, y, 1);
           yBNextVert = NNF(x-step, y, 2);

           patchA = myPatch(A,sizePatch,x,y);
           patchMid = myPatch(B,sizePatch,xBMid,yBMid);
           patchNextHori = myPatch(B,sizePatch,xBNextHori,yBNextHori-step);
           patchNextVert = myPatch(B,sizePatch,xBNextVert-step,yBNextVert);

           ssdMid = SSD(patchA,patchMid);
           ssdNextHori = SSD(patchA,patchNextHori);
           ssdNextVert = SSD(patchA,patchNextVert);

           minSSD = min([ssdMid ssdNextHori ssdNextVert]);

           if(minSSD == ssdMid)
               C(x-fix(sizePatch/2):x+fix(sizePatch/2),y-fix(sizePatch/2):y+fix(sizePatch/2),:) = patchMid;
               %C(x,y,:)=B(xBMid,yBMid,:);
               NNF(x,y,1)=xBMid;
               NNF(x,y,2)=yBMid;
           elseif(minSSD == ssdNextHori)
               C(x-fix(sizePatch/2):x+fix(sizePatch/2),y-fix(sizePatch/2):y+fix(sizePatch/2),:) = patchNextHori;
               %C(x,y,:)=B(xBNextHori,yBNextHori,:);
               NNF(x,y,1)=xBNextHori;
               NNF(x,y,2)=yBNextHori;
           elseif(minSSD == ssdNextVert)
               C(x-fix(sizePatch/2):x+fix(sizePatch/2),y-fix(sizePatch/2):y+fix(sizePatch/2),:) = patchNextVert;
               %C(x,y,:)=B(xBNextVert,yBNextVert,:);
               NNF(x,y,1)=xBNextVert;
               NNF(x,y,2)=yBNextVert;
           end
       end
    end
end

imagesc(C)
