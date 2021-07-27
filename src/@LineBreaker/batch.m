function this = batch(this, inputFile, outputDir)
% BATCH - run LineBreaker in bach mode
%     THIS = BATCH(THIS, INPUTFILE, OUTPUTDIR) accepts an input
%  filename or filename pattern INPUTFILE and output folder OUTPUTDIR, both character
%  vectors, and creates images with individual lines
%  of text in the folder. In addition, INPUTFILE may be a cell array of
%  filename patterns. This function uses the current settings of LineBreaker
%  for all files. Hence, all files submitted should be similar, and
%  should be known to be successfuly broken up into lines by
%  choosing a representative sample.
    this.Force = true;
    if ~exist(outputDir,'dir')
        if this.Force
            mkdir(outputDir);
            warning('Output directory %s created.', outputDir);
        else
            error('Output directory %s does not exist. Set ''Force'' to true?', ...
                  outputDir);
        end
    end
    
    if ~iscell(inputFile)
        inputFile = { inputFile };
    end
    this.notifyFileCompleted('Working...');
    file_lst = [];
    file_count = 0;
    for j=1:numel(inputFile)
        loc_file_lst = dir(inputFile{j});
        file_count = file_count + numel(loc_file_lst);
        this.notifyFileCompleted(['File count is ', num2str(file_count), '...']);
        file_lst = [file_lst, loc_file_lst];
    end
    this = batch_helper(this, file_lst, outputDir);
    this.notifyFileCompleted('Done.');
end


function this = batch_helper(this, file_lst, outputFolder)
    if isempty(file_lst) 
        warning('There are no files matching: %s', inputFile);
    end
    for j=1:numel(file_lst)
        lineOutputFolder = fullfile(outputFolder,file_lst(j).folder, file_lst(j).name);
        this.notifyFileCompleted(file_lst(j).name);
        mkdir(lineOutputFolder);
        batch_single_file(this, ...
                          fullfile(file_lst(j).folder, file_lst(j).name),...
                          lineOutputFolder);
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