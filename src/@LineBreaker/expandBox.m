function expandedBBoxes = expandBox(bboxes, relExpansion, absExpansion, clippingSize)
% EXPANDBOX - enlage a box in both directions
%    EXPANDEDBBOXES = EXPANDBOX(BBOXES, RELEXPANSION, ABSEXPANSION, CLIPPINGSIZE) acepts
% an N-by-4 array BBOXES whose rows are position vectors in the format
% [xmin ymin width height]  and a vector RELEXPANSION with
% 2 numbers, RELEXPANSION == [V, H] where H and V are fractions
% by which the box will be expanded in horizontal and vertical direction
% respectively. Similarly, ABSEXPANSION is the amount to be added to each
% dimension in pixels.
%
% CLIPSIZE is a size to which to clip. If CLIPSIZE = [YMAX XMAX]
% then the box is clipped to the rectangle 0.5 <= Y <= YMAX+0.5,
% 0.5 <= X <= XMAX + 0.5, which is the usual clipping implemented by MATLAB.
    nargchk(3,3,nargin);

    import LineBreaker.*;
    boxBounds = convertBox(bboxes);

    xmin = boxBounds(:,1);
    ymin = boxBounds(:,2);
    xmax = boxBounds(:,3);
    ymax = boxBounds(:,4);


    XExpand = (xmax - xmin) .* relExpansion(2) ./ 2 + absExpansion(2);
    YExpand = (ymax - ymin) .* relExpansion(1) ./ 2 + absExpansion(1);
    xmin =  xmin - XExpand;
    ymin =  ymin - YExpand;
    xmax =  xmax + XExpand;
    ymax =  ymax + YExpand;

    % Clip the bounding boxes to be within the image bounds
    xmin = max(xmin, 0.5);
    ymin = max(ymin, 0.5);
    xmax = min(xmax, clippingSize(2)+0.5);
    ymax = min(ymax, clippingSize(1)+0.5);

    expandedBoxBounds = [xmin, ymin, xmax, ymax];
    expandedBBoxes = invertConvertBox(expandedBoxBounds);
end
