function varargout=yhzfiltdes(action,varargin);
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

%if nargin==0 
    %if isempty(findobj(0,'tag','sptool'))
    %    disp('Type ''sptool'' to start the Signal GUI.')
    %else
    %    disp('To use the Filter Designer, click on the ''Design New'' button')
    %    disp('under the ''Filters'' column in the ''SPTool''.')
    %end
    %return
%    yhzfdesini;
%end

%tempfilt = [];

if nargin == 0
    %if ~isstr(action)
    %    tempfilt = action;
        action = 'initialize';
    %end
end

switch action
case 'initialize'
% -------------------------------------------------------------------------

    %if ~isempty(tempfilt)
    %    fdinit(tempfilt)
    %else
        yhzfdesini;
    %end
    
    shh=get(0,'showhiddenhandles');
    set(0,'showhiddenhandles','on')
    ud = get(gcf,'userdata');
 
    set(ud.toolbar.zoomgroup,'visible','on')
    set(ud.toolbar.helpgroup,'visible','on')
    set(0,'showhiddenhandles',shh)

case 'changefir'
%--------------------------------------------------------------------------
% yhzfiltdes('changefir')
%  callback of fir choose radiobutton
%
    ud=get(gcf,'UserData');
    if ~get(ud.ht.changefir,'value')
       set(ud.ht.changefir,'value',1);
       return
    end
    ud.specs.ir=[1,0];
    set(ud.ht.changeiir,'value',0);
    set([ud.ht.firNHndl,ud.ht.firmethod],'enable','on');
    set([ud.ht.iirmethod1,ud.ht.iirmethod2,ud.ht.iirorderHndl],'enable','off');
    set(gcf,'UserData',ud);
    yhzfiltdes('specchange');
    yhzfdzoom('zoomout',gcf)
case 'changeiir'
%--------------------------------------------------------------------------
% yhzfiltdes('changeiir')
%  callback of iir choose radiobutton
%
    ud=get(gcf,'UserData');
    if ~get(ud.ht.changeiir,'value')
       set(ud.ht.changeiir,'value',1);
       return
    end
    if ud.specs.f(1,:)==ud.specs.f(2,:)
       disp('请先输入临界频率,fp,fs');
       set(gco,'value',0);
       return
    end   
    ud.specs.ir=[0,1];
    set(ud.ht.changefir,'value',0);
    set([ud.ht.firNHndl,ud.ht.firmethod],'enable','off');
    set([ud.ht.iirmethod1,ud.ht.iirmethod2,ud.ht.iirorderHndl],'enable','on');
    set(gcf,'UserData',ud);
    yhzfiltdes('specchange');
    yhzfdzoom('zoomout',gcf)

case 'changeiirmethod1'
%--------------------------------------------------------------------------
% yhzfiltdes('changeiirmethod1')
%   callback of IIR FILTER DESIGN METHOD popup 1
%
    i1=get(gcbo,'value');
    % 1: buttor 2: cheby1 3: cheby2
    ud = get(gcf,'UserData');
    i11=ud.specs.iirmethod(1);
    if i1~=i11
        ud.specs.iirmethod(1) = i1;
        %ud.specs.specialparamsmode = 1;  % use 'auto' mode for special parameters
        set(gcf,'userdata',ud);
        yhzfiltdes('specchange');  % redesign or invalidate filter
        yhzfdzoom('zoomout',gcf);
    end
case 'changeiirmethod2'
%--------------------------------------------------------------------------
% yhzfiltdes('changeiirmethod2')
%   callback of IIR FILTER DESIGN METHOD popup 2
%
    i2=get(gcbo,'value');
    % 1: buttor 2: cheby1 3: cheby2
    ud = get(gcf,'UserData');
    i22=ud.specs.iirmethod(2);
    if i2==i22 | ud.specs.FType~=1;
       set(ud.ht.iirmethod2,'value',i22);
       return;
    else
        ud.specs.iirmethod(2) = i2;
        %ud.specs.specialparamsmode = 1;  % use 'auto' mode for special parameters
        set(gcf,'userdata',ud);
        yhzfiltdes('specchange');  % redesign or invalidate filter
        yhzfdzoom('zoomout',gcf);
    end
        
case 'changefirmethod'
% -------------------------------------------------------------------------
% yhzfiltdes('changemethod')
%   callback of FILTER DESIGN METHOD popup
%
    v = get(gco,'value');  % 1 = boxcar, 2 = hanning,3 = hamming,
                           % 4 = blackman 5 = kaiser, 6 = FS
    ud = get(gcf,'userdata');
    vv = ud.specs.firmethod;   % old value
    if vv~=v
        %if v == 2   % FIRLS - turn off Auto order selection mode
        %    set(ud.ht.btn1Hndl,'enable','off')
        %    set(ud.ht.btn1Hndl,'value',0);
        %    set(ud.ht.btn2Hndl,'value',1)
        %    ud.specs.ordermode = 2;
        %else   % ALL OTHERS - change back to auto order selection mode
        %    set(ud.ht.btn1Hndl,'enable','on')
        %    set(ud.ht.btn1Hndl,'value',1);
        %    set(ud.ht.btn2Hndl,'value',0)
        %    ud.specs.ordermode = 1;
        %end
        ud.specs.firmethod = v;
        %ud.specs.specialparamsmode = 1;  % use 'auto' mode for special parameters
        set(gcf,'userdata',ud);
        yhzfiltdes('specchange');  % redesign or invalidate filter
        yhzfdzoom('zoomout',gcf);
        %if ( ((v<=2)&(vv>=3)) | ((vv<=2)&(v>=3)) | ...
        %     ((v==3)&(vv>=4)) | ((vv==3)&(v>=4)) )
        %    yhzfiltdes('copyspecials')  % copy the estimated special parameters
               % to the 'set' special parameters
               % if it doesn't make sense to use the old 'set' params anymore
        %end
    end

case 'changeFType'  
% -------------------------------------------------------------------------
% yhzfiltdes('changeFType')
%   callback of FILTER TYPE popup
%   POPUP value: 1 = lp, 2 = hp, 3 = bp,%% 4 = bs
%
    ud = get(gcf,'UserData');
    Fs = ud.specs.Fs;     % sampling frequency
    v = get(ud.ht.FType,'value');  
    % v contains new filter type: 1 = lp, 2 = hp, 3 = bp, 4 = bs
    oldv = ud.specs.FType;
    if v~=oldv
        f = ud.specs.f;
        str = get(ud.ht.specHndl,'string');      % old string
        if v == 1  % to lowpass 
            if oldv == 3   % from bandpass
               f=[f(2,1);f(1,1)];
               %f(1:2) = [];
            elseif oldv == 2  % from highpass %%bandstop
               f=[f(2);f(1)];
            end
        elseif v == 2  % to highpass 
            if oldv == 3   % from bandpass
               f=[f(1,1);f(2,1)];
               %f(3:4) = [];
            elseif oldv == 1  % from LP %%bandstop
               f=[f(2);f(1)];
               %f(1:2) = [];
            end
        elseif v == 3  % to bandpass
            if oldv == 1   % from lowpass
                %splitwidth = .15;
                %xd = [0 f(1)];
                %dxd = diff(xd);
                %xd = xd(1)+dxd/2 + [-dxd*splitwidth/2;  dxd*splitwidth/2];
                ffp1=min(f(2),Fs/2-f(2));
                ffp2=max(f(2),Fs/2-f(2));
                ffs1=ffp1/2;
                ffs2=Fs/2-ffs1;
                f = [ffp1,ffp2;ffs1,ffs2];
            elseif oldv == 2  % from highpass
                %splitwidth = .15;
                %xd = [f(1) Fs/2];
                %dxd = diff(xd);
                %xd = xd(1)+dxd/2 + [-dxd*splitwidth/2;  dxd*splitwidth/2];
                %f = [ f(1:2); xd];
                ffp1=min(f(1),Fs/2-f(1));
                ffp2=max(f(1),Fs/2-f(1));
                ffs1=ffp1/2;
                ffs2=Fs/2-ffs1;
                f = [ffp1,ffp2;ffs1,ffs2];
                %f = [f(1),Fs/2-f(1);f(2),Fs/2-f(2)];
            end
        %elseif v == 4  % to bandstop
        %    if oldv == 1   % from lowpass
        %        splitwidth = .15;
        %        xd = [f(1) Fs/2];
        %        dxd = diff(xd);
        %        xd = xd(1)+dxd/2 + [-dxd*splitwidth/2;  dxd*splitwidth/2];
        %        f = [ f(1:2); xd];
        %    elseif oldv == 2  % from highpass
        %        splitwidth = .15;
        %        xd = [0 f(1)];
        %        dxd = diff(xd);
        %        xd = xd(1)+dxd/2 + [-dxd*splitwidth/2;  dxd*splitwidth/2];
        %        f = [ xd;  f];
        %    end
        end
        ud.specs.f = f;
        ud.specs.FType = v;
        if v~=1 & ud.specs.iirmethod(2)==2
           ud.specs.iirmethod(2)=1;
           set(ud.ht.iirmethod2,'value',1)
        end           
        set(ud.ht.specHndl,'String',Localfdspecstr(ud.specs))
        %ud.specs.specialparamsmode = 1;  % use 'auto' mode for special parameters
        set(gcf,'userdata',ud)
        yhzfiltdes('specchange')
        yhzfdzoom('zoomout',gcf);
        % if ( ((v<=2)&(oldv>=3)) | ((oldv<=2)&(v>=3)) )
       %     yhzfiltdes('copyspecials')
       % end
    end

