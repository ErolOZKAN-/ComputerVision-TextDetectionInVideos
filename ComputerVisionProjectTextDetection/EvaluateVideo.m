function finalResult= EvaluateVideo(bboxA,bboxB)

overlap = overlap_matrix(bboxA,bboxB);
maxRows = max(overlap,[],2);
finalResult = sum(maxRows)/size(maxRows,1);