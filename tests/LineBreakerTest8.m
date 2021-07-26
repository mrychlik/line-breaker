%----------------------------------------------------------------
% File:     LineBreakerTest8.m
%----------------------------------------------------------------
%
% Author:   Marek Rychlik (rychlik@email.arizona.edu)
% Date:     Sun Jul 25 10:47:13 2021
% Copying:  (C) Marek Rychlik, 2020. All rights reserved.
% 
%----------------------------------------------------------------
% Chinese
preamble;
inputFile = fullfile('..','images','38004.png');
outputDir = fullfile('.','Chars-38004-mono');
ob = LineBreaker;
ob.RelHorExpansion = 0.15;
ob.RelVertExpansion = 0.05;
ob.BigSizeThreshold = 1;
ob.SmallSizeThreshold = 1;
ob.BinarizationType = 'AdaptiveMean';
ob.BinarizationThresh = 0.12;
ob.Force = true;
ob.Verbose = true;
ob.DotsPerPoint = [];
ob.OutputType = 'Binarized';
ob = ob.batch(inputFile,outputDir);


