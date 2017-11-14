function [ e ] = overlapError(part1, part2)
%OVERLAPERROR Summary of this function goes here
%   Detailed explanation goes here
    e = zeros(size(part1,1), size(part1,2), 1);
    sizeE = size(e);
    for x=1:sizeE(1)
        for y=1:sizeE(2)
            e(x,y) = sum(part1(x,y,:)-part2(x,y,:).^2,3);
        end
    end
end

