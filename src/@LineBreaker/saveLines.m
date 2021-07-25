function this = saveLines(this, event)
    if isempty(this.app)
        error(['LineBreaker::saveLines: No controlling app.',... 
               'Try ''writeLines'' instead.']);
    end
    if isempty(this.CurrentFilepath)
        uialert(this.app.LineBreakerAppUIFigure, ...
                'You have not opened a file  yet, please do!',...
                'Saving lines to folder.');
        return;
    end
    [file, dirname] = uiputfile({ '*.png', 'PNG-files (*.png)';...
                        '*.jpg', 'JPEG-files (*.jpg)' },...
                                'Save as', 'line%03d.png');
    outputType = this.app.OutputTypeListBox.Value;
    if isequal(file,0)
        disp('User selected Cancel');
    else
        disp(['User selected ', file]);
        lines = this.ImageLines;
        ask = true;
        doWrite = true;
        for j=1:numel(lines)
            filepath = fullfile(dirname,sprintf(file,j));
            if exist(filepath,'file') == 2
                if ask 
                    doWrite = true;
                    opt = uiconfirm(this.app.LineBreakerAppUIFigure,...
                                    "File '" + file + "' exists. Overwrite?",...
                                    'A file is about to be overwritten!',...
                                    'Options',{'Yes','No','Always','Never'});
                    if strcmp(opt,'Always') || strcmp(opt,'Never')
                        ask = false;
                    end
                    if strcmp(opt,'No') || strcmp(opt,'Never')
                        doWrite = false;
                    end
                end
            end
            if doWrite
                imwrite(lines{j},filepath,'PNG'),
                disp("File " + filepath + " was written.");
            else
                disp("File " + filepath + " was not written.");
            end
        end
    end
end