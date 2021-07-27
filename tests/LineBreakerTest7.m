%----------------------------------------------------------------
% File:     LineBreakerTest7.m
%----------------------------------------------------------------
%
% Author:   Marek Rychlik (rychlik@email.arizona.edu)
% Date:     Sun Jul 25 10:40:24 2021
% Copying:  (C) Marek Rychlik, 2020. All rights reserved.
% 
%----------------------------------------------------------------
% Chinese
preamble;
inputFile = fullfile('..','images','38059-000001.png');
outputDir = fullfile('.','Lines-38059-000001');
ob = LineBreaker('Force',true,'Verbose',true);
ob = ob.batch(inputFile,outputDir);

