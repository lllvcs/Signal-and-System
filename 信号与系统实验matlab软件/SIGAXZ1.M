function sigaxz1(action,in1,in2);
%SIGAXZ1 交互式信号演示 - 1 : 信号的 DFT
%	Illustrating some basic signal processing concepts, such as 
%	sampling, aliasing, and windowing.

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

global SIGAXZ1_DAT
global ADDIT_DAT	% this is for WINDOW pop-up button
global fun_str

if strcmp(action,'start'),

    %====================================
    % Graphics initialization
    oldFigNumber = watchon;
    figNumber = figure;
    set(gcf, ...
        'NumberTitle','off', ...
        'Name','离散傅立叶变换', ...
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
		'global SIGAXZ1_DAT;',...
		'popup=SIGAXZ1_DAT(11);',...
		'val = get(popup,''Value'');',...
		'if val<=3',...
		'	sigaxz1(''redraw'');',...
		'else',...
		'	getstr;',...
		'end']);

    %====================================
    % The WINDOW command popup button
    btnNumber=2;
    yLabelPos=top-(btnNumber-1)*(btnHt+labelHt+spacing);
    labelStr=' 窗口函数';
    popupStr= '矩形|三角形|汉宁|海明';
    if ~isstudent
        popupStr= [popupStr '|切比雪夫|恺撒'];
    end
    callbackStr= 'sigaxz1(''setwindow'')';

    % Generic label information
    labelPos=[left yLabelPos-labelHt labelWid labelHt];
    uicontrol( ...
        'Style','text', ...
        'Units','normalized', ...
        'Position',labelPos, ...
        'BackgroundColor',labelColor, ...
        'HorizontalAlignment','left', ...
        'String',labelStr);

    % Generic popup button information
    btnPos=[left yLabelPos-labelHt-btnHt-btnOffset btnWid btnHt];
    winHndl = uicontrol( ...
        'Style','popup', ...
        'Units','normalized', ...
        'BackgroundColor','w', ...
        'ForegroundColor','k', ...
        'Position',btnPos, ...
        'String',popupStr, ...
	'visible','on',...
        'Callback',callbackStr);

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
        'CallBack','sigaxz1(''setfreq''); sigaxz1(''redraw'')');

   %====================================
    % The Show Window CheckBox
    show_window=uicontrol(gcf, ...
        'Style','checkbox', ...
        'Units','normalized',...
	'Position',[left yLabelPos-labelHt*4.5 labelWid+0.02 labelHt],...
	'backgroundcolor',[0.5 0.5 0.5],...
	'foregroundcolor','w',...
        'HorizontalAlignment','left', ...
        'string','显示窗口函数',...
	'value',0,...
        'Callback','sigaxz1(''delshow'');');

   %====================================
    % The INFO button
    uicontrol( ...
        'Style','push', ...
        'Units','normalized', ...
        'Position',[left bottom+(2*labelHt)+spacing btnWid 2*labelHt], ...
        'String','信息', ...
        'Callback','sigaxz1(''info'')');

   %========================================
   % The CLOSE button
    done_button=uicontrol('Style','Pushbutton', ...
        'Position',[left bottom btnWid 2*labelHt], ...
        'Units','normalized','Callback',...
        'sigaxz1(''done'')','String','关闭');
   %====================================

    % Create intial signal
    N=201;     % number of samples
