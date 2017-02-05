function boxes= DrawRectangle(Morphed_mask)

T_area=str2num('2000');
Connected_comp = bwconncomp(Morphed_mask);
Connected_data = regionprops(Connected_comp,'BoundingBox','Area');
boxes = round(vertcat(Connected_data(vertcat(Connected_data.Area) > T_area).BoundingBox));




