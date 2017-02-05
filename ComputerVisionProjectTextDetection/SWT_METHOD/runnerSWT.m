close all;
clear all;
im = imread('../TestImages2/2.jpg');

lightOnDark = 0;
debugMode = 1;

rectangles = DetectText(im,lightOnDark,debugMode)

figure, imshow(im);
hold on;
for i=1:size(rectangles,1)
    rectangle('Position', rectangles(i,:),'EdgeColor','g','LineWidth',2)
end