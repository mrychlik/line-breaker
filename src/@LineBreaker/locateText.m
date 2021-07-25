function this = locateText(this)
% Reading the Image and Convert to Binarazid
% Example: colorImage = imread(fullfile('Pages','page-14.png'));

    import LineBreaker.*;

    if isempty(this.CurrentBWImage)
        this.binarizeCurrentImage;
    else
        this.showBinarizedImage;
    end

    %Finding the Text and connected region
    mserConnComp = bwconncomp(this.CurrentBWImage);
    mserStats = regionprops(mserConnComp, 'BoundingBox');
    
    % Get bounding boxes for all the regions
    this.BBoxes = vertcat(mserStats.BoundingBox);

    % Fallback if no objects were detected
    if isempty(this.BBoxes)
        this.BBoxes = zeros(0,4);
    end
    
    this.findOverlapsFirstPass;
    i_showTextBoxes(this, this.SortedTextBBoxes);

    % Attach small lines to big ones
    this.findOverlapsSecondPass;
    i_showTextBoxes(this, this.SortedTextBBoxes);

    this.findOverlapsThirdPass;
    i_showTextBoxes(this, this.SortedTextBBoxes);
    
    this.linkAxes;
end

function i_showTextBoxes(this, textBBoxes)
    str    = sprintf('Box = %f', textBBoxes(:,1));
    nLines = size(textBBoxes,1);
    label_str = {};
    for ii=1:nLines
        %label_str{ii} = ['Xmin=',num2str(textBBoxes(ii,1),'%0.3f')];
        label_str{ii} = ['Line ',num2str(ii)];
    end
    
    if ~isempty(label_str)
        ITextRegion = insertObjectAnnotation(this.CurrentImage, ...
                                             'Rectangle', textBBoxes, label_str, ...
                                             'LineWidth',4,...
                                             'TextBoxOpacity',0.4, ...
                                             'Color',{'green'});
    else
        ITextRegion = this.CurrentImage;
    end
    ax3 = this.UIAxes3;
    cla(ax3);
    image(ax3,ITextRegion);
    title(ax3,"Detected " + nLines + " Text Lines");
end