%    N=21;
    amp=0.5;
    freq=5;    % hertz
    t0=0;      % seconds
    t1=1;      % seconds
    t=linspace(t0,t1,N)';
    T=(t1-t0)/N;            % sampling rate in seconds
    M=256;     % length of fft
    window=ones(N,1);    % use window to lower side-lobes in the freq. domain
                             % (makes peaks wider)

    min_dB = -40; % freq. domain lower axis limit

    % create axes for time domain and frequency domain plot
    ax_freq=axes('Position',[.12 .14 .6 .3],'XLim',...
             [0 1/(2*T)],'YLim',[min_dB 50]);
    
    % time domain
    val = get(popup,'Value');
    if (val == 1),
        f=amp*sin(freq*t*2*pi);
    elseif (val == 2),   % square wave
        tt=freq*t*2*pi;
        tmp=rem(tt,2*pi);
        f=amp*(2*rem((tt<0)+(tmp>pi | tmp<-pi)+1,2)-1);
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
    FF=20*log10(abs(F));
    ind=find(FF<min_dB);
    FF(ind)=NaN*ones(size(ind)); % put NaN's in where
         % min_dB shows up - this is to work around no clipping in xor mode
    freq_line=plot(w/2/pi/T,FF,'EraseMode','xor');
    axis([0 1/(2*T)  min_dB 50]);
    grid;
    ylabel('幅度 (dB)');
    xlabel('频率 (Hz)');

    ax_time=axes('Position',[.12 .58 .6 .3],'XLim',[t0 t1],'YLim',[-1 1]);
    time_line=plot(t,f,'-','markersize',8,'EraseMode','xor');
    axis([t0 t1 -1 1]);
    % (set to xor mode to prevent re-rendering, that is, for speed)
    grid;
    ylabel('波形');
    xlabel('时间（秒）');
    text(0.05, 1.55,'点击并拖放信号波形以改变其基频与振幅。');

    set(time_line,'ButtonDownFcn','sigaxz1(''down'')');

    SIGAXZ1_DAT = [freq; amp; N; M; min_dB; 0; 0; ...
		time_line; freq_line; freq_field; popup; -1; gcf; ...
		t(:); window(:); show_window];
    ADDIT_DAT = winHndl;

    watchoff(oldFigNumber);

elseif strcmp(action,'down'),

  popup=SIGAXZ1_DAT(11);
  val = get(popup,'value');
  if val<=3
    % assumes that a line was clicked
    time_line=SIGAXZ1_DAT(8);
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
    set(time_line,'LineStyle',':');

    SIGAXZ1_DAT(6)=fixed_x;
    SIGAXZ1_DAT(7)=fixed_y;

    set(gca,'units',units_str );
    set(gcf,'WindowButtonMotionFcn', 'sigaxz1(''move'')');
    set(gcf,'WindowButtonUpFcn', 'sigaxz1(''up'')');
    % set(gcf,'userdata',u);
end

elseif strcmp(action,'move'),
    % u = get(gcf,'userdata');
    freq=SIGAXZ1_DAT(1);
    amp=SIGAXZ1_DAT(2);
    N=SIGAXZ1_DAT(3);
    M=SIGAXZ1_DAT(4);
    min_dB=SIGAXZ1_DAT(5);
    fixed_x=SIGAXZ1_DAT(6);
    fixed_y=SIGAXZ1_DAT(7);
    time_line=SIGAXZ1_DAT(8);
    freq_line=SIGAXZ1_DAT(9);
    freq_field=SIGAXZ1_DAT(10);
    popup=SIGAXZ1_DAT(11);
    t=SIGAXZ1_DAT(14:14+N-1);
    window=SIGAXZ1_DAT(14+N:14+N+N-1);

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

    val = get(popup,'Value');
    if (val == 1),
        f=amp1*sin(freq1*t*2*pi);
    elseif (val == 2),   % square wave
        tt=freq1*t*2*pi;
        tmp=rem(tt,2*pi);
        f=amp1*(2*rem((tt<0)+(tmp>pi | tmp<-pi)+1,2)-1);
    elseif (val == 3),   % sawtooth
        tt=freq1*t*2*pi;
        f=amp1*((tt < 0) + rem(tt,2*pi)/2/pi - .5)*2;
    end;
    set(time_line,'YData',f);
    F=fft(window.*f,2*M);
    F=F(1:M);
    w=(0:M-1)*pi/M;
    FF=20*log10(abs(F));
    ind=find(FF<min_dB);
    FF(ind)=NaN*ones(size(ind)); % put NaN's in where
             % min_dB shows up - this is to work around no clipping in xor mode
    set(freq_line,'YData',FF);
    set(freq_field,'String',num2str(freq1));

elseif strcmp(action,'up'),
    pt=get(gca,'currentpoint');
    x=pt(1,1);
    y=pt(1,2);

    set(gcf,'WindowButtonMotionFcn','');
    set(gcf,'WindowButtonUpFcn','');

    % u=get(gcf,'userdata');
    freq=SIGAXZ1_DAT(1);
    amp=SIGAXZ1_DAT(2);
    fixed_x=SIGAXZ1_DAT(6);
    fixed_y=SIGAXZ1_DAT(7);

    amp1=y/fixed_y*amp;
    if (abs(amp1)>1.0),
       amp1=1.0*sign(amp1);
    end;
    if (abs(amp1)<0.05),
       amp1=0.05*sign(amp1);
    end;
    freq1=fixed_x/x*freq;

    set(SIGAXZ1_DAT(8),'linestyle','-','markersize',8);
    SIGAXZ1_DAT(1)=freq1;  % set amplitude and frequency
    SIGAXZ1_DAT(2)=amp1;
    % set(gcf,'userdata',u);
    sigaxz1('redraw');

