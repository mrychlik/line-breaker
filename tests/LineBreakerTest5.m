%----------------------------------------------------------------
% File:     LineBreakerTest5.m
%----------------------------------------------------------------
%
% Author:   Marek Rychlik (rychlik@u.arizona.edu)
% Date:     Sun Apr  5 18:22:08 2020
% Copying:  (C) Marek Rychlik, 2019. All rights reserved.
% 
%----------------------------------------------------------------
% Test of batch processing of two files. Tests 'Force' option
preamble;
% Construct a list of two patterns separated with the pathsep (':' on Unix, ';' on Windows).
inputFile = [fullfile('..','images','sinat-074.png'),...
             pathsep,...
             fullfile('..','images','azu_acku_bl51_seen79_1349_w-000016.png')];

% Folder to place the output (image files with lines) of both images
outputDir = fullfile('..','Bingo','Lines-sinat-074-and-azu_acku_bl51_seen79_1349_w-000016');

ob = LineBreaker('Force',true,'Verbose',true);
ob.SmallSizeThreshold = 10;

% Start batch processing of both files
ob.batch(inputFile,outputDir);

