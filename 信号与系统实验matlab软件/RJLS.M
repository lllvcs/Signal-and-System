function rjls(action,in1,in2);
%rjls 系统特性演示 - 1 : 二阶离散系统
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
%     'setC'

if nargin<1,
    action='start';
end;

global rjls_DAT
%global ADDIT_DAT	% this is for WINDOW pop-up button
global fun_str
global Ts
if strcmp(action,'start'),

    %====================================
    % Graphics initialization
    oldFigNumber = watchon;
    figNumber = figure;
    set(gcf, ...
        'NumberTitle','off', ...
        'Name','二阶离散系统特性', ...
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
    labelStr='二阶离散系统 ';
    labelPos=[left yLabelPos-labelHt labelWid labelHt];
    uicontrol( ...
        'Style','text', ...
        'Units','normalized', ...
        'Position',labelPos, ...
        'BackgroundColor',labelColor, ...
        'HorizontalAlignment','left', ...
        'String',labelStr);

    btnPos=[left yLabelPos-labelHt-btnHt-btnOffset btnWid btnHt];
    popup=uicontrol('Style','Popup','String','二阶离散系统',...
        'Position', btnPos, ...
        'BackgroundColor','w', ...
        'ForegroundColor','k', ...
        'Units','normalized',...
        'CallBack',[...
		'global rjls_DAT;',...
		'popup=rjls_DAT(11);',...
		'val = get(popup,''Value'');',...
		'if val<=2',...
		'	rjls(''redraw'');',...
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
    labelPos=[left yLabelPos-labelHt-0.10 labelWid+0.02 labelHt];
    R_text = uicontrol( ...
        'Style','text', ...
        'Position', labelPos, ...
        'Units','normalized', ...
        'BackgroundColor',[0.5 0.5 0.5], ...
        'ForegroundColor','g', ...
        'HorizontalAlignment','left', ...
        'String','极点的模(r[0 1])：');

    btnPos=[left+0.02  yLabelPos-labelHt-btnHt-btnOffset-0.10 ...
            0.4*btnWid+frmBorder  btnHt];
    R_field = uicontrol( ...
        'Style','edit', ...
        'BackgroundColor','w', ...
        'ForegroundColor','k', ...
        'Position', btnPos, ...
        'Units','normalized', ...
        'HorizontalAlignment','left', ...
        'String','1/4',...
        'CallBack','rjls(''setR''); rjls(''redraw'')');

    %====================================
    %
     % The FUNDAMENTAL editable text box
    btnNumber=3;
    yLabelPos=top-(btnNumber-1)*(btnHt+labelHt+spacing);
    labelPos=[left yLabelPos-labelHt-0.15 labelWid labelHt];
    C_text = uicontrol( ...
        'Style','text', ...
        'Position', labelPos, ...
        'Units','normalized', ...
        'BackgroundColor',[0.5 0.5 0.5], ...
        'ForegroundColor','g', ...
        'HorizontalAlignment','left', ...
        'String','极点的相位：');

   btnPos=[left+0.02  yLabelPos-labelHt-btnHt-btnOffset-0.15 ...
            0.4*btnWid+frmBorder  btnHt];
    C_field = uicontrol( ...
        'Style','edit', ...
        'BackgroundColor','w', ...
        'ForegroundColor','k', ...
        'Position', btnPos, ...
        'Units','normalized', ...
        'HorizontalAlignment','left', ...
        'String','0',...
        'CallBack','rjls(''setC''); rjls(''redraw'')');


       % The CLOSE button
    done_button=uicontrol('Style','Pushbutton', ...
        'Position',[left bottom btnWid 2*labelHt], ...
        'Units','normalized','Callback',...
        'rjls(''done'')','String','关闭');
   %====================================
    % Create intial signal
    N=100;     % number of samples
    Ts=100;
    C=0;
    R=1/4;    % hertz
   % t=R*C;
      w=linspace(-2*pi,2*pi);
       M=100;     % length of fft
    window=ones(N,1);    % use window to lower side-lobes in the freq. domain
                             % (makes peaks wider)
   
     ax_pha=axes('Position',[.12 .14 .6 .3],'XLim',...
             [-2*pi,2*pi],'YLim',[-2 2]);
     %ax_win=axes('Position',[left yLabelPos-labelHt-0.1 labelWid 2*labelHt]);
    % time domain
    val = get(popup,'Value');
  
    if (val == 1),
         num=[1 0 0];den=[1 -2*R*cos(C) R*R];
[mag,phase]=dbode(num,den,Ts,w);

%       num=[1 0];den=[1 -R];
%[m,p]=bode(num,den,w);
p=phase;
p=p*pi./180;

elseif (val == 2),   % high pass
num=[t 0];den=[t 1];
[m,p]=bode(num,den,w);
p=p*pi./180;
   end;

pha_line= plot(w,p, '-','markersize',8,'EraseMode','xor');
      axis([-2*pi 2*pi -2 2]);

    grid;
    ylabel('相频特性');
    xlabel('频率 (Hz)');

    ax_amp=axes('Position',[.12 .58 .6 .3],'XLim',[-2*pi 2*pi],'YLim',[-10 30]);
    amp_line= plot(w,20*log10(mag),'-','markersize',8,'EraseMode','xor');
   axis([-2*pi 2*pi -10 30]);
    %ax_ax=axes('Position',[.52 .18 .6 .3]);
    % (set to xor mode to prevent re-rendering, that is, for speed)
    grid;
    ylabel('幅频特性');
    xlabel('频率 (Hz)');
    text(-2.00, 35.25,'二阶系统的波特图');

   %set(amp_line,'ButtonDownFcn','rjls(''down'')');
    %set(pha_line,'ButtonDownFcn','rjls(''down'')');

    rjls_DAT = [R; C; N; M; C_field; 0; 0; ...
		amp_line; pha_line; R_field; popup; -1; gcf; ...
		w(:); window(:); 0];
    %ADDIT_DAT = winHndl;

    watchoff(oldFigNumber);

elseif strcmp(action,'down'),

  popup=rjls_DAT(11);
  val = get(popup,'value');
  if val<=2
    % assumes that a line was clicked
    amp_line=rjls_DAT(8);
    axes(get(amp_line,'parent'));	% set the right axes

%     Obtain coordinates of mouse click location in axes units
    pt=get(gca,'currentpoint');
    x=pt(1,1);
    y=pt(1,2);


% find closest vertex of line to mouse click location (call it fixed_x, fixed_y)

    line_x=get(amp_line,'XData');
    line_y=get(amp_line,'YData');
    units_str = get(gca,'units');  % save normalized state
    set(gca,'units','pixels');     % distance must be in pixels
    pp=get(gca,'pos');
    xa=get(gca,'xlim');
    ya=get(gca,'ylim');
    
    dist=((line_x-x)*pp(3)/(xa(2)-xa(1))).^2 + ...
         ((line_y-y)*pp(4)/(ya(2)-ya(1))).^2;
    [temp,i]=min(dist);
    fixed_x=line_x(i);
    fixed_y=line_y(i);
    set(amp_line,'LineStyle',':');

    rjls_DAT(6)=fixed_x;
    rjls_DAT(7)=fixed_y;

    set(gca,'units',units_str );
    set(gcf,'WindowButtonMotionFcn', 'rjls(''move'')');
    set(gcf,'WindowButtonUpFcn', 'rjls(''up'')');
  %  set(gcf,'userdata',u);
end

elseif strcmp(action,'move'),
    % u = get(gcf,'userdata');
    R=rjls_DAT(1);
    C=rjls_DAT(2);
    N=rjls_DAT(3);
    M=rjls_DAT(4);
    C_field=rjls_DAT(5);
    fixed_x=rjls_DAT(6);
    fixed_y=rjls_DAT(7);
    amp_line=rjls_DAT(8);
    pha_line=rjls_DAT(9);
    R_field=rjls_DAT(10);
    popup=rjls_DAT(11);
    w=rjls_DAT(14:14+N-1);
    window=rjls_DAT(14+N:14+N+N-1);

    pt=get(gca,'currentpoint');
    x=pt(1,1);
    y=pt(1,2);

     val = get(popup,'Value');
       t=R*C;
    if (val == 1),
           num=[0 1];den=[t 1];
   [m,p]=bode(num,den,w);
       p=p*pi./180;
    elseif (val == 2),   % high pass
            num=[t 0];den=[t 1];
[m,p]=bode(num,den,w);
     p=p*pi./180;
end;

      set(amp_line,'YData',m);
    
    set(pha_line,'YData',p);
    set(R_field,'String',num2str(R));
   set(C_field,'String',num2str(C));
 
%elseif strcmp(action,'up'),
    pt=get(gca,'currentpoint');
    x=pt(1,1);
    y=pt(1,2);

    set(gcf,'WindowButtonMotionFcn','');
    set(gcf,'WindowButtonUpFcn','');

    % u=get(gcf,'userdata');
    R=rjls_DAT(1);
    C=rjls_DAT(2);
    fixed_x=rjls_DAT(6);
    fixed_y=rjls_DAT(7);

  

    set(rjls_DAT(8),'linestyle','-','markersize',8);
    rjls_DAT(1)=R;  % set amplitude and frequency
    rjls_DAT(2)=C;
    % set(gcf,'userdata',u);
    rjls('redraw');

elseif strcmp(action,'done'),
    % close the figure window that is showing the window fnction:
    % u = get(gcf,'userdata');
    show_window=findobj('Tag','window_window');
    if ( ~isempty(show_window) & rjls_DAT(12)~=-1 )
    	close(rjls_DAT(12));
    end;
    close(gcf);
    clear global rjls_DAT
    clear global ADDIT_DAT
    clear global fun_str
    clear show_window

elseif strcmp(action,'redraw'),
    % recomputes time and frequency waveforms and updates display
     %u = get(gcf,'userdata');
    R=rjls_DAT(1);
    C=rjls_DAT(2);
    N=rjls_DAT(3);
    M=rjls_DAT(4);
    C_field=rjls_DAT(5);
    amp_line=rjls_DAT(8);
    pha_line=rjls_DAT(9);
    R_field=rjls_DAT(10);
    popup=rjls_DAT(11);
    w=rjls_DAT(14:14+N-1);
    window=rjls_DAT(14+N:14+N+N-1);
    val = get(popup,'Value');
      %t=R*C;
      if (val == 1),
          num=[1 0 0];den=[1 -2*R*cos(C) R*R];
[mag,phase]=dbode(num,den,Ts,w);
p=phase;   
          p=p*pi./180;
    elseif (val == 2),   % high pass
  num=[t 0];den=[t 1];
[m,p]=bode(num,den,w);
  p=p*pi./180;
end;

       set(amp_line,'YData', 20*log10(mag));
    %  amp_line= semilogx(w,20*log10(m));
  %grid
       set(pha_line,'YData',p);
    set(R_field,'String',num2str(R));
    set(C_field,'String',num2str(C));
    drawnow;

   
 elseif strcmp(action,'setR'),
       x = str2num(get(rjls_DAT(10),'String'));
    if isempty(x),   % handle the non-numeric case
        set(rjls_DAT(10),'String',num2str(rjls_DAT(1)));
    else
        rjls_DAT(1)=x;
end;

elseif strcmp(action,'setC'),
       x = str2num(get(rjls_DAT(5),'String'));
    if isempty(x),   % handle the non-numeric case
        set(rjls_DAT(10),'String',num2str(rjls_DAT(2)));
    else
        rjls_DAT(2)=x;
    end;



end