case 'setfirN'
% yhzfiltdes('setfirN')
%    callback for firN edit uicontrol
%
   ud=get(gcf,'UserData');
   oldN=ud.specs.firN;
%   oldbeta=ud.specs.kaiserbeta;
   NStr=get(ud.ht.firNHndl,'string');
  % if oldN==str2num(NStr)
  %    return;
  % end   
   %if ud.specs.firmethod<=5  %the single line for N, window
   sameFlag=1;
   if ud.specs.firmethod==5  %kaiser
         oldbeta=ud.specs.kaiserbeta;
         %ent=sprintf('\n');
         %entind=findstr(NStr,ent);
         N=str2num(NStr(1,:)); %entind-1));
         beta=str2num(NStr(2,:)); %entind+1:end));
         if beta~=oldbeta
            ud.specs.kaiserbeta=beta;
            sameFlag=0;
         end
      else  N=str2num(NStr);
      end   
      if ~rem(N,2) % the length of window is even
         %disp('窗口大小需为奇数!');
         N=N+1;
         if ud.specs.firmethod==5
            NStr=sprintf('%s\n%s',num2str(N),num2str(beta));
         else 
            NStr=sprintf('%s',num2str(N));
         end   
         set(ud.ht.firNHndl,'string',NStr);
       end      
       if N~=oldN %| ud.specs.firmethod~=5)
          sameFlag=0;
       end
       if sameFlag | fix(N)~=N | N<=0
          disp('请重新输入');
          return;
       end   
       ud.specs.firN=N;
 set(gcf,'UserData',ud);
 yhzfiltdes('specchange');
 yhzfdzoom('zoomout',gcf)

   %elseif
case 'setiirorder'
%------------------------------------------------------------------------   
% yhzfiltdes('setiirorder');
% call back of iirorder edit uicontrol
%
   newOrd=str2num(get(gcbo,'string'));
   ud=get(gcf,'UserData');
   oldOrd=ud.specs.iirorder;
   if oldOrd==newOrd | fix(newOrd)~=newOrd | newOrd<=0
      set(ud.ht.iirorderHndl,'string',num2str(oldOrd));
      return;
   end
   ud.specs.iirorder = newOrd;
   set(gcf,'UserData',ud);
   yhzfiltdes('specchange');
   yhzfdzoom('zoomout',gcf)

case 'specchange'
% -------------------------------------------------------------------------
% yhzfiltdes('specchange',fig)
%   spec has changed - either   redesign filter   OR   invalidate old filter
%   (depending on 'Update Automatically' mode)
%   also, CLEARS 'saved' FLAG
%   if fig is present, uses that figure number - else uses gcf
%
    if nargin < 2
        fig = gcf;
    else
        fig = varargin{1};
    end
    ud = get(fig,'userdata');
    wbmf = get(fig,'windowbuttonmotionfcn');
    set(fig,'windowbuttonmotionfcn','')  % temporarily clear this
    setptr(fig,'watch');
    yhzfiltdes('drawspeclines',fig)
    % clear 'saved' flag here:
    ud.saved = 0;
    set(fig,'userdata',ud)
    %yhzfiltdes('fixlabels',fig)
    if gcbo~=ud.ht.firNHndl & gcbo~=ud.ht.iirorderHndl & ud.needEst
       yhzfiltdes('estimate',fig)
    else
       ud.needEst=1;
    end   
    FType = ud.specs.FType;     %   1 = lp, 2 = hp, 3 = bp, 4 = bs
    %method = ud.specs.method; % filter design method
    %if get(ud.ht.btn2Hndl,'value')   % in manual order select mode
    %    order = ud.specs.order.manual;
    %    if method <= 3   % REMEZ, FIRLS, OR KAISER
    %        if type == 2 | type == 4  % high pass or band stop
    %            if rem(order(1),2)   % can't use odd order for these types 
    %                order(1) = order(1) + 1;
    %                ud.specs.order.manual = order;
    %                set(fig,'userdata',ud)
    %            end
    %        end
    %    end
    %end
 %   if strcmp(get(ud.ht.Omenu1,'checked'),'on')   % if autodesign mode
        set(ud.ht.magline,'linestyle',':')
        %set(get(ud.ht.ax1,'title'),'string','Designing filter ...')
        %xstr = get(get(ud.ht.ax1,'xlabel'),'string');
        %set(get(ud.ht.ax1,'xlabel'),'string',...
        %    '(Type Control-C in Command window to interrupt)')
        drawnow    
        % if the estimated order is too big, DO SOMETHING HERE!
        %elseif (n>max_n)|(isnan(n))|(isinf(n))
        %set(ord2Hndl,'UserData',reasonable_n,'string',num2str(reasonable_n))
        %set(btn1Hndl,'value',0,'userdata',2)  % switch radio buttons
        %set(btn2Hndl,'value',1)
        %order = get(ord2Hndl,'UserData'); % use specified Filter order
        %end
        [title_str,errflag] = yhzfiltdes('design',fig);
        %set(get(ud.ht.ax1,'title'),'string',[ud.label ': ' title_str])
        %set(get(ud.ht.ax1,'xlabel'),'string',xstr)
        if ~errflag
            yhzfiltdes('response',fig)
            set(ud.ht.magline,'linestyle','-')
        else
           % set(ud.ht.designmenu,'enable','on') 
        end
    
        %ud = get(fig,'userdata');
        %tempfilt = sptool('Filters',0);  % get current filter
        %tempfilt.tf.num = ud.num;        % assign new num,den and specs
        %tempfilt.tf.den = ud.den;
        %tempfilt.label = ud.label;
        %tempfilt.specs = ud.specs;
        %tempfilt.zpk = [];
        %tempfilt.ss = [];
        %tempfilt.sos = [];
        %ud.filt = tempfilt;
        set(fig,'userdata',ud)
        %sptool('import',tempfilt,1)
        % update filter viewer here!
        
 %   else
        % make changes since filter spec has changed: dotted line, enable
        %  'design now' menu item
   %     set(ud.ht.magline,'linestyle',':')
   %     set(ud.ht.designmenu,'enable','on')
%    end

    setptr(fig,'arrow')
    set(fig,'windowbuttonmotionfcn',wbmf)  % restore motion function

case 'estimate'
% -------------------------------------------------------------------------
% [n,wn,max_n,reasonable_n] = yhzfiltdes('estimate',fig)
%   estimate filter order
%   this section takes the specifications as given by the current
%   figure status and estimates the order and special parameters
%   needed to meet those specifications.
%   It stores the resultant order and special parameters in
%   the userdata of the figure:
%      ud.specs.order.auto (n) is a scalar
%        for firls, n is -1 since you can't estimate the filter order
%      ud.specs.special.auto (wn) is a row containing the 'special' 
%      estimated parameters:
%        remez - weights   (one element for each band)
%        firls - weights   (one element for each band)
%        kaiser - beta of Kaiser window (scalar), followed by cutoff freq(s)
%        butter - 3dB frequency(ies)
%        cheby1 - passband edge(s)
%        cheby2 - stopband edge(s)
%        ellip  - passband edge(s)
%   Sets the static text 'string' to num2str(n)
%   Updates the special parameters dialog box, if it exists
%   If there are output arguments, return the order and the special
%   parameters:
%      [n,wn,max_n,reasonable_n] = yhzfiltdes('estimate');
%
    if nargin < 2
        fig = gcf;
    else
        fig = varargin{1};
    end

  % get handles
    ud=get(fig,'Userdata');

  % initialize variables

    FType = ud.specs.FType;    %   1 = lp, 2 = hp, 3 = bp, 4 = bs
    Fs = ud.specs.Fs;     % sampling frequency
    spec = ud.specs;
    fp = spec.f(1,:);
    fs = spec.f(2,:);
    %if FType > 2
    %    f3 = spec.f(3);
    %    f4 = spec.f(4);
    %end
    Rp = spec.Rp;
    Rs = spec.Rs;

