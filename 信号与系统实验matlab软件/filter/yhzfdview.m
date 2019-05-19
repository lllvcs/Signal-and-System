function yhzfdview(varargin)
% yhzfdview serves as the execution of the GUI for filter design result, it shows the magnitude, phase, group delay, and 
%      some other characteristics of a filter, it figures out when the 'analysis' button is pushed in the last slide of 
%      filter designing(fdshow), 
%      and it retrieves the parameters of a filter from yhzfd.mat which the mytext1 has loaded in
%
% see also yhzviewini, 
%
% by: Eddy Yu, Wei Guo, Kayak Tech. and Xi'an Jiaotong University; hzhyu@hotmail.com  ; 5/16/99
% copyright  1998-1999 
% version 2.0

if nargin==0
   load yhzfd
   filter.num=bz;
   filter.den=az;
   %filter.Fs=fsa;
   filter.label=label;
   filter.paraLabel=paraLabel;
   filter.zpk=[];
   [filter.imp,filter.t] = ...
              impz(filter.num,filter.den,[],1);
   fignum=yhzviewini(filter);
   return
end
%if ~isstr(varargin{1})
    %fvinit(varargin{:})
%    drawnow
%    shh=get(0,'showhiddenhandles');
%    set(0,'showhiddenhandles','on')
%    ud = get(gcf,'userdata');

%    set(ud.toolbar.zoomgroup,'visible','on')
%    set(ud.toolbar.helpgroup,'visible','on')
%    set(0,'showhiddenhandles',shh)
%    return
%end

action = varargin{1};

switch action
% ----------------------------------------------------------------------
% yhzfdview('cb',checkboxnum)
%   callback of checkbox to turn plots on/off
%
case 'cb'
    cbnum = varargin{2};
    fig = gcf;
    ud = get(fig,'userdata');
    ud.prefs.plots(cbnum) = 1-ud.prefs.plots(cbnum);
    set(fig,'userdata',ud)
    yhzfvresize(1,fig)
    if ud.prefs.plots(cbnum)
        pflag = [0 0 0 0 0 0]';
        pflag(cbnum) = 1;
        yhzfdview('plots',pflag)
    else % else if we're turning a plot off, zoom out of that plot
        yhzfvzoom('zoomout',[zeros(1,cbnum-1) 1 zeros(1,6-cbnum)],fig)
    end

    % Disable and enable Magnitude and Phase popupmenus as appropriate
    if get(ud.ht.cb(1),'value') == 0
        set(ud.ht.magpop,'enable','off')
    else
        set(ud.ht.magpop,'enable','on')       
    end
    
    if get(ud.ht.cb(2),'value') == 0
        set(ud.ht.phasepop,'enable','off')
    else
        set(ud.ht.phasepop,'enable','on')       
    end
    
% ----------------------------------------------------------------------
% yhzfdview('magpop')
%   callback of magnitude linear/log popup
%
case 'magpop'
    fig = gcf;
    ud = get(fig,'userdata');
    
    oldmode = ud.prefs.magmode;
    popupval = get(ud.ht.magpop,'value');
    switch popupval
    case 1
        if strcmp(oldmode,'linear')
            return
        end
        ud.prefs.magmode = 'linear';
        set(ud.ht.a(1),'yscale','linear')
    case 2
        if strcmp(oldmode,'log')
            return
        end
        ud.prefs.magmode = 'log';
        set(ud.ht.a(1),'yscale','log')
    case 3
        if strcmp(oldmode,'decibels')
            return
        end
        ud.prefs.magmode = 'decibels';
        set(ud.ht.a(1),'yscale','linear')
    end
    set(fig,'userdata',ud)
    if ud.prefs.plots(1)
        yhzfvzoom('zoomout',[1 0 0 0 0 0],fig)
        yhzfdview('plots',[1; 0; 0; 0; 0; 0])
    end
    %p = sptool('getprefs','yhzfdview1');
    %p.magscale = popupval;
    %sptool('setprefs','yhzfdview1',p)
    
