 function fignum = yhzviewini(filter)
%yhzviewini Initialize filter viewer.

%   Copyright (c) 1988-97 by The MathWorks, Inc.
%       $Revision: 1.25 $
 

    save_shh = get(0,'showhiddenhandles');
    set(0,'showhiddenhandles','on')

    ud.filt=filter;
    
    figname = prepender(['滤波器分析:',ud.filt.label]);

    %toolnum = 1;  % which instance of the browser

    visFrame = 'off';   % set frame around single popups invisible 
    if strcmp(visFrame,'off')
       indentPop = 15; 
    else
       indentPop = 0;
    end
    
    % ====================================================================
    % set defaults and initialize userdata structure
    %filtview1Prefs = sptool('getprefs','filtview1');
    %filtview2Prefs = sptool('getprefs','filtview2');
    %ud.prefs.tool.zoompersist = filtview1Prefs.zoomFlag;
    
    %ud.prefs.nfft = evalin('base',filtview1Prefs.nfft);
    %ud.prefs.nimp = evalin('base',filtview1Prefs.nimp);
            % Length of impulse / step response ([] ==> auto)
                                    
    ud.prefs.magmode = {'linear' 'log' 'decibels'};
    ud.prefs.magmode = ud.prefs.magmode{1};
    ud.prefs.phasemode = {'degrees' 'radians'};
    ud.prefs.phasemode = ud.prefs.phasemode{1};
    ud.prefs.freqscale = {'linear' 'log'};
    ud.prefs.freqscale = ud.prefs.freqscale{1};
    ud.prefs.freqrange = 1;
            % 1==[0 Fs/2], 2==[0 Fs], 3==[-Fs/2 Fs/2]
                        
    %if filtview2Prefs.mode1
    %    ud.prefs.tilemode = [2 3];
    %elseif filtview2Prefs.mode2
        ud.prefs.tilemode = [3 2];
    %elseif filtview2Prefs.mode3
    %    ud.prefs.tilemode = [6 1];
    %elseif filtview2Prefs.mode4
    %    ud.prefs.tilemode = [1 6];
    %end
            
    ud.prefs.plots = [1 1 0 0 0 0]';  
    ud.prefs.plotspacing = [40 35 10 20]; 
        % spacing in pixels from [left bottom right top] 
        % lots of room: [40 40 20 25]
    scalefactor = (get(0,'screenpixelsperinch')/72)^.5;
    ud.prefs.plotspacing = ud.prefs.plotspacing*scalefactor;
    ud.prefs.Fs=1;
    
    co = get(0,'defaultaxescolororder');
    
    ud.prefs.linecolor = co(1,:);

    ud.sz.ih= 47;
    ud.sz.iw= 42;
    ud.sz.lw= 130;
    ud.sz.fus= 5;
    ud.sz.ffs= 5;
    ud.sz.lfs= 3;
    ud.sz.lh= 18;
    ud.sz.uh= 20;
    ud.sz.rw= 130;
    ud.sz.rih= 40;
    ud.sz.riw= 55;
    ud.sz.pmw= 14;
    ud.sz.lbs= 3;
    ud.sz.as= [57.7350 46.1880 23.0940 34.6410];
    ud.sz.ph= 60;
    ud.sz.bw= 110;

    %sptsizes;
    ud.sz.bw = ud.sz.bw+10;
    
    %[err,errstr,ud.filt] = importfilt('make',{1 1 1 1});
    
    ud.justzoom = [ 0 0 ] ;  % used for mode switching (between zoom and pan)

    filtDefined = 0; 
    %switch nargin
    %case 0
    makeParams = {1 1 1};
    %case 1
    %    if isstruct(varargin{1})
    %        [valid,ud.filt] = importfilt('valid',varargin{1});
    %        if ~valid
    %            error('Input is not a valid Filter structure.')
    %        end
    %        filtDefined = 1;
    %    else
    %        makeParams = {varargin{1} 1 1};
    %    end
    %case 2
     %       makeParams = {varargin{1:2} 1};
    %case 3
    %        makeParams = varargin;
    %end
    %if ~filtDefined
    %    [err,errstr,ud.filt] = importfilt('make',{1 makeParams{:}});
    %    if err
    %        error(errstr)
    %    end
    %end
    
    %ud.prefs.Fs = sprintf('%.9g',ud.filt.Fs);

    %ud.tilefig = [];  % handle to tile dialog box figure
    %ud.loadfig = [];  % handle to Load dialog box figure
    %ud.tabfig = [];  % settings figure handle
    %ud.toolnum = toolnum;
    
    ud.pointer = 0;  % pointer mode ...  == -1 watch, 0 arrow/drag indicators, 
                     %     1 zoom, 2 help
    sz = ud.sz;

    screensize = get(0,'screensize');
	    
    ud.resize.minsize = [3*sz.bw+9*sz.fus sz.ih+16*sz.fus+10*sz.uh+4*sz.lh];
       % minimum width, height of figure window
    ud.resize.leftwidth = sz.bw+6*sz.fus;
    
    ud.resize.topheight = sz.ih;
    
    fp = get(0,'defaultfigureposition');
	 w = max(ud.resize.minsize(1),fp(3));
	 h = max(ud.resize.minsize(2),fp(4));
	 fp = [fp(1) fp(2)+fp(4)-h w h];  % keep upper-left corner stationary
    
    % ====================================================================
    % Save figure position for use in resizefcn:   
    ud.resize.figpos = fp;
    
    % CREATE FIGURE
    fig = figure('createfcn','',...
            'closerequestfcn','delete(gcf)',... %filtview(''SPTclose'')',...
            'tag','yhzview',...
            'numbertitle','off',...
            'integerhandle','off',...
            'userdata',ud ,...
            'units','pixels',...
            'position',fp,...
            'menubar','none',...
            'inverthardcopy','off',...
            'paperpositionmode','auto',...
            'visible','off',...
            'name',figname);

    uibgcolor = get(0,'defaultuicontrolbackgroundcolor');
    uifgcolor = get(0,'defaultuicontrolforegroundcolor');

    % ====================================================================
    % MENUs
    %  create cell array with {menu label, callback, tag}

 %  MENU LABEL                     CALLBACK                      TAG
