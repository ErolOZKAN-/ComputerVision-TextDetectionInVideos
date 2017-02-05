filein = 'videos/Video_1_1_2.mp4';
fileGT = 'video_gt/Video_1_1_2_GT.xml';
fileres = 'video_result/res_Video_1.xml';
value = 0;
values = 0;
myFile = '22.avi';


    %% Read in the video File 
    readerobj2 = VideoReader(myFile); %,'tag','myreader');

    readerobj = VideoReader(filein); %,'tag','myreader');
    numFrames = get(readerobj,'numberOfFrames');
    %numFrames = 5;
    
    outputVideo = VideoWriter('sonuc_22.avi');
    outputVideo.FrameRate = 10;
    open(outputVideo);

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
        video2 = read(readerobj2,k);

        imagee2 = video2(:,:,:,1);       
        imagee2=rgb2gray(imagee2);
        newImage = im2bw(imagee2);
        rectangles = DrawRectangle(newImage);  
  
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
        
               
        for o = 1:size(rectangles)

            rectangle('Position', rectangles(o,:),'EdgeColor','r','LineWidth',2)
        end
        

        hold off
        drawnow;
        
        f=getframe(gca);
        [X] = frame2im(f);
        %imwrite(X,strcat(strcat('erol/',num2str(k)),'.jpg'),'jpg');
        for ii = 1:1
            writeVideo(outputVideo,X);
        end

        
        value = EvaluateVideo(allGTRectanglesInFrame, rectangles);
        if ~isfinite(value)
            value = -1;
        end;

    end

close(outputVideo);