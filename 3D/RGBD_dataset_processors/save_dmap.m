function [ output_args ] = save_dmap( dmap_mat, savefn )
%CONVERT_DMAPS Summary of this function goes here
%   Detailed explanation goes here

fid = fopen(savefn, 'w');
sz = size(dmap_mat);
fprintf(fid, '%d %d\n', sz(2), sz(1));
dmap_mat = double(dmap_mat);
for r=1:size(dmap_mat,1)
    for c=1:size(dmap_mat,2)
        if c>1
            fprintf(fid, ' ');
        end
        fprintf(fid, '%f', dmap_mat(r,c));
    end
    fprintf(fid, '\n');
end

fclose(fid);

end

