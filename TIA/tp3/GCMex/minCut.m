%tp3

%%%%%%%%%%%%%%%%%%%%%% MINCUT %%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear

A = imread('text1.jpg');
A = im2double(A);
sizeA = size(A);
widthSize = sizeA(2);
heightSize = sizeA(1);

B = A;
sizeB = sizeA;

overlap = 8;

finalImg = zeros(heightSize, (widthSize*2)-overlap,3);
sizeIF = size(finalImg);

leftPart = A(:, widthSize-overlap+1:widthSize, :);
rightPart = B(:, 1:overlap, :);
sizeLeft = size(leftPart);

overlapErr = overlapError(leftPart, rightPart);

M = zeros(sizeLeft(1), sizeLeft(2));
sizeM = size(M);
Toto = M;

for x = 1:sizeM(2)
    M(1,x) = overlapErr(1,x);
end

C = M;

for y = 2:sizeM(1)
    for x = 2:sizeM(2)
        if(x == 1)
            M(y,x) = overlapError(y,x) + min([M(y-1,x),M(y-1,x+1)]);
            argMin = min([M(y-1,x),M(y-1,x+1)]);
            if(argMin == M(y-1,x))
                C(y,x) = x;
            elseif(argMin == M(y-1,x+1))
                C(y,x) = x+1;
            end
        elseif(x == sizeM(2))
            M(y,x) = overlapError(y,x) + min([M(y-1,x-1),M(y-1,x)]);
            argMin = min([M(y-1,x-1),M(y-1,x)]);
            if(argMin == M(y-1,x-1))
                C(y,x) = x-1;
            elseif(argMin == M(y-1,x))
                C(y,x) = x;
            end
        else
            M(y,x) = overlapError(y,x) + min([M(y-1,x-1),M(y-1,x),M(y-1,x+1)]);
            argMin = min([M(y-1,x-1),M(y-1,x),M(y-1,x+1)]);
            if(argMin == M(y-1,x-1))
                C(y,x) = x-1;
            elseif(argMin == M(y-1,x))
                C(y,x) = x;
            elseif(argMin == M(y-1,x+1))
                C(y,x) = x+1;
            end
        end
    end
end

minI = M(sizeM(1),2);
I = 2;
for x=3:sizeM(2)
    tmp = M(sizeM(1),x);
    if(minI > tmp)
        minI = tmp;
        I = x;
        test = I
    end
end

for y = heightSize:-1:1
    Toto(y,I)=1;
    for x = 1:sizeIF(2)
        if(x<widthSize-overlap+1+I)
            finalImg(y,x,:) = A(y,x,:);
        elseif(x>widthSize-overlap+1+I)
            xB = x-(widthSize-overlap+1);
            finalImg(y,x,:) = B(y,xB,:);
        end
    end
    I = C(y,I);
end

figure(1)
imagesc(finalImg)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%labelcost: delta c = ( 0 1 )
%                     ( 1 0 )
