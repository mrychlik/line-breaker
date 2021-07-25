function this = batch(this, inputFile, outputDir, varargin)
% BATCH - run LineBreaker in bach mode
%     THIS = BATCH(THIS, INPUTFILE, OUTPUTDIR, ...) accepts an input
%  filename INPUTFILE and output folder OUTPUTDIR, both character
%  vectors, and a number of options, and creates images with individual lines
%  of text in the folder.
%     This function is suitable for creating a standalone executable
%  implementing LineBreaker functionality.
    p = inputParser;
    p.addRequired('inputFile',@ischar);
    p.addRequired('outputDir',@ischar);
    p.addParameter('Force',false,@(x)islogical(x)||ischar(x));
    p.addParameter('Verbose',false,@(x)islogical(x)||ischar(x));
    p.addParameter('DotsPerPoint',[],@(x)isempty(x)||isscalar(x)||ischar(x));
    defaultOutputType = 'Input';
    expectedOutputTypes = {'Input','Binarized'};
    p.addParameter('OutputType',defaultOutputType,...
                   @(x) any(validatestring(x, expectedOutputTypes)));    
    p.parse(inputFile,outputDir, varargin{:});
    
    force = p.Results.Force;
    verbose = p.Results.Verbose;
    dotsPerPoint = p.Results.DotsPerPoint;
    if isdeployed
        if ischar(force)
            force = str2num(force);
        end
        if ischar(verbose)
            verbose = str2num(verbose);
        end
        if ischar(dotsPerPoint)
            dotsPerPoint = str2num(dotsPerPoint);
        end
    end

    if ~exist(outputDir,'dir')
        if force
            mkdir(outputDir);
            warning('Output directory %s created.', outputDir);
        else
            error('Output directory %s does not exist. Set ''Force'' to true?', ...
                  outputDir);
        end
    end
    if ~isempty(dotsPerPoint)
        this.DotsPerPoint = dotsPerPoint;
    end
    this.OutputType = p.Results.OutputType;
    
    if ~iscell(inputFile)
        inputFile = { inputFile }
    end
    for j=1:numel(inputFile)
        this = batch_one(this, inputFile{j},outputDir);
    end
end


function this = batch_one(this, inputFile,outputDir)
    d = dir(inputFile);
    for j=1:numel(d)
        folder = fullfile(outputDir,d(j).folder);
        mkdir(folder);
        batch_single_file(this, d(j).name, folder);
    end
end

function this = batch_single_file(this, inputFile,outputDir)

    this.CurrentFilepath = inputFile;
    this.binarizeCurrentImage;
    lines = this.ImageLines;
    disp("Lines in image: " + numel(lines));
    for j=1:numel(lines)
        filepath = fullfile(outputDir,sprintf('%s_line%03d.png',inputFile,j))
        doWrite = true;
        if exist(filepath,'file') == 2
            if force
                doWrite = true;
            else
                warning('File %s exists, skipping.', filepath);
                doWrite = false;
            end
        end
        if doWrite
            imwrite(lines{j},filepath,'PNG'),
            if verbose
                disp("File " + filepath + " was written.");
            end
        end
    end
end