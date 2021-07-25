%----------------------------------------------------------------
% File:     LineBreakerTest5.m
%----------------------------------------------------------------
%
% Author:   Marek Rychlik (rychlik@u.arizona.edu)
% Date:     Sun Apr  5 18:22:08 2020
% Copying:  (C) Marek Rychlik, 2019. All rights reserved.
% 
%----------------------------------------------------------------
% Test of batch processing of a single file. Tests 'Force' option
preamble;
inputFile = fullfile('..','images','sinat-074.png');
outputDir = fullfile('.','Lines-sinat-074');
ob = LineBreaker;
ob.SmallSizeThreshold = 10;
ob.batch(inputFile,outputDir,'Force',true,'Verbose',true);

