function this = binarizeCurrentImage(this)
    import LineBreaker.*;

    I = ~binarizeImage(this.CurrentImage, this.BinarizationType, this.BinarizationThresh);
    % NOTE: Now text is black
    % Remove objects that have too many pixels to be connected regions of text
    I = ~bwareaopen(I,this.AdjBigSizeThreshold);  
    % Remove small objects
    % TODO: Examine how bwareaopen eliminates diacritical marks
    % that it should not.
    %I = ~bwareaopen(I,this.AdjSmallSizeThreshold);   
    I = ~I;

    this.CurrentBWImage = ~I;
    showBinarizedImage(this);
end

