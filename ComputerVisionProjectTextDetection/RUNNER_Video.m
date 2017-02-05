clear all;
close all;
%% Setup
filein = 'videos/Video_1_1_2.mp4';
fileGT = 'video_gt/Video_1_1_2_GT.xml';
fileres = 'video_result/res_Video_1.xml';
lightOnDark = 0;
debugMode = 0;
videoMode = 1;
%% Video Options
outputVideo = VideoWriter('video.avi');
outputVideo.FrameRate = 10;
open(outputVideo);
%% 
%MyMethodVideo(filein, fileres,lightOnDark,debugMode,videoMode,outputVideo); 
ShowVideoResults(filein,fileGT,fileres,false,outputVideo);

close(outputVideo);