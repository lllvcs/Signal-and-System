function lszq(action,in1,in2);
%LSZQ	离散周期信号的频谱分析

%	possible actions:
%	  'start'
%	  'down'
%	  'move'
%	  'up'
%	  'redraw'
%	  'done'
%	  'setfreq'

if nargin<1,
    action='start';
end;

global lszq_DAT
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
    labelStr=' 离散周期信号';

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
    popup=uicontrol('Style','Popup','String','矩形波|正弦波|锯齿波|自定义',...
        'Position', btnPos, ...
        'BackgroundColor','w', ...
        'ForegroundColor','k', ...
        'Units','normalized',...
        'CallBack',[...
		'global lszq_DAT;',...
		'popup=lszq_DAT(9);',...
		'val = get(popup,''Value'');',...
		'if val<=3',...
		'	lszq(''redraw'');',...
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
    callbackStr= 'lszq(''setwindow'')';

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
    % The PERIOD editable text box
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
        'String','离散信号周期 N：');

    btnPos=[left+0.02  yLabelPos-labelHt-btnHt-btnOffset ...
            0.5*btnWid+frmBorder  btnHt-0.02];
    N_field = uicontrol( ...
        'Style','edit', ...
        'BackgroundColor','w', ...
        'ForegroundColor','k', ...
        'Position', btnPos, ...
        'Units','normalized', ...
        'HorizontalAlignment','left', ...
        'String','10',...
        'CallBack','lszq(''setfreq''); lszq(''redraw'')');

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
        'Callback','lszq(''delshow'');');

   %====================================
    % The INFO button
    uicontrol( ...
        'Style','push', ...
        'Units','normalized', ...
        'Position',[left bottom+(2*labelHt)+spacing btnWid 2*labelHt], ...
        'String','信息', ...
        'Callback','lszq(''info'')');

   %========================================
   % The CLOSE button
    done_button=uicontrol('Style','Pushbutton', ...
        'Position',[left bottom btnWid 2*labelHt], ...
        'Units','normalized','Callback',...
        'lszq(''done'')','String','关闭');
   %====================================

    % Create intial signal
    N=10;			% 周期
    N1=5;
    n=-N:N;
    nn=0:N-1;
    S=( nn>=0 & nn<N1 );	% 默认离散矩形波，先算出其一个周期
    Sn=[Sn Sn 1];		% 在屏幕上绘出 2 个周期信号波形，共 2N+1 个点
    SS=[];
    for i=1:8, SS=[SS S]; end	%  计算8个信号周期的 DFT

    M=1024;			% FFT 点数

    % create axes for time domain and frequency domain plot
    ax_freq=axes('Position',[.12 .14 .6 .3],'XLim',...
             [-3*pi 3*pi],'YLim',[0 1]);
    
    % time domain
    val = get(popup,'Value');
    if (val == 1),			% descrete square wave
        nn=0:N-1;
        Sn=( nn>=0 & nn<N1 );
        Sn=[Sn Sn 1];		% total 2N+1 points
    elseif (val == 2),
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
    F=fft(SS,M);
    F=abs(F)./mmax(abs(F));
    F1=[F(1:M) F(1:M/2)];
    F=[F1((3/2*M):-1:2) F1];
    w=linspace(-3*pi,3*pi,3*M-1);
    freq_line=plot(w,F,'EraseMode','xor');
    axis([-3*pi 3*pi 0 1]);
    grid;
    ylabel('幅频特性');
    xlabel('W');

    ax_time=axes('Position',[.12 .58 .6 .3],'XLim',[-N N],'YLim',[-1.1 1.1]);
    time_line=stemaxz(n,Sn);
    axis([-N N -1.1 1.1]);
    % (set to xor mode to prevent re-rendering, that is, for speed)
    grid;
    ylabel('波形 s[n]');
    xlabel('序列下标 n');

%    set(time_line,'ButtonDownFcn','lszq(''down'')');

    lszq_DAT = [N; N1; M; ax_time; ...
		time_line(:); freq_line; N_field; popup; -1; gcf];
    ADDIT_DAT = winHndl;

clear F1;

    watchoff(oldFigNumber);

elseif strcmp(action,'done'),
    % close the figure window that is showing the window fnction:
    % u = get(gcf,'userdata');

    close(gcf);
    clear global lszq_DAT
    clear global ADDIT_DAT
    clear global fun_str

