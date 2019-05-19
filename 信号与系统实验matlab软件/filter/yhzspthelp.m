function varargout = spthelp(varargin)
%SPTHELP  Context sensitive Help facility for SPTool and clients.
% This function has three main modes.  The first two are a pair:
%  an 'enter' mode, and an 'exit' mode which is usually called 
%  by this function automatically
% The third mode takes a tag and a help file and displays the help
%  for that tag in helpwin.
% ----------------------------------------------------------------
% spthelp('enter',fig,saveEnableControls,ax,titleStr,helpFcn)
% Enter context sensitive help mode.
%  Clears windowbuttonmotionfcn
%  sets enable of all uicontrols to inactive
%  sets buttondownfcn of all uicontrols and selected axes and their children
%   to spthelp('exit',get(gcbo,'tag'))
%  sets callback of all uimenus at the bottom level (no children) to 
%   spthelp('exit',get(gcbo,'tag'))
%  sets ud.pointer to 2 (stands for help mode)
%  saves all this in the userdata structure of the input figure
% Inputs:
%    fig - figure handle
%    saveEnableControls - list of handles of uicontrols whose enable property
%       needs to be restored after help mode.
%    ax - list of non-btngroup axes handles.  All lines, patches, and text
%       children of these axes are temporarily set to call spthelp for their
%       buttondownfcns.
%    titleStr - this will be used as the title for the helpwin
%    helpFcn - function name.  This function will be called with the
%       tag1 (or tag1:tag2) parameters and must return a cell array
%       of strings as per the multi-topic input of 'helpwin'
% ---------------------------------------------------------------
% spthelp('exit',tag1,tag2)
% Display help for object with tag1 (or tag1:tag2) in helpwin
% then leave context sensitive help mode, restoring figure to original condition.
% Inputs:
%    tag1 - string, tag of object clicked on; optional; defaults to 'help'
%    tag2 - optional; if present, helpFcn will be called with 'tag1:tag2' tag.
% ---------------------------------------------------------------
% spthelp('tag',fig,titleStr,helpFcn,tag1,tag2)
% Takes a tag and a help file and displays the help
%  for that tag in helpwin.
% Inputs:
%    fig - figure handle of calling tool
%    titleStr - this will be used as the title for the helpwin
%    helpFcn - function name.  This function will be called with the
%       tag1 (or tag1:tag2) parameters and must return a cell array
%       of strings as per the multi-topic input of 'helpwin'

%  This function has a modal behavior depending on the value of
%  ud.pointer.
%  On entry: 
%     ud.pointer == 2  --> sphelp displays help and sets ud.pointer 
%                          to 0 (leave help mode).
%     ud.pointer ~= 2  --> set ud.pointer to 2 (enter help mode).

%   Copyright (c) 1988-97 by The MathWorks, Inc.
% $Revision: 1.5 $

action = varargin{1};

switch action
case 'enter'
% Enter help mode
   fig = varargin{2};
   saveEnableControls = varargin{3};
   ax = varargin{4};
   titleStr = varargin{5};
   helpFcn = varargin{6};

   ud = get(fig,'userdata');
   
   ud.help.helpFcn = helpFcn;
   ud.help.titleStr = titleStr;
   ud.help.oldwbdf = get(fig,'windowbuttondownfcn');
   ud.help.saveEnableControls = saveEnableControls;
   ud.help.ax = ax;
   
   set(fig,'windowbuttondownfcn','')

   saveEnable = get(saveEnableControls,'enable');
   if length(saveEnableControls)==1
       set(saveEnableControls,'userdata',saveEnable)
   else
       set(saveEnableControls,{'userdata'},saveEnable)
   end
   
   shelpButtonDownFcn = 'sbswitch(''yhzspthelp'',''exit'',get(gcbo,''tag''))';
   uiControls = findobj(fig,'type','uicontrol');
   set(uiControls,'enable','inactive')
   set(uiControls,'buttondownfcn',shelpButtonDownFcn)
   set(ax,'buttondownfcn',shelpButtonDownFcn)
   lines = findobj(ax,'type','line');
   saveLineButtonDownFcns = get(lines,'buttondownfcn');
   if length(lines)==1
      set(lines,'userdata',saveLineButtonDownFcns);
   else   
      set(lines,{'userdata'},saveLineButtonDownFcns);
   end   
   set(lines,'buttondownfcn',shelpButtonDownFcn)
   texts = findobj(ax,'type','text');
   set(texts,'buttondownfcn',shelpButtonDownFcn)

   % find all uimenus with no children:
   uiMenus = findobj(fig,'type','uimenu','children',zeros(0,1));
   ind = Localfindcstr(get(uiMenus,{'tag'}),'winmenu');
   uiMenus(ind) = [];
   for i=length(uiMenus):-1:1
      p = get(uiMenus(i),'parent');
      if ishandle(p) & strcmp(get(p,'tag'),'winmenu')
         uiMenus(i) = [];
      end
   end 
   saveUiMenuCallbacks = get(uiMenus,'callback');
   saveUiMenuEnable = get(uiMenus,'enable');
   set(uiMenus, 'callback', shelpButtonDownFcn,'enable','on')
   if length(uiMenus)==1
      saveUiMenuCallbacks = {saveUiMenuCallbacks};
      saveUiMenuEnable = {saveUiMenuEnable };
   end
   set(uiMenus, {'userdata'}, saveUiMenuCallbacks)

   ud.pointer = 2;
   ud.help.saveEnable = saveEnable;
   ud.help.saveUiMenuEnable = saveUiMenuEnable;
   set(fig,'userdata',ud)

   setptr(fig,'help')
   
