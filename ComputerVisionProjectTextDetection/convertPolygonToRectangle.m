function myRectangle = convertPolygonToRectangle(polygon)

    starting = polygon(1,:);
    ending = polygon(3,:);
    ending = ending- starting;
    if ending(1)<0
        ending(1) = 1;
    end;
    if ending(2)<0
        ending(2) = 1;
    end;
    myRectangle = [starting ending];
    