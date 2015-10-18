function BinarySelectionToSkeletonStrokeMasksRunEx(indir,exname,exformat,outdir,erode,radius)

infile = sprintf('%s/%s.%s',indir,exname,exformat);
M = imread(infile);
M = M(:,:,1);
M = M > 127;

[F,B] = BinarySelectionToSkeletonStrokeMasks(M,erode,radius);

outfileF = sprintf('%s/%s_skelF.%s',outdir,exname,exformat);
outfileB = sprintf('%s/%s_skelB.%s',outdir,exname,exformat);

imwrite(F,outfileF,exformat);
imwrite(B,outfileB,exformat);

end
