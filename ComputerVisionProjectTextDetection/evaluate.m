function finalResult= evaluate(bboxA,bboxB,image,imageNumber)

overlap = overlap_matrix(bboxA,bboxB);
maxRows = max(overlap,[],2);
finalResult = sum(maxRows)/size(maxRows,1);

position =  [1 1];

if isempty(finalResult)
    finalResult = 0;
end

image = insertText(image,position,finalResult,'BoxOpacity',1);

figure, imshow(image);
hold on;
for i=1:size(bboxA)
    rectangle('Position', bboxA(i,:),'EdgeColor','g','LineWidth',2)
end

for i=1:size(bboxB)
    rectangle('Position', bboxB(i,:),'EdgeColor','r','LineWidth',2)
end
title('COMPARE RESULTS WITH GT');
f=getframe(gca);
[X] = frame2im(f);
imwrite(X,strcat(strcat('TextLocalization_Output_Images/',num2str(imageNumber)),'.jpg'),'jpg');
