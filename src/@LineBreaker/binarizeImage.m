function [BW] = binarizeImage(I,Type,Threshold)
% BINARIZEIMAGE changes a color image to monochrome.
%  [BW] = BWTHRESHOLD(I,TYPE,THRESHOLD) changes a color image I to monochrome,
%  according to an integer TYPE grayscale first, then
%  using different methods based on Type, it changes the figure I to
%  grayscale and then to black and white.
%  THRESHOLD is the the threshold value (default: 0.2)
    if  nargin < 3
        Threshold = 0.2;
    end

    if size(I,3)==3
        Igray = rgb2gray(I);
    else 
        Igray = I;
    end

    switch Type
      case 'FixedThreshold'
        T = Threshold;
      case 'Global'
        T = 'Global';
      case 'AdaptiveMean'
        T = adaptthresh(Igray,Threshold,'ForegroundPolarity','dark','Statistic','mean');
      case 'AdaptiveGaussian'
        T = adaptthresh(Igray,Threshold,'ForegroundPolarity','dark','Statistic','gaussian');
      case 'AdaptiveMedian'
        T = adaptthresh(Igray,Threshold,'ForegroundPolarity','dark','Statistic','median');
      otherwise
        uialert('How did we get here, Joe?');
    end

    BW = ~imbinarize(Igray,T);
end

