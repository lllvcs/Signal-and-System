function varargout=yhzfiltdes_temp(action,varargin);
%yhzfiltdes Filter Designer.
%   This graphical tool allows you to design lowpass, highpass, bandpass, 
%   and bandstop digital filters.
%
%   Type 'sptool' to start the Signal Processing GUI Tool and access
%   the Filter Designer.
%
%   [B,A] = yhzfiltdes('getfilt') returns the numerator coefficients in B 
%   and denominator coefficients in A of the current filter.
%
%   [B,A,Fs] = yhzfiltdes('getfilt') returns the sampling frequency Fs also.
%
%   See also SPTOOL, SIGBROWSE, FILTVIEW, SPECTVIEW.

%   Author: T. Krauss, 3/7/94
%   Copyright (c) 1988-97 by The MathWorks, Inc.
%   $Revision: 1.39 $

if nargin==0 
    if isempty(findobj(0,'tag','sptool'))
        disp('Type ''sptool'' to start the Signal GUI.')
    else
        disp('To use the Filter Designer, click on the ''Design New'' button')
        disp('under the ''Filters'' column in the ''SPTool''.')
    end
    return
end

tempfilt = [];

if nargin == 1
    if ~isstr(action)
        tempfilt = action;
        action = 'initialize';
    end
end



case 'designnow'   % Design filter now
% -------------------------------------------------------------------------
% yhzfiltdes('designnow')
%   callback for 'Update Now' menu item
%
    ud=get(gcf,'Userdata');
    set(gcf,'Pointer','watch');
    set(get(ud.ht.ax1,'title'),'string','Designing filter ...')
    xstr = get(get(ud.ht.ax1,'xlabel'),'string');
    set(get(ud.ht.ax1,'xlabel'),'string',...
        '(Type Control-C in Command window to interrupt)')
    drawnow
    [title_str,errflag] = yhzfiltdes('design');   % design filter
    set(get(ud.ht.ax1,'title'),'string',[ud.label ': ' title_str],...
           'tag','maintitle')
    set(get(ud.ht.ax1,'xlabel'),'string',xstr)
    if ~errflag
        yhzfiltdes('response')              % compute frequency response
        set(ud.ht.magline,'linestyle','-')      % make magline solid
        set(ud.ht.designmenu,'enable','off')       % disable 'Update Now' menu
    else
        set(ud.ht.designmenu,'enable','on') 
    end
    set(gcf,'Pointer','arrow');




    
case 'getfilt'
% -------------------------------------------------------------------------
% [b,a,Fs] = yhzfiltdes('getfilt')
%   retrieve filter coefficients from tool
%   whichone specifies which tool to get from
%
    shh = get(0,'showhiddenhandles');
    set(0,'showhiddenhandles','on');

    % first, find the tool
    fig = findobj('type','figure','tag','yhzfiltdes');
    if isempty(fig)
        set(0,'showhiddenhandles',shh)
        error('No Filter Design Tool is open - can''t get coefficients.')
    end
    ud=get(fig,'Userdata');

    Fs = ud.specs.Fs;     % sampling frequency
    b = ud.num;
    a = ud.den;
    if nargout >= 1, varargout{1} = b; end
    if nargout >= 2, varargout{2} = a; end
    if nargout >= 3, varargout{3} = Fs; end

    set(0,'showhiddenhandles',shh)

case 'print'
% -------------------------------------------------------------------------
% yhzfiltdes('print')
%   Print the contents of the yhzfiltdes (assumed in gcf)
%
    

%------------------------------------------------------------------------
% enable = yhzfiltdes('selection',verb.action,msg,SPTfig)
%  respond to selection change in SPTool
% possible actions are
%    'create'
%    'change'
%  Button is enabled when
%     a) there is a filter selected which is a valid design
%     b) there are no filters selected (makes a new design)
%case 'selection'
%    msg = varargin{2};
%    SPTfig = varargin{3};
%    switch varargin{1}
%    case 'create'
%        enable = 'on';  % this creates a new design; can always hit this button
%        % also need to focus the yhzfiltdes on the currently selected filter
%        fig = findobj('type','figure','tag','yhzfiltdes');
%        if ~isempty(fig)  % the yhzfiltdes is open
%            f = sptool('Filters',0,SPTfig);  % get the selected filter
%            ud = get(fig,'userdata');
%            % before comparison, copy fields that filtview may have changed but
%            % yhzfiltdes doesn't care about:
%            if ~isempty(f)
%                ud.filt.imp   = f.imp;
%                ud.filt.step  = f.step;
%                ud.filt.t     = f.t;
%                ud.filt.H     = f.H;
%                ud.filt.G     = f.G;
%                ud.filt.f     = f.f;
%                ud.filt.zpk   = f.zpk;
%            end
%            if isequal(f,ud.filt)
%                varargout{1} = enable;
%                return
%            end
%            switch msg
%            case 'Fs'
%                set(ud.ht.FsHndl,'string',sprintf('%.9g',f.Fs))
%                if strcmp(f.type,'design') & (f.Fs ~= f.specs.Fs)
%                    ud.filt = f;
%                   set(fig,'userdata',ud)
%                    yhzfiltdes('setFs',fig)
%                end
%            otherwise
%                yhzfiltdes('setfilt',f,fig)
%            end
%        end
%    case 'change'
%        f = sptool('Filters',0,SPTfig);
%        if isempty(f)
%            enable = 'off';
%        elseif strcmp(f.type,'design')
%            enable = 'on';  % this edits current design
%        else
%            enable = 'off';
%        end
%    end
%    varargout{1} = enable;
    