mc={ 
 'File'                              ' '                        'filemenu'
 '>&Close^w'                         'close'                    'closemenu'
 '&Window'                           winmenu('callback')        'winmenu'};
 
% 'Options'                           ' '                        'optionsmenu'
% '>&Tile Axes...'                    'sbswitch(''fvtile'')'     'tilemenu'

    menu_handles = makemenu(fig, char(mc(:,1)), ...
                            char(mc(:,2)), char(mc(:,3)));
    winmenu(fig)
    
 %   set(menu_handles,'hiddenhandle','on')
 %   ud.ht.reloadmenu = menu_handles(3);
 %   set(menu_handles(3),'enable','off')
    
    % ====================================================================
    % Frames

    f1 = [0 0 sz.bw+6*sz.ffs fp(4)-sz.ih];
    ud.ht.frame1 = uicontrol('units','pixels',...
              'style','frame','position',f1,'tag','mainframe');

    pf_height = 8*sz.fus+8.5*sz.uh;
    pf =  [  f1(1)+sz.fus      f1(2)+f1(4)-(sz.lh/2+sz.fus+pf_height) ...
             f1(3)-2*sz.fus    pf_height  ];
    ud.ht.plotsframe = uicontrol('units','pixels',...
              'style','frame','position',pf,'tag','plotframe');
    freqframeHt = 4*sz.fus+2*sz.uh+2.5*sz.lh;
    ff = [sz.fus pf(2)-freqframeHt-sz.fus-sz.lh/2 4*sz.fus+sz.bw freqframeHt];
    ud.ht.freqframe = uicontrol('units','pixels',...
              'style','frame','tag','freqframe',...
              'position',ff);

    mf = [pf(1)+sz.fus pf(2)+pf(4)-(sz.lh/2+sz.fus+2*sz.uh+sz.fus)+4 ...
             pf(3)-2*sz.fus  sz.fus+1.5*sz.uh];
    ud.ht.magframe = uicontrol('units','pixels','visible',visFrame,...
              'style','frame','position',mf,'tag','magframe');
    phf = [pf(1)+sz.fus pf(2)+pf(4)-(sz.lh/2+2*sz.fus+4*sz.uh+2*sz.fus)+5 ...
             pf(3)-2*sz.fus  sz.fus+1.5*sz.uh];
    ud.ht.phaseframe = uicontrol('units','pixels','visible',visFrame,...
              'style','frame','position',phf,'tag','phaseframe');

    fsf = [ff(1)+sz.fus ff(2)+ff(4)-(sz.fus+sz.uh+1.5*sz.lh) ...
           ff(3)-2*sz.fus sz.fus+sz.uh+.5*sz.lh];
    ud.ht.fscaleframe = uicontrol('units','pixels','visible',visFrame,...
              'style','frame','tag','freqsframe',...
              'position',fsf);

    frf = [ff(1)+sz.fus ff(2)+1.5*sz.fus ...
           ff(3)-2*sz.fus sz.fus+sz.uh+.5*sz.lh];
    ud.ht.frangeframe = uicontrol('units','pixels','visible',visFrame,...
              'style','frame','tag','freqrframe',...
              'position',frf);

   % ud.ht.Fsframe = uicontrol('units','pixels',...
   %           'style','frame','tag','fsframe','position',...
   %             [sz.fus sz.fus ...
   %              4*sz.fus+sz.bw sz.fus+sz.uh+.5*sz.lh]);

    % ====================================================================
    % Labels

    ud.ht.plotslabel = Localframelab(ud.ht.plotsframe,'项目',sz.lfs,sz.lh,'tag','plottext');
    ud.ht.freqlabel = Localframelab(ud.ht.freqframe,'频率轴',sz.lfs,sz.lh,'tag','freqtext');
    ud.ht.fscalelabel = Localframelab(ud.ht.fscaleframe,'量度',sz.lfs,sz.lh,'tag','freqstext');
    ud.ht.frangelabel = Localframelab(ud.ht.frangeframe,'范围',sz.lfs,sz.lh,'tag','freqrtext');
    
    ud.ht.filterLabel = uicontrol('style','text',...
                'horizontalalignment','left',...
                'string',ud.filt.paraLabel,...
                'tag','filterLabel',...
                'position',[sz.fus fp(4)-2-19-24 sz.bw+20 45]);
    %ud.ht.Fsedit = uicontrol('style','text',...
    %            'horizontalalignment','left',...
    %            'string',['Fs = '],... ud.prefs.Fs],...
    %            'tag','fsbox',...
    %            'position',[sz.fus fp(4)-4-2*19 sz.bw 19]);
    
    % Localframelab(ud.ht.Fsframe,'Sampling Freq.',sz.lfs,sz.lh,'tag','fstext');

    % ====================================================================
    % Checkboxes
    cb_props = {'units','pixels',...
              'style','checkbox','horizontalalignment','left'};
 
    checkbox_width = 15; % The checkbox part of the uicontrol

    cb1_pos = [mf(1)+sz.fus mf(2)+sz.uh+sz.fus sz.bw sz.uh];
    ud.ht.cb(1) = uicontrol(cb_props{:},...
        'string','幅度',...
        'tag','magcheck',...
        'value',ud.prefs.plots(1),...
        'callback','yhzfdview(''cb'',1)',...
	'position',cb1_pos);
    %if ~isunix
    %   label_ext = get(ud.ht.cb(1),'extent');
    %   cb1_pos(3) = label_ext(3)+checkbox_width;
    %   set(ud.ht.cb(1),'position', cb1_pos);
    %end
    
    cb2_pos = [phf(1)+sz.fus phf(2)+sz.uh+sz.fus sz.bw sz.uh];
    ud.ht.cb(2) = uicontrol(cb_props{:},...
        'string','相位',...
        'tag','phasecheck',...
        'value',ud.prefs.plots(2),...
	'callback','yhzfdview(''cb'',2)',...
	'position',cb2_pos);
    %if ~isunix
    %   label_ext = get(ud.ht.cb(2),'extent');
    %   cb2_pos(3) = label_ext(3)+checkbox_width;
    %   set(ud.ht.cb(2),'position', cb2_pos);
    %end    

    ud.ht.cb(3) = uicontrol(cb_props{:},...
       'string','群时延',...
       'tag','groupdelay',...
       'value',ud.prefs.plots(3),...
       'callback','yhzfdview(''cb'',3)',...
       'position',[pf(1)+2*sz.fus pf(2)+4*sz.fus+3*sz.uh sz.bw sz.uh]);
    ud.ht.cb(4) = uicontrol(cb_props{:},...
       'string','零极点图',...
       'tag','polezero',...
       'value',ud.prefs.plots(4),...
       'callback','yhzfdview(''cb'',4)',...
       'position',[pf(1)+2*sz.fus pf(2)+3*sz.fus+2*sz.uh sz.bw sz.uh]);
    ud.ht.cb(5) = uicontrol(cb_props{:},...
       'string','脉冲响应',...
       'tag','impresp',...
       'value',ud.prefs.plots(5),...
       'callback','yhzfdview(''cb'',5)',...
       'position',[pf(1)+2*sz.fus pf(2)+2*sz.fus+sz.uh sz.bw sz.uh]);
    ud.ht.cb(6) = uicontrol(cb_props{:},...
       'string','阶跃响应',...
       'tag','stepresp',...
       'value',ud.prefs.plots(6),...
       'callback','yhzfdview(''cb'',6)',...
       'position',[pf(1)+2*sz.fus pf(2)+sz.fus sz.bw sz.uh]);

    % ====================================================================
    % Popups
    pop_props = {'units','pixels',...
              'style','popup','horizontalalignment','left'};

    % Tweak position & size of popups: [horz_pos ver_pos width height]
    %switch computer
    %case 'MAC2'
    %   popTweak = [0 -2 0 0];
    %case 'PCWIN'
    popTweak = [0  0 0 0];
    %otherwise  % UNIX
    %   popTweak = [0 -2 0 0];
    %end
  
    switch ud.prefs.magmode
    case 'linear'
       magpopvalue = 1;
    case 'log'
       magpopvalue = 2;
    case 'decibels'
       magpopvalue = 3;
    end
    
    ud.ht.magpop = uicontrol(pop_props{:},...
       'string',{'linear'; 'log'; 'decibels'},...
       'tag','maglist',...
       'callback','yhzfdview(''magpop'')',...
       'value',magpopvalue,...
       'position',[mf(1:2)+sz.fus+[indentPop 0] sz.bw-indentPop sz.uh]+popTweak);

    switch ud.prefs.phasemode
    case 'degrees'
       phasepopvalue = 1;
    case 'radians'
       phasepopvalue = 2;
    end

    ud.ht.phasepop = uicontrol(pop_props{:},...
       'string',{'degrees'; 'radians'},...
       'tag','phaselist',...
       'callback','yhzfdview(''phasepop'')',...
       'value',phasepopvalue,...
       'position',[phf(1:2)+sz.fus+[indentPop 0] sz.bw-indentPop sz.uh]+popTweak);
 
    switch ud.prefs.freqscale
    case 'linear'
        fscalevalue = 1;
    case 'log'
        fscalevalue = 2;
    end
    ud.ht.fscalepop = uicontrol(pop_props{:},...
       'string',{'linear'; 'log'},...
       'tag','freqscale',...
       'callback','yhzfdview(''fscalepop'')',...
       'value',fscalevalue,...
       'position',[fsf(1:2)+sz.fus+[indentPop 0] sz.bw-indentPop sz.uh]+popTweak);

    ud.ht.frangepop = uicontrol(pop_props{:},...
       'string',{'[0..Fs/2]'; '[0..Fs]'; '[-Fs/2..Fs/2]'},...
       'tag','freqrange',...
       'callback','yhzfdview(''frangepop'')',...
       'value',ud.prefs.freqrange,...
       'position',[frf(1:2)+sz.fus+[indentPop 0] sz.bw-indentPop sz.uh]+popTweak);

    % ====================================================================
    % Create axes:

    ax_props = {
         'units','pixels',...
         'box','on',...
         'parent',fig};

    % create axes:
    for i=1:6
        ud.ht.a(i) = axes(ax_props{:});
    end

    ud.titles = {   'Magnitude' 
                    { 'Phase (degrees)' 'Phase (radians)' } 
                    'Group Delay' 
                    'Zeros & Poles' 
                    'Impulse Response'
                    'Step Response'};

    ud.tags =    { 'magaxes'
                   'phaseaxes'
                   'delayaxes'
                   'pzaxes'
                   'impaxes'
                   'stepaxes' };

    ud.xlabels = {  'Frequency'
                    'Frequency'
                    'Frequency'
                    'Real'
                    'Time'
                    'Time' };
  
    ud.ylabels = {  ''
                    ''
                    ''
                    'Imaginary'
                    ''
                    ''};

    th = get(ud.ht.a,'title');
    set([th{[1 3:6]}],{'string'},ud.titles([1 3:6]))
    switch ud.prefs.phasemode
    case 'degrees'
        set(th{2},'string',ud.titles{2}(1))
    case 'radians'
        set(th{2},'string',ud.titles{2}(2))
    end
    if fscalevalue == 2
        set(ud.ht.a([1 2 3]),'xscale','log')
    end
    if magpopvalue == 2
        set(ud.ht.a(1),'yscale','log')
    end

    set([th{:}],{'tag'},ud.tags)
    set(ud.ht.a,{'tag'},ud.tags)
    xh = get(ud.ht.a,'xlabel');
    set([xh{:}],{'string'},ud.xlabels,{'tag'},ud.tags)
    yh = get(ud.ht.a,'ylabel');
    set([yh{:}],{'string'},ud.ylabels,{'tag'},ud.tags)

    % ====================================================================
    % initialize lines
    ud.lines.mag = [];   
    ud.lines.phase = [];   
    ud.lines.grpdelay = [];   
    ud.lines.z = [];   
    ud.lines.p = [];   
    ud.lines.zgrid = [];
    ud.lines.imp = [];   
    ud.lines.impstem = [];   
    ud.lines.impc = [];   
    ud.lines.impstemc = [];   
    ud.lines.step = [];   
    ud.lines.stepstem = [];   
    ud.lines.stepc = [];   
    ud.lines.stepstemc = [];   
    
    % ====================================================================
    % Save userdata structure
    set(fig,'userdata',ud)
    
    fignum=fig;
    
    % ====================================================================
    % now add toolbar for filter viewer
    btnlist = { 'mousezoom'  'zoomout'  'help'}';
    tb_callbackstr = {
       'sbswitch(''yhzfvzoom'',''mousezoom'')'
       'sbswitch(''yhzfvzoom'',''zoomout'')'
       'sbswitch(''yhzfdview'',''help'')' };
    yhzzoombar('fig',fig,'btnlist',btnlist,'callbacks',tb_callbackstr,...
            'left_width',ud.resize.leftwidth); 
    set(fig,'resizefcn',...
            yhzappstr(get(fig,'resizefcn'),'sbswitch(''fvresize'')'))
    %set(fig,'windowbuttonmotionfcn',...
    %      ['sbswitch(''fvmotion'',' num2str(ud.toolnum) ')'])
    set(fig,'HandleVisibility','callback')
        
    yhzfvresize(1,fig)   % position axes

    % Do the plots
    yhzfdview('plots',ud.prefs.plots)

    set(fig,'visible','on')
    set(0,'showhiddenhandles',save_shh)

    function fl = Localframelab(framehand,labelstr,lfs,lh,varargin)
    % FRAMELAB Create UIControl of style static text for frame label.
    %   Assumes all positions and units are in pixels.
    %   Inputs:
    %     framehand - handle of frame
    %     labelstr - string 
    %     lfs - spacing between label text and left edge of frame 
    %     lh - label height 
    %     varargin{:} - param/value pairs for uicontrol creation
    %   Outputs:
    %     fl - frame label handle
 
    %   Copyright (c) 1988-97 by The MathWorks, Inc.
    % $Revision: 1.6 $

    pos = get(framehand,'position');

    lpos = [pos(1)+lfs pos(2)+pos(4)-lh/2 100 lh];
    
    l = uicontrol('style','text',...
          'units','pixels',...
          'string',[labelstr ' '],...
          'position',lpos,varargin{:});

    ex = get(l,'extent');

    set(l,'position',[lpos(1:2) ex(3) lpos(4)])
    set(l,'horizontalalignment','center')

    if nargout > 0
        fl = l;
     end
     



   
    % WORK NEEDS TO BE DONE:
    %      % ADD FILTER INFORMATION: ud.filt.{label, Fs,.......}
    %      % Adjust the uicontrols
    %      % All button's callbackStr
    %       Do the Plots Origianlly Line469
    %      % Line 462, 462
    %       Tool Bar Call Back String
    %       464,465