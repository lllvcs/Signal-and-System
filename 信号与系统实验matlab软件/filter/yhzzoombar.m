function varargout = yhzzoombar(varargin)
%yhzzoombar  Toolbar for zoom controls, settings, and help.
%  [toolbar,zoomgroup,helpgroup] = yhzzoombar
%   Allows you to specify a toolbar from a list of buttons and creates and manages
%   the toolbar.  A left side and right side button group will be created
%   in an axes across the top of the specified figure.  The buttons will appear
%   from left-to-right in the order of the tags in the btnlist input parameter.
%   The toolbar will be in pixel units and will resize when the figure does.
%   Note: DO NOT overwrite the figure's ResizeFcn string after calling this
%   function; instead, use appstr() to append your callback.
%  Inputs are in parameter/value pairs.
%     'fig' - figure handle of parent figure (defaults to gcf)
%     'btnlist' - cell array of tag strings for which buttons to include (required)
%        Can include any of the following:
%           Button Tag     Type of button  Default side
%           'mousezoom'      toggle            0
%           'zoomout'        flash             0
%           'zoominy'        flash             0
%           'zoomouty'       flash             0
%           'zoominx'        flash             0
%           'zoomoutx'       flash             0
%           'passband'       flash             0
%           'settings'       flash             1
%           'help'           toggle            1
%     'callbacks' - cell array of strings with callbacks for the
%        different buttons - must be same length as btnlist (required)
%     'rightside' (optional) - vector indicating which buttons should appear in
%        which toolbar, 0 for left, 1 for right - same length as btnlist
%     'left_width' - starting pixel for left button group (default is 
%        sz.ffs+sz.fus+sz.lw+sz.fus+sz.ffs where sz is size struct in ud)
%     'right_width' - right OFFSET in pixels for right button group 
%              (default is 0)
%        
%  Outputs:
%     toolbar - handle to toolbar axes
%     zoomgroup, helpgroup - handles to btngroup axes in the toolbar
%     ALSO: .toolbar structure field added to figure's userdata, containing
%       ud.toolbar.toolbar, ud.toolbar.zoomgroup, ud.toolbar.helpgroup

%   Copyright (c) 1988-97 by The MathWorks, Inc.
%       $Revision: 1.12 $

if (nargin>0) & ~isstr(varargin{1})
   action = varargin{2};
else
   action = 'init';
   
   % define default values
   fig = gcf;
   ud = get(fig,'userdata');
   sz = ud.sz;
   left_width = sz.ffs+sz.fus+sz.lw+sz.fus+sz.ffs;
   right_width = 0;
   rightside = [];
   % parse parameters
   for i=1:2:length(varargin)
       param = lower(varargin{i});
       value = varargin{i+1};
       eval([param ' = value;'])
   end

   if isempty(rightside)
       defaultSides = 1;
   else
       defaultSides = 0;
   end
end

