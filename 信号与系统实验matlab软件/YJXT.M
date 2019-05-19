function yjxt(action,in1,in2);
%yjxt 系统特性演示 - 1 : 一阶系统
%	Illustrating some basic signal processing concepts, such as 
%	sampling, aliasing, and windowing.

%	possible actions:
%	  'start'
%	  'down'
%	  'move'
%	  'up'
%	  'redraw'
%	  'done'
%	  'setR'
%	  'setwindow'
%	  'showwin'

if nargin<1,
    action='start';
end;

global yjxt_DAT
global ADDIT_DAT	% this is for WINDOW pop-up button
global fun_str

if strcmp(action,'start'),

    %====================================
    % Graphics initialization
    oldFigNumber = watchon;
    figNumber = figure;
    set(gcf, ...
        'NumberTitle','off', ...
        'Name','一阶系统特性', ...
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
    labelStr='一阶系统 ';

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
    popup=uicontrol('Style','Popup','String','一阶低通|一阶高通|',...
        'Position', btnPos, ...
        'BackgroundColor','w', ...
        'ForegroundColor','k', ...
        'Units','normalized',...
        'CallBack',[...
		'global yjxt_DAT;',...
		'popup=yjxt_DAT(11);',...
		'val = get(popup,''Value'');',...
		'if val<=3',...
		'	yjxt(''redraw'');',...
		'else',...
		'	getstr;',...
		'end']);

    %====================================
    % The WINDOW command popup button
   
    winHndl=0;
    % Generic label information
    

    % Generic popup button information
  
  %====================================
    % The FUNDAMENTAL editable text box
    btnNumber=2;
    yLabelPos=top-(btnNumber-1)*(btnHt+labelHt+spacing);
    labelPos=[left yLabelPos-labelHt-0.15 labelWid+0.02 labelHt];
    freq_text = uicontrol( ...
        'Style','text', ...
        'Position', labelPos, ...
        'Units','normalized', ...
        'BackgroundColor',[0.5 0.5 0.5], ...
        'ForegroundColor','w', ...
        'HorizontalAlignment','left', ...
        'String','时间常数(t)：');

    btnPos=[left+0.02  yLabelPos-labelHt-btnHt-btnOffset-0.15 ...
            0.5*btnWid+frmBorder  btnHt];
    R_field = uicontrol( ...
        'Style','edit', ...
        'BackgroundColor','w', ...
        'ForegroundColor','k', ...
        'Position', btnPos, ...
        'Units','normalized', ...
        'HorizontalAlignment','left', ...
        'String','10',...
        'CallBack','yjxt(''settime''); yjxt(''redraw'')');

   %====================================
    % The Show Window CheckBox
    
    
   %====================================
    % The INFO button
    uicontrol( ...
        'Style','push', ...
        'Units','normalized', ...
        'Position',[left bottom+(2*labelHt)+spacing btnWid 2*labelHt], ...
        'String','信息', ...
        'Callback','yjxt(''info'')');

   %========================================
   % The CLOSE button
    done_button=uicontrol('Style','Pushbutton', ...
        'Position',[left bottom btnWid 2*labelHt], ...
        'Units','normalized','Callback',...
        'yjxt(''done'')','String','关闭');
   %====================================

    % Create intial signal
    N=512;     % number of samples
%    N=21;
    C=1;
R=10;    % hertz
t=R*C;
    %t0=-10;      % seconds
    %t1=10;      % seconds
    t1=logspace(-3,5);
    %T=(t1-t0)/N;
    %ws=2*pi./T;            % sampling rate in seconds
    M=512;     % length of fft
    %window=ones(N,1);    % use window to lower side-lobes in the freq. domain
                             % (makes peaks wider)

    %C_field=0; % freq. domain lower axis limit
    %w=ws*(1:N/2)/N;
    %w2=ws*(-(0:N/2-1))/N;
    % create axes for time domain and frequency domain plot
     ax_pha=axes('Position',[.12 .14 .6 .3],'XLim',...
             [1e-3,1e5],'YLim',[-4 4]);

    % time domain
    val = get(popup,'Value');
    %if(freq<0.05)freq=0.05;end
     %if(freq>0.95)freq=0.95;end
      %if(amp>1.0)amp=1.0;end
    if (val == 1),
       num=[0 1];den=[t 1];
[m,p]=bode(num,den,w);
subplot(211),semilogx(w,20*log10(m));
subplot(212),semilogx(w,p); 
     
    elseif (val == 2),   % square wave
 num=[t 0];den=[t 1];
[m,p]=bode(num,den,w);
subplot(211),semilogx(w,20*log10(m));
subplot(212),semilogx(w,p); 
           
   end;
pha_line= semilogx(w,p, '-','markersize',8,'EraseMode','xor');
      axis([1e-3 1e5 -4 4]);

    grid;
    ylabel('相频特性');
    xlabel('频率 (Hz)');

    ax_amp=axes('Position',[.12 .58 .6 .3],'XLim',[1e-3 1e5],'YLim',[-80 0]);
    amp_line= semilogx(w,20*log10(m),'-','markersize',8,'EraseMode','xor');
      axis([1e-3 1e5 -80 0]);
    % (set to xor mode to prevent re-rendering, that is, for speed)
    grid;
    ylabel('幅频特性');
    xlabel('频率 (Hz)');
    text(-7.55, 1.25,'点击并拖放信号波形以改变其基频与振幅。');

    set(amp_line,'ButtonDownFcn','yjxt(''down'')');

    yjxt_DAT = [R; C; N; M; C_field; 0; 0; ...
		amp_line; pha_line; R_field; popup; -1; gcf; ...
		t(:); window(:); 0];
    ADDIT_DAT = winHndl;

    watchoff(oldFigNumber);

elseif strcmp(action,'down'),

  popup=yjxt_DAT(11);
  val = get(popup,'value');
  if val<=3
    % assumes that a line was clicked
    amp_line=yjxt_DAT(8);
    axes(get(amp_line,'parent'));	% set the right axes

    % Obtain coordinates of mouse click location in axes units
    pt=get(gca,'currentpoint');
    x=pt(1,1);
    y=pt(1,2);


% find closest vertex of line to mouse click location (call it fixed_x, fixed_y)

    line_x=get(amp_line,'XData');
    line_y=get(amp_line,'YData');
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
    set(amp_line,'LineStyle',':');

    yjxt_DAT(6)=fixed_x;
    yjxt_DAT(7)=fixed_y;

    set(gca,'units',units_str );
    set(gcf,'WindowButtonMotionFcn', 'yjxt(''move'')');
    set(gcf,'WindowButtonUpFcn', 'yjxt(''up'')');
  %  set(gcf,'userdata',u);
end

elseif strcmp(action,'move'),
    % u = get(gcf,'userdata');
    freq=yjxt_DAT(1);
    amp=yjxt_DAT(2);
    N=yjxt_DAT(3);
    M=yjxt_DAT(4);
    C_field=yjxt_DAT(5);
    fixed_x=yjxt_DAT(6);
    fixed_y=yjxt_DAT(7);
    amp_line=yjxt_DAT(8);
    pha_line=yjxt_DAT(9);
    R_field=yjxt_DAT(10);
    popup=yjxt_DAT(11);
    t=yjxt_DAT(14:14+N-1);
    window=yjxt_DAT(14+N:14+N+N-1);

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
     %if(freq1<0.05)freq1=0.05;end
      %if(freq>0.95)freq1=0.95;end
     % if(amp1>1.0)amp1=1.0;end
    if (val == 1),
           %if t==0 f=1;
           %else 
          f=amp1*sin(freq1*t)./(t*pi);
         %  end;
    elseif (val == 2),   % square wave
            for i=1:N
            if abs(i-N/2)<=N/(6*freq1)
              f(i)=amp1;
           else
              f(i)=0;
   
             end
           end        
        %tt=freq1*t*2*pi;
       % tmp=rem(tt,2*pi);
        %f=amp1*(2*rem((tt<0)+(tmp>pi | tmp<-pi)+1,2)-1);
    elseif (val == 3),   % sawtooth
            for i=1:N  
           if i==N/2, f(i)=1;
           else f(i)=0; 
           end;      
         end
     %tt=freq1*t*2*pi;
       % f=amp1*((tt < 0) + rem(tt,2*pi)/2/pi - .5)*2;
  elseif (val == 4),   % self-defined waveform
	f=eval(fun_str);

    end;
      set(amp_line,'YData',f);
    F=fft(f,2*M);
    F=F(1:M);
    w=(0:M-1)*ws/(2*M);
    FF=abs(F);
    % ind=find(FF<C_field);
    % FF(ind)=NaN*ones(size(ind)); % put NaN's in where
         % C_field shows up - this is to work around no clipping in xor mode
  %  pha_line=plot(w1(1:N/2),FF(1:N/2),w2(1:N/2),FF(1:N/2),'EraseMode','xor');
   % axis([-100 100 0 40]);
    
    set(pha_line,'YData',FF);
    set(R_field,'String',num2str(freq1));

elseif strcmp(action,'up'),
    pt=get(gca,'currentpoint');
    x=pt(1,1);
    y=pt(1,2);

    set(gcf,'WindowButtonMotionFcn','');
    set(gcf,'WindowButtonUpFcn','');

    % u=get(gcf,'userdata');
    freq=yjxt_DAT(1);
    amp=yjxt_DAT(2);
    fixed_x=yjxt_DAT(6);
    fixed_y=yjxt_DAT(7);

    amp1=y/fixed_y*amp;
    if (abs(amp1)>1.0),
       amp1=1.0*sign(amp1);
    end;
    if (abs(amp1)<0.05),
       amp1=0.05*sign(amp1);
    end;
    freq1=fixed_x/x*freq;

    set(yjxt_DAT(8),'linestyle','-','markersize',8);
    yjxt_DAT(1)=freq1;  % set amplitude and frequency
    yjxt_DAT(2)=amp1;
    % set(gcf,'userdata',u);
    yjxt('redraw');

elseif strcmp(action,'done'),
    % close the figure window that is showing the window fnction:
    % u = get(gcf,'userdata');
    show_window=findobj('Tag','window_window');
    if ( ~isempty(show_window) & yjxt_DAT(12)~=-1 )
    	close(yjxt_DAT(12));
    end;
    close(gcf);
    clear global yjxt_DAT
    clear global ADDIT_DAT
    clear global fun_str
    clear show_window

elseif strcmp(action,'redraw'),
    % recomputes time and frequency waveforms and updates display
    % u = get(gcf,'userdata');
    freq=yjxt_DAT(1);
    amp=yjxt_DAT(2);
    N=yjxt_DAT(3);
    M=yjxt_DAT(4);
    C_field=yjxt_DAT(5);
    amp_line=yjxt_DAT(8);
    pha_line=yjxt_DAT(9);
    R_field=yjxt_DAT(10);
    popup=yjxt_DAT(11);
    t=yjxt_DAT(14:14+N-1);
    window=yjxt_DAT(14+N:14+N+N-1);
    val = get(popup,'Value');
     % if(freq<0.05)freq=0.05;end
      %if(freq>10)freq=10;end
     % if(amp>1.0)amp=1.0;end
    if (val == 1),
        %if t==0,f=1        
         % else
       f=amp*sin(freq*t)./(t*pi);
      %  end;
    elseif (val == 2),   % square wave
   for i=1:N
            if abs(i-N/2)<=N/(6*freq)
              f(i)=amp;
           else
              f(i)=0;
   
             end
           end      
%tt=freq*t*2*pi;
 %       tmp=rem(tt,2*pi);
       % f=amp*(2*rem((tt<0)+(tmp>pi | tmp<-pi)+1,2)-1);
    elseif (val == 3),   % sawtooth
          for i=1:N
           if i==N/2, f(i)=1;
           else f(i)=0;
           end
           end        
   %tt=freq*t*2*pi;
        %f=amp*((tt < 0) + rem(tt,2*pi)/2/pi - .5)*2;
    elseif (val == 4),   % self-defined waveform
	f=eval(fun_str);
    end;
       set(amp_line,'YData',f);
         F=fft(f,2*M);
    F=F(1:M);
    w=(0:M-1)*ws/(2*M);
    FF=abs(F);
    % ind=find(FF<C_field);
    % FF(ind)=NaN*ones(size(ind)); % put NaN's in where
         % C_field shows up - this is to work around no clipping in xor mode
   %  pha_line=plot(w1(1:N/2),FF(1:N/2),w2(1:N/2),FF(1:N/2),'EraseMode','xor');
   % axis([-100 100 0 40]);
   
  
    set(pha_line,'YData',FF);
    set(R_field,'String',num2str(freq));

    drawnow;

elseif strcmp(action,'setwindow'),
    % u = get(gcf,'userdata');
    winHndl = ADDIT_DAT;
    in1 = get(winHndl,'Value');
    in2 = 30;
    N=yjxt_DAT(3);
    show_window=yjxt_DAT(14+N+N);

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

    yjxt_DAT(14+N:14+N+N-1)=window;
    % set(gcf,'userdata',u);
    yjxt('redraw');

    if get(show_window,'value'),
        yjxt('showwin');
    end;

elseif strcmp(action,'showwin'),
    % u=get(gcf,'userdata');
    oldfig=gcf;
    N=yjxt_DAT(3);
    t=yjxt_DAT(14:14+N-1);
    window=yjxt_DAT(14+N:14+N+N-1);

    if (yjxt_DAT(12)==-1),
        yjxt_DAT(12)=figure('NumberTitle','off', ...
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
        line2=plot((0:(1/1024):(.5-(1/1024)))*N,abs(W(1:512))); 
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
			'global yjxt_DAT;',...
			'yjxt_DAT(12)=-1;',...
			'clear THEHAND yjxt_DAT;']);

	set(gcf,'userdata',[oldfig line1 line2]);
        % set(oldfig,'userdata',u);
	clear line1 line2 W;
        
    else
	show_window=findobj('Tag','window_window');
	if isempty(show_window)
		yjxt_DAT(12)=-1;
		yjxt('showwin');
	else
        	figure(yjxt_DAT(12));
		drawnow
        	lines=get(gcf,'userdata');
        	set(lines(2),'ydata',window);
        	W=fft(window,1024);
        	set(lines(3),'ydata',abs(W(1:512)));
        	figure(yjxt_DAT(12));
        	drawnow;
		clear W lines;
	end
	clear show_window;
    end

    clear oldfig N t window;

