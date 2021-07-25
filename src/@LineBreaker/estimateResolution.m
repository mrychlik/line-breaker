function dotsPerPoint = estimateResolution(size, papersize)
    nargchk(1,2,nargin);
    if nargin < 2
        papersize='letter';
    end
    switch papersize
      case 'letter'
        % Size in points
        height = 11.5*72;
        width = 8.5*72;
        dotsPerPoint = (size(1) + size(2))./(height + width);
    end
end