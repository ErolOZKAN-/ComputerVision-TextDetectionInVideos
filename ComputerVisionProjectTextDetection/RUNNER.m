close all;
clear all;

delete('TextLocalization_Output_Images/*');
delete('TextLocalization_Output/*');

numOfImages= 10;
lightOnDark = 1;
debugMode = 1;
TextLocalization('TestImages', 'TextLocalization_Output',numOfImages,lightOnDark,debugMode);
result = ShowBoundingBoxes('TestImages', 'TextLocalization_GT', 'TextLocalization_Output',numOfImages);
result

