%----------------------------------------------------------------
% File:     LineBreakerTest1.m
%----------------------------------------------------------------
%
% Author:   Marek Rychlik (rychlik@u.arizona.edu)
% Date:     Sun Apr  5 10:12:33 2020
% Copying:  (C) Marek Rychlik, 2019. All rights reserved.
% 
%----------------------------------------------------------------
preamble;
ob = LineBreaker;
ob.CurrentFilepath = fullfile('..','images','page-14.png');
lines = ob.ImageLines;
