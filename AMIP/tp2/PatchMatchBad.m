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