% ----------------------------------------------------------------------
% yhzfdview('phasepop')
%   callback of phase degrees/radians popup
%
case 'phasepop'
    fig = gcf;
    ud = get(fig,'userdata');
    popupval = get(ud.ht.phasepop,'value');
    switch popupval
    case 1
        if strcmp(ud.prefs.phasemode,'degrees')
            return
        end
        ud.prefs.phasemode = 'degrees';
        set(get(ud.ht.a(2),'title'),'string',ud.titles{2}{1})
    case 2
        if strcmp(ud.prefs.phasemode,'radians')
            return
        end
        ud.prefs.phasemode = 'radians';
        set(get(ud.ht.a(2),'title'),'string',ud.titles{2}{2})
    end
    set(fig,'userdata',ud)
    if ud.prefs.plots(2)
        yhzfvzoom('zoomout',[0 1 0 0 0 0],fig)
        yhzfdview('plots',[0; 1; 0; 0; 0; 0])
    end
   % p = sptool('getprefs','yhzfdview1');
   % p.phaseunits = popupval;
   % sptool('setprefs','yhzfdview1',p)

% ----------------------------------------------------------------------
% yhzfdview('fscalepop')
%   callback of frequency scale linear/log popup
%
case 'fscalepop'
    fig = gcf;
    ud = get(fig,'userdata');
    switch get(ud.ht.fscalepop,'value')
    case 1
        if strcmp(ud.prefs.freqscale,'linear')
            return
        end
        ud.prefs.freqscale = 'linear';
        set(fig,'userdata',ud)
        set(ud.ht.a([1 2 3]),'xscale','linear')
        yhzfvzoom('zoomout',[1 1 1 0 0 0],fig)

    case 2
        if strcmp(ud.prefs.freqscale,'log')
            return
        end
        ud.prefs.freqscale = 'log';
        set(fig,'userdata',ud)
        if ud.prefs.freqrange == 3  % can't have negative frequencies
                                 % in logarithmic scale - change to [0..Fs/2]
            set(ud.ht.frangepop,'value',1)
            yhzfdview('frangepop')
            ud = get(fig,'userdata');
        end
        Fs = 1; %evalin('base',ud.prefs.Fs,'1');
        switch ud.prefs.freqrange
        case 1    % [0 Fs/2]
            flim = [Fs/2048 Fs/2];
        case 2    % [0 Fs]
            flim = [Fs/2048 Fs];
        end

        set(ud.ht.a([1 2 3]),'xscale','log','xlim',flim)
    end
  %  p = sptool('getprefs','yhzfdview1');
  %  p.freqscale = get(ud.ht.fscalepop,'value');
  %  sptool('setprefs','yhzfdview1',p)

