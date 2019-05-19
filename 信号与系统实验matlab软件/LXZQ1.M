function lxzq(action,in1,in2);
%LXZQ	连续周期信号的频谱分析

%	possible actions:
%	  'start'
%	  'down'
%	  'move'
%	  'up'
%	  'redraw'
%	  'done'
%	  'setfreq'
%	  'setwindow'
%	  'showwin'

if nargin<1,
    action='start';
end;

global lxzq_DAT
global fun_str
global zkb1 zkb2 zkb3

if strcmp(action,'start'),

    %====================================
    % Graphics initialization
    oldFigNumber = watchon;
    figNumber = figure;
    set(gcf, ...
        'NumberTitle','off', ...
        'Name','连续周期信号的频谱分析', ...
        'backingstore','off',...
        'Units','normalized');

    %====================================
    % Information for all buttons
    labelColor=192/255*[1 1 1];
    top=0.95;
    bottom=0.05;
    left=0.75;
    yInitLabelPos=0.90;
    left = 0.78;
    labelWid=0.18;
    labelHt=0.05;
    btnWid = 0.18;
    btnHt=0.07;
    % Spacing between the label and the button for the same command
    btnOffset=0.003;
    % Spacing between the button and the next command's label
    spacing=0.05;
 
    %====================================
    % The CONSOLE frame
    frmBorder=0.02;
    yPos=0.05-frmBorder;
    frmPos=[left-frmBorder yPos btnWid+2*frmBorder 0.9+2*frmBorder];
    h=uicontrol( ...
        'Style','frame', ...
        'Units','normalized', ...
        'Position',frmPos, ...
        'BackgroundColor',[0.5 0.5 0.5]);
    
    %====================================
    % The SIGNAL command popup button

    btnNumber=1;
    yLabelPos=top-(btnNumber-1)*(btnHt+labelHt+spacing);
    labelStr=' 信号';

    % Generic label information
    labelPos=[left yLabelPos-labelHt labelWid labelHt];
    uicontrol( ...
        'Style','text', ...
        'Units','normalized', ...
        'Position',labelPos, ...
        'BackgroundColor',labelColor, ...
        'HorizontalAlignment','left', ...
        'String',labelStr);

    btnPos=[left yLabelPos-labelHt-btnHt-btnOffset btnWid btnHt];
    popup=uicontrol('Style','Popup','String','正弦波|矩形波|锯齿波|自定义',...
        'Position', btnPos, ...
        'BackgroundColor','w', ...
        'ForegroundColor','k', ...
        'Units','normalized',...
        'CallBack',[...
		'global lxzq_DAT zkb1 zkb2 zkb3;',...
		'popup=lxzq_DAT(10);',...
		'val = get(popup,''Value'');',...
		'if val == 2', ...
		'   set(zkb1,''Visible'',''on'');', ...
		'   set(zkb2,''Visible'',''on'');', ...
		'   set(zkb3,''Visible'',''on'');', ...
		'   lxzq(''redraw'');',...
		'else,', ...
		'   set(zkb1,''Visible'',''off'');', ...
		'   set(zkb2,''Visible'',''off'');', ...
		'   set(zkb3,''Visible'',''off'');', ...
		'   if val==1 | val==3,',...
		'      lxzq(''redraw'');',...
		'   else,',...
		'      getsig;',... % 输入对话框
		'   end,', ...
		'end;']);


    %====================================
    % 矩形波占空比
    btnNumber=2;
    yLabelPos=top-(btnNumber-1)*(btnHt+labelHt+spacing);
    labelStr=' 占空比';

    % Generic label information
    labelPos=[left yLabelPos-labelHt labelWid-0.09 labelHt];
    zkb1 = uicontrol( ...
        'Style','text', ...
        'Units','normalized', ...
        'Position',labelPos, ...
        'BackgroundColor',labelColor, ...
        'HorizontalAlignment','left', ...
	'Visible','off', ...
        'String',labelStr);

    % Generic slider button information
    btnPos=[left yLabelPos-labelHt-btnHt-btnOffset btnWid btnHt-0.02];
    zkb2 = uicontrol( ...
        'Style','slider', ...
        'Units','normalized', ...
        'BackgroundColor','w', ...
        'ForegroundColor','k', ...
        'Position',btnPos, ...
	'value',0.5,'Min',0.05,'Max',0.95, ...
	'visible','off',...
        'Callback','lxzq(''setzkb2'')');

    editPos=[left+0.095 yLabelPos-labelHt labelWid-0.09 labelHt];
    zkb3 = uicontrol( ...
        'Style','edit', ...
        'Units','normalized', ...
        'Position',editPos, ...
        'BackgroundColor','w', ...
        'HorizontalAlignment','left', ...
	'Visible','off', ...
        'String','0.5', ...
	'callback','lxzq(''setzkb3'')');

  %====================================
    % The FUNDAMENTAL editable text box
    btnNumber=3;
    yLabelPos=top-(btnNumber-1)*(btnHt+labelHt+spacing);
    labelPos=[left yLabelPos-labelHt labelWid+0.02 labelHt];
    freq_text = uicontrol( ...
        'Style','text', ...
        'Position', labelPos, ...
        'Units','normalized', ...
        'BackgroundColor',[0.5 0.5 0.5], ...
        'ForegroundColor','w', ...
        'HorizontalAlignment','left', ...
        'String','基波频率：(Hz)');

    btnPos=[left+0.02  yLabelPos-labelHt-btnHt-btnOffset ...
            0.5*btnWid+frmBorder  btnHt];
    freq_field = uicontrol( ...
        'Style','edit', ...
        'BackgroundColor','w', ...
        'ForegroundColor','k', ...
        'Position', btnPos, ...
        'Units','normalized', ...
        'HorizontalAlignment','left', ...
        'String','5',...
        'CallBack','lxzq(''setfreq''); lxzq(''redraw'')');

   %====================================
    % The INFO button
    uicontrol( ...
        'Style','push', ...
        'Units','normalized', ...
        'Position',[left bottom+(2*labelHt)+spacing btnWid 2*labelHt], ...
        'String','信息', ...
        'Callback','lxzq(''info'')');

   %========================================
   % The CLOSE button
    done_button=uicontrol('Style','Pushbutton', ...
        'Position',[left bottom btnWid 2*labelHt], ...
        'Units','normalized','Callback',...
        'lxzq(''done'')','String','关闭');

   %====================================
   % Create intial signal
    N=200;     % number of samples
    amp=0.5;
    freq=5;    % hertz
    t0=0;      % seconds
    t1=1;      % seconds
    t=linspace(t0,t1,N)';
    T=(t1-t0)/N;            % sampling rate in seconds
    M=256;     % length of fft
    window=ones(N,1);    % use window to lower side-lobes in the freq. domain
                             % (makes peaks wider)
    ratio = 0.5;	% 矩形波占空比

    % create axes for time domain and frequency domain plot
    ax_freq=axes('Position',[.12 .14 .6 .3],'XLim',...
             [0 1/(2*T)],'YLim',[0 1]);
    
    % time domain
    val = get(popup,'Value');
    if (val == 1),
        f=amp*sin(freq*t*2*pi);
    elseif (val == 2),   % square wave
        tt=freq*t*2*pi;
        tmp=rem(tt,2*pi);
        f1=amp*(2*rem((tt<0)+(tmp>2*ratio*pi | tmp<-2*ratio*pi)+1,2)-1);
        f=f1+1;
    elseif (val == 3),   % sawtooth
        tt=freq*t*2*pi;
        f=amp*((tt < 0) + rem(tt,2*pi)/2/pi - .5)*2;
    elseif (val == 4),   % self-defined waveform
        f=eval(fun_str);
    end;

    % frequency domain
    F=fft(window.*f,2*M);
    F=F(1:M);
    w=(0:M-1)*pi/M;
    FF=abs(F);
    FF=FF*2;
    FF(1)=FF(1)/2;
    FF(M)=FF(M)/2;
    FF=FF/length(f);
    freq_line=plot(w/2/pi/T,FF,'EraseMode','xor');
    axis([0 1/(2*T)  0 1]);
    grid;
    ylabel('幅频特性');
    xlabel('频率 (Hz)');

    ax_time=axes('Position',[.12 .58 .6 .3],'XLim',[t0 t1],'YLim',[-1 1]);
    time_line=plot(t,f,'-','markersize',8,'EraseMode','xor');
    axis([t0 t1 -1 1]);
    % (set to xor mode to prevent re-rendering, that is, for speed)
    grid;
    ylabel('波形');
    xlabel('时间（秒）');
    text(0.05, 1.55,'点击并拖放信号波形以改变其基频与振幅。');

    set(time_line,'ButtonDownFcn','lxzq(''down'')');

    lxzq_DAT = [freq; amp; N; M; 0; 0; ...
		time_line; freq_line; freq_field; popup; -1; gcf; ...
		t(:); window(:); ratio];

    watchoff(oldFigNumber);

