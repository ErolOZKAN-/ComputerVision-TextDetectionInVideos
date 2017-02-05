function rectangles= DetectText(im,lightOnDark,debugMode)
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
    title('Coarse Component Filtering Result');
    figure, imshow(gt_final);
    title('Final Result');
end
%% 
Morphed_mask = BoundryFill(gt_final);
%% 
if debugMode
    figure, imshow(Morphed_mask,[]);
end
%% 
rectangles = DrawRectangle(Morphed_mask);



