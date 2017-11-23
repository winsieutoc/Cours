function [ e ] = overlapError(part1, part2)
%OVERLAPERROR Summary of this function goes here
%   Detailed explanation goes here
    e = (sum(part1,3)-sum(part2,3)).^2;
end