elseif strcmp(action,'delshow'),
    N=yjxt_DAT(3);
    show_window=yjxt_DAT(14+N+N);
    if ( yjxt_DAT(12)~=-1 & get(show_window,'value')==0),
	show_window=findobj('Tag','window_window');
	if isempty(show_window)
	        yjxt_DAT(12)=-1;
	else
		figure(show_window);
        	THEHAND=get(gcf,'userdata');
		close;
		figure(THEHAND(1));
		yjxt_DAT(12)=-1;
		clear THEHAND;
    	end
    end
    clear show_window N;

elseif strcmp(action,'setR'),
       x = str2num(get(yjxt_DAT(10),'String'));
    if isempty(x),   % handle the non-numeric case
        set(yjxt_DAT(10),'String',num2str(yjxt_DAT(1)));
    else
        yjxt_DAT(1)=x;
    end;

elseif strcmp(action,'info'),
    ttlStr = '连续信号傅立叶变换'; 

    hlpStr1= ...                                              
        ['                                             '
         ' 我们看到，在演示窗口中，上方的图给出了一个  '
         ' 连续时间非周期信号的时域波形，用鼠标点击并  '
         ' 拖动信号上的任意一点就可改变该信号的幅值及  '
         ' 压缩或展宽信号的波形；也可通过用鼠标单击“带'
         ' 限宽度”的文本框来压缩或展宽信号的波形。    '                   
         ' 下方的图给出了该连续信号经傅立叶变换后的频谱'
         ' 密度的图形即信号的频域波形。                '                                              
         ' 频域信号是通过连续信号的采样点经快速傅立叶  '
         ' 变换算法(FFT)而得到的。采样间隔由傅立叶变换 '
         ' 的点数决定。                                '       
         '                                             '  
         ' 注意：下图中，频率范围是从0 到100 Hz。处于  '
         ' 负频域的 DFT 是正频域 DFT 的镜象，故在此只  '
         ' 画出了正频域的 DFT。抽样频率是 200Hz，这意  '
         ' 味着“奈奎斯特”频率是100Hz。在高于“奈奎斯 '
         ' 特”频率的频率点处的 DFT 与在低频（负频域） '
         ' 处的DFT相同。                               '   
         '                                             '];

    hlpStr2= ...                                               
        ['                                             '
	 ' 在上图中，点击并拖动信号波形上的任意一点，  '
         ' 这样可以设置信号的带限范围与信号幅度。      '  
         '                                             '  
         ' 用鼠标单击“信号”文本框，就给出一个下拉式菜'
         ' 单，从中选中信号即可改变输入的信号。        '  
         '                                             '  
         ' 菜单“窗口”让你选择一个窗口函数，在对信号  '
         ' 进行DFT 以前，这个窗口将与信号波形相乘——  '
         ' 即“开窗截取”。                            '  
         '                                             '   
         ' 检查框“显示窗口函数”若被选中，则在显示信  '
         ' 号波形和其DFT的同时，也显示出窗口函数的形状 '  
         '                                             '  
         ' 左边的文本框给出了信号的带限值，可以通过用  '
         ' 鼠标点击此文本框，然后设置带限值的大小，再  '
         ' 回车来改变信号的形状。                      ' ];

  

     helpwin(ttlStr, hlpStr1, hlpStr2);

end
