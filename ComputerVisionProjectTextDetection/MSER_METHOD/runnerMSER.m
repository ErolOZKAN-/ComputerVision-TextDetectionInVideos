close all;
clear all;
image = imread('../TestImages/img_1.png');
darkBackgroundLightText= false;
rectangles = myMethod(image,darkBackgroundLightText);

figure, imshow(image);
hold on;
for i=1:size(rectangles,1)
    rectangle('Position', rectangles(i,:),'EdgeColor','g')
end