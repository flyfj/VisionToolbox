
indir = 'C:\Users\feng\Projects\Skeletonization_code\in1\';
indir = 'F:\Depth\RGBD_Saliency\converted\';
exformat = 'png';

outdir = 'C:\Users\feng\Projects\Skeletonization_code\out1\';
%{
erode = 1;
method = 'erode';
radius = 10;
%}
%%{
erode = 0;
method = 'dilate_skel';
radius = 2;
%}

files = dir(sprintf('%s*.%s',indir, exformat));
for i = 1:size(files,1)
   file = files(i).name;
   exname = file(1:length(file)-4);
   BinarySelectionToSkeletonStrokeMasksRunEx(indir, exname, exformat, outdir, erode, radius);
   fprintf('%d/%d\n', i, size(files,1));
end


% exname = 'audience_L'
% BinarySelectionToSkeletonStrokeMasksRunEx(indir,exname,exformat,outdir,erode,radius);
% 
% exname = 'audience_R'
% BinarySelectionToSkeletonStrokeMasksRunEx(indir,exname,exformat,outdir,erode,radius);
% 
% exname = 'bamboo_L'
% BinarySelectionToSkeletonStrokeMasksRunEx(indir,exname,exformat,outdir,erode,radius);
% 


