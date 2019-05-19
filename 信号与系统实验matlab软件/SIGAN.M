function sigan(action,in1,in2);
%sigan 交互式信号演示 - 1 : 信号的 DFT
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

global sigan_DAT
global ADDIT_DAT	% this is for WINDOW pop-up button
global fun_str
global ws

if strcmp(action,'start'),

    %====================================
    % Graphics initialization
    oldFigNumber = watchon;
    figNumber = figure;
    set(gcf, ...
        'NumberTitle','off', ...
        'Name','离散非周期信号傅立叶变换', ...
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
    popup=uicontrol('Style','Popup','String','矩形脉冲|单位脉冲',...
        'Position', btnPos, ...
        'BackgroundColor','w', ...
        'ForegroundColor','k', ...
        'Units','normalized',...
        'CallBack',[...
		'global sigan_DAT;',...
		'popup=sigan_DAT(11);',...
		'val = get(popup,''Value'');',...
		'if val<=3',...
		'	sigan(''redraw'');',...
		'else',...
		'	getstr;',...
		'end']);

    %====================================
    % The WINDOW command popup button
   % btnNumber=2;
    %yLabelPos=top-(btnNumber-1)*(btnHt+labelHt+spacing);
   % labelStr=' 窗口函数';
    %popupStr= '矩形|三角形|汉宁|海明';
   % if ~isstudent
    %    popupStr= [popupStr '|切比雪夫|恺撒'];
    %end
   % callbackStr= 'sigan(''setwindow'')';

    % Generic label information
%    labelPos=[left yLabelPos-labelHt labelWid labelHt];
 %   uicontrol( ...
  %      'Style','text', ...
   %     'Units','normalized', ...
    %    'Position',labelPos, ...
     %   'BackgroundColor',labelColor, ...
      %  'HorizontalAlignment','left', ...
       % 'String',labelStr);

    % Generic popup button information
%    btnPos=[left yLabelPos-labelHt-btnHt-btnOffset btnWid btnHt];
 %   winHndl = uicontrol( ...
  %      'Style','popup', ...
   %     'Units','normalized', ...
    %    'BackgroundColor','w', ...
     %   'ForegroundColor','k', ...
      %  'Position',btnPos, ...
       % 'String',popupStr, ...
	%'visible','on',...
        %'Callback',callbackStr);

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
        'String','脉宽参数(N1):');

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
        'CallBack','sigan(''setfreq''); sigan(''redraw'')');

   %====================================
    % The Show Window CheckBox
