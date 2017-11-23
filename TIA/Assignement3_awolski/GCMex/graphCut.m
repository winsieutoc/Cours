%%%%%%%%%%%%%%%%%%%%%% GRAPHCUT %%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear

A = imread('text1.jpg');
A = im2double(A);
sizeA = size(A);
widthS = sizeA(2);
heightS = sizeA(1);
B = A;
sizeB = sizeA;

overlap = 16;

finalImg = zeros(heightS, (widthS*2)-overlap,3);
sizeIF = size(finalImg);

leftP = A(:, widthS-overlap+1:widthS, :);
rightP = B(:, 1:overlap, :);
sizeLR = size(leftP);

H = sizeLR(1);
W = sizeLR(2);
N = H * W;
segclass = zeros(N,1);

nbClass = 2; %%%%%%%%%%%%%%%%%%%%%%% ???????????????

unary = zeros(nbClass, N);
pairwise = sparse(N,N);
labelcost = [0,1 ; 1,0];
tmpMask = zeros(H,W);

for row = 0:H-1
  for col = 0:W-1
    pixel = 1+ row*W + col;
    tmpMask(row+1, col+1) = pixel;
    if row+1 < H, pairwise(pixel, 1+col+(row+1)*W) = smoothness(leftP,[row+1 col+1],rightP,[row+2 col+1]); end
    if row-1 >= 0, pairwise(pixel, 1+col+(row-1)*W) = smoothness(leftP,[row+1 col+1],rightP,[row col+1]); end 
    if col+1 < W, pairwise(pixel, 1+(col+1)+row*W) = smoothness(leftP,[row+1 col+1],rightP,[row+1 col+2]); end
    if col-1 >= 0, pairwise(pixel, 1+(col-1)+row*W) = smoothness(leftP,[row+1 col+1],rightP,[row+1 col]); end 
    if pixel < 25
      unary(:,pixel) = [0 1000]'; 
    else
      unary(:,pixel) = [1000 0]'; 
    end
  end
end

[labels E Eafter] = GCMex(segclass, single(unary), pairwise, single(labelcost),0);

fprintf('E: %d (should be 260), Eafter: %d (should be 44)\n', E, Eafter);
fprintf('unique(labels) should be [0 4] and is: [');
fprintf('%d ', unique(labels));
fprintf(']\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ????????????????????

labelsId = labels .* (1:N)';

maskA = ismember(tmpMask,labelsId);
maskB = ones(H,W) - maskA;

size(maskA)
size(maskB)

res1 = (maskA .* rightP(:,:,1)) + (maskB .* leftP(:,:,1));
res2 = (maskA .* rightP(:,:,2)) + (maskB .* leftP(:,:,2));
res3 = (maskA .* rightP(:,:,3)) + (maskB .* leftP(:,:,3));
res = zeros(H,W,3);
res(:,:,1) = res1;
res(:,:,2) = res2;
res(:,:,3) = res3;


finalImg(:,1:widthS,:) = A;
% Add patch B
finalImg(:,end-widthS+1:end,:) = B;
% Add computed overlap
finalImg(:,widthS-overlap+1:widthS,:) = res;

figure(1)
imagesc(finalImg);