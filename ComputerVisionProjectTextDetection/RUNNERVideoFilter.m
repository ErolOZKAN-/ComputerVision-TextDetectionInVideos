clear all;
close all;

filein = 'videos/Video_1_1_2.mp4';
filein2 = 'binaryOutput.avi';
fileGT = 'video_gt/Video_1_1_2_GT.xml';

numberOfImagesToCombine=2;
value = 0;
values = 0;


outputVideo = VideoWriter('11.avi');
outputVideo.FrameRate = 10;
open(outputVideo);

outputVideo2 = VideoWriter('22.avi');
outputVideo2.FrameRate = 10;
open(outputVideo2);

outputVideo3 = VideoWriter('33.avi');
outputVideo3.FrameRate = 10;
open(outputVideo3);

    %% Read in the video File 
readerobj = VideoReader(filein); %,'tag','myreader');
readerobj2 = VideoReader(filein2); %,'tag','myreader');
    
numFrames = get(readerobj,'numberOfFrames');
    %numFrames = 5;

    %% Read in the Ground Truth XML File
   
   
   for i = (numberOfImagesToCombine+1):(numFrames-numberOfImagesToCombine)
       
       
         im = uint32(read(readerobj,(i-numberOfImagesToCombine)));
         im2 = uint32(read(readerobj2,(i-numberOfImagesToCombine)));
         someImage = uint32(read(readerobj,i));
         
         for j = (i-numberOfImagesToCombine+1):(i+numberOfImagesToCombine)
             imToAdd = uint32(read(readerobj,j));
             im = imadd(im,imToAdd);
             
             imToAdd2 = uint32(read(readerobj2,j));
             im2 = imadd(im2,imToAdd2);
         end
         
         
         im = im/(2*numberOfImagesToCombine+1);
         im2 = im2/(2*numberOfImagesToCombine+1);
         
         
           res= uint8(im);
           res2= uint8(im2);
           res3= uint8(someImage);
          
          
           writeVideo(outputVideo2,res2);
           res2(:,:,3) = 0;
           res2(:,:,2) = 0;
           myImage = imfuse(res,res2,'blend','Scaling','joint');
           
           myImageeeeeee = imfuse(res3,res2,'blend','Scaling','joint');

           writeVideo(outputVideo3,myImageeeeeee);
           writeVideo(outputVideo,myImage);
           
          fprintf('%d  \  %d  \n',i,numFrames);
        % level = graythresh(rtol);
        % BW = im2bw(rtol,level);
         imshow(myImage);
   end

    
  close(outputVideo);
  close(outputVideo2);
  close(outputVideo3);
   
