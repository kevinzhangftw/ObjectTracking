clear all:
%adapted from https://github.com/jeholmes/MATLAB-Backprojection/blob/master/tracker.m#L289
% matvideo = load('CMPT412_bluecup.mat');
% video = matvideo.bluecup;
matvideo = load('CMPT412_blackcup.mat');
video = matvideo.blackcup;
imshow(video(:,:,:,1));
[x_input,y_input] = ginput(1);
r = 50;

% from part 1 getting histogram M
cup8 = imcrop(video(:,:,:,1),[x_input-r y_input-r 2*r 3*r]);
% imshow(cup8);
cup3 = fix(double(cup8)/(2^5))+1;
M = zeros(8,8,8);
for i = 1:size(cup3,1)
    for j = 1:size(cup3,2)
        px = cup3(i,j,:);
        M(px(1), px(2), px(3)) = M(px(1), px(2), px(3)) + 1;
    end
end
M(1,1,1)=0;

% from part 1 get histogram I for every frame
for frame = 1:size(video,4)
    close;
    aframe = video(:,:,:,frame);
    f3 = fix(double(aframe)/(2^5))+1;
    
    I = zeros(8,8,8);
    for i = 1:size(f3,1)
        for j = 1:size(f3,2)
            px = f3(i,j,:);
            I(px(1), px(2), px(3)) = I(px(1), px(2), px(3)) + 1;
        end
    end
    
    rhisto = min(M ./ I, 1);
    
    for i = 1:size(f3,1)
        for j = 1:size(f3,2)
            px = f3(i,j,:);
            resultimg(i,j,:) = rhisto(px(1),px(2),px(3));
        end
    end

    resultimg1 = edge(resultimg,'Sobel',[],'horizontal','nothinning');
    resultimg2 = bwareaopen(resultimg1, 300);
    imshow(aframe)
    blk = regionprops(resultimg2, 'BoundingBox');
    blkregions = [blk(1).BoundingBox(1), blk(1).BoundingBox(2), 50, 50]; 
    rectangle('Position', blkregions, 'EdgeColor','r', 'LineWidth',3);
    
    %adapted from https://github.com/jeholmes/MATLAB-Backprojection/blob/master/tracker.m#L289
    filename = fullfile('trackingblackcup.gif');
    drawnow
    gifframe = getframe(1);
    im = frame2im(gifframe);
    [imind,cm] = rgb2ind(im,256);
    if frame == 1
      imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
    else
      imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
    
    clear resultimg;

end    



