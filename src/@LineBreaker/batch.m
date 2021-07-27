function this = batch(this)
% BATCH - run LineBreaker in bach mode
%
%     THIS = BATCH(THIS) processes files whose name matches the variable
%  this.InputFilePattern and outputs the results to the folder
%  this.OutputDirectory. In that directory a subdirectory is created for
%  each matching image file, with name identical to the name of the image
%  file, and in that directory images are created with individual lines of
%  text.
%     
%  In addition, this.InputFilePattern may be a cell array of filename
%  patterns.
%
%  All image files are processed with the current settings of LineBreaker,
%  for all files. Hence, all files submitted should be similar, and should
%  be known to be successfuly broken up into lines by choosing a
%  representative sample. The parameters should be chosen first. This can be
%  done by first processing one of the files.
%
    this.Force = true;
    this.InterruptFlag = false;
    if ~exist(this.OutputDirectory,'dir')
        if this.Force
            mkdir(this.OutputDirectory);
            warning('Output directory %s created.', this.OutputDirectory);
        else
            error('Output directory %s does not exist. Set ''Force'' to true?', ...
                  this.OutputDirectory);
        end
    end
    
    this.notifyFileCompleted('Gathering file info...');
    file_lst = [];
    file_count = 0;
    for j=1:numel(this.InputFilePattern)
        loc_file_lst = dir(this.InputFilePattern{j});
        file_count = file_count + numel(loc_file_lst);
        this.notifyFileCompleted(['File count is now ', num2str(file_count), '...']);
        file_lst = [file_lst, loc_file_lst];
    end
    this = batch_helper(this, file_lst, this.OutputDirectory);
    this.notifyFileCompleted('Done.');
end


function this = batch_helper(this, file_lst, outputFolder)
    for j=1:numel(file_lst)
        if this.InterruptFlag 
            this.InterruptFlag = false;
            this.notifyFileCompleted('Job interrupted by the user.');
            break;
        end
        lineOutputFolder = fullfile(outputFolder,file_lst(j).folder, file_lst(j).name);
        this.notifyFileCompleted(['Working on file: ', file_lst(j).name]);
        mkdir(lineOutputFolder);
        batch_single_file(this, ...
                          fullfile(file_lst(j).folder, file_lst(j).name),...
                          lineOutputFolder);
        this.notifyFileCompleted(['File done: ', file_lst(j).name]);
    end
end

function this = batch_single_file(this, inputFile, lineOuputFolder)
    this.CurrentFilepath = inputFile;
    this.binarizeCurrentImage;
    lines = this.ImageLines;
    disp("Lines in image: " + numel(lines));
    for j=1:numel(lines)
        doWrite = true;
        outputFile = fullfile(lineOuputFolder, sprintf('line%03d.png',j));
        if exist(outputFile,'file') == 2
            if this.Force
                doWrite = true;
            else
                warning('File %s exists, skipping.', outputFile);
                doWrite = false;
            end
        end
        if doWrite
            imwrite(lines{j},outputFile,'PNG'),
            if this.Verbose
                disp("File " + outputFile + " was written.");
            end
        end
    end
end