%    show_window=uicontrol(gcf, ...
 %       'Style','checkbox', ...
  %      'Units','normalized',...
	%'Position',[left yLabelPos-labelHt*4.5 labelWid+0.02 labelHt],...
%	'backgroundcolor',[0.5 0.5 0.5],...
	%'foregroundcolor','w',...
       % 'HorizontalAlignment','left', ...
        %'string','显示窗口函数',...
	%'value',0,...
        %'Callback','sigan(''delshow'');');

   %====================================
    % The INFO button
    uicontrol( ...
        'Style','push', ...
        'Units','normalized', ...
        'Position',[left bottom+(2*labelHt)+spacing btnWid 2*labelHt], ...
        'String','信息', ...
        'Callback','sigan(''info'')');

   %========================================
   % The CLOSE button
    done_button=uicontrol('Style','Pushbutton', ...
        'Position',[left bottom btnWid 2*labelHt], ...
        'Units','normalized','Callback',...
        'sigan(''done'')','String','关闭');
   %====================================

    % Create intial signal
    N=512;     % number of samples
     N1=20;
    amp=1;
    freq=5;    % hertz
    t0=-10;      % seconds
    t1=10;      % seconds
    t=-10:10;
    T=(t1-t0)/N;
    ws=t(2)-t(1);            % sampling rate in seconds
    M=512;     % length of fft
    window=ones(N,1);    % use window to lower side-lobes in the freq. domain
                             % (makes peaks wider)
    
    min_dB=0; % freq. domain lower axis limit
    %w=ws*(1:N/2)/N;
    %w2=ws*(-(0:N/2-1))/N;
    % create axes for time domain and frequency domain plot

     ax_freq=axes('Position',[.12 .14 .6 .3],'XLim',...
             [0,10],'YLim',[0 15]);

    % time domain
    val = get(popup,'Value');
    %if(freq<0.05)freq=0.05;end
     %if(freq>0.95)freq=0.95;end
      %if(amp>1.0)amp=1.0;end
    %if (val == 1),
        %for t=t0:t:t1
         % if t==0,f=1;
          %   else
     %f=amp*sin(freq*t)./(t*pi);
    %      end;
     %    end
    if (val == 1),   % square wave
       for i=1:N1+1
         if abs(i-N1/2-1)<=freq
        
            f(i)=amp;
          else
              f(i)=0;
   
            end
           end

         
        %tt=freq*t*2*pi;
        %tmp=rem(tt,2*pi);
        %f=amp*(2*rem((tt<0)+(tmp>pi | tmp<-pi)+1,2)-1);
    elseif (val == 2),   % sawtooth
        
  for i=1:N1+1  
           if i==(N1/2)+1, f(i)=1;
           else f(i)=0; 
           end;      
         end


               %tt=freq*t*2*pi;
       % f=amp*((tt < 0) + rem(tt,2*pi)/2/pi - .5)*2;
    elseif (val == 3),   % self-defined waveform
	f=eval(fun_str);
    end;

    % frequency domain
    F=fft(f,M);
       %F=F(1:M);
    w=2*pi/ws/M*(0:M-1);
    FF=sqrt(F.*conj(F));
    % ind=find(FF<min_dB);
    % FF(ind)=NaN*ones(size(ind)); % put NaN's in where
         % min_dB shows up - this is to work around no clipping in xor mode
       
      
     freq_line=plot(w,FF,'EraseMode','xor');
      axis([0 10 0 15]);
    grid;
    ylabel('幅频特性');
    xlabel('频率 (Hz)');

    ax_time=axes('Position',[.12 .58 .6 .3],'XLim',[-10 10],'YLim',[0 1]);
   
    time_line=plot(t,f,'EraseMode','xor');
    stem(t,f);
   % stem(-t,f);
      axis([-10 10 0 1]);
    % (set to xor mode to prevent re-rendering, that is, for speed)
    grid;
    ylabel('波形');
    xlabel('时间');
    %text(-7.55, 1.25,'点击并拖放信号波形以改变其基频与振幅。');
  
      %set(time_line,'ButtonDownFcn','sigan(''down'')');

    sigan_DAT = [freq; amp; N; M; min_dB; 0; 0; ...
		time_line; freq_line; freq_field; popup; -1; gcf; ...
		];
    %ADDIT_DAT = winHndl;

    watchoff(oldFigNumber);

elseif strcmp(action,'down'),

  popup=sigan_DAT(11);
  val = get(popup,'value');
  if val<=3
    % assumes that a line was clicked
    time_line=sigan_DAT(8);
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

    sigan_DAT(6)=fixed_x;
    sigan_DAT(7)=fixed_y;

    set(gca,'units',units_str );
    set(gcf,'WindowButtonMotionFcn', 'sigan(''move'')');
    set(gcf,'WindowButtonUpFcn', 'sigan(''up'')');
  %  set(gcf,'userdata',u);
end

elseif strcmp(action,'move'),
    % u = get(gcf,'userdata');
    freq=sigan_DAT(1);
    amp=sigan_DAT(2);
    N=sigan_DAT(3);
    M=sigan_DAT(4);
    min_dB=sigan_DAT(5);
    fixed_x=sigan_DAT(6);
    fixed_y=sigan_DAT(7);
    time_line=sigan_DAT(8);
    freq_line=sigan_DAT(9);
    freq_field=sigan_DAT(10);
    popup=sigan_DAT(11);
    %t=sigan_DAT(14:14+N-1);
    %window=sigan_DAT(14+N:14+N+N-1);

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
    
