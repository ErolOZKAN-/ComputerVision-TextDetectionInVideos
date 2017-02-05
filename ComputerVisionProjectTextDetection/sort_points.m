function sorted_pts = sort_points(pts)
minx = min(pts(:,1));
maxx = max(pts(:,1));
miny = min(pts(:,2));
maxy = max(pts(:,2));

center.x = (minx + maxx) / 2;
center.y = (miny + maxy) / 2;

pts1 = [];

for i = 1:size(pts,1)
    pts1 = [pts1; [pts(i,1)-center.x,pts(i,2)-center.y]];
end

[THETA,RHO] = cart2pol(pts1(:,1),pts1(:,2));

[Y,I] = sort(THETA);

sorted_pts = pts(I(:),:);

end