%------------------------------------------------------------------------
% yhzfiltdes('action',verb.action)
%  respond to button push in SPTool
% possible actions are
%    'create'
%    'change'
case 'action'
    switch varargin{1}
    case 'change'
        SPTfig = gcf;
        f = sptool('Filters',0);  % get the selected filter
        fig = findobj('type','figure','tag','yhzfiltdes');
        if isempty(fig)  % create the spectview tool
            yhzfiltdes(f)
            fig = gcf;
        end
        % bring spectview figure to front:
        figure(fig)
    case 'create'
        SPTfig = gcf;
        [specs,num,den] = yhzfiltdes('getspecs','factory');
        [err,errstr,struc] = importfilt('make',{1 num den 1});
        struc.type = 'design';
        struc.specs = specs;
        
        labelList = sptool('labelList',SPTfig);
        [popupString,fields,FsFlag,defaultLabel] = importfilt('fields');
        struc.label = uniqueDefaultLabel(labelList,defaultLabel);
        
        fig = findobj('type','figure','tag','yhzfiltdes');
        if isempty(fig)  % create the yhzfiltdes tool if not open
            yhzfiltdes(struc)
            fig = gcf;
        end

        sptool('import',struc,1)  % puts new struc in SPTool AND
                  % focuses yhzfiltdes on the struc
        
        % now bring yhzfiltdes to the front:
        figure(fig)
    end
    
%------------------------------------------------------------------------
% yhzfiltdes('SPTclose',verb.action)
%  respond to SPTool closing
% possible actions are
%    'design'
case 'SPTclose'
    yhzfiltdes('close')
    
case 'close'
% -------------------------------------------------------------------------
% yhzfiltdes('close')
%   Close the yhzfiltdes and all associated figures:
%       special filter parameters dialog box
%       tool parameters dialog box
%
    figname = prepender('Filter Designer');
    fig = findobj('type','figure','name',figname);
    if ~isempty(fig)
        ud = get(fig,'userdata');
        delete(fig)
    else
        return
    end

    if ~isempty(ud.paramdlg)
        delete(ud.paramdlg)
    end
    if ~isempty(ud.tabfig)
        delete(ud.tabfig)
    end
%------------------------------------------------------------------------
% errstr = yhzfiltdes('setprefs',panelName,p)
% Set preferences for the panel with name panelName
% Inputs:
%   panelName - string; must be either 'ruler','color', or 'sigbrowse'
%              (see sptprefreg for definitions)
%   p - preference structure for this panel
case 'setprefs'
    errstr = '';
    panelName = varargin{1};
    p = varargin{2};
    % first do error checking
    switch panelName        
    case 'yhzfiltdes'
        arbitrary_obj = {'arb' 'obj'};
        fgrid = evalin('base',p.fgrid,'arbitrary_obj');
        if isequal(fgrid,arbitrary_obj)
            errstr = ['Sorry, the Frequency Grid Spacing' ... 
                      ' you entered could not be evaluated.'];
        elseif  isempty(fgrid) | ( fgrid<=0 | ~isreal(fgrid) )
            errstr = ['The Frequency Grid Spacing must be a positive, real scalar.'];
        end
        if isempty(errstr)
            mgrid = evalin('base',p.mgrid,'arbitrary_obj');
            if isequal(mgrid,arbitrary_obj)
                errstr = ['Sorry, the Magnitude Grid Spacing' ... 
                          ' you entered could not be evaluated.'];
            elseif isempty(mgrid) |  (mgrid<=0 | ~isreal(mgrid))
                errstr = ['The Magnitude Grid Spacing' ...
                          ' must be a positive, real scalar.'];
            end
        end
    end
    
    varargout{1} = errstr;
    if ~isempty(errstr)
        return
    end
        
    % now set preferences
    fig = findobj('type','figure','tag','yhzfiltdes');
    if ~isempty(fig)
        ud = get(fig,'userdata');
        newprefs = ud.prefs;
        switch panelName
        case 'yhzfiltdes'
            newprefs.tool.zoompersist = p.zoomFlag;
            newprefs.nfft = evalin('base',p.nfft);
            xgridsize = evalin('base',p.fgrid);        %  Hz  grid size
            ygridsize = evalin('base',p.mgrid);        %  dB  grid size
            newprefs.gridsize = [xgridsize ygridsize];
            newprefs.gridding = p.gridflag;   % snap to grid ?
        end
        if newprefs.nfft ~= ud.prefs.nfft
            ud.prefs = newprefs;
            set(fig,'userdata',ud)
            yhzfiltdes('response',fig)
        else
            ud.prefs = newprefs;
            set(fig,'userdata',ud)
        end
    end
otherwise
% -------------------------------------------------------------------------
% yhzfiltdes(action)
%   default action - not recognized - show warning in command window
%
  disp(sprintf( ...
     'yhzfiltdes: action string ''%s'' not recognized, no action taken.',action))
end       
    
function label = uniqueDefaultLabel(labelList,defaultLabel)
% Inputs:
%    labelList - list of strings
%    defaultLabel - string; such as 'sig','filt'
% Output:
%    label - unique identifier such as 'sig1', 'sig2'
    i=1;
    label = [defaultLabel sprintf('%.9g',i)];
    while ~isempty(findcstr(labelList,label))
        i=i+1;
        label = [defaultLabel sprintf('%.9g',i)];
    end