elseif strcmp(action,'down'),

  popup=lxzq_DAT(10);
  val = get(popup,'value');
  if val<=3
    % assumes that a line was clicked
    time_line=lxzq_DAT(7);
    axes(get(time_line,'parent'));	% set the right axes

    % Obtain coordinates of mouse click location in axes units
    pt=get(gca,'currentpoint');
    x=pt(1,1);
    y=pt(1,2);


% find closest vertex of line to mouse click location (call it fixed_x, fixed_y)

    line_x=get(time_line,'XData');
    line_y=get(time_line,'YData');
    units_str = get(gca,'units');  % save normalized state
    set(gca,'units','pixels');     % distance must be in pixels
    p=get(gca,'pos');
    xa=get(gca,'xlim');
    ya=get(gca,'ylim');
    
    dist=((line_x-x)*p(3)/(xa(2)-xa(1))).^2 + ...
         ((line_y-y)*p(4)/(ya(2)-ya(1))).^2;
    [temp,i]=min(dist);
    fixed_x=line_x(i);
    fixed_y=line_y(i);
    set(time_line,'LineStyle','-');

    lxzq_DAT(5)=fixed_x;
    lxzq_DAT(6)=fixed_y;

    set(gca,'units',units_str );
    set(gcf,'WindowButtonMotionFcn', 'lxzq(''move'')');
    set(gcf,'WindowButtonUpFcn', 'lxzq(''up'')');
    % set(gcf,'userdata',u);