% ----------------------------------------------------------------------
% yhzfdview('frangepop')
%   callback of frequency range popup
%
case 'frangepop'
    fig = gcf;
    ud = get(fig,'userdata');
    switch get(ud.ht.frangepop,'value')
    case 1
        if ud.prefs.freqrange == 1
            return
        end
        ud.prefs.freqrange = 1;
    case 2
        if ud.prefs.freqrange == 2
            return
        end
        ud.prefs.freqrange = 2;
    case 3
        % if in log scaling, don't allow display of negative frequencies
        if strcmp(ud.prefs.freqscale,'log')
            set(ud.ht.frangepop,'value',ud.prefs.freqrange)
            return
        end
        if ud.prefs.freqrange == 3
            return
        end
        ud.prefs.freqrange = 3;
    end
    set(fig,'userdata',ud)

    yhzfvzoom('zoomout',[ud.prefs.plots(1:3)' 0 0 0],fig)
    yhzfdview('plots',[ud.prefs.plots(1:3); 0; 0; 0])

    %p = sptool('getprefs','yhzfdview1');
    %p.freqrange = get(ud.ht.frangepop,'value');
    %sptool('setprefs','yhzfdview1',p)

% ----------------------------------------------------------------------
% yhzfdview('Fs',fig)
%   callback of sampling frequency edit box 
%   (or you can use this to set the sampling frequency if you
%   set the string of ud.ht.Fsedit first)
%
%case 'Fs'
%    if nargin < 2
%        fig = gcf;
%    else
%        fig = varargin{2};
%    end
%
%    ud = get(fig,'userdata');
%
%    str = get(ud.ht.Fsedit,'string');

%    if isequal(str,ud.prefs.Fs)
%        return
%    end

 %   [Fs,err] = validarg(str,[0 Inf],[1 1],'sampling frequency');
 %   if err
 %       set(ud.ht.Fsedit,'string',ud.prefs.Fs)
 %       return
 %   else
 %       ud.prefs.Fs = str;
 %       set(fig,'userdata',ud)
 %       if ~isempty(ud.tabfig)    % update settings figure
 %           data = get(ud.tabfig,'userdata');
 %           % this panel has been created since it is the first 1
 %           fvprefhand('populate',ud.tabfig,1,ud.prefs)
 %       end

 %       yhzfvzoom('zoomout',ud.prefs.plots,fig)
 %       yhzfdview('plots',ud.prefs.plots,fig)
 %   end
 
% ----------------------------------------------------------------------
% yhzfdview('plots',plots,fig)
%   updates the plots indicated with a '1' in the plots vector
%   
case 'plots'
    if nargin < 3
        fig = gcf;
    else
        fig = varargin{3};
    end

    ud = get(fig,'userdata');

    plots = varargin{2};
    if all(plots==0)
        return
    end
    %Fs = evalin('base',ud.prefs.Fs,'1');
    Fs=1;
    nfft = 4096; %ud.prefs.nfft;
    
    if strcmp(ud.prefs.freqscale,'log')
        xlim1 = Fs/nfft;
    else
        xlim1 = 0;
    end
    switch ud.prefs.freqrange
    case 1    % [0 Fs/2]
        ud.filt.f = 0:Fs/nfft:(Fs/2 - Fs/(2*nfft));
        flim = [xlim1 Fs/2];
    case 2    % [0 Fs]
        ud.filt.f = 0:Fs/nfft:(Fs - Fs/nfft);
        flim = [xlim1 Fs];
    case 3    % [-Fs/2 Fs/2]
        ud.filt.f = fftshift(0:Fs/nfft:(Fs - Fs/nfft));
        ind = find(ud.filt.f>=Fs/2);
        ud.filt.f(ind) = ud.filt.f(ind)-Fs;
        flim = [-Fs/2 Fs/2];
    end
    
   % if isempty(ud.filt.tf)
   %     % uninitialized tool - no filter
   %     % need to set axes limits
   %     for i=1:3
   %        if plots(i)
   %           set(ud.ht.a(i),'xlim',flim)
   %         end
   %     end
   %     return
   % end

    if any(plots([1 2]))
        ud.filt.H = fft(ud.filt.num,nfft);
        warnsave=warning; warning('off')  % prevent possible divide by 0 message
        ud.filt.H = ud.filt.H./fft(ud.filt.den,nfft);
        warning(warnsave)
        switch ud.prefs.freqrange
        case 1    % [0 Fs/2]
            ud.filt.H = ud.filt.H(1:nfft/2);
        case 3    % [-Fs/2 Fs/2]
            ud.filt.H = fftshift(ud.filt.H);
        end
    end

    if plots(1)
        if isempty(ud.lines.mag)
            ud.lines.mag = line(1,1,'color',ud.prefs.linecolor,...
                 'tag','magline',...
                 'parent',ud.ht.a(1),'buttondownfcn','yhzfdview(''mdown'')');
        end
        if strcmp(ud.prefs.magmode,'decibels')
            absH = abs(ud.filt.H);
            ind = find(absH>0);
            dbH = -Inf; dbH = dbH(ones(size(absH)));
            dbH(ind) = 20*log10(absH(ind));
            set(ud.lines.mag,'xdata',ud.filt.f,'ydata',dbH,'visible','on')
        else
            set(ud.lines.mag,'xdata',ud.filt.f,'ydata',abs(ud.filt.H),'visible','on')
        end
        set(ud.ht.a(1),'ylimmode','auto','xlim',flim)
    end
    if plots(2)
        if isempty(ud.lines.phase)
            ud.lines.phase = line(1,1,'color',ud.prefs.linecolor,...
                 'tag','phaseline',...
                 'parent',ud.ht.a(2),'buttondownfcn','yhzfdview(''mdown'')');
        end    
        if ud.prefs.freqrange < 3
            pha = unwrap(angle(ud.filt.H));
        else
            pha_neg = unwrap(angle(ud.filt.H(nfft/2:-1:1)));
            pha_neg = pha_neg(end:-1:1);                %???
            pha_pos = unwrap(angle(ud.filt.H((nfft/2+1):end)));
            pha = [pha_neg(:); pha_pos(:);];
        end

        switch ud.prefs.phasemode
        case 'degrees'
            set(ud.lines.phase,'xdata',ud.filt.f,'ydata',pha*180/pi,'visible','on')
        case 'radians'
            set(ud.lines.phase,'xdata',ud.filt.f,'ydata',pha,'visible','on')
        end
        set(ud.ht.a(2),'ylimmode','auto','xlim',flim)
    end
    if plots(3)
        warnsave = warning; warning('off');  % turn off divide by zero warning
        ud.filt.G = grpdelay(ud.filt.num,ud.filt.den,ud.filt.f,Fs);
        warning(warnsave);  
        if isempty(ud.lines.grpdelay)
            ud.lines.grpdelay = line(1,1,'color',ud.prefs.linecolor,...
                 'tag','delayline',...
                 'parent',ud.ht.a(3),'buttondownfcn','yhzfdview(''mdown'')');
        end
        set(ud.lines.grpdelay,'xdata',ud.filt.f,'ydata',ud.filt.G,'visible','on')
        set(ud.ht.a(3),'ylimmode','auto','xlim',flim)
        yylim=get(ud.ht.a(3),'ylim');
        newylim=max(length(ud.filt.den),length(ud.filt.num));
        set(ud.ht.a(3),'ylim',[-newylim,newylim]);
    end
    if plots(4)
        if isempty(ud.lines.z)
            ud.lines.z = line(NaN,NaN,'color',ud.prefs.linecolor,...
                 'linestyle','none','marker','o',...
                 'tag','zerosline',...
                 'parent',ud.ht.a(4),...
                 'buttondownfcn','yhzfdview(''mdown'')');
        end
        if isempty(ud.lines.p)
            ud.lines.p = line(NaN,NaN,'color',ud.prefs.linecolor,...
                 'linestyle','none','marker','x',...
                 'tag','polesline',...
                 'parent',ud.ht.a(4),...
                 'buttondownfcn','yhzfdview(''mdown'')');
        end
        if isempty(ud.lines.zgrid)
            w = linspace(0,2*pi,201);
            ud.lines.zgrid = line(cos(w),sin(w),...
                 'color',get(ud.ht.a(4),'xcolor'),...
                 'linestyle',':',...
                 'tag','unitcircle',...
                 'parent',ud.ht.a(4),...
                 'buttondownfcn','yhzfdview(''mdown'')');
        end

        if isempty(ud.filt.zpk)
           % if ~isempty(ud.filt.ss)
           %     [z,p,k] = ss2zp(ud.filt.ss.a,ud.filt.ss.b,...
           %                    ud.filt.ss.c,ud.filt.ss.d,1);
           % elseif ~isempty(ud.filt.sos)
           %     [z,p,k] = sos2zp(ud.filt.sos);
           % else
                if length(ud.filt.den)<length(ud.filt.num)
                    den = ud.filt.den;
                    den(length(ud.filt.num)) = 0;   % zero pad       %???
                    [z,p,k] = tf2zp(ud.filt.num,den);
                else
                    [z,p,k] = tf2zp(ud.filt.num,ud.filt.den);
                end
            %end
            ud.filt.zpk.z = z;
            ud.filt.zpk.p = p; 
            ud.filt.zpk.k = k;
        end
        set(ud.lines.z,'xdata',real(ud.filt.zpk.z),...
                       'ydata',imag(ud.filt.zpk.z),'visible','on')
        set(ud.lines.p,'xdata',real(ud.filt.zpk.p),...
                       'ydata',imag(ud.filt.zpk.p),'visible','on')
        set(ud.ht.a(4),'ylimmode','auto','xlimmode','auto')
        apos = get(ud.ht.a(4),'Position');
        set(ud.ht.a(4),'DataAspectRatio',[1 1 1],... %???
            'PlotBoxAspectRatio',apos([3 4 4]))
        xlim1 = min(real([ud.filt.zpk.z(:); ud.filt.zpk.p(:)]));
        xlim2 = max(real([ud.filt.zpk.z(:); ud.filt.zpk.p(:)]));
        ylim1 = min(imag([ud.filt.zpk.z(:); ud.filt.zpk.p(:)]));
        ylim2 = max(imag([ud.filt.zpk.z(:); ud.filt.zpk.p(:)]));
        if isempty(xlim1)
            xlim1 = -1.5;
        end
        if isempty(xlim2)
            xlim2 = 1.5;
        end
        if isempty(ylim1)
            ylim1 = -1.5;
        end
        if isempty(ylim2)
            ylim2 = 1.5;
        end
        if xlim1 == xlim2
            xlim1 = xlim1-1;
            xlim2 = xlim2+1;
        end
        if ylim1 == ylim2
            ylim1 = ylim1-1;
            ylim2 = ylim2+1;
        end
        set(get(ud.ht.a(4),'xlabel'),'userdata',[xlim1 xlim2 ylim1 ylim2]);
    end
    if any(plots([5 6]))
        [ud.filt.imp,ud.filt.t] = ...
              impz(ud.filt.num,ud.filt.den,[],Fs);
    end
    if plots(5)
        if isempty(ud.lines.imp)
            ud.lines.imp = line(nan,nan,'color',ud.prefs.linecolor,...
                 'linestyle','none','marker','.',...
                 'tag','implinedots',...
                 'markerfacecolor',ud.prefs.linecolor,...
                 'parent',ud.ht.a(5),...
                 'buttondownfcn','yhzfdview(''mdown'')');
        end
        if isempty(ud.lines.impstem)
            ud.lines.impstem = line(nan,nan,'color',ud.prefs.linecolor,...
                 'linestyle','-',...
                 'tag','implinestem',...
                 'parent',ud.ht.a(5),...
                 'buttondownfcn','yhzfdview(''mdown'')');
        end
        if isempty(ud.lines.impc)
            ud.lines.impc = line(nan,nan,'color',ud.prefs.linecolor,...
                 'linestyle','none','marker','*',...
                 'tag','implinedots',...
                 'markerfacecolor',ud.prefs.linecolor,...
                 'parent',ud.ht.a(5),...
                 'buttondownfcn','yhzfdview(''mdown'')');
        end
        if isempty(ud.lines.impstemc)
            ud.lines.impstemc = line(nan,nan,'color',ud.prefs.linecolor,...
                 'linestyle','-',...
                 'tag','implinestem',...
                 'parent',ud.ht.a(5),...
                 'buttondownfcn','yhzfdview(''mdown'')');
        end
        Localsetstem([ud.lines.imp ud.lines.impstem],ud.filt.t,real(ud.filt.imp))
        %function Localsetstem(h,x,y)
        %%Localsetstem Set xdata and ydata of two handles for stem plots

%        set(h(1),'xdata',x,'ydata',y)
%        x = x(:);  % make it a column
%        xx = x(:,[1 1 1])';
%        xx = xx(:);
%        n = nan;
%        y = [zeros(size(x)) y(:) n(ones(length(x),1),:)]';
%        set(h(2),'xdata',xx,'ydata',y(:));

        if sum(imag(ud.filt.imp).^2) > 1e-10 * sum(real(ud.filt.imp).^2)  %???
            Localsetstem([ud.lines.impc ud.lines.impstemc],ud.filt.t,imag(ud.filt.imp))
            set([ud.lines.impc ud.lines.impstemc],'visible','on')
        else
            set([ud.lines.impc ud.lines.impstemc],'visible','off')
        end
        set([ud.lines.imp ud.lines.impstem],'visible','on')
        set(ud.ht.a(5),'ylimmode','auto',...
                       'xlim',[ud.filt.t(1)-1/Fs  ud.filt.t(end)+1/Fs])
    end
    if plots(6)
        if isempty(ud.lines.step)
            ud.lines.step = line(nan,nan,'color',ud.prefs.linecolor,...
                 'linestyle','none','marker','.',...
                 'tag','steplinedots',...
                 'markerfacecolor',ud.prefs.linecolor,...
                 'parent',ud.ht.a(6),...
                 'buttondownfcn','yhzfdview(''mdown'')');
        end
        if isempty(ud.lines.stepstem)
            ud.lines.stepstem = line(nan,nan,'color',ud.prefs.linecolor,...
                 'linestyle','-',...
                 'tag','steplinestem',...
                 'parent',ud.ht.a(6),...
                 'buttondownfcn','yhzfdview(''mdown'')');
        end            
        if isempty(ud.lines.stepc)
            ud.lines.stepc = line(nan,nan,'color',ud.prefs.linecolor,...
                 'linestyle','none','marker','*',...
                 'tag','steplinedots',...
                 'markerfacecolor',ud.prefs.linecolor,...
                 'parent',ud.ht.a(6),...
                 'buttondownfcn','yhzfdview(''mdown'')');
        end
        if isempty(ud.lines.stepstemc)
            ud.lines.stepstemc = line(nan,nan,'color',ud.prefs.linecolor,...
                 'linestyle','-',...
                 'tag','steplinestem',...
                 'parent',ud.ht.a(6),...
                 'buttondownfcn','yhzfdview(''mdown'')');
           end         
        stepA=ud.filt.den;
        stepB=ud.filt.num;
        stepX=ones(1,length(ud.filt.t));
        ud.filt.step = myfilter(stepB,stepA,stepX);%ud.filt.num,ud.filt.den,ones(1,length(ud.filt.t)));
        Localsetstem([ud.lines.step ud.lines.stepstem],ud.filt.t,real(ud.filt.step))
        if sum(imag(ud.filt.step).^2) > 1e-10 * sum(real(ud.filt.step).^2)   %???
            Localsetstem([ud.lines.stepc ud.lines.stepstemc],ud.filt.t,imag(ud.filt.step))
            set([ud.lines.stepc ud.lines.stepstemc],'visible','on')
        else
            set([ud.lines.stepc ud.lines.stepstemc],'visible','off')
        end
        set([ud.lines.step ud.lines.stepstem],'visible','on')
        set(ud.ht.a(6),'ylimmode','auto',...
                       'xlim',[ud.filt.t(1)-1/Fs  ud.filt.t(end)+1/Fs])
    end

    set(fig,'userdata',ud)
    %sptool('import',ud.filt)

%------------------------------------------------------------------------
% yhzfdview('settab')
%  open settings tabbed dialog box
%
%case 'settab'
%    fig = gcf;
%    ud = get(fig,'userdata');

%    if ud.pointer == 2  % help mode
%        fvhelp('settab')
%        return
%    end

%    if isempty(ud.tabfig)
%        setptr(fig,'watch');
%        ud.pointer = -1; 
%        set(fig,'userdata',ud)
%        tabfig1 = tabfig(0,'fvprefhand',ud.sz);
%        ud.tabfig = tabfig1;
%        ud.pointer = 0; 
%        set(fig,'userdata',ud);
%        fvmotion(ud.toolnum)
%    else
%        set(ud.tabfig,'visible','on')
%        figure(ud.tabfig)
%    end
    
%------------------------------------------------------------------------
% yhzfdview('mdown')
%  mouse down event on one of the lines
%
case 'mdown'
    [l,fig] = gcbo;
    ud = get(fig,'userdata');
    %if ud.pointer == 2  % help mode
    %    fvhelp('line')  %???
    %    return
    %end
    
    if ~Localjustzoom(fig)
        ax = get(l,'parent');
        if ax==ud.ht.a(5) | ax==ud.ht.a(6)
            erasemode = 'xor';
        else
            erasemode = 'background';
        end
        
        xlim = get(ax,'xlim');
        ylim = get(ax,'ylim');
        set(ax,'ylimmode','auto','xlimmode','auto')
        bounds.xlim = get(ax,'xlim');
        bounds.ylim = get(ax,'ylim');
        set(ax,'ylim',ylim,'xlim',xlim)
        panfcn('erasemode',erasemode,'bounds',bounds)
    end
    
%------------------------------------------------------------------------
% enable = yhzfdview('selection',action,msg,SPTfig)
%  respond to selection change in SPTool
% possible actions are
%    'view'
%  Button is enabled when
%     a) there is a filter selected
%
%case 'selection'
%    msg = varargin{3};
%    SPTfig = varargin{4};
%    f = sptool('Filters',0,SPTfig);
%    if isempty(f)
%        varargout{1} = 'off';
%    else
%        varargout{1} = 'on';
%    end

