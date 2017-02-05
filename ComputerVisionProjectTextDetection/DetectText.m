function rectangles= DetectText(im,lightOnDark,debugMode,videoMode,outputVideo)
%% read and preprocess image
if debugMode
    figure,imshow(im);
    title('Orginal Image');
end
%% 
image = preProcess(im);
%% 
if debugMode
    figure,imshow(image);
    title('Image After Preprocessing');
end
%% manager
[swt_im, ccomps] = swt(image,lightOnDark);
[coarse_filt, gnt_filtered, gt, mt, g_comp_idxs, m_comp_idxs] = ...
    filter_ccs(ccomps, swt_im, image, 1);
[PROB, added, added_indices] = ...
    comp_vote(gnt_filtered, gt, g_comp_idxs, m_comp_idxs);
gt_final = gt;
gt_final(added > 0) = 1;

%% last process
if debugMode
    figure, imshow(uint8(swt_im));
    title('SWT Result');
    figure, imshow(uint8(coarse_filt));
    title('Filtering Result');
    figure, imshow(gt_final);
    title('Final Result');
end
%% 
Morphed_mask = BoundryFill(gt_final);
if debugMode
    figure, imshow(Morphed_mask,[]);
    title('Fill Boundry Result');
end
%% 
rectangles = DrawRectangle(Morphed_mask);
%% 
if videoMode    
    myImage = uint8(255 * Morphed_mask);
    %myImage = cat(3,myImage,myImage,myImage);
    %myImage(:,:,3) = 0;
    %myImage(:,:,2) = 0;
    %myImage = imfuse(im,myImage,'blend','Scaling','joint');
    imwrite(myImage,strcat(strcat('erol/',num2str(rand)),'.jpg'),'jpg');
    for ii = 1:1
       writeVideo(outputVideo,myImage);
    end
end;
