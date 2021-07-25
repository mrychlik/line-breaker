function lines = getImageLines(this)
    import LineBreaker.*;
    this.locateText;
    textBoxBounds = convertBox(this.SortedTextBBoxes);

    xmin = textBoxBounds(:,1);
    ymin = textBoxBounds(:,2);
    xmax = textBoxBounds(:,3);
    ymax = textBoxBounds(:,4);
    
    n = size(xmin,1);
    lines = {};
    for j=1:n
        lines{j} = this.OutputImage( ceil(ymin(j)):floor(ymax(j)), ...
                                     ceil(xmin(j)):floor(xmax(j)) );
    end
end