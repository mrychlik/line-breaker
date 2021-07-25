function this = binarizeCurrentImage(this)
    import LineBreaker.*;

    I = ~binarizeImage(this.CurrentImage, this.BinarizationType, this.BinarizationThresh);
    % NOTE: Now text is black
    % Remove objects that have too many pixels to be connected regions of text
    I = ~bwareaopen(I,this.AdjBigSizeThreshold);  
    % Remove small objects
    I = ~bwareaopen(I,this.AdjSmallSizeThreshold);   

    this.CurrentBWImage = ~I;
    showBinarizedImage(this);
end

