 function fignum = yhzzpini
%yhzviewini Initialize filter viewer.

%   Copyright (c) 1988-97 by The MathWorks, Inc.
%       $Revision: 1.25 $
 

    save_shh = get(0,'showhiddenhandles');
    set(0,'showhiddenhandles','on')

    %zpud.filt=filter;
    %fignum = findobj('type','
    figname=prepender('¬À≤®∆˜¡„º´µ„…Ëº∆∑®');

    %toolnum = 1;  % which instance of the browser

    visFrame = 'off';   % set frame around single popups invisible 
    %if strcmp(visFrame,'off')
    %   indentPop = 15; 
    %else
    %   indentPop = 0;
    %end
    
    % ====================================================================
    % set defaults and initialize userdata structure
    %filtview1Prefs = sptool('getprefs','filtview1');
    %filtview2Prefs = sptool('getprefs','filtview2');
    %zpud.prefs.tool.zoompersist = filtview1Prefs.zoomFlag;
    
    %zpud.prefs.nfft = evalin('base',filtview1Prefs.nfft);
    %zpud.prefs.nimp = evalin('base',filtview1Prefs.nimp);
            % Length of impulse / step response ([] ==> auto)
                                    
    zpud.prefs.pointmodeStr = {' Û±Í»°µ„' ' ÷π§ ‰»Î'};
    zpud.prefs.pointmode = 1;%zpud.prefs.pointmodeStr{1};
    zpud.prefs.minsize = [180 220]; 

    %scalefactor = (get(0,'screenpixelsperinch')/72)^.5;
    %zpud.prefs.plotspacing = zpud.prefs.plotspacing*scalefactor;
    zpud.prefs.Fs=1;
    
    co = get(0,'defaultaxescolororder');
    
    zpud.prefs.linecolor = co(1,:);

    zpud.sz.ih= 47;
    zpud.sz.iw= 42;
    zpud.sz.lw= 130;
    zpud.sz.fus= 5;
    zpud.sz.ffs= 5;
    zpud.sz.lfs= 15;
    zpud.sz.lh= 18;
    zpud.sz.uh= 20;
    zpud.sz.rw= 230;
    zpud.sz.rih= 40;
    zpud.sz.riw= 55;
    zpud.sz.pmw= 14;
    zpud.sz.lbs= 3;
    zpud.sz.as= [57.7350 46.1880 23.0940 34.6410];
    zpud.sz.ph= 60;
    zpud.sz.bw= 110;

    %sptsizes;
    zpud.sz.bw = zpud.sz.bw+10;
    
    %[err,errstr,zpud.filt] = importfilt('make',{1 1 1 1});
    
    zpud.justzoom = [ 0 0 ] ;  % used for mode switching (between zoom and pan)
    zpud.zeros=[];
    zpud.poles=[];
    zpud.zpHndl=[];
    filtDefined = 0; 
    %switch nargin
    %case 0
    makeParams = {1 1 1};
    
    zpud.pointer = 0;  % pointer mode ...  == -1 watch, 0 arrow/drag indicators, 
                     %     1 zoom, 2 help
    sz = zpud.sz;

    screensize = get(0,'screensize');
	    
    zpud.resize.minsize = [3*sz.bw+9*sz.fus sz.ih+16*sz.fus+10*sz.uh+4*sz.lh];
       % minimum width, height of figure window
    zpud.resize.leftwidth = sz.bw+6*sz.fus;
    
    zpud.resize.topheight = sz.ih;
    
    fp = get(0,'defaultfigureposition');
    w = max(zpud.resize.minsize(1),fp(3));
	 h = max(zpud.resize.minsize(2),fp(4));
	 fp = [fp(1) fp(2)+fp(4)-h w+100 h+50];  % keep upper-left corner stationary
    
    % ====================================================================
    % Save figure position for use in resizefcn:   
    zpud.resize.figpos = fp;
    
    % CREATE FIGURE
    fig = figure('createfcn','',...
            'closerequestfcn','delete(gcf);',... %filtview(''SPTclose'')',...
            'tag','yhzzp',...
            'numbertitle','off',...
            'integerhandle','off',...
            'userdata',zpud ,...
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
%mc={ 
% 'File'                              ' '                        'filemenu'
% '>&Close^w'                         'close'                    'closemenu'
% '&Window'                           winmenu('callback')        'winmenu'};
 
% 'Options'                           ' '                        'optionsmenu'
% '>&Tile Axes...'                    'sbswitch(''fvtile'')'     'tilemenu'

%    menu_handles = makemenu(fig, char(mc(:,1)), ...
%                            char(mc(:,2)), char(mc(:,3)));
%    winmenu(fig)
    
 %   set(menu_handles,'hiddenhandle','on')
 %   zpud.ht.reloadmenu = menu_handles(3);
 %   set(menu_handles(3),'enable','off')
    
    % ====================================================================
    % Frames

    %f1 = [0 0 sz.bw+6*sz.ffs fp(4)-sz.ih];
    %zpud.ht.lftframe = uicontrol('units','pixels',...
    %          'style','frame','tag','zpleftframe');

%    pf_height = 8*sz.fus+8.5*sz.uh;
 %   pf =  [  f1(1)+sz.fus      f1(2)+f1(4)-(sz.lh/2+sz.fus+pf_height) ...
 %            f1(3)-2*sz.fus    pf_height  ];
    %zpud.ht.plotsframe = uicontrol('units','pixels',...
%              'style','frame','position',pf,'tag','plotframe');
    %freqframeHt = 4*sz.fus+2*sz.uh+2.5*sz.lh;
    %ff = [sz.fus pf(2)-freqframeHt-sz.fus-sz.lh/2 4*sz.fus+sz.bw freqframeHt];
    zpud.ht.chsframe = uicontrol('units','pixels',...
              'style','frame','tag','zpchooseframe');
             % 'position',ff);

    %mf = [pf(1)+sz.fus pf(2)+pf(4)-(sz.lh/2+sz.fus+2*sz.uh+sz.fus)+4 ...
    %         pf(3)-2*sz.fus  sz.fus+1.5*sz.uh];
    %zpud.ht.magframe = uicontrol('units','pixels','visible',visFrame,...
    %          'style','frame','position',mf,'tag','magframe');
    %phf = [pf(1)+sz.fus pf(2)+pf(4)-(sz.lh/2+2*sz.fus+4*sz.uh+2*sz.fus)+5 ...
    %         pf(3)-2*sz.fus  sz.fus+1.5*sz.uh];
    %zpud.ht.phaseframe = uicontrol('units','pixels','visible',visFrame,...
    %          'style','frame','position',phf,'tag','phaseframe');
%
%    fsf = [ff(1)+sz.fus ff(2)+ff(4)-(sz.fus+sz.uh+1.5*sz.lh) ...
%           ff(3)-2*sz.fus sz.fus+sz.uh+.5*sz.lh];
%    zpud.ht.fscaleframe = uicontrol('units','pixels','visible',visFrame,...
%              'style','frame','tag','freqsframe',...%
%              'position',fsf);

%    frf = [ff(1)+sz.fus ff(2)+1.5*sz.fus ...
%           ff(3)-2*sz.fus sz.fus+sz.uh+.5*sz.lh];
%    zpud.ht.frangeframe = uicontrol('units','pixels','visible',visFrame,...
%              'style','frame','tag','freqrframe',...
%              'position',frf);

   % zpud.ht.Fsframe = uicontrol('units','pixels',...
   %           'style','frame','tag','fsframe','position',...
   %             [sz.fus sz.fus ...
   %              4*sz.fus+sz.bw sz.fus+sz.uh+.5*sz.lh]);
  
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
  
    
    zpud.ht.modepop = uicontrol(pop_props{:},...
       'string',{' Û±Í»°µ„'; ' ÷π§ ‰»Î'},...
       'tag','zpmodelist',...
       'callback','yhzzpact(''modechange'')',...
       'value',zpud.prefs.pointmode);
%       'position',[mf(1:2)+sz.fus+[indentPop 0] sz.bw-indentPop sz.uh]+popTweak);

