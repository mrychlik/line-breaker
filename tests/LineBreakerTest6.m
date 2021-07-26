%----------------------------------------------------------------
% File:     LineBreakerTest6.m
%----------------------------------------------------------------
%
% Author:   Marek Rychlik (rychlik@u.arizona.edu)
% Date:     Mon Apr  6 11:34:40 2020
% Copying:  (C) Marek Rychlik, 2019. All rights reserved.
% 
%----------------------------------------------------------------
% Test of batch processing of a single file. Tests 'Force' option
inputFile = fullfile('..','images','azu_acku_bl51_seen79_1349_w-000016.png');
outputDir = fullfile('.','Lines-azu_acku_bl51_seen79_1349_w-000016');
ob = LineBreaker('Force',true,'Verbose',true);
ob = ob.batch(inputFile,outputDir);

