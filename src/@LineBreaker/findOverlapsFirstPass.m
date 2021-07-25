function this = findOverlapsFirstPass(this)
% FINDOVERLAPSFIRSTPASS - find overlaps between boxes and compute text lines
%    THIS = FINDOVERLAPSFIRSTPASS(THIS) 
% and computes bbox overlaps between expanded THIS.BBOXES. Using the
% resulting matrix as adjacency matrix of a graph, computes connected
% components of the graph and considers them the lines.
% The result is stored in the property THIS.TEXTBBOXES;

    import LineBreaker.*;
    
    % Identify big boxes, which are probably not diacritics
    bigBBoxes = max(this.BBoxes(:,[4,3]) > this.AdjMaxDiacriticSize,[],2);
    bigBBoxesIdx = find(bigBBoxes);
    
    clippingSize = size(this.CurrentImage);
    expandedBBoxes = this.BBoxes;

    expandedBBoxes = expandBox(this.BBoxes(bigBBoxesIdx,:), this.RelBoxExpansion, ...
                               this.AbsBoxExpansion,clippingSize);
    i_showBBoxes(this,expandedBBoxes);

    overlapRatio = bboxOverlapRatio(expandedBBoxes,expandedBBoxes,this.OverlapType);
    n = size(overlapRatio);
    overlapRatio(1:(n+1):n.^2) = 0;
    
    g = graph(overlapRatio);
    
    % Find the connected text regions within the graph
    bins = conncomp(g);
    boxBounds = convertBox(this.BBoxes(bigBBoxesIdx,:));
    for j=1:2
        tmp{j} = accumarray(bins',boxBounds(:,j),[],@min);
    end
    for j=3:4
        tmp{j} = accumarray(bins',boxBounds(:,j),[],@max);
    end
    textBoxBounds = [tmp{1},tmp{2},tmp{3},tmp{4}];
    
    % Compose the merged bounding boxes using the [x y width height] format.
    this.TextBBoxes = invertConvertBox(textBoxBounds);
    this.Bins = -ones(size(this.BBoxes,1),1);
    this.Bins(bigBBoxesIdx,:) = bins;
end

function i_showBBoxes(this, bboxes)
    IBBoxes = insertShape(this.CurrentImage,...
                          'FilledRectangle',bboxes, ...
                          'Opacity',0.3,...
                          'LineWidth',4,...
                          'Color',{'cyan'});
    
    ax1 = this.UIAxes;
    cla(ax1);
    image(ax1, IBBoxes);
    title(ax1,'Expanded Big blob bounding Boxes')
end
