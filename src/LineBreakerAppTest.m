%----------------------------------------------------------------
% File:     LineBreakerAppTest.m
%----------------------------------------------------------------
%
% Author:   Marek Rychlik (rychlik@email.arizona.edu)
% Date:     Wed Jul 29 11:30:16 2020
% Copying:  (C) Marek Rychlik, 2020. All rights reserved.
% 
%----------------------------------------------------------------
% This tests the interaction between comand line and GUI

% Build the app
app = LineBreakerApp;

% Get the non-gui component (object of class LineBreaker)
ob = app.ob;

% Set the filepath
ob.CurrentFilepath = fullfile('..','images','page-14.png');

% Retrieve the lines of text
lines = ob.ImageLines;
