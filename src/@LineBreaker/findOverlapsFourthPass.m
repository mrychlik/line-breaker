function this = findOverlapsFourthPass(this)
% FINDOVERLAPSFOURTHPASS - merge small lines into big ones
    import LineBreaker.*;

    overlapRatio = bboxOverlapRatio(this.TextB,expandedBBoxes,this.OverlapType);
    n = size(overlapRatio);
    overlapRatio(1:(n+1):n.^2) = 0;

    g = graph(overlapRatio);
    
    % Find the connected text regions within the graph
    bins = conncomp(g);
    boxBounds = convertBox(this.BBoxes);
    for j=1:2
        tmp{j} = accumarray(bins',boxBounds(:,j),[],@min);
    end
    for j=3:4
        tmp{j} = accumarray(bins',boxBounds(:,j),[],@max);
    end
    textBoxBounds = [tmp{1},tmp{2},tmp{3},tmp{4}];
    
    % Compose the merged bounding boxes using the [x y width height] format.
    this.TextBBoxes = invertConvertBox(textBoxBounds);
    this.Bins = bins;

    
end

