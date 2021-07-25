function this = guessResolution(this)
    this.DotsPerPoint = ...
        LineBreaker.estimateResolution(size(this.CurrentImage));
end