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

nbPatch = 2;

unary = zeros(nbPatch, N);
pairwise = sparse(N,N); % poids de voisin
labelcost = [0,1 ; 1,0];
maskTMP = zeros(H,W); % matrice pour fusion les images

for row = 0:H-1
  for col = 0:W-1
    pixel = 1+ row*W + col;
    maskTMP(row+1, col+1) = pixel;
    if row+1 < H, pairwise(pixel, 1+col+(row+1)*W) = smoothness(leftP,[row+1 col+1],rightP,[row+2 col+1]); end
    if row-1 >= 0, pairwise(pixel, 1+col+(row-1)*W) = smoothness(leftP,[row+1 col+1],rightP,[row col+1]); end 
    if col+1 < W, pairwise(pixel, 1+(col+1)+row*W) = smoothness(leftP,[row+1 col+1],rightP,[row+1 col+2]); end
    if col-1 >= 0, pairwise(pixel, 1+(col-1)+row*W) = smoothness(leftP,[row+1 col+1],rightP,[row+1 col]); end 
  end
  unary(:,row*W+1) = [0 1000]'; %cout du pixel
  unary(:,(row+1)*W) = [1000 0]'; 
end

[labels E Eafter] = GCMex(segclass, single(unary), pairwise, single(labelcost),0);

fprintf('E: %d (should be 260), Eafter: %d (should be 44)\n', E, Eafter);
fprintf('unique(labels) should be [0 4] and is: [');
fprintf('%d ', unique(labels));
fprintf(']\n');

labelsId = labels .* (1:N)';

maskA = ismember(maskTMP,labelsId); %part A dans l'overlap
maskB = ones(H,W) - maskA; %part B dans l'overlap

r = (maskA .* rightP(:,:,1)) + (maskB .* leftP(:,:,1));
g = (maskA .* rightP(:,:,2)) + (maskB .* leftP(:,:,2));
b = (maskA .* rightP(:,:,3)) + (maskB .* leftP(:,:,3));
resRGB = zeros(H,W,3);
resRGB(:,:,1) = r;
resRGB(:,:,2) = g;
resRGB(:,:,3) = b;

%ajout de la partie image A (gauche)
finalImg(:,1:widthS,:) = A;
%ajout de la partie image B (droite)
finalImg(:,end-widthS+1:end,:) = B;
%ajout de la partie overlap (centre)
finalImg(:,widthS-overlap+1:widthS,:) = resRGB;

figure(1)
imagesc(finalImg);