case 'exit'

% We are coming out of help mode - figure out where from and display help
   fig = gcf;
   if ~isequal(gcbf, fig) & ishandle(gcbf)
      figure(gcbf);
      fig = gcbf;
   end
   ud = get(fig,'userdata');
   set(fig,'windowbuttondownfcn',ud.help.oldwbdf)
   
   if ~isempty(findobj(fig,'tag','helpgroup'))
       btnup(fig,'helpgroup','help')  % restore help button to up state
   end
   uiControls = findobj(fig,'type','uicontrol');
   set(uiControls,'enable','on')
   set(uiControls,'buttondownfcn','')

   ax = ud.help.ax;
   set(ax,'buttondownfcn','')
   lines = findobj(ax,'type','line');
   set(lines,'buttondownfcn','')
   texts = findobj(ax,'type','text');
   set(texts,'buttondownfcn','')

   if nargin > 2
       s=sprintf([varargin{2} ':' varargin{3}]);
   elseif nargin > 1
       s=sprintf(varargin{2});
   else
       s=sprintf('help');
   end

   str = feval(ud.help.helpFcn,s,fig);
   
   %if strcmp(computer,'MAC2')
   %   crchar = 13;
   %else
      crchar = 10;
   %end

   for i=1:size(str,1)
      str{i,2} = char(str{i,2});
      str{i,2} = [str{i,2},crchar*ones(size(str{i,2},1),1)]';
      str{i,2} = str{i,2}(:)';
   end

   helpwin(str,str{1,1},ud.help.titleStr)

   % ASSUMPTION:  ORDER OF FINDOBJ RESULTS IS THE SAME NOW AS
   %  WHEN CALLBACKS / BUTTONDOWNFCNS WERE SAVED
   restoreEnableControls = ud.help.saveEnableControls;
   restoreEnable = get(restoreEnableControls,'userdata');
   if length(restoreEnableControls)==1
       set(restoreEnableControls,'enable',restoreEnable)
   else
       set(restoreEnableControls,{'enable'},restoreEnable)
   end
   restoreLineButtonDownFcns = get(lines,'userdata');
   set(lines,{'buttondownfcn'},restoreLineButtonDownFcns);

   % find all uimenus with no children:
   uiMenus = findobj(fig,'type','uimenu','children',zeros(0,1));
   ind = Localfindcstr(get(uiMenus,{'tag'}),'winmenu');
   uiMenus(ind) = [];
   for i=length(uiMenus):-1:1
      p = get(uiMenus(i),'parent');
      if ishandle(p) & strcmp(get(p,'tag'),'winmenu')
         uiMenus(i) = [];
      end
   end 
   restoreUiMenuCallbacks = get(uiMenus,'userdata');
   restoreUiMenuEnable = ud.help.saveUiMenuEnable;
   if length(uiMenus)==1
      restoreUiMenuCallbacks = {restoreUiMenuCallbacks};
   end
   set(uiMenus, {'callback'}, restoreUiMenuCallbacks)
   set(uiMenus,{'enable'},restoreUiMenuEnable)

   ud.pointer = 0;
   set(fig,'userdata',ud)
   setptr(fig,'arrow')

case 'tag'
   fig = varargin{2};
   titleStr = varargin{3};
   helpFcn = varargin{4};
   if nargin > 5
       s=sprintf([varargin{5} ':' varargin{6}]);
   elseif nargin > 4
       s=sprintf(varargin{5});
   else
       s=sprintf('help');
   end
   
   str = feval(helpFcn,s,fig);
   
   %if strcmp(computer,'MAC2')
   %   crchar = 13;
   %else
      crchar = 10;
   %end

   for i=1:size(str,1)
      str{i,2} = char(str{i,2});
      str{i,2} = [str{i,2},crchar*ones(size(str{i,2},1),1)]';
      str{i,2} = str{i,2}(:)';
   end

   helpwin(str,str{1,1},titleStr)
end

function ind = Localfindcstr(cstr,str)
%Localfindcstr  Finds occurrences of string in cell array of strings.
%   IND = Localfindcstr(CSTR,STR) finds the indices of the cell array of strings
%   CSTR where CSTR{IND(I)} == STR, for I from 1 to length(IND).

%   Copyright (c) 1988-97 by The MathWorks, Inc.
%       $Revision: 1.7 $

if isempty(cstr)
    ind = [];
    return
end
for i=prod(size(cstr)):-1:1
    ind(i) = strcmp(cstr{i},str);
end
ind = find(ind);


