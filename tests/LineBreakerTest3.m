%----------------------------------------------------------------
% File:     LineBreakerTest3.m
%----------------------------------------------------------------
%
% Author:   Marek Rychlik (rychlik@u.arizona.edu)
% Date:     Sun Apr  5 09:33:11 2020
% Copying:  (C) Marek Rychlik, 2019. All rights reserved.
% 
%----------------------------------------------------------------
preamble;
% Test of batch processing of a single file
inputFile = fullfile('..','images','page-14.png');
outputDir = fullfile('.','Lines-page-14');
mkdir(outputDir);
ob=LineBreaker;
ob=ob.batch(inputFile,outputDir);