%if (val == 1),
           %if t==0 f=1;
           %else 
 %         f=amp1*sin(freq1*t)./(t*pi);
         %  end;
    if (val == 1),   % square wave
            for i=1:N1+1
            if abs(i-N1/2-1)<=freq1
              f(i)=amp1;
           else
              f(i)=0;
   
             end
           end        
        %tt=freq1*t*2*pi;
       % tmp=rem(tt,2*pi);
        %f=amp1*(2*rem((tt<0)+(tmp>pi | tmp<-pi)+1,2)-1);
    elseif (val == 2),   % sawtooth
            for i=1:N1+1  
           if i==(N1/2)+1, f(i)=1;
           else f(i)=0; 
           end;      
         end
     %tt=freq1*t*2*pi;
       % f=amp1*((tt < 0) + rem(tt,2*pi)/2/pi - .5)*2;
  elseif (val == 4),   % self-defined waveform
	f=eval(fun_str);

    end;
      set(time_line,'YData',f);
    F=fft(f,M);
    %F=F(1:M);
    w=(0:M-1)*ws/(2*M);
    FF=abs(F);
     F=fft(f,M);
       %F=F(1:M);
    w=2*pi/ws/M*(0:M-1);
    FF=sqrt(F.*conj(F));
    % ind=find(FF<min_dB);
    % FF(ind)=NaN*ones(size(ind)); % put NaN's in where
         % min_dB shows up - this is to work around no clipping in xor mode
       
      
     freq_line=plot(w,FF,'EraseMode','normal');
      axis([0 10 0 15]);
    grid;
    ylabel('幅频特性');
    xlabel('频率 (Hz)');

    ax_time=axes('Position',[.12 .58 .6 .3],'XLim',[-10 10],'YLim',[0 1]);
    stem(t,f);
      axis([-10 10 0 1]);
    % (set to xor mode to prevent re-rendering, that is, for speed)
    grid;
    ylabel('波形');
    xlabel('时间（秒）');
    
  %  set(freq_line,'YData',FF);
   %set(freq_field,'String',num2str(freq1));

elseif strcmp(action,'up'),
    pt=get(gca,'currentpoint');
    x=pt(1,1);
    y=pt(1,2);

%    set(gcf,'WindowButtonMotionFcn','');
 %   set(gcf,'WindowButtonUpFcn','');

    % u=get(gcf,'userdata');
    freq=sigan_DAT(1);
    amp=sigan_DAT(2);
    fixed_x=sigan_DAT(6);
    fixed_y=sigan_DAT(7);

    amp1=y/fixed_y*amp;
    if (abs(amp1)>1.0),
       amp1=1.0*sign(amp1);
    end;
    if (abs(amp1)<0.05),
       amp1=0.05*sign(amp1);
    end;
    freq1=fixed_x/x*freq;

    set(sigan_DAT(8),'linestyle','-','markersize',8);
    sigan_DAT(1)=freq1;  % set amplitude and frequency
    sigan_DAT(2)=amp1;
    % set(gcf,'userdata',u);
    sigan('redraw');

elseif strcmp(action,'done'),
    % close the figure window that is showing the window fnction:
    % u = get(gcf,'userdata');
    show_window=findobj('Tag','window_window');
    if ( ~isempty(show_window) & sigan_DAT(12)~=-1 )
    	close(sigan_DAT(12));
    end;
    close(gcf);
    clear global sigan_DAT
    clear global ADDIT_DAT
    clear global fun_str
    clear show_window