%    fig = findobj('type','figure','tag','yhzfdview');
%    if ~isempty(fig)  % update filter viewer
%        ud = get(fig,'userdata');
%        if ~isequal(f,ud.filt)
%            if isempty(f)
%                set(ud.ht.Fsedit,'string','')
%                set(ud.ht.filterLabel,'string',['Filter: <none>'])
%                ud.filt.tf = [];
%                h = struct2cell(ud.lines);
%                h = [h{:}];
%                delete(h)
%                flds = fieldnames(ud.lines);
%                for i = 1:length(flds)
%                    eval(['ud.lines.' flds{i} '=[];'])
%                end
%            else         
%                ud.filt = f; 
%                ud.prefs.Fs = sprintf('%.9g',f.Fs);
%                set(ud.ht.filterLabel,'string',['Filter: ' ud.filt.label])
%                set(ud.ht.Fsedit,'string',['Fs = ' ud.prefs.Fs])
%            end
%            set(fig,'userdata',ud)
%            yhzfdview('plots',ud.prefs.plots,fig)
%        end
%    end
    
%------------------------------------------------------------------------
% enable = yhzfdview('action',verb.action)
%  respond to button push in SPTool
% possible actions are
%    'view'
%
%case 'action'
%    SPTfig = gcf;
%    f = sptool('Filters',0,SPTfig);  % get selected filter
%    fig = findobj('type','figure','tag','yhzfdview');
%    if isempty(fig)  % create the yhzfdview tool
%        yhzfdview(f)
%    else % activate the yhzfdview
%        set(fig,'visible','on')
%        figure(fig)
%        ud = get(fig,'userdata');
%        if ~isequal(f,ud.filt)
%            ud.filt = f; 
%            ud.prefs.Fs = sprintf('%.9g',f.Fs);
%            set(ud.ht.Fsedit,'string',ud.prefs.Fs)
%            set(fig,'userdata',ud)
%            yhzfdview('plots',ud.prefs.plots,fig)
%            set(ud.ht.filterLabel,'string',['Filter: ' ud.filt.label])
%            set(ud.ht.Fsedit,'string',['Fs = ' ud.prefs.Fs])
%        end
%    end
%------------------------------------------------------------------------
% yhzfdview('SPTclose',verb.action)
%  respond to SPTool closing
% possible actions are
%    'view'
%
%case 'SPTclose'
%    fig = findobj('type','figure','tag','yhzfdview');
%    if ~isempty(fig)  % destroy the yhzfdview tool
%        ud = get(fig,'userdata');
%       delete(fig)
%    end
%------------------------------------------------------------------------
% yhzfdview('print')
%  print contents of yhzfdview (assumed in gcf)
%
%case 'print'
    