elseif strcmp(action,'redraw'),
    % recomputes time and frequency waveforms and updates display
    % u = get(gcf,'userdata');
    N = lszq_DAT(1);
    N1 = lszq_DAT(2);
    M = lszq_DAT(3);
    ax_time = lszq_DAT(4);
    time_line = lszq_DAT(5:6);
    freq_line = lszq_DAT(7);
    N_field = lszq_DAT(8);
    popup = lszq_DAT(9)

    val = get(popup,'Value');

    if (val == 1),
	n=[-N:N];
        nn=0:N-1;
        Sn=( nn>=0 & nn<N1 );
        Sn=[Sn Sn 1];		% total 2N+1 points
	set(ax_time,'XLim',[-N N]);
	l=length(n);
	xx = [n;n;nan*ones(size(n))];
	yy = [zeros(1,l);Sn;nan*ones(size(Sn))];
	SS=[];
	for i=1:8, SS=[SS S]; end	%  计算8个信号周期的 DFT
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

    set(time_line(1),'XData',n,'YData',Sn);
    set(time_line(2),'XData',xx,'YData',yy);

    F=fft(SS,M);
    F=abs(F)./mmax(abs(F));
M
    F1=[F(1:M) F(1:M/2)];
    F=[F1((3/2*M):-1:2) F1];
    w=linspace(-3*pi,3*pi,3*M-1);
    set(freq_line,'YData',FF);
    set(N_field,'String',num2str(N));

clear F1
    drawnow;

elseif strcmp(action,'setwindow'),
    % u = get(gcf,'userdata');
    winHndl = ADDIT_DAT;
    in1 = get(winHndl,'Value');
    in2 = 30;
    N=lszq_DAT(3);
    show_window=lszq_DAT(14+N+N);

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

    lszq_DAT(14+N:14+N+N-1)=window;
    % set(gcf,'userdata',u);
    lszq('redraw');

    if get(show_window,'value'),
        lszq('showwin');
    end;

elseif strcmp(action,'showwin'),
    % u=get(gcf,'userdata');
    oldfig=gcf;
    N=lszq_DAT(3);
    t=lszq_DAT(14:14+N-1);
    window=lszq_DAT(14+N:14+N+N-1);

    if (lszq_DAT(12)==-1),
        lszq_DAT(12)=figure('NumberTitle','off', ...
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
			'global lszq_DAT;',...
			'lszq_DAT(12)=-1;',...
			'clear THEHAND lszq_DAT;']);

	set(gcf,'userdata',[oldfig line1 line2]);
        % set(oldfig,'userdata',u);
	clear line1 line2 W;
        
    else
	show_window=findobj('Tag','window_window');
	if isempty(show_window)
		lszq_DAT(12)=-1;
		lszq('showwin');
	else
        	figure(lszq_DAT(12));
		drawnow
        	lines=get(gcf,'userdata');
        	set(lines(2),'ydata',window);
        	W=fft(window,1024);
        	set(lines(3),'ydata',20*log10(abs(W(1:512))));
        	figure(lszq_DAT(12));
        	drawnow;
		clear W lines;
	end
	clear show_window;
    end

    clear oldfig N t window;

elseif strcmp(action,'delshow'),
    N=lszq_DAT(3);
    show_window=lszq_DAT(14+N+N);
    if ( lszq_DAT(12)~=-1 & get(show_window,'value')==0),
	show_window=findobj('Tag','window_window');
	if isempty(show_window)
	        lszq_DAT(12)=-1;
	else
		figure(show_window);
        	THEHAND=get(gcf,'userdata');
		close;
		figure(THEHAND(1));
		lszq_DAT(12)=-1;
		clear THEHAND;
    	end
    end
    clear show_window N;

elseif strcmp(action,'setfreq'),
    x = str2num(get(lszq_DAT(10),'string'));
    if isempty(x),   % handle the non-numeric case
        set(lszq_DAT(10),'string',num2str(lszq_DAT(1)));
    else
        lszq_DAT(1)=x;
    end;

elseif strcmp(action,'info'),
    ttlStr = '离散周期信号的频谱分析'; 

    hlpStr1= ...                                              
        ['          '
         '          '];

    hlpStr2= ...                                               
        [' '
         ' ' ];

     hlpStr3= str2mat(...                   
         ' ', ...
         ' 文件名：lszq.m');

     helpwin(ttlStr, hlpStr1, hlpStr2, hlpStr3);

end