end

elseif strcmp(action,'move'),
    % u = get(gcf,'userdata');
    freq=lxzq_DAT(1);
    amp=lxzq_DAT(2);
    N=lxzq_DAT(3);
    M=lxzq_DAT(4);
    fixed_x=lxzq_DAT(5);
    fixed_y=lxzq_DAT(6);
    time_line=lxzq_DAT(7);
    freq_line=lxzq_DAT(8);
    freq_field=lxzq_DAT(9);
    popup=lxzq_DAT(10);
    t=lxzq_DAT(13:13+N-1);
    window=lxzq_DAT(13+N:13+N+N-1);
    ratio = lxzq_DAT(13+N+N);

    pt=get(gca,'currentpoint');
    x=pt(1,1);
    y=pt(1,2);

    amp1=y/fixed_y*amp;
    if (abs(amp1)>1.0),
       amp1=1.0*sign(amp1);
    end;
    if (abs(amp1)<0.05),
       amp1=0.05*sign(amp1);
    end;
    if (amp1 == 0),
        amp1=0.05;
    end;
    freq1=fixed_x/x*freq;
    if freq1<0, freq1=0.01; elseif freq1>100, freq1=100; end;
    val = get(popup,'Value');
    if (val == 1),
        f=amp1*sin(freq1*t*2*pi);
    elseif (val == 2),   % square wave
        tt=freq1*t*2*pi;
        tmp=rem(tt,2*pi);
        f1=amp1*(2*rem((tt<0)+(tmp>2*ratio*pi | tmp<-2*ratio*pi)+1,2)-1);
        f=f1+amp;
    elseif (val == 3),   % sawtooth
        tt=freq1*t*2*pi;
        f=amp1*((tt < 0) + rem(tt,2*pi)/2/pi - .5)*2;
    end;
    set(time_line,'YData',f);
    F=fft(window.*f,2*M);
    F=F(1:M);
    w=(0:M-1)*pi/M;
    FF=abs(F);
    FF=FF*2;
    FF(1)=FF(1)/2;
    FF(M)=FF(M)/2;
    FF=FF/length(f);
    set(freq_line,'YData',FF);
    set(freq_field,'String',num2str(freq1));

