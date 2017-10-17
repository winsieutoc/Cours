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

sizeForNNF = size(A,1)*size(A,2);

NNF = zeros(sizeForNNF,1);
sizeNNF = size(NNF);
SSDNNF = zeros(sizeNNF);

for x=1+sizePatch:sizeA(1)-sizePatch
    for y=1+sizePatch:sizeA(2)-sizePatch
        xB = randi(sizeB(1));
        yB = randi(sizeB(2));
        if(xB+sizePatch<sizeB(1) && xB-sizePatch>0 && yB-sizePatch>0 && yB+sizePatch<sizeB(2))
            pB = assoAB(B,sizePix,xB,yB);
            NNF(y+x*sizeA(2))=yB+xB*sizeB(2);

            patchA = myPatch(A,sizePatch,sizeA(1),x,y);
            patchB = myPatch(B,sizePatch,sizeB(1),xB,yB);
            ssd = SSD(patchB, patchA);
            SSDNNF(y+x*sizeA(2))=ssd;

            C(x,y,:)= pB;
        end
    end
end

figure(3)
imagesc(C)

ssdmid = 0;
ssdLeft = 0;
coordXLeft = 0;
coordYLeft = 0;
ssdTop = 0;
coordXTop = 0;
coordYTop = 0;
minSSD = 9000;
minX = 0;
minY = 0;

for w=1:size(NNF)
    if(NNF(w)~=0)
        x = fix( w / sizeA(2));
        y = w - x*sizeA(2);
        patchA = myPatch(A,sizePatch,sizeA(1),x,y);
        ssdmid = SSDNNF(y+x*sizeA(2));
        if(x>4 && x<sizeA(2)-4 && y>4 && y<sizeA(2))
            % SSD LEFT
            coordXLeft = fix( NNF(w-1)/ sizeA(2));
            coordYLeft = NNF(w-1)- coordXLeft*sizeA(2);
            patchBLeft = myPatch(B,sizePatch,sizeB(1),coordXLeft,(coordYLeft+1));
            ssdLeft = SSD(patchBLeft,patchA);
            % SSD TOP
            coordXTop = fix( NNF(w-sizeA(2)) / sizeA(2));
            coordYTop = NNF(w-sizeA(2))- coordXTop*sizeA(2);
            patchBTop = myPatch(B,sizePatch,sizeB(1),(coordXTop-1),coordYTop);
            ssdTop = SSD(patchBLeft,patchA);

            if(minSSD>ssdmid)
                minSSD=ssdmid;
                minX = x;
                minY = y;
            end
            if(minSSD>ssdLeft)
                minSSD=ssdLeft;
                minX = coordXLeft;
                minY = coordYLeft-1;
            end
            if(minSSD>ssdTop)
                minSSD=ssdTop;
                minX = coordXTop-1;
                minY = coordYTop;
            end

            NNF(y+x*sizeA(2))=minY+minX*sizeB(2);
            SSDNNF(y+x*sizeA(2))=minSSD;
            
            C(x,y,:)=B(minX,minY,:);
            imagesc(C);
            drawnow;
        end
    end
end
