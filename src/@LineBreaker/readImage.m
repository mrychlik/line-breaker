function I = readImage(filepath)
% readImage - read image data from a file
% I=readImage(filepath) accepts a valid path FILEPATH
% and it returns an image I, which is m x n x p where
% P == 1 or P == 3 is the number of color planes.
% If the original format is RGBA (p==4), discards the alpha channel.
    if exist(filepath,'file') ~= 2
        error('LineBreaker::readImage: image file does not exist.');
    end
    [I,cmap] = imread(filepath);
    if ~isempty(cmap)
        I = cmap(I)
    end
    if size(I,3)==4
        I=I(:,:,1:3);
    end
end