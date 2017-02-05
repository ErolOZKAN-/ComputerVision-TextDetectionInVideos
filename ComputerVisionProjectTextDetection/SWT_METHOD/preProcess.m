function img= preProcess(im)
%% Convert To Gray Scale
img = im2double(rgb2gray(im));
%% Enchance edges + smooth
img = double(img);
img = double(img).^0.75;
img = img./max(img(:));

img = adapthisteq(img,...
                 'ClipLimit',0.01,...
                 'NBins',256,...
                 'NumTiles', [32 32]);

img = imfilter(img, fspecial('gaussian',5,1));