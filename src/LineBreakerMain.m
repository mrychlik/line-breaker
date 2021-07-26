%----------------------------------------------------------------
% File:     LineBreakerMain.m
%----------------------------------------------------------------
%
% Author:   Marek Rychlik (rychlik@u.arizona.edu)
% Date:     Sun Apr  5 10:19:50 2020
% Copying:  (C) Marek Rychlik, 2019. All rights reserved.
% 
%----------------------------------------------------------------
% The main file of a standalone LineBreaker application
function LineBreakerMain(inputFile,outputDir,varargin)
    import LineBreaker.*;
    ob = LineBreaker;
    ob.configure(varargin{:});
    ob = ob.batch(inputFile,outputDir);
    quit(0,"force");
end

