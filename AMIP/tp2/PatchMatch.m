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





% minSSD = intmax;
% coordXA = 0;
% coordYA = 0;
% for x=1:sizeC(1)
%     for y=1:sizeC(2)
%         a = C(x,y,:);
%         for i=1:sizeA(1)
%             for j=1:sizeA(2)
%                 b = A(i,j,:);
%                 if isequal(a,b)
%                     %calcul de la SSD entre top et left !
%                     ssd = SSD(a,b);
%                     if ssd < minSSD
%                         minSSD = ssd;
%                         coordXA = i;
%                         coordYA = j;
%                     end
%                 end
%             end
%         end
%         coordXA
%         coordYA
%     end
% end