%------------------------------------------------------------------------
% yhzfdview('help')
% Callback of help button in toolbar
case 'help'
    fig = gcf;
    ud = get(fig,'userdata');
    if ud.pointer ~= 2   % if not in help mode
        % enter help mode
        saveEnableControls = [];
        ax = [ud.ht.a ud.toolbar.toolbar];
        titleStr = 'ÂË²¨Æ÷Éè¼Æ_·ÖÎö_°ïÖú';
        helpFcn = 'yhzfvhelpstr';
        yhzspthelp('enter',fig,saveEnableControls,ax,titleStr,helpFcn)
    else
        yhzspthelp('exit')
    end
    
%------------------------------------------------------------------------
% errstr = yhzfdview('setprefs',panelName,p)
% Set preferences for the panel with name panelName
%
% Inputs:
%   panelName - string; must be either 'ruler','color', 'yhzfdview1', 
%               or 'yhzfdview2'
%              (see sptprefreg for definitions)
%   p - preference structure for this panel
%
%case 'setprefs'
%    errstr = '';
%    panelName = varargin{2};
%    p = varargin{3};
%    % first do error checking
%    switch panelName        
%    case 'yhzfdview1'
%        arbitrary_obj = {'arb' 'obj'};
%        nfft = evalin('base',p.nfft,'arbitrary_obj');
%        if isequal(nfft,arbitrary_obj)
%            errstr = 'Sorry, the FFT Length you entered could not be evaluated';
%        elseif isempty(nfft) | (round(nfft)~=nfft | nfft<=0 | ~isreal(nfft))
%            errstr = ['The FFT Length must be a positive integer.'];
%        end
%        if isempty(errstr)
%            nimp = evalin('base',p.nimp,'arbitrary_obj');
%            if isequal(nimp,arbitrary_obj)
%                errstr = 'Sorry, the Time Response Length you entered could not be evaluated';
%            elseif ~isempty(nimp) & (round(nimp)~=nimp | nimp<=0 | ~isreal(nimp))
%                errstr = ['The Time Response Length must be a positive integer' ...
%                          ' or the empty matrix ''[]'' (to get the default value).'];
%           end
%        end
%        if isempty(errstr) & (p.freqscale == 2 & p.freqrange == 3)
%            errstr = ['You can''t have frequency log scaling with a negative ' ...
%                      'frequency range.'];
%        end
%
%    case 'yhzfdview2'  % tiling
%    end
%    
%    varargout{1} = errstr;
%    if ~isempty(errstr)
%        return
%    end
%        
%    % now set preferences
%    fig = findobj('type','figure','tag','yhzfdview');
%    if ~isempty(fig)
%        ud = get(fig,'userdata');
 %       newprefs = ud.prefs;
