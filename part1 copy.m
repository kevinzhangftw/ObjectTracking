clear all, close all
%In = imread('swain_database/.sqr.128.bmp');
 In = imread('swain_database/crunchberries.sqr.128.bmp');
% imshow(In);
Input = fix(double(In)/(2^5))+1;
% [Input,map] = rgb2ind(In,8);

%adapted from https://github.com/jeholmes/MATLAB-Backprojection/blob/master/tracker.m#L289
M = zeros(8,8,8);
for i = 1:size(Input,1)
    for j = 1:size(Input,2)
        px = Input(i,j,:);
        M(px(1),px(2),px(3)) = M(px(1), px(2), px(3))+1;
    end
end
M(1, 1, 1) = 0;

collage8 = imread('SwainCollageForBackprojectionTesting.bmp');
collage = fix(double(collage8)/(2^5))+1;

%adapted from https://github.com/jeholmes/MATLAB-Backprojection/blob/master/tracker.m#L289
I = zeros(8,8,8);
for i = 1:size(collage,1)
    for j = 1:size(collage,2)
        px = collage(i,j,:);
        I(px(1), px(2), px(3)) = I(px(1), px(2), px(3)) + 1;
    end
end

rhisto = min(M ./ I, 1);

%adapted from https://github.com/jeholmes/MATLAB-Backprojection/blob/master/tracker.m#L289
for i = 1:size(collage,1)
    for j = 1:size(collage,2)
        px = collage(i,j,:);
        resultimg(i,j,:) = rhisto(px(1),px(2),px(3));
    end
end

resultimg1 = medfilt2(resultimg, [6 6]);
imshow(resultimg1)
blk = regionprops(resultimg1, 'BoundingBox');
blkregions = [blk(1).BoundingBox(1),blk(1).BoundingBox(2),blk(1).BoundingBox(3),blk(1).BoundingBox(4)]; 
rectangle('Position', blkregions, 'EdgeColor','r', 'LineWidth',3);