switch action
case 'init'

    uibgcolor = get(0,'defaultuicontrolbackgroundcolor');
    uifgcolor = get(0,'defaultuicontrolforegroundcolor');

    ax_props = {
         'units','pixels',...
         'box','on',...
         'xcolor','k',...
         'ycolor','k',...
         'color',uibgcolor,...
         'xtick',[],...
         'ytick',[],...
         'handlevisibility','callback'   };

    toolbar = axes(ax_props{:},'tag','toolbar');

    % common text properties:
    tp = [',''color'',''k'',''fontunits'',''pixels'',' ...
         '''horizontalalignment'',''center'',''fontsize'',9'];  

    lefttags = {};
    leftcallbacks = {};
    lefttypes = {};
    lefticons = {};
    righttags = {};
    rightcallbacks = {};
    righttypes = {};
    righticons = {};
    for i=1:length(btnlist)
      switch(btnlist{i})
      case 'mousezoom'  
          btntype = 'toggle';
          btnicon = [ ...
         '[line([.2 .8 .8 .2 .2],[.65 .65 .95 .95 .65],''linestyle'','':'','...
         '''color'',''k'') text(.5,.45,''Mouse''' tp ')'...
         ' text(.5,.15,''Zoom''' tp ')' ...
         ' line([.2 .8],[.95 .65],''linestyle'',''none'',''marker'',''+'','...
         '''color'',''k'')  ]'];
          side = 0;
      case 'zoomout'
          btntype = 'flash';
          btnicon = [ ...
         '[text(.5,.7,''Full''' tp ',''fontsize'',10)'...
         ' text(.5,.3,''View''' tp ',''fontsize'',10)'...
         ' line([.05 .95 .95 .05 .05],[.05 .05 .95 .95 .05],''color'',''k'')]'];
          side = 0;
      case 'zoominy'      
          btntype = 'flash';
          btnicon = [ ...
         '[text(.5,.45,''Zoom''' tp ') text(.5,.15,''In-Y''' tp ')'...
         ' line([.3 .7 .5 .3 NaN .3 .7 .5 .3],' ...
         '[.63 .63 .77 .63 NaN .95 .95 .82 .95],''color'',''k'')]'];
          side = 0;
      case 'zoomouty'     
          btntype = 'flash';
          btnicon = [ ...
         '[text(.5,.45,''Zoom''' tp ') text(.5,.15,''Out-Y''' tp ')' ...
         ' line([.3 .7 .5 .3 NaN .3 .7 .5 .3],' ...
         '[.77 .77 .63 .77 NaN .82 .82 .95 .82],''color'',''k'')]'];
          side = 0;
      case 'zoominx'      
          btntype = 'flash';
          btnicon = [ ...
         '[text(.5,.45,''Zoom''' tp ') text(.5,.15,''In-X''' tp ')'...
         ' line([.1 .45 .1 .1 NaN .9 .9 .55 .9],' ...
         '[.65 .8 .95 .65 NaN .65 .95 .8 .65],''color'',''k'')]'];
          side = 0;
      case 'zoomoutx'      
          btntype = 'flash';
          btnicon = [ ...
         '[text(.5,.45,''Zoom''' tp ') text(.5,.15,''Out-X''' tp ')' ...
         ' line([.45 .1 .45 .45 NaN .55 .55 .9 .55],' ...
         '[.65 .8 .95 .65 NaN .65 .95 .8 .65],''color'',''k'')]'];
          side = 0;
      case 'passband'      
          btntype = 'flash';
          btnicon = [ ...
         '[line(linspace(.03,.93,30),20*log10(abs(freqz(remez(26,[0 .5 .6 1],[1 1 0 0]),' ...
         '1,linspace(0,.5*pi,30))))*.57+.83,''color'',''k'') ' ...
         'text(.5,.45,''Pass''' tp ') text(.5,.15,''Band''' tp ')]'];
          side = 0;
      case 'settings'   
          btntype = 'flash';
          btnicon = [ ...
          '[ line([.5 .5 .9],[.95 .65 .65],''color'',''k'') ' ...
          ' text(.7,.45,''x''' tp ')'...
          ' text(.3,.8,''y''' tp ')' ...
          ' text(.5,.15,''Settings''' tp ')  ]'];
          side = 1;
      case 'help' 
          btntype = 'toggle';
          btnicon = [ ...
            '[text(.5,.15,''Help''' tp ',''fontsize'',10) '...
            'text(.5,.6,''?''' tp ',''fontsize'',18) ]'];
          side = 1;
      end
      if defaultSides
          rightside(i) = side;
      end
      if rightside(i)
          righttags = {righttags{:}, btnlist{i}};
          rightcallbacks = {rightcallbacks{:}, callbacks{i}};
          righttypes = {righttypes{:}, btntype};
          righticons = {righticons{:}, btnicon};
      else
          lefttags = {lefttags{:}, btnlist{i}};
          leftcallbacks = {leftcallbacks{:}, callbacks{i}};
          lefttypes = {lefttypes{:}, btntype};
          lefticons = {lefticons{:}, btnicon};
      end
    end
 
    % common btngroup param/value pairs:
    group_props = {'BevelWidth',.05, 'Orientation','horizontal',...
                   'Units','pixels'};

    if length(righttags)>0
        helpgroup = btngroup('GroupID','helpgroup',...
            'IconFunctions',str2mat(righticons{:}),...
            'ButtonID',str2mat(righttags{:}),...
            'PressType',str2mat(righttypes{:}),...
            'Callbacks',str2mat(rightcallbacks{:}),...
            'GroupSize',[1 length(righttags)],...
            group_props{:});
        setFontUnitsPixels(helpgroup)
    else
        helpgroup = [];
    end

    if length(righttags)>0
        zoomgroup = btngroup('GroupID','zoomgroup',...
            'IconFunctions',str2mat(lefticons{:}),...
            'ButtonID',str2mat(lefttags{:}),...
            'PressType',str2mat(lefttypes{:}),...
            'Callbacks',str2mat(leftcallbacks{:}),...
            'GroupSize',[1 length(lefttags)],...
            group_props{:});
        setFontUnitsPixels(zoomgroup)
    else
        zoomgroup = [];
    end

    group_axes_props = { 'xcolor' uibgcolor 'ycolor' uibgcolor};
    set([zoomgroup helpgroup],group_axes_props{:})

    % save handles to axes in 'toolbar' structure:
    toolbar.toolbar = toolbar;
    toolbar.zoomgroup = zoomgroup;    
    toolbar.helpgroup = helpgroup;   

    % compute minimum width of figure, in pixels, and save in toolbar
    % structure:
    leftN = length(lefticons);
    rightN = length(righticons);
    toolbar.minWidth = left_width + (leftN+rightN)*sz.iw + right_width; 
    
    % Save offsets:
    toolbar.left_width = left_width;
    toolbar.right_width = right_width;

    % SAVE TOOLBAR Struct in figure's user data
    ud = get(fig,'userdata');
    ud.toolbar = toolbar;
    set(fig,'userdata',ud);

    % now resize the objects we've just created:
    yhzzoombar(0,'resize',fig)
    
    % append toolbar resize function to figure's resizefcn:
    set(fig,'resizefcn',yhzappstr(get(fig,'resizefcn'),...
       'sbswitch(''yhzzoombar'',0,''resize'')'))

    % assign output arguments:
    varargout{1} = toolbar;
    varargout{2} = zoomgroup;
    varargout{3} = helpgroup;