% Estimate order !
    % 1 = REMEZ, 2 = FIRLS, 4 = BUTTER, 5 = CHEBY1, 6 = CHEBY2, 7 = ELLIP, 
    %  3 = KAISER
    firmethod = ud.specs.firmethod;
    iirmethod1 = ud.specs.iirmethod(1);
    iirmethod2 = ud.specs.iirmethod(2);
    ir = ud.specs.ir;
    f=ud.specs.f;
    if ir(1)  %method == 1
        % compute deviations and estimate order
        %if type == 1    % low pass
        %    dev = [ (10^(Rp/20)-1)/(10^(Rp/20)+1)  10^(-Rs/20) ];
        %    f = [f1 f2];  m = [1 0];
        %elseif type == 2   % high pass
        %    dev = [ 10^(-Rs/20) (10^(Rp/20)-1)/(10^(Rp/20)+1)];
        %    f = [f1 f2];  m = [0 1];
        %elseif type == 3   % band pass
        %    dev = [ 10^(-Rs/20) (10^(Rp/20)-1)/(10^(Rp/20)+1) 10^(-Rs/20)];
        %    f = [f1 f2 f3 f4];  m = [0 1 0];
        %elseif type == 4   % band stop
        %    dev = [(10^(Rp/20)-1)/(10^(Rp/20)+1) ...
        %               10^(-Rs/20) (10^(Rp/20)-1)/(10^(Rp/20)+1)];
        %    f = [f1 f2 f3 f4];  m = [1 0 1];
        %end
        %[n,fo,mo,wn] = remezord(f,m,dev,Fs);
        %max_n = 2000;  reasonable_n = 500;
        %wn = wn(:)';   % make it a row
        %if type == 2 | type == 4   % highpass or bandstop
        %    if rem(n,2)==1   % if n is odd, must increase
        %        n = n+1;
        %    end
        %end
        %if n<3, n=3; end   % n must be at least 3 for remez
    %elseif method == 2  % FIRLS
    %    if type == 1    % low pass
    %        dev = [ (10^(Rp/20)-1)/(10^(Rp/20)+1)  10^(-Rs/20) ];
    %    elseif type == 2   % high pass
    %        dev = [ 10^(-Rs/20) (10^(Rp/20)-1)/(10^(Rp/20)+1)];
    %    elseif type == 3   % band pass
    %        dev = [ 10^(-Rs/20) (10^(Rp/20)-1)/(10^(Rp/20)+1) 10^(-Rs/20)];
    %    elseif type == 4   % band stop
    %        dev = [(10^(Rp/20)-1)/(10^(Rp/20)+1) ...
    %                   10^(-Rs/20) (10^(Rp/20)-1)/(10^(Rp/20)+1)];
    %    end
    %    n = -1;   % can't estimate this baby
    %    wn = ones(size(dev))*max(dev)./dev;
   %     max_n = 2000;  reasonable_n = 500;
      if firmethod == 5   % KAISER
        dev = [ (10^(Rp/20)-1)/(10^(Rp/20)+1)  10^(-Rs/20) ];
        alfa = -min(20*log10(dev));
        if alfa > 50,
            beta = .1102*(alfa - 8.7);
        elseif alfa >= 21,
            beta = .5842*((alfa-21).^(.4)) + .07886*(alfa-21);
        else
            beta = 0;
        end
        if FType <= 2    % lowpass or highpass
            f1=min(f); f2=max(f);
            n = ceil((alfa - 8)/(2.285*(f2-f1)*2*pi/Fs));
            f = (f1+(f2-f1)/2);
         else  % bandpass 
            f1=f(2,1); f2=f(1,1); f3=f(1,2); f4=f(2,2);
            n = ceil((alfa - 8)/(2.285*min(f2-f1,f4-f3)*2*pi/Fs));
            f = [(f1+(f2-f1)/2) (f3+(f4-f3)/2)];
        end
        wn = [beta f];
        max_n = 2000;  reasonable_n = 500;
        %if FType == 2 | FType == 4   % highpass or bandstop
            if rem(n,2)==1   % if n is odd, must decrease
                n = n-1;
            end
         %end
      ud.specs.kaiserbeta=beta;
      ud.specs.firN=n+1;
      elseif firmethod ==6 %Frequency Sampling Method
         %???
      else 
         n=ud.specs.firN;
      end
     % ud.specs.firN=n;
   else %iir   
      if iirmethod1==1
      %elseif method == 4
        if FType == 1    % lowpass
           [n,wn]=buttord(fp*2/Fs,fs*2/Fs,Rp,Rs);
        elseif FType == 2   % highpass
           [n,wn]=buttord(fp*2/Fs,fs*2/Fs,Rp,Rs);
        elseif FType == 3   % bandpass
           [n,wn]=buttord(fp*2/Fs,fs*2/Fs,Rp,Rs);
    %    elseif type == 4   % bandstop
    %        [n,wn]=buttord([f1 f4]*2/Fs,[f2 f3]*2/Fs,Rp,Rs);
        end
       wn = wn*Fs/2;
        max_n = 60;  reasonable_n = 30;
      elseif iirmethod1 == 2
       % if type == 1    % lowpass
       %     [n,wn]=cheb1ord(f1*2/Fs,f2*2/Fs,Rp,Rs);
       % elseif type == 2   % highpass
       %     [n,wn]=cheb1ord(f2*2/Fs,f1*2/Fs,Rp,Rs);
       % elseif type == 3   % bandpass
       %     [n,wn]=cheb1ord([f2 f3]*2/Fs,[f1 f4]*2/Fs,Rp,Rs);
       % elseif type == 4   % bandstop
       %     [n,wn]=cheb1ord([f1 f4]*2/Fs,[f2 f3]*2/Fs,Rp,Rs);
       % end
       [n,wn]=cheb1ord(fp*2/Fs,fs*2/Fs,Rp,Rs);
        wn = wn*Fs/2;
        max_n = 30;  reasonable_n = 15;
      elseif iirmethod1 == 3
        %if type == 1    % lowpass
        %    [n,wn]=cheb2ord(f1*2/Fs,f2*2/Fs,Rp,Rs);
        %elseif type == 2   % highpass
        %    [n,wn]=cheb2ord(f2*2/Fs,f1*2/Fs,Rp,Rs);
        %elseif type == 3   % bandpass
        %    [n,wn]=cheb2ord([f2 f3]*2/Fs,[f1 f4]*2/Fs,Rp,Rs);
        %elseif type == 4   % bandstop
        %    [n,wn]=cheb2ord([f1 f4]*2/Fs,[f2 f3]*2/Fs,Rp,Rs);
        %end
        [n,wn]=cheb2ord(fp*2/Fs,fs*2/Fs,Rp,Rs);
        wn = wn*Fs/2;
        max_n = 30;  reasonable_n = 15;
    %elseif method == 7   % elliptic
    %    if type == 1    % lowpass
    %        [n,wn]=ellipord(f1*2/Fs,f2*2/Fs,Rp,Rs);
    %    elseif type == 2   % highpass
    %        [n,wn]=ellipord(f2*2/Fs,f1*2/Fs,Rp,Rs);
    %    elseif type == 3   % bandpass
    %        [n,wn]=ellipord([f2 f3]*2/Fs,[f1 f4]*2/Fs,Rp,Rs);
    %    elseif type == 4   % bandstop
    %        [n,wn]=ellipord([f1 f4]*2/Fs,[f2 f3]*2/Fs,Rp,Rs);
    %    end
    %    wn = wn*Fs/2;
    %    max_n = 25;  reasonable_n = 12;
       end

    % set order field
    ud.specs.iirorder = n;
    %ud.specs.special.auto = wn;
    %if method == 2   % can't estimate !
    %    set(ud.ht.ord1Hndl,'String','-')
    %else
    end
    if ir(2)
        set(ud.ht.iirorderHndl,'String',num2str(n))
     elseif firmethod==5
        label=sprintf('N:\nbeta:');
        set(ud.ht.firlabelHndl,'string',label); %'string','[N\nbeta]:');
        label=sprintf('%g\n%g',ud.specs.firN,beta);
        set(ud.ht.firNHndl,'string',label);%[num2str(n),' ',num2str(beta)]);
        %end
     else
        set(ud.ht.firlabelHndl,'string','N:');
        set(ud.ht.firNHndl,'string',num2str(ud.specs.firN));
    end   
    set(fig,'userdata',ud)

    %fdspdlg('updateparamdialog',fig)

    % output params?  Return estimates if so
    if nargout > 0
        varargout{1} = n;
    end
    if nargout > 1
        varargout{2} = wn;
    end
    if nargout > 2
        varargout{3} = max_n;
    end
    if nargout > 1
        varargout{4} = reasonable_n;
    end

