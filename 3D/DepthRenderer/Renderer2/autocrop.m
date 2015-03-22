function im2 = autocrop(im, background)

if (~exist('background', 'var')); background = 0; end
if (size(im, 3) ~= 0); immask = im(:, :, 1); end;
[y, x] = ind2sub(size(immask), find(immask ~= background));
minx = min(x); maxx = max(x);
miny = min(y); maxy = max(y);

im2 = im(miny: maxy, minx: maxx, :);

end