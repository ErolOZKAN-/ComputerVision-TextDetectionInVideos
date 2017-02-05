function MyMethodVideo(filein, fileout,lightOnDark,debugMode,videoMode,outputVideo)
    disp('Reading in the video');
    readerobj = VideoReader(filein); 
    numFrames = get(readerobj,'numberOfFrames');
    %numFrames = 5;
    disp('Localizing Text in frames');
    locations(1:numFrames) = struct('objects',[]);

    for i = 1:numFrames
        Frame = read(readerobj,i);
        locations(i).objects(1).id = 1;        
        res = DetectText(Frame,lightOnDark,debugMode,videoMode,outputVideo);
       
        for index = 1:size(res) 
            locations(i).objects(index).id = index;
            locations(i).objects(index).polygon=[res(index,1), res(index,2); res(index,1)+res(index,3), res(index,2); res(index,1)+res(index,3), res(index,2)+res(index,4); res(index,1),res(index,2)+res(index,4)];
        end
    end

    disp('saving results in xml');

    docNode = com.mathworks.xml.XMLUtils.createDocument('Frames');
    docRootNode = docNode.getDocumentElement;

    for i=1:numFrames
        FrameElement = docNode.createElement('frame');
        FrameElement.setAttribute('id',num2str(i));

        for o=1:length(locations(i).objects)           
            ObjectElement = docNode.createElement('object');       
            ObjectElement.setAttribute('id',num2str(o));
            if any(strcmp('polygon',fieldnames(locations(i).objects(1))))    
                for p=1:length(locations(i).objects(1).polygon)
                    Point = docNode.createElement('Point');
                    Point.setAttribute('x',num2str(locations(i).objects(1).polygon(p,1)));
                    Point.setAttribute('y',num2str(locations(i).objects(1).polygon(p,2)));
                    ObjectElement.appendChild(Point);
                end
            else
                for p=1:4
                    Point = docNode.createElement('Point');
                    Point.setAttribute('x',num2str(0));
                    Point.setAttribute('y',num2str(0));
                    ObjectElement.appendChild(Point);
                end
            end
            FrameElement.appendChild(ObjectElement);
        end
        docRootNode.appendChild(FrameElement);
    end
    xmlwrite(fileout, docNode);
end


