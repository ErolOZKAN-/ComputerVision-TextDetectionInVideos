function TextLocalization(TestImgDir, OutputDir,numOfTrainImages,lightOnDark,debugMode)
    for i=1:numOfTrainImages
        %% Read in the image
        img_filename = [TestImgDir, '/img_', int2str(i), '.png'];
        image = imread(img_filename);       
        %% Applying my method
        res = DetectText(image,lightOnDark,debugMode,0);        
        figure, imshow(image);
        hold on;
        for k=1:size(res,1)
            rectangle('Position', res(k,:),'EdgeColor','r','LineWidth',2)
        end
        title('DETECTED TEXT AREAS');
        %% Create a results file for the image
        res_filename = [OutputDir, '/res_img_', int2str(i), '.txt'];
        fid = fopen(res_filename, 'w');
        if (fid == -1)
            disp('Error opening output file for writing');
            return;
        end;
        for j = 1:size(res,1)
            fprintf(fid,'%d, %d, %d, %d,%s\r\n', res(j, 1), res(j, 2), res(j, 3), res(j, 4),' "sometext"');
        end
        fclose(fid);     
    end;
end