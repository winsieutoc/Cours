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

C = zeros(sizeB);
sizeC = size(B);

for x=1:sizeB(1)
    for y=1:sizeB(2)
        patch = randPatch(B,sizePix);
        C(x,y,:)=patch;
    end
end

figure(3)
imagesc(C)

minSSD = intmax;
coordXA = 0;
coordYA = 0;
for x=1:sizeC(1)
    for y=1:sizeC(2)
        a = C(x,y,:);
        for i=1:sizeA(1)
            for j=1:sizeA(2)
                b = A(i,j,:);
                if isequal(a,b)
                    %calcul de la SSD entre top et left !
                    ssd = SSD(a,b);
                    if ssd < minSSD
                        minSSD = ssd;
                        coordXA = i;
                        coordYA = j;
                    end
                end
            end
        end
        coordXA
        coordYA
    end
end
