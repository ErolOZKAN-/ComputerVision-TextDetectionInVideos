function frames = ReadVideoXML(XMLfile)

xDoc = xmlread(XMLfile);

elements = xDoc.getElementsByTagName('frame');

for i = 0:elements.getLength-1
    frames(i+1).objects = [];
    objects = elements.item(i).getElementsByTagName('object');
    for el=0:objects.getLength-1
        obj.label = '';
        obj.id = 0;
        obj.quality = '';
        obj.polygon = [];
        attr = objects.item(el).getAttributes();
        for at = 0:attr.getLength-1
            if strcmp(attr.item(at).getName,'Transcription')==1
               obj.label = char(attr.item(at).getValue);
            end
            if strcmp(attr.item(at).getName,'ID')==1
               obj.id = str2num(char(attr.item(at).getValue));
            end
            if strcmp(attr.item(at).getName,'Quality')==1
               obj.quality = char(attr.item(at).getValue);
            end  
        end
        points = objects.item(el).getElementsByTagName('Point');
        
        for p = 0:points.getLength-1
            attr = points.item(p).getAttributes();
            x = -1;
            y = -1;
            for at = 0:attr.getLength-1
              
                if strcmp(attr.item(at).getName,'x')==1
                    x = str2num(char(attr.item(at).getValue));
                end
                if strcmp(attr.item(at).getName,'y')==1
                    y = str2num(char(attr.item(at).getValue));
                end
                
            end
            obj.polygon = [obj.polygon; x, y];
        end
        
        frames(i+1).objects = [frames(i+1).objects; obj];
    end    
end

end