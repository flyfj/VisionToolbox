function [F,B] = BinarySelectionToSkeletonStrokeMasks(M,erode,radius)

% erode = 0 ==> compute the skeleton and then dilate with a disk of given radius
% erode = 1 ==> erode with a disk of given radius

se = strel('disk',radius,8);

if (erode)
F = imerode(M,se);
B = imerode(~M,se);
else
F = bwmorph(M,'skel',inf);
B = bwmorph(~M,'skel',inf);
F = imdilate(F,se);
F = F & M;
B = imdilate(B,se);
B = B & ~M;
end

F = im2uint8(F);
B = im2uint8(B);

end
