function this = openFile(this, event)
% LOADFCN loads saved state from file
    [file, dirname] = uigetfile({
        '*.png', 'PNG-files (*.png)';
        '*.jpg', 'JPEG-files (*.jpg)';
        '*.tif', 'TIFF-files (*.tif)';
        '*', 'All files (*)' 
                   },...
                                'Select an image file', 'image.png');

    if isequal(file,0)
        disp('User selected Cancel');
    else
        filepath = fullfile(dirname,file);
        disp(['User selected ', filepath]);
        this.CurrentFilepath = filepath;
    end
end