elseif strcmp(action,'redraw'),
    % recomputes time and frequency waveforms and updates display
    % u = get(gcf,'userdata');
    freq=sigan_DAT(1);
    amp=sigan_DAT(2);
    N=sigan_DAT(3);
    M=sigan_DAT(4);
    min_dB=sigan_DAT(5);
    time_line=sigan_DAT(8);
    freq_line=sigan_DAT(9);
    freq_field=sigan_DAT(10);
    popup=sigan_DAT(11);
    %ax_freq=axes('Position',[.12 .14 .6 .3],'XLim',...
     %        [0,10],'YLim',[0 10]);
    % plot(w,FF,'EraseMode','normal');
   N1=20;%M=512; 
   t=-10:10;
   ws=t(2)-t(1);
   % window=sigan_DAT(14+N:14+N+N-1);
    val = get(popup,'Value');
    %  if(freq<0.05)freq=0.05;end
     % if(freq>10)freq=10;end
      %if(amp>1.0)amp=1.0;end
   % if (val == 1),
       % if t==0,f=1        
        % else
       %f=amp*sin(freq*t)./(t*pi);
      %  end;
    if (val == 1),   % square wave
   for i=1:N1+1
            if abs(i-N1/2-1)<=freq
              f(i)=1;
           else
              f(i)=0;
   
             end
           end      
%tt=freq*t*2*pi;
 %       tmp=rem(tt,2*pi);
       % f=amp*(2*rem((tt<0)+(tmp>pi | tmp<-pi)+1,2)-1);
    elseif (val == 2),   % sawtooth
         for i=1:N1+1
           if i==(N1/2)+1, f(i)=1;
           else f(i)=0;
           end
           end                    %end        
   %tt=freq*t*2*pi;
        %f=amp*((tt < 0) + rem(tt,2*pi)/2/pi - .5)*2;
    elseif (val == 3),   % self-defined waveform
	f=eval(fun_str);
    end;
        F=fft(f,M);
       %F=F(1:M);
       w=2*pi/ws/M*(0:M-1);
        FF=sqrt(F.*conj(F));
    % ind=find(FF<min_dB);
    % FF(ind)=NaN*ones(size(ind)); % put NaN's in where
         % min_dB shows up - this is to work around no clipping in xor mode
        
   
%        plot(w,FF,'EraseMode','xor');
 %      plot(w,FF,'y');
%      axis([0 10 0 15]);
  %  grid;
   % ylabel('幅频特性');
    %xlabel('频率 (Hz)');
     

  %ax_time=axes('Position',[.12 .58 .6 .3],'XLim',[-10 10],'YLim',[0 1]);
    stem(t,f);
      axis([-10 10 0 1]);
    % (set to xor mode to prevent re-rendering, that is, for speed)
   grid;
    ylabel('波形');
    xlabel('时间（秒）');
  % freq_line=plot(w,FF,'EraseMode','xor');
%       plot(w,FF);
   %   axis([0 10 0 15]);
       %set(time_line,'YData',f);
        % F=fft(f,2*M);
    %F=F(1:M);
    %w=(0:M-1)*ws/(2*M);
    %FF=abs(F);
    % ind=find(FF<min_dB);
    % FF(ind)=NaN*ones(size(ind)); % put NaN's in where
         % min_dB shows up - this is to work around no clipping in xor mode
   %  freq_line=plot(w1(1:N/2),FF(1:N/2),w2(1:N/2),FF(1:N/2),'EraseMode','xor');
   % axis([-100 100 0 40]);
   
  
  set(freq_line,'YData',FF);
    set(freq_field,'String',num2str(freq));

%    drawnow;

elseif strcmp(action,'setwindow'),
    % u = get(gcf,'userdata');
    %winHndl = ADDIT_DAT;
    in1 = get(winHndl,'Value');
    in2 = 30;
    N=sigan_DAT(3);
    %show_window=sigan_DAT(14+N+N);

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

    sigan_DAT(14+N:14+N+N-1)=window;
    % set(gcf,'userdata',u);
    sigan('redraw');

    if get(show_window,'value'),
        sigan('showwin');
    end;

