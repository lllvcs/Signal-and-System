function sigdwx(action,in1,in2);
%SIGDWX Interactive signal demo - 2 : continuous FT of a signal
%	Demonstrates MATLAB's graphic user interface using Handle Graphics
%       while illustrating basic Fourier transform (FT) properties,
%	including modulation.

%	possible actions:
%	  'start'
%	  'down'       - in1=1 ==> time_line, in1=2 ==> freq_line
%	  'move'
%	  'up'
%	  'redraw'     
%	  'setfreq'    - in1=1 ==> from slider, in1=2 ==> from edit text
%	  'info'
%	  'done'

if nargin<1,
    action='start';
end;

global SIGDWX_DAT

if strcmp(action,'start'),

    %====================================
    % Graphics initialization
    oldFigNumber = watchon;
    figNumber = figure;
    set(gcf, ...
        'NumberTitle','off', ...
        'Name','调制频率', ...
	'backingstore','off',...
	'Units','normalized');
 
    %====================================
    % Information for all buttons
    top=0.95;
    bottom=0.05;
    left=0.82;
    yInitLabelPos=0.90;
    btnWid = 0.13;
    btnHt=0.08;
    % Spacing between the label and the button for the same command
    btnOffset=0.02;
    % Spacing between the button and the next command's label
    spacing=0.02;
    %bottom=bottom+spacing;
 
    %====================================
    % The CONSOLE frame
    frmBorder=0.02;
    yPos=0.02;
    frmPos=[left-frmBorder bottom-frmBorder btnWid+2*frmBorder ...
	    0.9+2*frmBorder];
    h=uicontrol( ...
        'Style','frame', ...
        'Units','normalized', ...
        'Position',frmPos, ...
        'BackgroundColor',[0.5 0.5 0.5]);

    %====================================
    % The INFO button
    uicontrol( ...
        'Style','push', ...
        'Units','normalized', ...
        'Position',[left bottom+btnHt+spacing+0.075  btnWid btnHt], ...
        'String','信息', ...
        'Callback','sigdWX(''info'')');
 
   %========================================
   % The CLOSE button
    done_button=uicontrol('Style','Pushbutton', ...
        'Units','normalized',...
        'Position',[left bottom+0.025 btnWid btnHt], ...
        'Callback','sigdwx(''done'')','String','关闭');
   %====================================

    % Create initial signal
    min_freq = 1;
    max_freq = 5;
    min_amp = .1;
    max_amp = 1;
    amp=0.5;
    freq=2.5;    % hertz
    [t,f,w,F]=tffunc(amp,freq);

freq_text=uicontrol('Style','text', ...
   'Units','normalized', ...
   'Position',[.18 .02 .38 .07], ...
   'BackgroundColor','black', ...
   'ForegroundColor','white','String',' 调制频率 (Hz):');

uicontrol('style','text', ...
   'Units','normalized', ...
   'pos',[.14 .07 .02 .05],...
   'BackgroundColor','black', ...
   'ForegroundColor','white','String',num2str(min_freq));

uicontrol('style','text', ...
   'Units','normalized', ...
   'pos',[.74 .07 .02 .05 ], ...
   'BackgroundColor','black', ...
   'ForegroundColor','white','String',num2str(max_freq));

freq_field=uicontrol('Style','edit', ...
   'Units','normalized', ...
   'Position',[.59 .02 .12 .07], ...
   'String',num2str(freq), ...
   'CallBack','sigdwx(''setfreq'',2); sigdwx(''redraw'');');

