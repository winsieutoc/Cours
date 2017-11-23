%%%%%%%%%%%%%%%%%%%%%% MINCUT %%%%%%%%%%%%%%%%%%%%%%%%%

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

e = overlapError(leftP, rightP);

M = zeros(sizeLR(1), sizeLR(2));
sizeM = size(M);

% initialisation de la première ligne de M avec l'erreur
for x = 1:sizeM(2)
    M(1,x) = e(1,x);
end

% initialisation de la première ligne de C
C = M;

% remplissage de M et C
for y = 2:sizeM(1)
    for x = 1:sizeM(2)
        if(x == 1)
            M(y,x) = e(y,x) + min([M(y-1,x),M(y-1,x+1)]);
            argMin = min([M(y-1,x),M(y-1,x+1)]);
            if(argMin == M(y-1,x))
                C(y,x) = x;
            elseif(argMin == M(y-1,x+1))
                C(y,x) = x+1;
            end
        elseif(x == sizeM(2))
            M(y,x) = e(y,x) + min([M(y-1,x-1),M(y-1,x)]);
            argMin = min([M(y-1,x-1),M(y-1,x)]);
            if(argMin == M(y-1,x-1))
                C(y,x) = x-1;
            elseif(argMin == M(y-1,x))
                C(y,x) = x;
            end
        else
            M(y,x) = e(y,x) + min([M(y-1,x-1),M(y-1,x),M(y-1,x+1)]);
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

%recherche du min dans la dernière ligne de M, pour savoir où on commence
minI = M(sizeM(1),1);
I = 1;
for x=3:sizeM(2)
    tmp = M(sizeM(1),x);
    if(minI > tmp)
        minI = tmp;
        I = x;
    end
end

%on remonte jusqu'en haut en choisissant le min des 3 voisins du dessus
for y = heightS:-1:1
    tmpShow(y,I)=1;
    for x = 1:sizeIF(2)
        %place les pixels de A (gauche)
        if(x<widthS-overlap+I)
            finalImg(y,x,:) = A(y,x,:);
        %place les pixels de B (droite)
        elseif(x>widthS-overlap+I)
            xB = x-(widthS-overlap);
            finalImg(y,x,:) = B(y,xB,:);
        %place la moyenne entre le pixel de A et pixel de B à la frontière
        elseif(x==widthS-overlap+I)
            xB = x-(widthS-overlap);
            moyA = A(y,x,:)./2;
            moyB = B(y,xB,:)./2;
            moyenne = moyA+moyB;
            finalImg(y,x,:) = moyenne;
        end
    end
    I = C(y,I);
end

figure(1)
imagesc(finalImg)