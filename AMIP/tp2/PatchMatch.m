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

        patchA = myPatch(A,sizePatch,x,y);
        patchB = myPatch(B,sizePatch,xB,yB);
        ssd = SSD(patchB, patchA);

        C(x,y,:)= pB;
    end
end

figure(3)
imagesc(C)

for x=1+(sizePatch+1):sizeNNF(1)-(sizePatch+1)
   for y=1+(sizePatch+1):sizeNNF(2)-(sizePatch+1)
       xBMid = NNF(x, y, 1);
       yBMid = NNF(x, y, 2);
       xBLeft = NNF(x, y-1, 1);
       yBLeft = NNF(x, y-1, 2);
       xBTop = NNF(x-1, y, 1);
       yBTop = NNF(x-1, y, 2);
       
       patchA = myPatch(A,sizePatch,x,y);
       patchMid = myPatch(B,sizePatch,xBMid,yBMid);
       patchLeft = myPatch(B,sizePatch,xBLeft,yBLeft);
       patchTop = myPatch(B,sizePatch,xBTop,yBTop);
       
       ssdMid = SSD(patchA,patchMid);
       ssdLeft = SSD(patchA,patchLeft);
       ssdTop = SSD(patchA,patchTop);
       
       minSSD = min([ssdMid ssdLeft ssdTop]);
       
       if(minSSD == ssdMid)
           C(x-fix(sizePatch/2):x+fix(sizePatch/2),y-fix(sizePatch/2):y+fix(sizePatch/2),:) = patchMid;
           NNF(x,y,1)=xBMid;
           NNF(x,y,2)=yBMid;
       elseif(minSSD == ssdLeft)
           C(x-fix(sizePatch/2):x+fix(sizePatch/2),y-fix(sizePatch/2):y+fix(sizePatch/2),:) = patchLeft;
           NNF(x,y,1)=xBLeft;
           NNF(x,y,2)=yBLeft;
       elseif(minSSD == ssdTop)
           C(x-fix(sizePatch/2):x+fix(sizePatch/2),y-fix(sizePatch/2):y+fix(sizePatch/2),:) = patchTop;
           NNF(x,y,1)=xBTop;
           NNF(x,y,2)=yBTop;
       end
       imagesc(C)
       drawnow
   end
end


% for w=1:size(NNF)
%     if(NNF(w)~=0)
%         x = fix( w / sizeA(2));
%         y = w - x*sizeA(2);
%         patchA = myPatch(A,sizePatch,x,y);
%         ssdmid = SSDNNF(y+x*sizeA(2));
%         if(x>4 && y>4)
%             % SSD LEFT
%             coordXLeft = fix( NNF(w-1)/ sizeB(2));
%             coordYLeft = NNF(w-1)- coordXLeft*sizeB(2);
%             patchBLeft = myPatch(B,sizePatch,coordXLeft,(coordYLeft+1));
%             ssdLeft = SSD(patchBLeft,patchA);
%             % SSD TOP
%             coordXTop = fix( NNF(w-sizeA(2)) / sizeB(2));
%             coordYTop = NNF(w-sizeA(2))- coordXTop*sizeB(2);
%             patchBTop = myPatch(B,sizePatch,(coordXTop-1),coordYTop);
%             ssdTop = SSD(patchBLeft,patchA);
% 
%             if(minSSD>ssdmid)
%                 minSSD=ssdmid;
%                 minX = fix( NNF(w)/ sizeB(2));
%                 minY = w- minX*sizeB(2);
%                 patch = patchA;
%             end
%             if(minSSD>ssdLeft)
%                 minSSD=ssdLeft;
%                 minX = coordXLeft;
%                 minY = coordYLeft-1;
%                 patch = patchBLeft;
%             end
%             if(minSSD>ssdTop)
%                 minSSD=ssdTop;
%                 minX = coordXTop-1;
%                 minY = coordYTop;
%                 patch = patchBTop;
%             end
% 
%             NNF(y+x*sizeA(2))=minY+minX*sizeB(2);
%             SSDNNF(y+x*sizeA(2))=minSSD;
%             C(x-fix(sizePatch/2):x+fix(sizePatch/2),y-fix(sizePatch/2):y+fix(sizePatch/2),:) = patch;
%             imagesc(C);
%             drawnow;
%         end
%     end
% end
