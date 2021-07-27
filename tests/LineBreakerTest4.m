%----------------------------------------------------------------
% File:     LineBreakerTest4.m
%----------------------------------------------------------------
%
% Author:   Marek Rychlik (rychlik@u.arizona.edu)
% Date:     Sun Apr  5 09:47:56 2020
% Copying:  (C) Marek Rychlik, 2019. All rights reserved.
% 
%----------------------------------------------------------------
preamble;
% Test of batch processing of a single file. Tests 'Force' option
inputFile = fullfile('..','images','page-14.png');
outputDir = fullfile('..','Bingo','Lines-page-14');
ob=LineBreaker('Force',true,'Verbose',true);
ob=ob.batch(inputFile,outputDir);