%=====================================================================
% Create radiobuttons

    radio_props = {'units','pixels',...
            'style','radiobutton','horizontalalignment','left'};
      
      zpud.ht.zerosBtn=uicontrol( radio_props{:},...
         'string','¡„µ„',...
         'callback','yhzzpact(''choosezeros'')',...
         'tag','zpchoosezeros',...
         'value',1);


     zpud.ht.polesBtn=uicontrol( radio_props{:},...
         'string','º´µ„',...
         'callback','yhzzpact(''choosepoles'')',...
         'tag','zpchoosepoles',...
         'value',0);
      
 %======================================================================
 % Create edit for zeros and poles
 
     edit_props = { 'units','pixels','backgroundcolor',[1 1 1],...
           'style','edit','horizontalalignment','left','enable','off'};
     
     zpud.ht.zerosEdit=uicontrol(edit_props{:},...
        'string',' ',...
        'callback','yhzzpact(''zEditChange'');',...
        'tag','zpzerosEdit');
     
     zpud.ht.polesEdit=uicontrol(edit_props{:},...
        'string',' ',...
        'callback','yhzzpact(''pEditChange'');',...
        'tag','zppolesEdit');
     
 %======================================================================
 % Create pushbuttons
      push_props = {'units','pixels',...
            'style','pushbutton','horizontalalignment','center'};
      
      zpud.ht.clearLast=uicontrol( push_props{:},...
         'string','«Â≥˝…œ“ª∏ˆ',...
         'callback','yhzzpact(''clearLast'')',...
         'tag','zpclearLast');

     zpud.ht.clearAll=uicontrol( push_props{:},...
         'string','«Â≥˝À˘”–',...
         'callback','yhzzpact(''clearAll'')',...
         'tag','zpclearAll');
      
      
     zpud.ht.backFD=uicontrol( push_props{:},...
         'string','∑µªÿ',...
         'callback','yhzzpact(''backFD'')',...
         'tag','zpbackFD');



    % ====================================================================
    % Create axes:

    ax_props = {
         'units','pixels',...
         'box','on',...
         'parent',fig};

   %ttl=text('∆µ¬ œÏ”¶');
   %piS='\pi';
   zpud.ht.respAxes = axes(ax_props{:},...
      'tag','zpResponseAxes',...
      'Xlim',[0,pi],...
      'Xtick',[0,pi/4,pi/2,pi/4*3,pi],...
      'XTickLabel',{'0','pi/4','pi/2','3pi/4','pi'} );
                      %'yscale','log');
   title('∆µ¬ œÏ”¶');          
   Xlabel('∆µ¬ , Fsa=2\pi');
   Ylabel('∑˘∂»(dB)');
          
             
   zpud.ht.zpAxes = axes(ax_props{:},...
      'tag','zpZPAxes',...
      'xlim',[-1,1],...
      'ylim',[-1,1]);
      %'xlimmode','auto',...
      %'ylimmode','auto');
    Xlabel('¡„º´µ„Œª÷√');
    %Xlabel('¡„º´µ„Œª÷');
    %Ylabel('–È÷·');
    grid on;    
          
    %==============================================================================
    % create the response line; 
    colors = get(zpud.ht.respAxes,'colororder'); 
    zpud.ht.respline = line(0,0,'tag','zprespline','color',colors(1,:),...
                         'buttondownfcn','yhzzpact(''mdown'',3)','parent',zpud.ht.respAxes);
    %ud.ht.panfcnline = line(0,0,'tag','yhzpfline','color',colors(1,:),'visible','off');

    %xlabel('∆µ¬ ÷·','tag','zprespline')
    %ylabel('∑˘∂»(∑÷±¥)','tag','zprespline')

    
    
    
    
    % ====================================================================
    % initialize lines
    zpud.lines.mag = [];   
    zpud.lines.z = [];   
    zpud.lines.p = [];   
    zpud.lines.zgrid = [];
    
    % ====================================================================
    % Save userdata structure
    set(fig,'userdata',zpud)
    
    fignum=fig;
    
    % ====================================================================
    % now add toolbar for filter viewer
    btnlist = {'zoominy' 'zoomouty' 'zoominx' ...
              'zoomoutx'  'zoomout' 'mousezoom' 'help'}';
    tb_callbackstr = {
       'sbswitch(''yhzzpzoom'',''zoominy'')'
       'sbswitch(''yhzzpzoom'',''zoomouty'')'
       'sbswitch(''yhzzpzoom'',''zoominx'')'
       'sbswitch(''yhzzpzoom'',''zoomoutx'')'
%       'sbswitch(''yhzzpzoom'',''passband'')'
       'sbswitch(''yhzzpzoom'',''zoomout'')'
       'sbswitch(''yhzzpzoom'',''mousezoom'')'
       'sbswitch(''yhzzpact'',''help'')' };
    yhzzoombar('fig',fignum,'btnlist',btnlist,'callbacks',tb_callbackstr,...
            'left_width',0); 
    yhzzpresize(1,fignum);
    set(fignum,'resizefcn',...
    yhzappstr(get(fignum,'resizefcn'),'sbswitch(''yhzzpresize'')'));

     set(fignum, 'Visible','on');
 
     %yhzzpact('mousepoint');
 
 
%    set(get(ud.ht.ax1,'title'),'Interpreter','none','tag','title')
  %  yhzfiltdes('specchange')
  %  yhzfiltdes('copyspecials')
 %   eval('yhzfiltdes(''setfilt'',filtStruc,figNumber)');
    
    %set(get(ud.ht.ax1,'zlabel'),'userdata',[0 ud.specs.Fs/2  -ud.specs.Rs-20 5])
    
    %set(figNumber,'windowbuttonmotionfcn','sbswitch(''fdmotion'',''1'')')


  %  set(fig,'visible','on')
    set(0,'showhiddenhandles',save_shh);




   
