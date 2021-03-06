function xhsy;
% XHSY Signal and System CAI run file.

echo off;
clc;
close all;

%========================================
% Precompile map function
snsmap null

%========================================
% Initialize important default values
%global t z1 z2 z3 z4

%========================================
% Restore important applications
! copy .\models\*.* .\*.* >NUL

%========================================
% Create the SPLASH window
figNumber=figure( ...
   'BackingStore','on', ...
   'menubar','none',...
   'NumberTitle','off', ...
   'Name','欢迎来到《信号与系统》实验教学系统', ...
   'Resize','off', ...
   'Units','normalized', ...
   'Position',[0.16 0.16 0.67 0.67], ...
   'Pointer','watch');
axHndl1=axes( ...
   'Parent',figNumber, ...
   'position',[0 0 1 1], ...
   'Units','normalized', ...
   'Visible','off');

%========================================
% Create the START button
callbackStr='snsmap(''start'');';
contHndl=uicontrol( ...
   'Parent',figNumber, ...
   'Style','pushbutton', ...
   'Units','normalized', ...
   'Position',[0.6 0.05 0.15 0.09], ...
   'FontSize',10, ...
   'String','开  始', ...
   'Enable','off', ...
   'TooltipString','从此进入《信号与系统》实验教学系统……', ...
   'Callback',callbackStr);

%========================================
% Create the HELP button
helpCallback='snsmap(''help'');';
hlpHndl=uicontrol( ...
   'Parent',figNumber, ...
   'Style','pushbutton', ...
   'Units','normalized', ...
   'Position',[0.8 0.05 0.15 0.09], ...
   'FontSize',10, ...
   'String','帮  助', ...
   'Enable','off', ...
   'TooltipString','请看有关本软件的帮助信息……', ...
   'Callback',helpCallback);

%========================================
% Put up "SnS" background image
axes(axHndl1);
load('.\images\fig_cover.mat');
colormap(map);
image(x);
clear x map;
set(axHndl1,'Visible','off');

%========================================
% Set Copyright information
info=['设计制作：西安交通大学信通系教研室' char(10), ...
      '　　　　　版权所有 (C) 1998－2000'];
text( ...
   'Position',[20 440], ...
   'HorizontalAlignment','left', ...
   'String',info, ...
   'FontName','宋体', ...
   'FontSize',9);

set([contHndl hlpHndl],'Enable','on');
set(0,'DefaultFigureColor',[0.7 0.7 0.7])
set(0,'DefaultAxesColor','w')
set(figNumber,'Pointer','arrow','Visible','on');
clc