elseif strcmp(action,'up'),
    pt=get(gca,'currentpoint');
    x=pt(1,1);
    y=pt(1,2);

    set(gcf,'WindowButtonMotionFcn','');
    set(gcf,'WindowButtonUpFcn','');

    % u=get(gcf,'userdata');
    freq=lxzq_DAT(1);
    amp=lxzq_DAT(2);
    fixed_x=lxzq_DAT(5);
    fixed_y=lxzq_DAT(6);

    amp1=y/fixed_y*amp;
    if (abs(amp1)>1.0),
       amp1=1.0*sign(amp1);
    end;
    if (abs(amp1)<0.05),
       amp1=0.05*sign(amp1);
    end;
    freq1=fixed_x/x*freq;
    if freq1<0, freq1=0.01; elseif freq1>100, freq1=100; end;

    set(lxzq_DAT(8),'linestyle','-','markersize',8);
    lxzq_DAT(1)=freq1;  % set amplitude and frequency
    lxzq_DAT(2)=amp1;
    % set(gcf,'userdata',u);
    lxzq('redraw');

elseif strcmp(action,'done'),
    % close the figure window that is showing the window fnction:
    % u = get(gcf,'userdata');
    show_window=findobj('Tag','window_window');
    if ( ~isempty(show_window) & lxzq_DAT(11)~=-1 )
    	close(lxzq_DAT(11));
    end;
    close(gcf);
    clear global lxzq_DAT
    clear global ADDIT_DAT
    clear global fun_str
    clear show_window

elseif strcmp(action,'redraw'),
    % recomputes time and frequency waveforms and updates display
    % u = get(gcf,'userdata');
    freq=lxzq_DAT(1);
    amp=lxzq_DAT(2);
    N=lxzq_DAT(3);
    M=lxzq_DAT(4);
    time_line=lxzq_DAT(7);
    freq_line=lxzq_DAT(8);
    freq_field=lxzq_DAT(9);
    popup=lxzq_DAT(10);
    t=lxzq_DAT(13:13+N-1);
    ratio = lxzq_DAT(13+N+N);

    window=lxzq_DAT(13+N:13+N+N-1);
    val = get(popup,'Value');
    if (val == 1),
        f=amp*sin(freq*t*2*pi);
    elseif (val == 2),   % square wave
        tt=freq*t*2*pi;
        tmp=rem(tt,2*pi);
        f1=amp*(2*rem((tt<0)+(tmp>2*ratio*pi | tmp<-2*ratio*pi)+1,2)-1);
       f=f1+amp;
       f=1;
    elseif (val == 3),   % sawtooth
        tt=freq*t*2*pi;
        f=amp*((tt < 0) + rem(tt,2*pi)/2/pi - .5)*2;
    elseif (val == 4),   % self-defined waveform
	f=eval(fun_str);
    end;
    set(time_line,'YData',f);
    F=fft(window.*f,2*M);
    F=F(1:M);
    w=(0:M-1)*pi/M;
    FF=abs(F);
    FF=FF*2;
    FF(1)=FF(1)/2;
    FF(M)=FF(M)/2;
    FF=FF/length(f);
    set(freq_line,'YData',FF);
    set(freq_field,'String',num2str(freq));

    drawnow;

elseif strcmp(action,'setfreq'),
    x = str2num(get(lxzq_DAT(9),'string'));
    if isempty(x),   % handle the non-numeric case
        set(lxzq_DAT(9),'string',num2str(lxzq_DAT(1)));
    else,
	if ( x>=0 & x<=100 ),
	        lxzq_DAT(1)=x;
	else,
		set(lxzq_DAT(9),'string',num2str(lxzq_DAT(1)));
	end;
    end;

elseif strcmp(action,'setzkb2'),
    N=lxzq_DAT(3);
    r = get(zkb2,'value');
    lxzq_DAT(13+N+N) = r;
    set(zkb3,'string',num2str(r));
    lxzq('redraw');

elseif strcmp(action,'setzkb3'),
    N=lxzq_DAT(3);
    r = str2num(get(zkb3,'string'));
    if isempty(r),
       set(zkb3,'string',num2str(lxzq_DAT(13+N+N)));
    else,
       if ( r>=0.05 & r<=0.95 ),
          lxzq_DAT(13+N+N) = r;
          set(zkb2,'value',r);
          lxzq('redraw');
       else,
          set(zkb3,'string',num2str(lxzq_DAT(13+N+N)));
       end;
    end;

elseif strcmp(action,'info'),
    ttlStr = '连续周期信号的频谱分析'; 

    hlpStr1= ...                                              
        ['         '
         '         '];

    hlpStr2= ...                                               
        ['    '
         '    ' ];

     hlpStr3= str2mat(...                   
         ' ', ...
         ' 文件名：lxzq.m');

     helpwin(ttlStr, hlpStr1, hlpStr2, hlpStr3);

end