elseif strcmp(action,'showwin'),
    % u=get(gcf,'userdata');
    oldfig=gcf;
    N=sigan_DAT(3);
   % t=sigan_DAT(14:14+N-1);
    %window=sigan_DAT(14+N:14+N+N-1);

    if (sigan_DAT(12)==-1),
        sigan_DAT(12)=figure('NumberTitle','off', ...
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
			'global sigan_DAT;',...
			'sigan_DAT(12)=-1;',...
			'clear THEHAND sigan_DAT;']);

	set(gcf,'userdata',[oldfig line1 line2]);
        % set(oldfig,'userdata',u);
	clear line1 line2 W;
        
    else
	show_window=findobj('Tag','window_window');
	if isempty(show_window)
		sigan_DAT(12)=-1;
		sigan('showwin');
	else
        	figure(sigan_DAT(12));
		drawnow
        	lines=get(gcf,'userdata');
        	set(lines(2),'ydata',window);
        	W=fft(window,1024);
        	set(lines(3),'ydata',abs(W(1:512)));
        	figure(sigan_DAT(12));
        	drawnow;
		clear W lines;
	end
	clear show_window;
    end

    clear oldfig N t window;

elseif strcmp(action,'delshow'),
    N=sigan_DAT(3);
    show_window=sigan_DAT(14+N+N);
    if ( sigan_DAT(12)~=-1 & get(show_window,'value')==0),
	show_window=findobj('Tag','window_window');
	if isempty(show_window)
	        sigan_DAT(12)=-1;
	else
		figure(show_window);
        	THEHAND=get(gcf,'userdata');
		close;
		figure(THEHAND(1));
		sigan_DAT(12)=-1;
		clear THEHAND;
    	end
    end
    clear show_window N;

elseif strcmp(action,'setfreq'),
       x = str2num(get(sigan_DAT(10),'String'));
    if isempty(x),   % handle the non-numeric case
        set(sigan_DAT(10),'String',num2str(sigan_DAT(1)));
    else
        sigan_DAT(1)=x;
    end;

elseif strcmp(action,'info'),
    ttlStr = '离散非周期信号傅立叶变换（DFT）'; 

    hlpStr1=str2mat(...                                              
        '                                               ',...  
         ' 我们看到，在演示窗口中，上方的图表示了一个离  '  ,...
         ' 散非周期信号的时域波形。用鼠标单击“时限长度”',...
         ' 的文本框选中输入值，用键盘输入数值即可改变离散',...
         ' 信号的点数。                                  ',...
         ' 离散信号的点数就等于所输入的数值。            '      ,...             
         '                                               '  ,...
         '   下方的图给出了该信号经离散傅立叶变换后的频谱',...
         ' 图即显示了信号的频域特性。                    '   ,...                                                       
         '                                               '  ,...
         ' 注意：下图中，频域图形是以2п即2*3.14为周期的 '  ,...
         ' 在此只画出了一个周期内的频谱特性。负频域的 DFT',...
         ' 是正频域DFT的镜象，故在此只画出了正频域的DFT。',...
         '                                               ');

    hlpStr2= str2mat(...                                              
        '                                              ' ,...
         ' 左边的文本框给出了信号的基频，可以通过用鼠标 ',...
         ' 点击此文本框，然后编辑时限值的大小，再回车来 ',...
         ' 展宽或压缩信号的波形。                       ',...
         '                                              ',...
         ' 从图中所示的波形可看出：当通过文本框改变时限 ',...
         ' 值大小时，时域信号与频域信号的波形都有所改变 ',...
         ' 。时域信号的时限范围变大，则频域信号的主瓣宽 ',...
         ' 度变窄。且一个周期内信号的起伏个数与时限值的 ',...
         ' 大小一致。                                   ',...
         ' 频域信号是以2п即2*3.14为周期的。            ' );

  
     helpwin(ttlStr, hlpStr1, hlpStr2);

end