case 'resize'
    if nargin > 2
        fig = varargin{3};   % start up 
    else
        fig = gcbf;          % during resizefcn 
    end
    fp = get(fig,'position');   % assume in pixels already
    ud = get(fig,'userdata');
    sz = ud.sz;
    toolbar_ht = sz.ih;
    
    if fp(3)<ud.toolbar.minWidth
       %disp('    yhzzoombar: figure too narrow - resizing')
       w = ud.toolbar.minWidth;
       h = fp(4);
       fp = [fp(1) fp(2)+fp(4)-h w h];
       set(fig,'position',fp)
       return
    end
    
    hand = ud.toolbar;

    left_ud = get(hand.zoomgroup,'userdata');
    right_ud = get(hand.helpgroup,'userdata');
    leftN = length(left_ud.state);
    rightN = length(right_ud.state);
    % 1-by-4 position vectors
    pos = {
      hand.toolbar       [0 fp(4)-toolbar_ht fp(3) toolbar_ht+2]
      hand.zoomgroup     [ud.toolbar.left_width fp(4)-sz.ih leftN*sz.iw sz.ih]
      hand.helpgroup     [fp(3)-ud.toolbar.right_width-rightN*sz.iw fp(4)-sz.ih ...
                         rightN*sz.iw sz.ih]
    };

    set([pos{:,1}],{'position'},pos(:,2))
    set(hand.toolbar,'xlim',[0 fp(3)],'ylim',[0 toolbar_ht])

end

function setFontUnitsPixels(ax)
% Sets the fontunits of all axes text children of ax to 'pixels'
% and keeps their font sizes the same
    t = findobj(ax,'type','text');
    s = get(t,'fontsize');
    set(t,'fontunits','pixels')
    set(t,{'fontsize'},s);





