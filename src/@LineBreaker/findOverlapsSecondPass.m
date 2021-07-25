function this = findOverlapsSecondPass(this)
% findOverlapsSecondPass - attach small objects to lines
    import LineBreaker.*;

    % Identify small boxes, which are probably diacritics
    smallBBoxesIdx = find(this.Bins == -1);
    
    smallBBoxes = this.BBoxes(smallBBoxesIdx,:);
    clippingSize = size(this.CurrentImage);

    % Expand only diacritics
    expandedSmallBBoxes = expandBox(smallBBoxes,...
                                    this.RelDiacriticExpansion,...
                                    this.AdjAbsDiacriticExpansion,...
                                    clippingSize);
    
    i_showBBoxes(this, expandedSmallBBoxes)

    overlapRatio = bboxOverlapRatio(smallBBoxes,this.TextBBoxes,this.OverlapType);
    
    nSmall = size(smallBBoxes,1);
    nText = size(this.TextBBoxes,1);
    markedForMerging = zeros(1,nSmall);
    mergeWith = zeros(1,nSmall);

    for j=1:nSmall
        [maxOverlap, idx] = max(overlapRatio(j,:));
        if maxOverlap > this.OverlapThreshold
            markedForMerging(j) = 1;
            mergeWith(j) = idx;
        end
    end
    
    % Merge bboxes marked for merging
    smallBBoxBounds = convertBox(smallBBoxes);
    textBBoxBounds = convertBox(this.TextBBoxes);
    textBBoxBoundsOut = textBBoxBounds;

    markedForDeletion = zeros(1,nSmall);
    for j=1:nSmall
        if markedForMerging(j)
            k = mergeWith(j);
            for l=1:2
                textBBoxBoundsOut(k,l) = min(textBBoxBoundsOut(k,l), smallBBoxBounds(j,l));
            end
            for l=3:4
                textBBoxBoundsOut(k,l) = max(textBBoxBoundsOut(k,l), smallBBoxBounds(j,l));
            end
            this.Bins(j) = k;
        end
    end

    markedForMerging = find(markedForMerging);
    disp("Merged " + numel(markedForMerging) + " objects into lines.");

    % Compose the merged bounding boxes using the [x y width height] format.
    this.TextBBoxes = invertConvertBox(textBBoxBoundsOut);
end

function i_showBBoxes(this, bboxes)
    IBBoxes = insertShape(this.CurrentImage,...
                          'FilledRectangle',bboxes, ...
                          'Opacity',0.6,...
                          'LineWidth',6,...
                          'Color',{'red'});
    
    ax2 = this.UIAxes2;
    cla(ax2);
    image(ax2, IBBoxes);
    title(ax2,'Bounding Boxes of Unclassified Diacritics and Other Small Objects')
end
