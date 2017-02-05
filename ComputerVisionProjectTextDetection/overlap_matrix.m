    function result= overlap_matrix(box1,box2)
    [m,y1]=size(box1);
    [n,y2]=size(box2);
    result=zeros(m,n,'double');
    for  i = 1:m 
      for j=1:n
         gt=box1(i,:);
         pr=box2(j,:);

         x_g=box1(i,1);
         y_g=box1(i,2);
         width_g=box1(i,3);
         height_g=box1(i,4);

         x_p=box2(j,1);
         y_p=box2(j,2);
         width_p=box2(j,3);
         height_p=box2(j,4);
         intersectionArea=rectint(gt,pr); 
         unionCoords=[min(x_g,x_p),min(y_g,y_p),max(x_g+width_g-1,x_p+width_p-1),max(y_g+height_g-1,y_p+height_p-1)];
         unionArea=(unionCoords(3)-unionCoords(1)+1)*(unionCoords(4)-unionCoords(2)+1);
         overlapArea=intersectionArea/unionArea; 
         result(i,j)=overlapArea;
      end
    end