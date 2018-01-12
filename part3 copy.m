clear all, close all

%adapted from https://github.com/jeholmes/MATLAB-Backprojection/blob/master/tracker.m#L289
matvideo = load('CMPT412_bluecup.mat');
video = matvideo.bluecup;
% matvideo = load('CMPT412_blackcup.mat');
% video = matvideo.blackcup;
imshow(video(:,:,:,1));
[x_input,y_input] = ginput(1);
r = 53;

cup8 = imcrop(video(:,:,:,1),[x_input-r y_input-r 2*r 3*r]);
imshow(cup8);
cup3 = fix(double(cup8)/(2^8/2^3))+1;

M = zeros(8,8,8);
for i = 1:size(cup3,1)
    for j = 1:size(cup3,2)
        px = cup3(i,j,:);
        M(px(1), px(2), px(3)) = M(px(1), px(2), px(3)) + 1;
    end
end

mean = [x_input y_input];
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
    
    %adapted from https://github.com/jeholmes/MATLAB-Backprojection/blob/master/tracker.m#L289
    all = 0;
    xcnt = 0;
    ycnt = 0;
    
    for i = 1:size(resultimg,1)
        for j = 1:size(resultimg,2)          
            if sqrt((i-mean(2))^2 + (j-mean(1))^2) < 2*r
                all = all + resultimg1(i,j);
                xcnt = xcnt + j*resultimg1(i,j);
                ycnt = ycnt + i*resultimg1(i,j);
            end
        end
    end
    mean(1) = xcnt/all;
    mean(2) = ycnt/all; 
    
    imshow(aframe);
    blkregions = [mean(1), mean(2), 50, 50]; 
    rectangle('Position', blkregions, 'EdgeColor','r', 'LineWidth',3);

    
    %adapted from https://github.com/jeholmes/MATLAB-Backprojection/blob/master/tracker.m#L289
    filename = fullfile('trackingbluecupmean.gif');
%     filename = fullfile('trackingblackcupmean.gif');
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