%    freq_slider=uicontrol('Style','slider','Position',[.15 .12 .6 .04],...
freq_slider=uicontrol('Style','slider', ...
   'Units','normalized', ...
   'Position',[.12 .12 .6 .04], ...
   'Value',freq,'Max',max_freq,'Min',min_freq,...
   'Callback','sigdwx(''setfreq'',1); sigdwx(''redraw'');');
   
    %  frequency domain
%    ax_freq=axes('Position',[.15 .28 .8 .26],'XLim',[-8 8],'YLim',[-.5 2]);
    ax_freq=axes('Position',[.12 .28 .6 .26],'XLim',[-8 8],'YLim',[-.5 2]);
    freq_line=plot(w,F,'EraseMode','xor');
    axis([-8 8 -.5 2]);
    grid;
    ylabel('幅值');
    xlabel('频率(Hz)');

    % time domain
%    ax_time=axes('Position',[.15 .66 .8 .26],'XLim',[-1 1],'YLim',[-1 1]);
    ax_time=axes('Position',[.12 .66 .6 .26],'XLim',[-1 1],'YLim',[-1 1]);
    time_line=plot(t,f,'EraseMode','xor');
    % (set to xor mode to prevent re-rendering, that is, for speed)
    axis([-1 1 -1 1]);
    grid;
    ylabel('波形');
    xlabel('时间(秒)');
    title('单击并拖动波形可设置新的调制频率和幅值');

    set(time_line,'ButtonDownFcn','sigdwx(''down'',1)');
    set(freq_line,'ButtonDownFcn','sigdwx(''down'',2)');
    drawnow;

    SIGDWX_DAT = [freq; amp; min_freq; max_freq; min_amp; max_amp; 0; 0; ...
         time_line; freq_line; freq_field; freq_slider; ax_time; ax_freq ];
     
    watchoff(oldFigNumber);

elseif strcmp(action,'down'),
    % assumes that a line was clicked 

    if (in1==1),
        line_handle = SIGDWX_DAT(9);
        ax = SIGDWX_DAT(13);
    else   % assume in1 == 2 otherwise (might not be true)
        line_handle = SIGDWX_DAT(10);
        ax = SIGDWX_DAT(14);
    end;

    if (ax~=gca),
        axes(ax);
        drawnow discard;
    end;

    % Obtain coordinates of mouse click location in axes units
    pt=get(gca,'currentpoint');
    x=pt(1,1);
    y=pt(1,2);

    % find closest point on line to mouse click loc (call it fixed_x, fixed_y)
    line_x=get(line_handle,'XData');
    line_y=get(line_handle,'YData');
    dist=(line_x-x).^2 + (line_y-y).^2;
    [temp,i]=min(dist);
    fixed_x=line_x(i);
    fixed_y=line_y(i);

    set(line_handle,'LineStyle','--');
    drawnow;

    SIGDWX_DAT(7)=fixed_x;
    SIGDWX_DAT(8)=fixed_y;

    set(gcf,'WindowButtonMotionFcn', sprintf('sigdwx(''move'',%g)',in1));
    set(gcf,'WindowButtonUpFcn', sprintf('sigdwx(''up'',%g)',in1));

elseif strcmp(action,'move'),
    freq=SIGDWX_DAT(1);
    amp=SIGDWX_DAT(2);
    min_freq=SIGDWX_DAT(3);
    max_freq=SIGDWX_DAT(4);
    min_amp=SIGDWX_DAT(5);
    max_amp=SIGDWX_DAT(6);
    fixed_x=SIGDWX_DAT(7);
    fixed_y=SIGDWX_DAT(8);
    time_line=SIGDWX_DAT(9);
    freq_line=SIGDWX_DAT(10);
    freq_field=SIGDWX_DAT(11);
    freq_slider=SIGDWX_DAT(12);

    pt=get(gca,'currentpoint');
    x=pt(1,1);
    y=pt(1,2);

    amp1=y/fixed_y*amp;
    if (amp1>max_amp ),
       amp1=max_amp ;
    end;
    if (amp1<min_amp ),
       amp1=min_amp ;
    end;
    if (in1==1),
        freq1=fixed_x/x*freq;
    else
        freq1=x/fixed_x*freq;
    end;
    if (freq1>max_freq),
       freq1=max_freq;
    end;
    if (freq1<min_freq),
       freq1=min_freq;
    end;

    [t,f,w,F]=tffunc(amp1,freq1);
    set(time_line,'YData',f);
    set(freq_line,'YData',F);
    set(freq_field,'String',num2str(freq1));
    set(freq_slider,'Value',freq1);

elseif strcmp(action,'up'),
    freq=SIGDWX_DAT(1);
    amp=SIGDWX_DAT(2);
    min_freq=SIGDWX_DAT(3);
    max_freq=SIGDWX_DAT(4);
    min_amp=SIGDWX_DAT(5);
    max_amp=SIGDWX_DAT(6);
    fixed_x=SIGDWX_DAT(7);
    fixed_y=SIGDWX_DAT(8);

    pt=get(gca,'currentpoint');
    x=pt(1,1);
    y=pt(1,2);

    amp1=y/fixed_y*amp;
    if (amp1>max_amp ),
       amp1=max_amp ;
    end;
    if (amp1<min_amp ),
       amp1=min_amp ;
    end;
    if (in1==1),
        freq1=fixed_x/x*freq;
    else
        freq1=x/fixed_x*freq;
    end;
    if (freq1>max_freq),
       freq1=max_freq;
    end;
    if (freq1<min_freq),
       freq1=min_freq;
    end;

    set(gcf,'WindowButtonMotionFcn','');
    set(gcf,'WindowButtonUpFcn','');

    set(SIGDWX_DAT(9),'linestyle','-');
    set(SIGDWX_DAT(10),'linestyle','-');
    SIGDWX_DAT(1)=freq1;  % set amplitude and frequency
    SIGDWX_DAT(2)=amp1;

    sigdwx('redraw');

elseif strcmp(action,'redraw'),
    freq=SIGDWX_DAT(1);
    amp=SIGDWX_DAT(2);

    set(SIGDWX_DAT(11),'string',num2str(freq));
    set(SIGDWX_DAT(12),'value',freq);

    [t,f,w,F]=tffunc(amp,freq);
    set(SIGDWX_DAT(9),'YData',f);
    set(SIGDWX_DAT(10),'YData',F);

    drawnow;

elseif strcmp(action,'setfreq'),
    if (in1==1),    % set from slider
        SIGDWX_DAT(1)=get(SIGDWX_DAT(12),'value');
    else  % set from edit text
        min_freq=SIGDWX_DAT(3);
        max_freq=SIGDWX_DAT(4);
        freq=str2num(get(SIGDWX_DAT(11),'string'));
        if isempty(freq),    % handle non-numeric input into field
            set(SIGDWX_DAT(11),'string',num2str(SIGDWX_DAT(1)));
        else
            if (freq>max_freq),
                freq=max_freq;
            end;
            if (freq<min_freq),
               freq=min_freq;
            end;
            SIGDWX_DAT(1)=freq;
        end
    end

elseif strcmp(action,'info'),
    ttlStr='调制频率';
 
    hlpStr1= [ ...                                              
         ' 　　　　　　　　　　　　　　　　　　　　　　　　'
         ' 　　演示窗口上给出的是连续信号的时域表征（上面的'
         ' 波形）与它的傅立叶变换（下面的波形）。时域信号是'
         ' 高斯脉冲经一个特定频率的余弦信号相乘或调制后的已'
         ' 调制信号。通过改变调制信号的频率，以及改变时域信'
         ' 号的幅值，就可以看到信号在时域与频域的变化情况。' ];
    hlpStr2= [ ...                                               
         ' 　　　　　　　　　　　　　　　　　　　　　　　　'
         ' 单击并拖动显示波形上的一点，可以移动波形，从而设'  
         ' 置新的调制频率和幅值。　　　　　　　　　　　　　'  
         ' 　　　　　　　　　　　　　　　　　　　　　　　　'  
         ' 图形下面的文本框给出了波形的调制频率。这一调制频'  
         ' 率可通过单击并拖动任一波形上的点来修订，也可通过'  
         ' 单击选中文本框，编辑一个值再按下回车键或移动文本'  
         ' 框外的指针来设置。　　　　　　　　　　　　　　　'  
         ' 　　　　　　　　　　　　　　　　　　　　　　　　'  
         ' 文本框上的滚动条控制监视着调制频率的变化，通过单'  
         ' 击并拖动滚动条，也可设置调制频率。　　　　　　　' ];
 
    
 
     helpwin(ttlStr, hlpStr1, hlpStr2);

elseif strcmp(action,'done'),
    close(gcf);
    clear global SIGDWX_DAT

end
