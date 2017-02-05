function finalResult =  ShowBoundingBoxes(imageDirectory, groundTruthDirectory,resultDirectory,numOfTrainImages)

finalResult=[];
    for i = 1:numOfTrainImages
        %% Read in the image
        imageFile = [imageDirectory, '/img_', int2str(i), '.png'];
        groundTruthFile = [groundTruthDirectory, '/gt_img_', int2str(i), '.txt'];
        resultFile = [resultDirectory, '/res_img_', int2str(i), '.txt'];
        Img = imread(imageFile);        
        %% Read in groundTruthFile
        fid = fopen(groundTruthFile, 'r');
        if (fid == -1)
            disp('invalid Bounding Box file');
            return;
        end;
        BoundingBoxesGT = textscan(fid,'%d,%d,%d,%d,%*[^\n]', 'CollectOutput', 1);
        BoundingBoxesGT = BoundingBoxesGT{1};
        fclose(fid);

        BoundingBoxesGT(:,3) = BoundingBoxesGT(:,3)- BoundingBoxesGT(:,1)+2;
        BoundingBoxesGT(:,4) = BoundingBoxesGT(:,4)- BoundingBoxesGT(:,2)+2;

        %% Read in the resultFile
        fid = fopen(resultFile, 'r');
        if (fid == -1)
            disp('invalid Bounding Box file');
            return;
        end;
        BoundingBoxesMYRESULT = textscan(fid,'%d,%d,%d,%d,%*[^\n]', 'CollectOutput', 1);
        BoundingBoxesMYRESULT = BoundingBoxesMYRESULT{1};
        fclose(fid);
        
        result = evaluate(double(BoundingBoxesGT),double(BoundingBoxesMYRESULT),Img,i);
        finalResult = [finalResult,result];
    end
end