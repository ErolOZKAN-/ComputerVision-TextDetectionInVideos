function ShowVideoResults(filein,fileGT,fileres,slowMotion,outputVideo)

value = 0;
values = 0;
    %% Read in the video File 
    readerobj = VideoReader(filein); %,'tag','myreader');
    numFrames = get(readerobj,'numberOfFrames');
    %numFrames = 5;

    %% Read in the Ground Truth XML File %
    fr_gt = ReadVideoXML(fileGT);
    
    %% Read in the Results XML file if one has been specified%
    fr_res = [];
    if ~isempty(fileres)
        fr_res = ReadVideoXML(fileres);
    end

    figure
    for k = 1:numFrames
        allGTRectanglesInFrame = [];
        allOfMyRectanglesInFrame = [];
        
        % Read each Frame 
        video = read(readerobj,k);
        % Insert Text
        position =  [1 1];
        video(:,:,:,1) = insertText(video(:,:,:,1),position,value,'BoxOpacity',1);
        %Display the Frame
        imshow(video(:,:,:,1));
                
        %Paint the bounding boxes of GT text areas over the frame
        hold on
        for o = 1:size(fr_gt(k).objects,1)
            %make sure the bounding box points are sorted in a clockwise
            %manner
            sorted_points = sort_points(fr_gt(k).objects(o).polygon);
            %Paint the bounding box            
            gtRectangle = convertPolygonToRectangle(sorted_points);
            rectangle('Position', gtRectangle,'EdgeColor','g','LineWidth',2)
            allGTRectanglesInFrame = [allGTRectanglesInFrame gtRectangle];
        end
        
        %Do the same for the Results bounding boxes if any results 
        %are specified
        if ~isempty(fileres)
            for o = 1:size(fr_res(k).objects,1)
                sorted_points = sort_points(fr_res(k).objects(o).polygon);
                %Paint the bounding box              
                myRectangle = convertPolygonToRectangle(sorted_points);
                if ~(myRectangle(1)== 0 && myRectangle(2)== 0 && myRectangle(3)== 0 && myRectangle(4)== 0)
                    rectangle('Position', myRectangle,'EdgeColor','r','LineWidth',2)                                                
                    allOfMyRectanglesInFrame = [allOfMyRectanglesInFrame myRectangle];
                end
            end
        end
        hold off
        drawnow;
        
        f=getframe(gca);
        [X] = frame2im(f);
        %imwrite(X,strcat(strcat('erol/',num2str(k)),'.jpg'),'jpg');
        for ii = 1:1
            writeVideo(outputVideo,X);
        end
        if slowMotion
            pause(1);
        end;
        
        value = EvaluateVideo(allGTRectanglesInFrame, allOfMyRectanglesInFrame);
        if ~isfinite(value)
            value = -1;
        end;

    end
end
