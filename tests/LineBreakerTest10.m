%----------------------------------------------------------------
% File:     LineBreakerTest10.m
%----------------------------------------------------------------
%
% Author:   Marek Rychlik (rychlik@email.arizona.edu)
% Date:     Sun Jul 25 11:55:24 2021
% Copying:  (C) Marek Rychlik, 2020. All rights reserved.
% 
%----------------------------------------------------------------
% Processing multiple files. As a demo, we process all images
% supplied with the project, but the results will not be
% good for all files, as the parameters must be tuned
% for specific content.

preamble;
inputFile = fullfile('..','images','*.png');
outputDir = fullfile('.','All-Images');
ob = LineBreaker;
ob.RelHorExpansion = 0.15;
ob.RelVertExpansion = 0.05;
ob.BigSizeThreshold = 1;
ob.SmallSizeThreshold = 1;
ob.BinarizationType = 'AdaptiveMean';
ob.BinarizationThresh = 0.12;
ob = ob.batch(inputFile,outputDir,...
              'Force',true,...
              'Verbose',true,...
              'DotsPerPoint',[],...
              'OutputType', 'Input');