%        switch panelName
%        case 'yhzfdview1'
%            newprefs.tool.zoompersist = p.zoomFlag;
%            newprefs.nfft = evalin('base',p.nfft);
%            newprefs.nimp = evalin('base',p.nimp);
%            
%            set(ud.ht.magpop,'value',p.magscale)
%            set(ud.ht.phasepop,'value',p.phaseunits)
%            set(ud.ht.fscalepop,'value',p.freqscale)
%            set(ud.ht.frangepop,'value',p.freqrange)
%                        
%            newprefs.magmode = {'linear' 'log' 'decibels'};
%            newprefs.magmode = newprefs.magmode{p.magscale};
%            newprefs.phasemode = {'degrees' 'radians'};
%            newprefs.phasemode = newprefs.phasemode{p.phaseunits};
%            newprefs.freqscale = {'linear' 'log'};
%            newprefs.freqscale = newprefs.freqscale{p.freqscale};
%            newprefs.freqrange = p.freqrange;
%                        
%        case 'yhzfdview2'
%            if p.mode1
%                newprefs.tilemode = [2 3];
%            elseif p.mode2
%                newprefs.tilemode = [3 2];
%            elseif p.mode3
%                newprefs.tilemode = [6 1];
%            elseif p.mode4
%            end
%        end
%        ud.prefs = newprefs;
%        set(fig,'userdata',ud)
%        
%        fvresize(1,fig)
%        yhzfvzoom('zoomout',ud.prefs.plots,fig)
%        yhzfdview('plots',ud.prefs.plots,fig)
%
%    end
%    
end  % of switch statement

function Localsetstem(h,x,y)           %???
%Localsetstem Set xdata and ydata of two handles for stem plots

    set(h(1),'xdata',x,'ydata',y)
    x = x(:);  % make it a column
    xx = x(:,[1 1 1])';
    xx = xx(:);
    n = nan;
    y = [zeros(size(x)) y(:) n(ones(length(x),1),:)]';
    set(h(2),'xdata',xx,'ydata',y(:));


function flag = Localjustzoom(fig)
%JUSTZOOM Determines whether the current buttondownfcn follows a 
%           zoom windowbuttondownfcn for the signal browser in figure fig.
%   Meant to be called by any buttondownfcn (eg, pickfcn, ruldown, 
%    pandown) that might be called AFTER the windowbuttondownfcn.
%   Writes userdata and clears flag if so.
 
%   Copyright (c) 1988-97 by The MathWorks, Inc.
% $Revision: 1.3 $

if nargin < 1
    fig = gcf;
end

ud = get(fig,'userdata');

if isequal(ud.justzoom,get(fig,'currentpoint'))
    flag = 1;
    ud.justzoom = [0 0];
    set(fig,'userdata',ud)
else
    flag = 0;
end



   
