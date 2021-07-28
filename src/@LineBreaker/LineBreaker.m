classdef LineBreaker < handle
% LineBreaker - breaks up a page into lines
%
%    LineBreaker class can be used standalone or a part of an AppDesigner
% GUI. Size estimates for default size parameters are based on 
% resolution of 72 DPI. This implies that a point is 1 pixel. If the document has
% significantly different resolution, this should be used, so that
% various heuristics about the size of objects, e.g. diacritics, works.
% This is done by setting the property DotsPerPoint (default: 1).
% 
    
    properties
        DotsPerPoint        = 1         % Dots per point
        BigSizeThreshold    = 1024      % Max blob area (points^2) in text
        SmallSizeThreshold  = 10        % Min blob size (points^2) in text
        BinarizationThresh  = 0.2       % The parameter for binarization
        RelDiacriticExpansion  = [2 0]  % As fraction
        AbsDiacriticExpansion  = [6 0]  % As points
        BinarizationType    = 'FixedThreshold';  %The type for binarization 
        CurrentFilepath     = [] % The filepath of the image being processed
        CurrentImage        = []         % The image being processed
        CurrentBWImage      = []         % Binarized and cleaned-up image
        BBoxes              = zeros(0,4) % The positions of objects
        TextBBoxes          = zeros(0,4) % The positions of lines of text
        Bins                = []         % Maps BBoxes to TextBBoxes
        %OverlapType        = 'Min'
        OverlapType         = 'Union'
        OverlapThreshold    = 0.2      % Overlap > this => merge
        MaxDiacriticSize    = [7,7]    % Max. size of a diacritic: [y,x]
        MinLineHeight       = 12       % Min. height of a line
        Force               = false    % Force destructive file operations
        Verbose             = false    % Be verbose
        InputFilePattern    = {}       % The list of patterns for batch processing
        OutputDirectory     = ''       % The path of the output folder (batch)
    end
    
    properties(Access = private)
        app = []                        % The GUI app
        filepath = []                   % File path
        outputTypeCached = 'Input'      % Cached value of OutputType
        RelBoxExpansion                 % As fraction, e.g. [-0.15 3]
        AbsBoxExpansion                 % As points, e.g. [0, 0]   
    end

    properties(Access = public, Hidden)
        InterruptFlag = false;          % Set to true/check to stop iteration
    end

    properties(Dependent, Access = public)
        appDataPath                     % Where the app stores its data
        OutputType                      % 'Input' or 'Binarized'
        OutputImage                     % The image used for output lines
        ImageLines                      % The images of lines
        SortedTextBBoxes                % Text bounding boxes from top to bottom

        % Length parameters originally in points, expressed in pixels
        AdjBigSizeThreshold;            
        AdjSmallSizeThreshold;          
        AdjAbsDiacriticExpansion        
        AdjAbsBoxExpansion              
        AdjMaxDiacriticSize             

        % Box expansions
        RelHorExpansion
        RelVertExpansion
        AbsHorExpansion
        AbsVertExpansion

        InputFilePatternCSV             % Input file pattern as a CSV string
    end
    
    methods
        function RelVertExpansion = get.RelVertExpansion(this)
            RelVertExpansion = this.RelBoxExpansion(1);
        end
        function this = set.RelVertExpansion(this, val)
            this.RelBoxExpansion(1) = val;
        end

        function RelHorExpansion = get.RelHorExpansion(this)
            RelHorExpansion = this.RelBoxExpansion(2);
        end

        function this = set.RelHorExpansion(this, val)
            this.RelBoxExpansion(2) = val;
        end

        function AbsVertExpansion = get.AbsVertExpansion(this)
            AbsVertExpansion = this.AbsBoxExpansion(1);
        end

        function this = set.AbsVertExpansion(this, val)
            this.AbsBoxExpansion(1) = val;
        end

        function AbsHorExpansion = get.AbsHorExpansion(this)
            AbsHorExpansion = this.AbsBoxExpansion(2);
        end

        function this = set.AbsHorExpansion(this, val)
            this.AbsBoxExpansion(2) = val;
        end

        function AdjBigSizeThreshold = get.AdjBigSizeThreshold(this)
            AdjBigSizeThreshold = round(this.BigSizeThreshold .* this.DotsPerPoint.^2);
        end

        function AdjSmallSizeThreshold = get.AdjSmallSizeThreshold(this)
            AdjSmallSizeThreshold = round(this.SmallSizeThreshold .* this.DotsPerPoint.^2);
        end

        function AdjAbsDiacriticExpansion = get.AdjAbsDiacriticExpansion(this)
            AdjAbsDiacriticExpansion = round(this.AbsDiacriticExpansion .* this.DotsPerPoint);
        end

        function AdjAbsBoxExpansion = get.AdjAbsBoxExpansion(this)
            AdjAbsBoxExpansion = round(this.AbsBoxExpansion .* this.DotsPerPoint);
        end

        function AdjMaxDiacriticSize = get.AdjMaxDiacriticSize(this)
            AdjMaxDiacriticSize = round(this.MaxDiacriticSize.* this.DotsPerPoint);
        end
    end

    properties(Dependent,Hidden)
        UIAxes;                         % First plot axes
        UIAxes2;                        % Second plot axes
        UIAxes3;                        % Third plot axes
        UIAxes4;                        % Fourth plot axes
    end

    methods
        function this = LineBreaker(varargin)
            configure(this, varargin{:});
        end
        
        function configure(this, varargin)
            p = inputParser;
            p.addOptional('app',[],@(x)isempty(x)||isa(x,'LineBreakerApp'));
            p.addParameter('Force',false,@(x)islogical(x)||ischar(x));
            p.addParameter('Verbose',false,@(x)islogical(x)||ischar(x));
            p.addParameter('DotsPerPoint',1,@(x)isscalar(x)||isempty(x));
            p.addParameter('AbsHorExpansion',0,@isscalar);
            p.addParameter('AbsVertExpansion',0,@isscalar);
            p.addParameter('RelHorExpansion',3,@isscalar);
            p.addParameter('RelVertExpansion',-0.15,@isscalar);

            defaultBinarizationType = 'AdaptiveMean';
            expectedBinarizationTypes = { 'FixedThreshold', 'Global', ...
                                'AdaptiveMean', 'AdaptiveGaussian',...
                                'AdaptiveMedian'};

            p.addParameter('BinarizationType',defaultBinarizationType,...
                           @(x) any(validatestring(x, expectedBinarizationTypes)));    

            p.addParameter('BinarizationThresh',0.2,@isscalar);
            p.addParameter('SmallSizeThreshold',10,@isscalar);            
            p.addParameter('BigSizeThreshold',1024,@isscalar);

            defaultOutputType = 'Input';
            expectedOutputTypes = {'Input','Binarized'};
            p.addParameter('OutputType',defaultOutputType,...
                           @(x) any(validatestring(x, expectedOutputTypes)));    
            defaultInputFilePattern = fullfile('..','images','*.png');
            p.addParameter('InputFilePattern',defaultInputFilePattern,...
                           @(x) ischar(x) || isstring(x) || iscell(x));
            defaultOutputDirectory = fullfile('..','Bingo');
            p.addParameter('OutputDirectory',defaultOutputDirectory,...
                           @(x) ischar(x));
            p.parse(varargin{:});    

            this.app = p.Results.app;
            this.AbsVertExpansion = p.Results.AbsVertExpansion;
            this.AbsHorExpansion = p.Results.AbsHorExpansion;            
            this.RelVertExpansion = p.Results.RelVertExpansion;
            this.RelHorExpansion = p.Results.RelHorExpansion;            
            this.BinarizationThresh = p.Results.BinarizationThresh;
            this.SmallSizeThreshold = p.Results.SmallSizeThreshold;
            this.BinarizationType = p.Results.BinarizationType;
            this.BigSizeThreshold = p.Results.BigSizeThreshold;
            this.OutputType = p.Results.OutputType;
            this.Force = p.Results.Force;
            this.Verbose= p.Results.Verbose;
            this.InputFilePattern = p.Results.InputFilePattern;
            this.OutputDirectory = p.Results.OutputDirectory;

            % Fix values in deployed applications
            if isdeployed
                if ischar(this.Force)
                    this.Force = str2num(this.Force);
                end
                if ischar(this.Verbose)
                    this.Verbose = str2num(this.Verbose);
                end
                if ischar(this.DotsPerPoint)
                    this.DotsPerPoint = str2num(this.DotsPerPoint);
                end
            end
        end

        function appDataPath = get.appDataPath(this)
            if isdeployed
                % We will find the files in the 'application' folder
                appDataPath = '';
            else
                % We're running within MATLAB, either as a MATLAB app,
                % or from a copy of the current folder. If we're running
                % as a MATLAB app, we need to get the application folder
                % by using matlab.apputil class.
                apps = matlab.apputil.getInstalledAppInfo;
                ind=find(cellfun(@(x)strcmp(x,this.app_name),{apps.name}));
                if isempty(ind)
                    appDataPath = '.';             % Current directory
                else
                    appDataPath = apps(ind).location; % This app is installed, its path
                end
            end
        end

        this = locateText(this)
        this = openFile(this, event)
        this = closeFile(this, event)
        plot(this)
        lines = getImageLines(this)
        this = saveLines(this, event)
        this = writeLines(this, dirname)
        
        function UIAxes = get.UIAxes(this)
            if ~isempty(this.app);
                UIAxes = this.app.UIAxes;
            else
                UIAxes = subplot(1,4,1);
            end
        end
        function UIAxes2 = get.UIAxes2(this)
            if ~isempty(this.app);
                UIAxes2 = this.app.UIAxes2;
            else
                UIAxes2 = subplot(1,4,2);
            end
        end
        function UIAxes3 = get.UIAxes3(this)
            if ~isempty(this.app);
                UIAxes3 = this.app.UIAxes3;
            else
                UIAxes3 = subplot(1,4,3);
            end
        end

        function UIAxes4 = get.UIAxes4(this)
            if ~isempty(this.app);
                UIAxes4 = this.app.UIAxes4;
            else
                UIAxes4 = subplot(1,4,4);
            end
        end

        function this = set.OutputType(this, OutputType)
            expectedOutputTypes = {'Input','Binarized'};
            any(validatestring(OutputType, expectedOutputTypes));    
            this.outputTypeCached = OutputType;
        end

        function OutputType = get.OutputType(this)
            OutputType = this.outputTypeCached;
        end

        function ImageLines = get.ImageLines(this)
            ImageLines = getImageLines(this);
        end
        
        function OutputImage = get.OutputImage(this)
            switch this.OutputType
              case 'Input',
                OutputImage = this.CurrentImage;
              case 'Binarized',
                OutputImage = this.CurrentBWImage;
            end
        end


        function this = set.CurrentFilepath(this, filepath)
            if isempty(filepath)
                this.CurrentFilepath = [];
                this.CurrentImage = [];
                this.TextBBoxes = [];
                this.DotsPerPoint = [];
            elseif exist(filepath,'file') == 2
                try 
                    this.CurrentFilepath = filepath;
                    this.CurrentImage = LineBreaker.readImage(filepath);
                    this.guessResolution;
                catch me
                    this.CurrentFilepath = [];
                    this.CurrentImage =[];
                    this.TextBBoxes = [];
                    this.DotsPerPoint = [];
                    this.notifyFileCompleted(['Invalid image file: ', filepath ]);
                end
            end
            if ~isempty(this.app)
                this.app.EmptyFilePathLabel.Text = this.CurrentFilepath;
            end
        end
        
        function this = set.InputFilePattern(this, pattern)
            if ischar(pattern)
                this.InputFilePattern = split(pattern,pathsep)';
            elseif isstring(pattern)
                pattern = split(pattern,pathsep)';
                % Now we have a 1-by-N string array, we need a cell array
                % of char vectors:
                this.InputFilePattern = arrayfun(@(j)cellstr(char(pattern(j))),1:numel(pattern));
            elseif iscell(pattern) & all(cellfun(@ischar,pattern))
                this.InputFilePattern = pattern;
            else
                this.InputFilePattern = [];
            end
        end

        function InputFilePatternCSV = get.InputFilePatternCSV(this)
            InputFilePatternCSV = strjoin(this.InputFilePattern,pathsep);
        end

        this = findOverlapsFirstPass(this)
        this = findOverlapsSecondPass(this)

        function linkAxes(this)
            if isempty(this.app)
                linkaxes([this.UIAxes,this.UIAxes2,this.UIAxes3,this.UIAxes4]);
            end
        end

        function SortedTextBBoxes = get.SortedTextBBoxes(this)
            [~,idx] = sort(this.TextBBoxes(:,2),'ascend');
            SortedTextBBoxes = this.TextBBoxes(idx,:);
        end

        this = batch(this,inputFile,outputDir, varargin)
        this = guessResolution(this)
        this = binarizeCurrentImage(this)
        this = showBinarizedImage(this)
        this = notifyFileCompleted(this, filename_or_msg)
    end


    methods(Static)
        d = rect_dist(a, b)
        idx = isProperSubBox(boxA,boxB)
        idx = isSubBox(boxA,boxB)
        expandedBBoxes = expandBox(bboxes,relExpansion,absExpansion,clippingSize)
        dotsPerPoint = estimateResolution(size, papersize)
        I = readImage(filepath)
        absPath = getAbsPath(obj)
    end

    methods(Static,Access = private)
        boxBounds = convertBox(bboxes)
        bboxes = invertConvertBox(boxBounds)
        BW = binarizeImage(fig,I,Type,Thres)
    end
end