elseif strcmp(action,'done'),
    % close the figure window that is showing the window fnction:
    % u = get(gcf,'userdata');
    show_window=findobj('Tag','window_window');
    if ( ~isempty(show_window) & SIGAXZ1_DAT(12)~=-1 )
    	close(SIGAXZ1_DAT(12));
    end;
    close(gcf);
    clear global SIGAXZ1_DAT
    clear global ADDIT_DAT
    clear global fun_str
    clear show_window

elseif strcmp(action,'redraw'),
    % recomputes time and frequency waveforms and updates display
    % u = get(gcf,'userdata');
    freq=SIGAXZ1_DAT(1);
    amp=SIGAXZ1_DAT(2);
    N=SIGAXZ1_DAT(3);
    M=SIGAXZ1_DAT(4);
    min_dB=SIGAXZ1_DAT(5);
    time_line=SIGAXZ1_DAT(8);
    freq_line=SIGAXZ1_DAT(9);
    freq_field=SIGAXZ1_DAT(10);
    popup=SIGAXZ1_DAT(11);
    t=SIGAXZ1_DAT(14:14+N-1);
    window=SIGAXZ1_DAT(14+N:14+N+N-1);
    val = get(popup,'Value');
    if (val == 1),
        f=amp*sin(freq*t*2*pi);
    elseif (val == 2),   % square wave
        tt=freq*t*2*pi;
        tmp=rem(tt,2*pi);
        f=amp*(2*rem((tt<0)+(tmp>pi | tmp<-pi)+1,2)-1);
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
    FF=20*log10(abs(F));
    ind=find(FF<min_dB);
    FF(ind)=NaN*ones(size(ind)); % put NaN's in where
             % min_dB shows up - this is to work around no clipping in xor mode
    set(freq_line,'YData',FF);
    set(freq_field,'String',num2str(freq));

    drawnow;

elseif strcmp(action,'setwindow'),
    % u = get(gcf,'userdata');
    winHndl = ADDIT_DAT;
    in1 = get(winHndl,'Value');
    in2 = 30;
    N=SIGAXZ1_DAT(3);
    show_window=SIGAXZ1_DAT(14+N+N);

    if (in1==1),
        window = boxcar(N);
    elseif (in1==2),
        window = triang(N);
    elseif (in1==3),
        window = hanning(N);
    elseif (in1==4),
        window = hamming(N);
    elseif (in1==5),
        window = chebwin(N,30);
    elseif (in1==6),
        window = kaiser(N,4);
    end;

    SIGAXZ1_DAT(14+N:14+N+N-1)=window;
    % set(gcf,'userdata',u);
    sigaxz1('redraw');

    if get(show_window,'value'),
        sigaxz1('showwin');
    end;

