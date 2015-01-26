function [ output_args ] = visualize_search_res( html_fn, query_fns, ranked_res_fns, topK )
%VISUALIZE_SEARCH_RES Summary of this function goes here
%   query_fns: Nx1 cell containing query filename
%   ranked_res_fns: NxM cell containing query search result filename

fp = fopen(html_fn, 'w');
fprintf(fp, '<html><head><title>Test results</title></head><body><table><tbody><tr><td>Query</td>');
for k = 1: topK
    fprintf(fp, '<td>%d</td>', k);
end
fprintf(fp, '</tr>');
tic;
for k = 1: size(query_fns, 1)
    % show results
    fprintf(fp, '<tr>');
    qimg = query_fns{k};
    substrs = strsplit(qimg, '\');
    pos = strfind(substrs{end}, '.');
    qobj_id = substrs{end}(1:pos-1);
    fprintf(fp, '<td><img src="%s" alt="Query" style="margin-right: 20px; width: 100px; border-right: solid 3px red;" /><h3>%s</h3></td>', qimg, qobj_id);
    prev_res_id = '';
    obj_num = 0;
    i = 1;
    while obj_num < topK
        if(i == size(ranked_res_fns, 2))
            break;
        end
        res_file = ranked_res_fns{k, i};
        substrs = strsplit(res_file, '\');
        pos = strfind(substrs{end}, '.');
        robj_id = substrs{end}(1:pos-1);
        % skip if same object as query or previous result
        i = i + 1;
        if(strcmp(qobj_id, robj_id) || strcmp(prev_res_id, robj_id))
            continue;
        end
        fprintf(fp, '<td><img src="%s" alt="%f" style="width: 100px"/><h3>%s</h3></td>', res_file, 0, robj_id);
        obj_num = obj_num + 1;
        prev_res_id = robj_id;
    end
    
    fprintf(fp, '</tr>');
end
toc;
fprintf(fp, '</table></body></html>');
fclose(fp);



end