case 'edit'
% -------------------------------------------------------------------------
% yhzfiltdes('edit')
%   callback of editbox for filter parameters (band edges and attenuations)
%
    ud = get(gcf,'UserData');
    FType = ud.specs.FType;    %%% 1 = lp, 2 = hp, 3 = bp, 4 = bs

    if FType<=2
       v = [ud.specs.f; ud.specs.Rp; ud.specs.Rs];   % old values
    else 
       v = [ud.specs.f(1,:)';ud.specs.f(2,:)'; ud.specs.Rp;ud.specs.Rs];
    end   
    str = get(gco,'String');
    ind = find(abs(str)<32);
    str(ind) = 32*ones(size(ind));
    str = [str 32*ones(size(str,1),1)];   % add a space after each number
    str = str';
    str = char(['[' str(:)' ']']);
    vv = eval(str,'-1')';     % new values
    if ~isempty(vv) & vv == -1
        vv = v;    % in case of error, restore old values
    end
    %if FType <= 2
    if isempty(vv) | any(imag(vv)) | any(vv<=0) %| length(vv)~=4  %| any(diff(vv(1:2))<=0) |             
       vv = v;
    end
    inpError = 0;
    if FType ==1 &  vv(1)>vv(2)
          inpError=1;
    end   
    if FType ==2 & vv(1)<vv(2)
          inpError =1;
    end
    if FType ==3 & ~(vv(3)<=vv(1) & vv(1)<=vv(2) & vv(2)<=vv(4))
          inpError =1;
    end
    if FType<3 & any(vv(1:2)>ud.specs.Fs/2)
       inpError=1;
    elseif FType==3 & any(vv(1:4)>ud.specs.Fs/2)
       inpError=1;
    end;      
    if inpError
       disp('输入错误, 请重新输入!');
       vv = v;
    end
    if FType<=2
        ud.specs.f = vv(1:2);
        ud.specs.Rp = vv(3);
        ud.specs.Rs = vv(4);
    else
       ud.specs.f=[vv(1:2)';vv(3:4)'];
       ud.specs.Rp = vv(5);
       ud.specs.Rs=vv(6);
    end   
       %if isempty(vv) | any(imag(vv)) | any(vv<=0) | ...
    %              any(diff(vv(1:4))<=0) | length(vv)~=6
    %        vv = v;
    %    end
    %    ud.specs.f = vv(1:4);
    %    ud.specs.Rp = vv(5);
    %    ud.specs.Rs = vv(6);
    %end
%    if spec.type <= 2
%        str = sprintf('%g\n%g\n\n%g\n%g',spec.f(1),spec.f(2),...
%          spec.Rp,spec.Rs);
%    else
%        str = sprintf('%g\n%g\n%g\n%g\n\n%g\n%g',spec.f(1),spec.f(2),...
%          spec.f(3),spec.f(4),spec.Rp,spec.Rs);
%    end
    set(gco,'String',Localfdspecstr(ud.specs))
    set(gcf,'userdata',ud)
    v = v(:);
    if any(vv~=v)
        yhzfiltdes('specchange')
    end
    
 case 'setFs'
% -------------------------------------------------------------------------
% yhzfiltdes('setFs',fig,dogrid)
%   callback to set sampling frequency of tool
%
    if nargin < 2
        fig = gcf;
    else
        fig = varargin{1};
    end

    if nargin < 3
        dogrid = 1;
    else
        dogrid = 0;
    end

    ud = get(fig,'userdata');

    %oldFs = ud.specs.Fs % old value of Fs sampling frequency
    oldFs = get(ud.ht.FsHndl,'userdata');  % old value of Fs sampling frequency
    str = get(ud.ht.FsHndl,'String');
    Fs = eval(str);
    if Fs<=0 | imag(Fs)~=0 | isempty(Fs)
       disp('输入错误, 请重新输入!');
       Fs=oldFs;
    end   
    %[Fs,err] = validarg(str,[0 Inf],[1 1],'sampling frequency');
    %Fs = ud.filt.Fs;     % new value (only different when the sampling frequency
    %                     %            is changed in the SPTool).
    %toolFs = get(ud.ht.FsHndl,'userdata');  % value currently in yhzfiltdes
    
    set(ud.ht.FsHndl,'userdata',Fs,'string',str);   % store new Fs
    ud.specs.Fs = Fs;
    if (Fs-oldFs)    % if Fs really changed,
        % update the tool here

        % update the band edges
        ud.specs.f = ud.specs.f*Fs/oldFs;
        
        % update the "Full View" limits
        ud.limits.xlim = ud.limits.xlim*Fs/oldFs;
        
        % update prefs string
        ud.prefs.Fs = str;

        if dogrid
          % make sure freq. grid spacing is proportionally the same
          ud.prefs.gridsize(1) = ud.prefs.gridsize(1)*Fs/oldFs;
          %if ~isempty(ud.tabfig)
          %   tabud = get(ud.tabfig,'userdata');
          %   if ~isempty(get(tabud.tabs(2),'userdata'))
          %      fdprefhand('populate',ud.tabfig,2,ud.prefs)
          %   end
          %end
        end
        
        % save the user data
        set(fig,'userdata',ud)

        % set string of filter specs edit box:
        set(ud.ht.specHndl,'string',Localfdspecstr(ud.specs)); 

        yhzfiltdes('drawspeclines',fig)

        set(ud.ht.ax1,'xlim',get(ud.ht.ax1,'xlim')*Fs/oldFs); 
        set(ud.ht.magline,...
              'xdata',get(ud.ht.magline,'xdata')*Fs/oldFs);  % magline

        figname = get(fig,'name');

        %if ~isempty(ud.tabfig)    % update settings figure
        %    % since Fs is on the first page, it has always been created
        %    fdprefhand('populate',ud.tabfig,1,ud.prefs)
        %end
        
        % update special parameters - both estimated and manually selected 
        firmethod = ud.specs.firmethod;
        iirmethod = ud.specs.iirmethod;
        %wn_est = ud.specs.special.auto;
        %wn_sel = ud.specs.special.manual;
        %if method == 3   % kaiser window
        %    wn_est(2:length(wn_est)) = wn_est(2:length(wn_est))*Fs/oldFs;
        %    wn_sel(2:length(wn_sel)) = wn_sel(2:length(wn_sel))*Fs/oldFs;
        %elseif method >= 4  % IIR filter
        %    wn_est = wn_est*Fs/oldFs;
        %    wn_sel = wn_sel*Fs/oldFs;
        %end
        %ud.specs.special.auto = wn_est;
        %ud.specs.special.manual = wn_sel;
        
        ud.filt.specs = ud.specs;
        
        % save the user data
        set(fig,'userdata',ud)

        % now ready to update 'Special Parameters' dialog box
        %fdspdlg('updateparamdialog',fig)
        
        % poke filt structure back into SPTool
        %sptool('import',ud.filt)
  else
    set(ud.ht.FsHndl,'string',ud.prefs.Fs)
    figure(fig)
  end


case 'setfilt'
%------------------------------------------------------------------------
% yhzfiltdes('setfilt',filt,fig)
% Sets the Filter Designer to the given filter.
% Inputs:
%    filt - filter structure; can be of type 'design' or 'imported'
%    fig - figure handle of filter designer
filt = varargin{1};
    fig = varargin{2};
    ud = get(fig,'userdata');
    %if isempty(filt) | ~strcmp(filt.type,'design')
    %   % disable yhzfiltdes
    %   disableList = [ud.ht.methodHndl ud.ht.typeHndl ud.ht.specHndl ...
    %                  ud.ht.ord1Hndl ud.ht.ord2Hndl ud.ht.btn1Hndl ...
    %                  ud.ht.btn2Hndl];
    %   set(disableList,'enable','off')
    %   set([ud.ht.magline ud.ht.specline1 ...
    %        ud.ht.specline2],'visible','off')
    %   if isempty(filt)
    %       set(get(ud.ht.ax1,'title'),'string','<no filter selected>')
    %       ud.label = '';
    %       set(ud.ht.FsHndl,'string','-')
    %   else
    %       ud.label = filt.label;
    %       ud.num = filt.tf.num;
    %       ud.den = filt.tf.den;
    %       set(get(ud.ht.ax1,'title'),'string',[ud.label ': <not a design>'])
    %       set(ud.ht.FsHndl,'string',sprintf('%.9g',filt.Fs))
    %   end
    %   ud.specs = [];
    %   ud.filt = filt;
    %   set(fig,'userdata',ud)
    %else
       % focus on selected filter
       ud.label = filt.label;
       ud.num = filt.tf.num;
       ud.den = filt.tf.den;
       filt.specs.Fs = filt.Fs;
       oldfilt = ud.filt;
       oldfilt.Fs = filt.Fs;
       ud.filt = filt;
       set(fig,'userdata',ud)
       if isequal(filt,oldfilt)   % ONLY Fs HAS CHANGED
           set(ud.ht.FsHndl,'string',sprintf('%.9g',filt.Fs))
           yhzfiltdes('setFs',fig)
       else
           yhzfiltdes('setspecs',filt.specs,0,fig)
           yhzfdzoom('zoomout',fig)
       end
    %end
case 'setspecs'
% -------------------------------------------------------------------------
% yhzfiltdes('setspecs',specs,designFlag)
% yhzfiltdes('setspecs',specs,designFlag,fig)
%   set specs according to first input argument (specifications structure)
% Inputs:
%    specs -   specifications structure
%    designFlag - 1 ==> redesign filter (default), 0 ==> just recompute response
%    fig - optional; defaults to gcf
    if nargin < 3
        designFlag = 1;
    else
        designFlag = 0;
    end
    if nargin < 4
        fig = gcf;
    else
        fig = varargin{3};
    end
    ud = get(fig,'userdata');

    newspecs = varargin{1};
    %if ~isfdt(newspecs)
    %    errordlg('Load error: invalid specifications structure');
    %    return
    %end

    % set 'saved' flag here:
    ud.saved = 1; 

    ud.specs = newspecs;
    set(fig,'userdata',ud)
    
    %oldFs = get(ud.ht.FsHndl,'userdata');  % old value of Fs sampling frequency
    Fs = ud.filt.Fs;
    %set(ud.ht.FsHndl,'string',sprintf('%.9g',Fs),'userdata',Fs)
    
    % update the "Full View" limits
    ud.limits.xlim = [0 Fs/2];
        
    ud.specs.Fs = Fs;        
    % save the user data
    set(fig,'userdata',ud)
                        
    set(ud.ht.FType,'value',newspecs.FType,'enable','on');
    set(ud.ht.changefir,'value',newspecs.ir(1));
    set(ud.ht.changeiir,'value',newspecs.ir(2));
    set(ud.ht.firmethod,'value',newspecs.firmethod);
    %set(ud.ht.firNHndl,'string',newspecs.firN);
    %set(ud.ht.iirorderHndl,'string',num2str(newspecs.iirorder));
    set(ud.ht.iirmethod1,'value',newspecs.iirmethod(1));
    set(ud.ht.iirmethod2,'value',newspecs.iirmethod(2));
    if get(ud.ht.changefir,'value')
       set([ud.ht.iirorderHndl,ud.ht.iirmethod1,ud.ht.iirmethod2],'enable','off');
    else
       set([ud.ht.firmethod,ud.ht.firNHndl],'enable','off');
    end   
   % set(ud.ht.methodHndl,'value',newspecs.method,'enable','on')
   % set(ud.ht.typeHndl,'value',newspecs.type,'enable','on')
   % set(ud.ht.specHndl,'string',Localfdspecstr(newspecs),'enable','on')
    
    %if ud.specs.ordermode == 1
    %    set(ud.ht.btn1Hndl,'value',1)
    %    set(ud.ht.btn2Hndl,'value',0)
    %else
    %    set(ud.ht.btn1Hndl,'value',0)
    %    set(ud.ht.btn2Hndl,'value',1)
    %end
    
    %if ud.specs.method == 2  % FIRLS
    %    set(ud.ht.ord1Hndl,'string','-','enable','on')
    %    set(ud.ht.btn1Hndl,'enable','off')
    %else
    %    set(ud.ht.ord1Hndl,'string',newspecs.order.auto,'enable','on')
    %    set(ud.ht.btn1Hndl,'enable','on')
    %end
    %set(ud.ht.ord2Hndl,'string',newspecs.order.manual,'enable','on')
    %set(ud.ht.btn2Hndl,'enable','on')    
    
    set([ud.ht.magline ud.ht.specline1 ud.ht.specline2],'visible','on')
    
    %fdspdlg('updateparamdialog',fig)

    %if designFlag
        yhzfiltdes('specchange',fig)
    %else
    %    yhzfiltdes('response',fig)              % compute frequency response
    %    title_str = yhzfiltdes('design',fig,1);
    %    set(get(ud.ht.ax1,'title'),'string',[ud.label ': ' title_str])
    %    yhzfiltdes('drawspeclines',fig)
        %yhzfiltdes('fixlabels',fig)
    %end
case 'drawspeclines'
% -------------------------------------------------------------------------
% yhzfiltdes('drawspeclines',fig)
%   set the x- and y-data of the specifications lines
%   if fig is not present, uses the gcf, else uses fig
%
    if nargin > 1
        fig = varargin{1};
    else
        fig = gcf;
    end
    ud = get(fig,'userdata');  % handle table
    FType = ud.specs.FType;   % 1 = lp, 2 = hp, 3 = bp, %%4 = bs
    Fs = ud.specs.Fs;          % sampling frequency
    %specHndl = ud.ht.specHndl;     % filter specs edit box
    %methodHndl = ud.ht.methodHndl;  % filter design method popup
    specline1 = ud.ht.specline1;   % passband ripple specifications line
    specline2 = ud.ht.specline2;   % stopband attenuation specifications line

    specs = ud.specs;
    Rp = specs.Rp;
    Rs = specs.Rs;
    if specs.ir(1)== 1    % FIR filter
        dev = [ (10^(Rp/20)-1)/(10^(Rp/20)+1)  10^(-Rs/20) ];
        above = 20*log10(1+dev(1)); below = 20*log10(1-dev(1));
    else   % IIR filter 
        above = 0;   below = -Rp;
    end
    fp = specs.f(1,:);
    fs = specs.f(2,:);
    if FType == 1  % lp 
        set(specline1,'xdata',[0 fp NaN 0 fp],...
                'ydata',[above above NaN below below])
        set(specline2,'xdata',[fs Fs/2],'ydata',[-Rs -Rs])
    elseif FType == 2  % hp
        set(specline1,'xdata',[fp Fs/2 NaN fp Fs/2],...
                'ydata',[above above NaN below below])
        set(specline2,'xdata',[0 fs],'ydata',[-Rs -Rs])
    elseif FType == 3  % bp
       % f3 = specs.f(3);  f4 = specs.f(4);
        set(specline1,'xdata',[fp(1) fp(2) NaN fp(1) fp(2)],...
                'ydata',[above above NaN below below])
        set(specline2,'xdata',[0 fs(1) NaN fs(2) Fs/2],...
                'ydata',[-Rs -Rs NaN -Rs -Rs])
    %elseif type == 4  % bs
    %    f3 = specs.f(3);  f4 = specs.f(4);
    %    set(specline1,'xdata',[0 f1 NaN 0 f1 NaN f4 Fs/2 NaN f4 Fs/2],...
    %     'ydata',[above above NaN below below NaN above above NaN below below])
    %    set(specline2,'xdata',[f2 f3],'ydata',[-Rs -Rs])
    end
    
 case 'response'
% -------------------------------------------------------------------------
% yhzfiltdes('response',fig)
%   compute frequency response of filter whose coefficients are stored in
%   ud.num and ud.den, and update ud.ht.magline's xdata and ydata
%
    if nargin > 1
        fig = varargin{1};
    else
        fig = gcf;
    end

   % get handles
    ud=get(fig,'Userdata');

   % initialize variables

    FType = ud.specs.FType;    %   1 = lp, 2 = hp, 3 = bp,%%4 = bs
    %method = ud.specs.method;    % filter design method
    Fs = ud.specs.Fs;     % sampling frequency
    spec = ud.specs;
    f1 = spec.f(1,:);
    f2 = spec.f(2,:);
    %if type > 2
    %    f3 = spec.f(3);
    %    f4 = spec.f(4);
    %end
    Rp = spec.Rp;
    Rs = spec.Rs;

    b = ud.num;
    a = ud.den;

    nfft = ud.prefs.nfft;
    emergencynfft = 2^nextpow2( 2*max(length(b),length(a)) );
    if nfft<emergencynfft
        %disp(sprintf(['%g is too few frequency points for this filter,'...
      %              ' using %g instead'],nfft, emergencynfft))
        nfft = emergencynfft;
    end
    [H,F] = freqz(b,a,nfft,Fs);
    magH = 20*log10(abs(H));
    set(ud.ht.magline,'xdata',F,'ydata',magH)
    %hold on;
case 'design'
% -------------------------------------------------------------------------
% [title_str,errflag] = yhzfiltdes('design',fig)
% [title_str,errflag] = yhzfiltdes('design',fig,titleFlag)
%   Design filter
%   JUST designs the filter and stores the coefficients in ud.num, ud.den
%   title_str is a string briefly describing the filter
%   errflag == 1 means an error occurred, errflag == 0 means no error
%   titleFlag - 1 ==> just return title (don't design), 0 ==> do design (default)
    if nargin < 2
        fig = gcf;
    else
        fig = varargin{1};
    end
    if nargin < 3
        titleFlag = 0;
    else
        titleFlag = varargin{2};
    end
    
  % get handles
    ud=get(fig,'Userdata');

  % initialize variables

    FType = ud.specs.FType;    %   1 = lp, 2 = hp, 3 = bp, %%4 = bs
    firmethod = ud.specs.firmethod;   % filter design method
    iirmethod1 = ud.specs.iirmethod(1);
    iirmethod2 = ud.specs.iirmethod(2);
    Fs = ud.specs.Fs;     % sampling frequency
    spec = ud.specs;
    fp = spec.f(1,:);
    fs = spec.f(2,:);
    %if type > 2
    %    f3 = spec.f(3);
    %    f4 = spec.f(4);
    %end
    Rp = spec.Rp;
    Rs = spec.Rs;
    
% %determine which order to use: estimated or specified
  %  if ud.specs.ordermode == 1    % use estimated order 
  %      order = spec.order.auto; 
  %  else             % use manually selected 
   %     order = spec.order.manual; 
   % end
    %if ud.specs.specialparamsmode == 1    % use estimated special parameters
    %    wn = spec.special.auto; 
    %else             % use manually selected special params
     %   wn = spec.special.manual; 
    %end

% Design filter
   % % 1 = REMEZ, 2 = FIRLS, 4 = BUTTER, 5 = CHEBY1, 6 = CHEBY2, 7 = ELLIP, 
   % %  3 = KAISER
   if spec.ir(1)   % FIR
      if firmethod<=5  %FIR-WINDOW
         winTypeS={'boxcar';'hanning';'hamming';'blackman';'kaiser'};
         winType=winTypeS(firmethod);
         %%elseif method == 3   % KAISER
         %fir1flag = 1;
         %if fir1flag 
             %dstr = [' window length = ' sprintf('%g',firN) ';'];
             if FType ~= 2   % low pass and band pass
             %   dstr = [dstr sprintf('\n') ...
             %      ' w = [' sprintf('%1.18e\n ',fp*2/Fs) '];'];
             %   dstr = [dstr sprintf('\n') ...
             %      ' wind = ',winType,'(window length+1,' sprintf('%1.18e',wn(1)) ');'];
            %dstr = [dstr sprintf('\n') ...
            %       ' b = fir1(order,w,wind,''noscale''); a = 1;' ];
               % wn=fp*2/Fs;
               if firmethod~=5
                  eval(['b=fir1(spec.firN-1,fp*2/Fs,',char(winType),'(spec.firN),''noscale'');']);
                  a = 1;
               else % Kaiser Window
                  eval(['b=fir1(spec.firN-1,fp*2/Fs,',...
                     char(winType),'(spec.firN,',num2str(spec.kaiserbeta),'),''noscale'');']);
                  a = 1;
               end;   
             else %type == 2   % high pass
            %dstr = [dstr sprintf('\n') ...
            %       ' w = [' sprintf('%1.18e\n ',wn(2)*2/Fs) '];'];
            %dstr = [dstr sprintf('\n') ...
            %       ' wind = kaiser(order+1,' sprintf('%1.18e',wn(1)) ');'];
            %dstr = [dstr sprintf('\n') ...
            %       ' b = fir1(order,w,''high'',wind,''noscale''); a = 1;' ];
               %dstr1 = ['b = fir1(order,wn(2)*2/Fs,''high'',' ...
               %      'kaiser(order+1,wn(1)),''noscale''); a = 1;'];
               if firmethod~=5
                  eval(['b=fir1(spec.firN-1,fp*2/Fs,''high'',',...
                     char(winType),'(spec.firN),''noscale'');']);
                  a = 1;
               else % Kaiser Window
                  b=fir1(spec.firN-1,fp*2/Fs,'high',kaiser(spec.firN,spec.kaiserbeta),'noscale');
                  a = 1;
               end; 
              %elseif type == 3   % band pass
            %dstr = [dstr sprintf('\n') ...
            %       ' w = [' sprintf('%1.18e\n ',wn(2:3)*2/Fs) '];'];
            %dstr = [dstr sprintf('\n') ...
            %       ' wind = kaiser(order+1,' sprintf('%1.18e',wn(1)) ');'];
            %dstr = [dstr sprintf('\n') ...
            %       ' b = fir1(order,w,wind,''noscale''); a = 1;' ];
            %dstr1 = ['b = fir1(order,wn(2:3)*2/Fs,kaiser(order+1,wn(1)),''noscale'');'...
            %         'a = 1;'];
        %elseif type == 4   % band stop
        %    dstr = [dstr sprintf('\n') ...
         %          ' w = [' sprintf('%1.18e\n ',wn(2:3)*2/Fs) '];'];
         %   dstr = [dstr sprintf('\n') ...
         %          ' wind = kaiser(order+1,' sprintf('%1.18e',wn(1)) ');'];
         %   dstr = [dstr sprintf('\n') ...
         %          ' b = fir1(order,w,''stop'',wind,''noscale''); a = 1;' ];
         %   dstr1 = ['b = fir1(order,wn(2:3)*2/Fs,''stop'',' ...
         %            'kaiser(order+1,wn(1)),''noscale''); a = 1;'];
              end
              title_str = sprintf('Order %g FIR Filter designed with Window %s',...
                                       spec.firN,char(winType));
           %else   %if fir1flag
       %dstr = [' order = ' sprintf('%g',order) ';'];
        %if type == 1    % low pass
         %   dstr = [dstr sprintf('\n') ...
         %          ' w = [0 ' sprintf('%1.18e\n ',wn(2)*2/Fs) ' ' ...
         %            sprintf('%1.18e\n ',wn(2)*2/Fs) ' 1];'];
         %   dstr = [dstr sprintf('\n') ...
         %          ' wind = kaiser(order+1,' sprintf('%1.18e',wn(1)) ')'';'];
         %   dstr = [dstr sprintf('\n') ...
         %          ' b = firls(order,w,[1 1 0 0]).*wind; a = 1;' ];
         %   dstr1 = ['b = firls(order,[0 wn([2 2])*2/Fs 1],[1 1 0 0])'...
         %            '.*kaiser(order+1,wn(1))''; a = 1;'];
        %elseif type == 2   % high pass
        %    dstr = [dstr sprintf('\n') ...
        %           ' w = [0 ' sprintf('%1.18e\n ',wn(2)*2/Fs) ' ' ...
        %             sprintf('%1.18e\n ',wn(2)*2/Fs) ' 1];'];
        %    dstr = [dstr sprintf('\n') ...
        %           ' wind = kaiser(order+1,' sprintf('%1.18e',wn(1)) ');'];
        %    dstr = [dstr sprintf('\n') ...
        %           ' b = firls(order,w,[0 0 1 1]).*wind; a = 1;' ];
        %    dstr1 = ['b = firls(order,[0 wn([2 2])*2/Fs 1],[0 0 1 1])'...
        %             '.*kaiser(order+1,wn(1))''; a = 1;'];
        %elseif type == 3   % band pass
        %    dstr = [dstr sprintf('\n') ...
        %           ' w = [' sprintf('%1.18e\n ',[0 wn([2 2 3 3])*2/Fs 1]) '];'];
        %    dstr = [dstr sprintf('\n') ...
        %           ' wind = kaiser(order+1,' sprintf('%1.18e',wn(1)) ');'];
        %    dstr = [dstr sprintf('\n') ...
        %           ' b = firls(order,w,[0 0 1 1 0 0]).*wind; a = 1;' ];
        %    dstr1 = ['b = firls(order,[0 wn([2 2 3 3])*2/Fs 1],'...
        %             '[0 0 1 1 0 0]).*kaiser(order+1,wn(1))'';'...
        %             'a = 1;'];
        %elseif type == 4   % band stop
        %    dstr = [dstr sprintf('\n') ...
        %           ' w = [' sprintf('%1.18e\n ',[0 wn([2 2 3 3])*2/Fs 1]) '];'];
        %    dstr = [dstr sprintf('\n') ...
        %           ' wind = kaiser(order+1,' sprintf('%1.18e',wn(1)) ');'];
        %    dstr = [dstr sprintf('\n') ...
        %           ' b = firls(order,w,[1 1 0 0 1 1]).*wind; a = 1;' ];
        %    dstr1 = ['b = firls(order,[0 wn([2 2 3 3])*2/Fs 1],'...
        %             '[1 1 0 0 1 1]).*kaiser(order+1,wn(1))'';'...
        %             'a = 1;'];
        %end
        %title_str = sprintf('Order %g FIR Filter designed with FIRLS',order);
       else % firmethod=6 Frequece Sampling Method
          b=yhzFirSamp(fp/Fs,spec.firN,FType);
          a=1;
          title_str=sprintf('FIR Filter Design with Frequency Sampling Points: %g',spec.firN);
       end %end of fir filter
    else %iir
       if iirmethod2==1 %BLT
          if iirmethod1==1 % buttor
             Proto='butterworth';
             switch FType
             case 1 %LP
                [b,a] = butter(spec.iirorder,fp*2/Fs);
             case 2 %HP
                [b,a] = butter(spec.iirorder,fp*2/Fs,'high');
             case 3 %BP
                [b,a] = butter(spec.iirorder,fp*2/Fs);
             end %switch FType
          elseif iirmethod1==2 %cheby1
             Proto='chebyshevI';
             if FType==2 
                [b,a] = cheby1(spec.iirorder,Rp,fp*2/Fs,'high');
             else %LP and Bp
                [b,a] = cheby1(spec.iirorder,Rp,fp*2/Fs);
             end %FTypp
          else %iirmethod1=3
             Proto='chebyshevII';
             if FType==2 
                [b,a] = cheby2(spec.iirorder,Rs,fp*2/Fs,'high');
             else %LP and Bp
                [b,a] = cheby2(spec.iirorder,Rs,fp*2/Fs);
             end %FTypp
          end %end of BLT
          title_str=sprintf('IIR Filter Design with Bilinear Transfer Method and LPAF Prototype:%s',Proto);
       else %iirmethod==2 Impulse Response Invariance--LP
          if iirmethod1==1 %butter
             Proto='butterworth';
             [b,a] = butterImp(spec.iirorder,fp*2/Fs);
          elseif iirmethod1==2 %cheby1
             Proto='chebyshevI';
             [b,a] = cheby1Imp(spec.iirorder,Rp,fp*2/Fs);
          else %cheby2
             Proto='chebyshevII';
             [b,a] = cheby2Imp(spec.iirorder,Rp,fp*2/Fs);
          end   
          title_str=sprintf('IIR Filter Design with Impulse Response Invariance Method and LPAF Prototype: %s',Proto);
       end    % end of IIR
    end   %end of FIR and IIR
   %end   
   %if (method == 1)|(method == 2)
   %     if type == 1    % low pass
   %         f = [0 f1 f2 Fs/2]*2/Fs;  m = [1 1 0 0];
   %     elseif type == 2   % high pass
   %         f = [0 f1 f2 Fs/2]*2/Fs;  m = [0 0 1 1];
   %     elseif type == 3   % band pass
   %         f = [0 f1 f2 f3 f4 Fs/2]*2/Fs;  m = [0 0 1 1 0 0];
   %     elseif type == 4   % band stop
   %         f = [0 f1 f2 f3 f4 Fs/2]*2/Fs;  m = [1 1 0 0 1 1];
   %     end
   %     dstr = [' order = ' sprintf('%g',order) ';'];
   %     dstr = [dstr sprintf('\n') ' f = [' sprintf('%1.18e\n ',f) '];'];
   %     dstr = [dstr sprintf('\n') ' m = [' sprintf('%1.18e\n ',m) '];'];
   %     dstr = [dstr sprintf('\n') ' wn = [' sprintf('%1.18e\n ',wn) '];'];
   %     if method == 1 
   %         dstr1 = 'b = remez(order,f,m,wn); a = 1;';
   %        title_str = sprintf('Order %g FIR Filter designed with REMEZ',order);
   %         dstr = [dstr sprintf('\n') ' b = remez(order,f,m,wn); a = 1;'];
   %     else
   %         dstr1 = 'b = firls(order,f,m,wn); a = 1;';
   %        title_str = sprintf('Order %g FIR Filter designed with FIRLS',order);
   %         dstr = [dstr sprintf('\n') ' b = firls(order,f,m,wn); a = 1;'];
   %     end
   %   elseif method == 4   % butterworth
   %     wn = wn*2/Fs;
   %     dstr = [' order = ' sprintf('%g',order) ';'];
   %     dstr = [dstr sprintf('\n') ...
   %            ' wn = [' sprintf('%1.18e\n ',wn) '];'];
   %     if type == 1    % lowpass
   %         dstr = [dstr sprintf('\n') ...
   %                ' [b,a] = butter(order,wn);' ];
   %         dstr1 = '[b,a] = butter(order,wn);';
   %     elseif type == 2   % highpass
   %         dstr = [dstr sprintf('\n') ...
   %                ' [b,a] = butter(order,wn,''high'');' ];
   %         dstr1 = '[b,a] = butter(order,wn,''high'');';
   %     elseif type == 3   % bandpass
   %         dstr = [dstr sprintf('\n') ...
   %                ' [b,a] = butter(order,wn);' ];
   %         dstr1 = '[b,a] = butter(order,wn);';
   %     elseif type == 4   % bandstop
   %         dstr = [dstr sprintf('\n') ...
   %                ' [b,a] = butter(order,wn,''stop'');' ];
   %         dstr1 = '[b,a] = butter(order,wn,''stop'');';
   %     end
   %     title_str = sprintf('Order %g Butterworth IIR Filter',order);
   % elseif method == 5   % chebyshev type 1
   %     wn = wn*2/Fs;
   %     dstr = [' order = ' sprintf('%g',order) ';'];
   %     dstr = [dstr sprintf('\n') ' Rp = ' sprintf('%g',Rp) ';'];
   %     dstr = [dstr sprintf('\n') ...
   %            ' wn = [' sprintf('%1.18e\n ',wn) '];'];
   %     if type == 1    % lowpass
   %         dstr = [dstr sprintf('\n') ...
   %                ' [b,a] = cheby1(order,Rp,wn);' ];
   %         dstr1 = '[b,a] = cheby1(order,Rp,wn);';
   %     elseif type == 2   % highpass
   %         dstr = [dstr sprintf('\n') ...
   %                ' [b,a] = cheby1(order,Rp,wn,''high'');' ];
   %         dstr1 = '[b,a] = cheby1(order,Rp,wn,''high'');';
   %     elseif type == 3   % bandpass
   %         dstr = [dstr sprintf('\n') ...
   %                ' [b,a] = cheby1(order,Rp,wn);' ];
   %         dstr1 = '[b,a] = cheby1(order,Rp,wn);';
   %     elseif type == 4   % bandstop
   %         dstr = [dstr sprintf('\n') ...
   %                ' [b,a] = cheby1(order,Rp,wn,''stop'');' ];
   %         dstr1 = '[b,a] = cheby1(order,Rp,wn,''stop'');';
   %     end
   %     title_str = sprintf('Order %g Chebyshev Type I IIR Filter',order);
   % elseif method == 6  % chebyshev type II
   %     wn = wn*2/Fs;
   %     dstr = [' order = ' sprintf('%g',order) ';'];
   %     dstr = [dstr sprintf('\n') ' Rs = ' sprintf('%g',Rs) ';'];
   %     dstr = [dstr sprintf('\n') ...
   %            ' wn = [' sprintf('%1.18e\n ',wn) '];'];
   %     if type == 1    % lowpass
   %        dstr = [dstr sprintf('\n') ...
   %                ' [b,a] = cheby2(order,Rs,wn);' ];
   %         dstr1 = '[b,a] = cheby2(order,Rs,wn);';
   %     elseif type == 2   % highpass
   %         dstr = [dstr sprintf('\n') ...
   %                ' [b,a] = cheby2(order,Rs,wn,''high'');' ];
   %         dstr1 = '[b,a] = cheby2(order,Rs,wn,''high'');';
   %     elseif type == 3   % bandpass
   %         dstr = [dstr sprintf('\n') ...
   %                ' [b,a] = cheby2(order,Rs,wn);' ];
   %         dstr1 = '[b,a] = cheby2(order,Rs,wn);';
   %     elseif type == 4   % bandstop
   %         dstr = [dstr sprintf('\n') ...
   %                ' [b,a] = cheby2(order,Rs,wn,''stop'');' ];
   %         dstr1 = '[b,a] = cheby2(order,Rs,wn,''stop'');';
   %     end
   %     title_str = sprintf('Order %g Chebyshev Type II IIR Filter',order);
   %elseif method == 7    % elliptic
   %     wn = wn*2/Fs;
   %     dstr = [' order = ' sprintf('%g',order) ';'];
   %     dstr = [dstr sprintf('\n') ' Rp = ' sprintf('%g',Rp) ';'];
   %     dstr = [dstr sprintf('\n') ' Rs = ' sprintf('%g',Rs) ';'];
   %     dstr = [dstr sprintf('\n') ...
   %            ' wn = [' sprintf('%1.18e\n ',wn) '];'];
   %     if type == 1    % lowpass
   %         dstr = [dstr sprintf('\n') ...
   %                ' [b,a] = ellip(order,Rp,Rs,wn);' ];
   %         dstr1 = '[b,a] =ellip(order,Rp,Rs,wn);';
   %     elseif type == 2   % highpass
   %         dstr = [dstr sprintf('\n') ...
   %                ' [b,a] = ellip(order,Rp,Rs,wn,''high'');' ];
   %        dstr1 = '[b,a] =ellip(order,Rp,Rs,wn,''high'');';
   %     elseif type == 3   % bandpass
   %         dstr = [dstr sprintf('\n') ...
   %                ' [b,a] = ellip(order,Rp,Rs,wn);' ];
   %        dstr1 = '[b,a] =ellip(order,Rp,Rs,wn);';
  %      elseif type == 4   % bandstop
  %          dstr = [dstr sprintf('\n') ...
  %                 ' [b,a] = ellip(order,Rp,Rs,wn,''stop'');' ];
  %          dstr1 = '[b,a] =ellip(order,Rp,Rs,wn,''stop'');';
  %      end
  %      title_str = sprintf('Order %g Elliptic IIR Filter',order);
  %  end

    if nargout > 0
        varargout{1} = title_str;
    end
    
    if titleFlag
        if nargout > 1
            varargout{2} = 0;
        end
        return
    end
    
    %eval(dstr1,'b=yhzfiltdes(''error'');')

    if isstr(b)   % an error or user interruption occurred!
        set(findobj(fig,'tag','designnow'),'userdata',dstr)
        title_str = b;
        errflag = 1;  % set error flag

    else
    %    ud.designstr = dstr;

        ud.num = b;
        ud.den = a;
        set(fig,'userdata',ud)

        errflag = 0;  % set error flag
    end

    if nargout > 1
        varargout{2} = errflag;
    end
%------------------------------------------------------------------------
% yhzfiltdes('help')
% Callback of help button in toolbar
case 'help'
    fig = gcf;
    ud = get(fig,'userdata');
    if ud.pointer ~= 2   % if not in help mode
        % enter help mode
        saveEnableControls = [ud.ht.FsHndl];
        ax = [ud.ht.ax1 ud.toolbar.toolbar];
        titleStr = 'Filter Designer Help';
        helpFcn = 'yhzfdhelpstr';
        yhzspthelp('enter',fig,saveEnableControls,ax,titleStr,helpFcn)
    else
        yhzspthelp('exit')
    end
    
%switch action
case 'mdown'
% -------------------------------------------------------------------------
% yhzfiltdes('mdown',whichline)
%   Mouse down function for line objects
%      whichline == 1 --> passband click
%      whichline == 2 --> stopband click
%      whichline == 3 --> click on frequency response line - pan if ud.pointer=0
%   Depending on pointer type, set up different motion and up callbacks
%
    ud = get(gcf,'userdata');
    pt = get(ud.ht.ax1,'currentpoint');

    if nargin == 1
        return
    end

    if varargin{1} == 3   % button down of frequency response line
        if ~Localjustzoom(gcf)
           switch ud.pointer    
           case 0   % panfcn  
               invis = [ud.ht.specline1 ud.ht.specline2 ud.ht.magline];
               xd = get(ud.ht.magline,'xdata');
               yd = get(ud.ht.magline,'ydata');
               n = length(yd);
               ind = floor((0:99)*n/100) + 1;
               set(ud.ht.panfcnline,'visible','on',...
                     'xdata',xd(ind),'ydata',yd(ind))
               panfcn('Ax',ud.ht.ax1,...
                      'Bounds',ud.limits,...
                      'Immediate',1,...
                      'Invisible',invis);
               set(ud.ht.panfcnline,'visible','off')
              
           case 2   % help mode - call fdhelp
               yhzspthelp('exit','response')
           end
       end
       return
    end

    switch yhzfdregion(gcf,pt(1,1:2))

    case 1   % mouse over band edge
        set(ud.ht.specline1,'erasemode','xor') 
                %set passband line's erase mode to xor
        set(ud.ht.specline2,'erasemode','xor')  % stop band
        spec = ud.specs;
        f = spec.f;
        pt = get(ud.ht.ax1,'currentpoint');   % in data units, top axes
        pt = pt(1,1:2);
        [dum,e] = min(abs(f-pt(1)));  % e is the index of the closest band edge
        set(gcf,'windowbuttonmotionfcn',['sbswitch(''yhzfdedrag'',' ...
                                              num2str(e) ')'])
        set(gcf,'windowbuttonupfcn',['sbswitch(''yhzfdedrag'',' num2str(e) ',0)'])

    case 2    % mouse over band
        if varargin{1} == 1
            set(ud.ht.specline1,'erasemode','xor') 
                %set passband line's erase mode to xor
        else
            set(ud.ht.specline2,'erasemode','xor')  % stop band
        end
        set(gcf,'windowbuttonmotionfcn',...
             ['sbswitch(''yhzfdrdrag'',' num2str(varargin{1}) ')'])
        set(gcf,'windowbuttonupfcn',...
             ['sbswitch(''yhzfdrdrag'',' num2str(varargin{1}) ',0)'])
    end
case 'error'
% -------------------------------------------------------------------------
% estr = yhzfiltdes('error')
%    catch callback for filter design - in case of error in design
%    or user interruption
%    estr returns a string describing the error
%
    varargout{1} = 'Filter design was interrupted or failed due to an error.';
  
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
function str = Localfdspecstr(spec)
%Localfdspecstr  Returns string for multi-line editbox of Filter Design tool.
%       The edit box contains band edges and ripple
 
%   Copyright (c) 1988-97 by The MathWorks, Inc.
% $Revision: 1.3 $

%       Tom Krauss, 1/19/96
%       $Revision: 1.3 $

    if spec.FType <= 2
        str = sprintf('%4.3g\n%4.3g\n\n%4.3g\n%4.3g',spec.f(1),spec.f(2),...
          spec.Rp,spec.Rs);
    else
        str = sprintf('%4.3g%s%4.3g\n%4.3g%s%4.3g\n\n%4.3g\n%4.3g',spec.f(1,1),'   ',...
          spec.f(1,2),spec.f(2,1),'   ',spec.f(2,2),...
          spec.Rp,spec.Rs); 
        %str = sprintf('%g\n%g\n%g\n%g\n\n%g\n%g',spec.f(1),spec.f(2),...
        %  spec.f(3),spec.f(4),spec.Rp,spec.Rs);
     end
     
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





