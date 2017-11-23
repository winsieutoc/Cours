function [smooth] = smoothness(A, neighbourA, B ,neighbourB)
%SMOOTHNESS Summary of this function goes here
%   Detailed explanation goes here
    smooth = sum(abs(A(neighbourA(1),neighbourA(2),:)-B(neighbourA(1),neighbourA(2),:))+abs(A(neighbourB(1),neighbourB(2),:)-B(neighbourB(1),neighbourB(2),:)),3);
end