elseif strcmp(action,'showwin'),
    % u=get(gcf,'userdata');
    oldfig=gcf;
    N=SIGAXZ1_DAT(3);
    t=SIGAXZ1_DAT(14:14+N-1);
    window=SIGAXZ1_DAT(14+N:14+N+N-1);

    if (SIGAXZ1_DAT(12)==-1),
        SIGAXZ1_DAT(12)=figure('NumberTitle','off', ...
			'Name','窗口', 'menubar','none',...
			'Tag','window_window');

        axes('Position',[.15 .62 .8 .3]);
        line1=plot(t,window); 
        title('窗口函数');
        xlabel('时间（秒）');
        grid;
        ylabel('窗口');

        axes('Position',[.15 .2 .8 .3]);
        W=fft(window,1024);
        line2=plot((0:(1/1024):(.5-(1/1024)))*N,20*log10(abs(W(1:512)))); 
        set(gca,'xlim',[0 N/2]);
        xlabel('频率 (Hz)');
        ylabel('幅度 (dB)');
        grid;

        windclose=uicontrol('Style','Pushbutton',...
		'Position',[.85 .02 .12 .08],...
		'Units','normalized',...
		'String','关闭',...
		'Callback',[...
			'THEHAND=get(gcf,''userdata'');',...
			'close;',...
			'figure(THEHAND(1));',...
			'global SIGAXZ1_DAT;',...
			'SIGAXZ1_DAT(12)=-1;',...
			'clear THEHAND SIGAXZ1_DAT;']);

	set(gcf,'userdata',[oldfig line1 line2]);
        % set(oldfig,'userdata',u);
	clear line1 line2 W;
        
    else
	show_window=findobj('Tag','window_window');
	if isempty(show_window)
		SIGAXZ1_DAT(12)=-1;
		sigaxz1('showwin');
	else
        	figure(SIGAXZ1_DAT(12));
		drawnow
        	lines=get(gcf,'userdata');
        	set(lines(2),'ydata',window);
        	W=fft(window,1024);
        	set(lines(3),'ydata',20*log10(abs(W(1:512))));
        	figure(SIGAXZ1_DAT(12));
        	drawnow;
		clear W lines;
	end
	clear show_window;
    end

    clear oldfig N t window;

elseif strcmp(action,'delshow'),
    N=SIGAXZ1_DAT(3);
    show_window=SIGAXZ1_DAT(14+N+N);
    if ( SIGAXZ1_DAT(12)~=-1 & get(show_window,'value')==0),
	show_window=findobj('Tag','window_window');
	if isempty(show_window)
	        SIGAXZ1_DAT(12)=-1;
	else
		figure(show_window);
        	THEHAND=get(gcf,'userdata');
		close;
		figure(THEHAND(1));
		SIGAXZ1_DAT(12)=-1;
		clear THEHAND;
    	end
    end
    clear show_window N;

elseif strcmp(action,'setfreq'),
    x = str2num(get(SIGAXZ1_DAT(10),'string'));
    if isempty(x),   % handle the non-numeric case
        set(SIGAXZ1_DAT(10),'string',num2str(SIGAXZ1_DAT(1)));
    else
        SIGAXZ1_DAT(1)=x;
    end;

elseif strcmp(action,'info'),
    ttlStr = '离散傅立叶变换（DFT）'; 

    hlpStr1= ...                                              
        ['                                                '
         ' 我们看到，在演示窗口中，上方的图表示了对一个周 '
	 ' 期信号波形的离散抽样（抽样频率 Fs = 200 Hz）； '  
         ' 下方的图给出了该离散信号的离散傅立叶变换（DFT）'  
         ' 的绝对值。DFT的值由快速傅立叶变换算法（FFT）得 '  
         ' 到。                                           '  
         '                                                '  
         ' 注意：下图中，频率范围是从 0 到 100 Hz。处于负 '  
         ' 频域的 DFT 是正频域 DFT 的镜象，故在此只画出了 '  
         ' 正频域的 DFT。抽样频率是 200Hz，这意味着“奈奎 '  
         ' 斯特”频率是 100Hz。在高于“奈奎斯特”频率的频 '  
         ' 率点处的 DFT 与在低频（负频域）处的DFT相同。   '  
         '                                                '];

    hlpStr2= ...                                               
        ['                                                '
	 ' 在上图中，点击并拖动信号波形上的任意一点，这样 '  
         ' 可以设置信号的新的基频与幅度。                 '  
         '                                                '  
         ' 选择下拉式菜单“信号”可改变信号的波形。       '  
         '                                                '  
         ' 菜单“窗口”让你选择一个窗口函数，在对信号进行 '  
         ' DFT 以前，这个窗口将与信号波形相乘——即       '  
         ' “开窗截取”。                                 '  
         '                                                '  
         ' 检查框“显示窗口函数”若被选中，则在显示信号波 '
         ' 形和其DFT的同时，也显示出窗口函数的形状。      '  
         '                                                '  
         ' 左边的文本框给出了信号的基频，可以通过用鼠标点 '  
         ' 击此文本框，然后编辑频率值的大小，再回车来改变 '  
         ' 信号的基频。                                   ' ];

     hlpStr3= str2mat(...                   
         ' ', ...
         ' 文件名：sigaxz1.m');

     helpwin(ttlStr, hlpStr1, hlpStr2, hlpStr3);

end
