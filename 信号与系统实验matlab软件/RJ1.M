function rj1(action,in1,in2);
%rj1 系统特性演示 - 1 : 二阶系统
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

global rj1_DAT
%global ADDIT_DAT	% this is for WINDOW pop-up button
global fun_str

if strcmp(action,'start'),

    %====================================
    % Graphics initialization
    oldFigNumber = watchon;
    figNumber = figure;
    set(gcf, ...
        'NumberTitle','off', ...
        'Name','二阶系统特性', ...
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
    labelStr='RLC二阶系统 ';

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
    popup=uicontrol('Style','Popup','String','二阶低通',...
        'Units','normalized',...
        'Position', btnPos, ...
        'BackgroundColor','w', ...
        'ForegroundColor','k', ...
        'CallBack',[...
		'global rj1_DAT;',...
		'popup=rj1_DAT(11);',...
		'val = get(popup,''Value'');',...
		'if val<=2',...
		'	rj1(''redraw'');',...
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
        'String','无阻尼自然频率');

    btnPos=[left+0.02  yLabelPos-labelHt-btnHt-btnOffset-0.10 ...
            0.4*btnWid+frmBorder  btnHt];
    R_field = uicontrol( ...
        'Style','edit', ...
        'BackgroundColor','w', ...
        'ForegroundColor','k', ...
        'Position', btnPos, ...
        'Units','normalized', ...
        'HorizontalAlignment','left', ...
        'String','10',...
        'CallBack','rj1(''setR''); rj1(''redraw'')');

    %====================================
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
        'String','阻尼系数（）');

   btnPos=[left+0.02  yLabelPos-labelHt-btnHt-btnOffset-0.15 ...
            0.4*btnWid+frmBorder  btnHt];
    C_field = uicontrol( ...
        'Style','edit', ...
        'BackgroundColor','w', ...
        'ForegroundColor','k', ...
        'Position', btnPos, ...
        'Units','normalized', ...
        'HorizontalAlignment','left', ...
        'String','1',...
        'CallBack','rj1(''setC''); rj1(''redraw'')');


    % The MoXing button
   % val = get(popup,'Value');
    %if val==1
         
        % plot([0 2],[2,2]);
     %    end
         %========================================
    
   % The CLOSE button
    done_button=uicontrol('Style','Pushbutton', ...
        'Position',[left bottom btnWid 2*labelHt], ...
        'Units','normalized','Callback',...
        'rj1(''done'')','String','关闭');
   %====================================

    % Create intial signal
    N=50;     % number of samples
%    N=21;
    C=1;
    R=10;    % hertz
    t=R*C;
      w=logspace(-4,3);
       M=50;     % length of fft
    window=ones(N,1);    % use window to lower side-lobes in the freq. domain
                             % (makes peaks wider)
   
     ax_tu=axes('Position',[.12 .05 .6 .2],'XLim',...
             [-2,8],'YLim',[-5 5]);
     %ax_win=axes('Position',[left yLabelPos-labelHt-0.1 labelWid 2*labelHt]);
    % time domain
    val = get(popup,'Value');
  
    if (val == 1),
         num=[R*R];den=[1 2*R*C R*R];

%       num=[0 1];den=[t 1];
[m,p]=bode(num,den,w);
p=p*pi./180;
plot([0 1 1 1],[2 2 1.5 2.5],'k',[1 2],[2.5 2.5],'k',[1 2],[1.5 1.5],'k',[2 2],[2.5 1.5],'k',[2 3],[2,2],'k',[3:1/14:3.5],[2 2.5 2.707 2.866 2.866 2.707 2.5 2],'k',[3.5:1/14:4],[2 2.5 2.707 2.866 2.866 2.707 2.5 2],'k',[4:1/14:4.5],[2 2.5 2.707 2.866 2.866 2.707 2.5 2],'k',[4.5:1/14:5],[2 2.5 2.707 2.866 2.866 2.707 2.5 2],'k',[5 7],[2 2],'k',[6 6 5.5 6.5],[2 0 0 0],'k',[5.5 6.5],[-1 -1],'k',[6 6 7 0],[-1 -3 -3 -3],'k');
axis([-2 8 -5 5]);
hold off
ylabel('二阶系统模型');
text('position',[1.3 0.4],'string','R');
text('position',[6.7 -.5],'string','C'); 
text('position',[3.5 0.4],'string','L');

elseif (val == 2),   % high pass
num=[t 0];den=[t 1];
[m,p]=bode(num,den,w);
p=p*pi./180;
end;

ax_pha=axes('Position',[.12 .36 .6 .22],'XLim',[1e-2 1e5],'YLim',[-4 2]);

pha_line= semilogx(w,p, '-','markersize',8,'EraseMode','xor');
      axis([1e-2 1e5 -4 2]);

    grid;
    ylabel('相频特性(度）');
    xlabel('频率 (Hz)');

    ax_amp=axes('Position',[.12 .68 .6 .24],'XLim',[1e-2 1e5],'YLim',[-80 20]);
    amp_line= semilogx(w,20*log10(m),'-','markersize',8,'EraseMode','xor');
    axis([1e-2 1e5 -80 20]);
    %ax_ax=axes('Position',[.52 .18 .6 .3]);
    % (set to xor mode to prevent re-rendering, that is, for speed)
    grid;
    ylabel('幅频特性（dB)');
    %xlabel('频率 (Hz)');
    text(1.10, 35.25,'二阶系统的波特图');

   %set(amp_line,'ButtonDownFcn','rj1(''down'')');
    %set(pha_line,'ButtonDownFcn','rj1(''down'')');

    rj1_DAT = [R; C; N; M; C_field; 0; 0; ...
		amp_line; pha_line; R_field; popup; -1; gcf; ...
		w(:); window(:); 0];
    %ADDIT_DAT = winHndl;

    watchoff(oldFigNumber);

elseif strcmp(action,'down'),

  popup=rj1_DAT(11);
  val = get(popup,'value');
  if val<=2
    % assumes that a line was clicked
    amp_line=rj1_DAT(8);
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

    rj1_DAT(6)=fixed_x;
    rj1_DAT(7)=fixed_y;

    set(gca,'units',units_str );
    set(gcf,'WindowButtonMotionFcn', 'rj1(''move'')');
    set(gcf,'WindowButtonUpFcn', 'rj1(''up'')');
  %  set(gcf,'userdata',u);
end

elseif strcmp(action,'move'),
    % u = get(gcf,'userdata');
    R=rj1_DAT(1);
    C=rj1_DAT(2);
    N=rj1_DAT(3);
    M=rj1_DAT(4);
    C_field=rj1_DAT(5);
    fixed_x=rj1_DAT(6);
    fixed_y=rj1_DAT(7);
    amp_line=rj1_DAT(8);
    pha_line=rj1_DAT(9);
    R_field=rj1_DAT(10);
    popup=rj1_DAT(11);
    w=rj1_DAT(14:14+N-1);
    window=rj1_DAT(14+N:14+N+N-1);

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
    R=rj1_DAT(1);
    C=rj1_DAT(2);
    fixed_x=rj1_DAT(6);
    fixed_y=rj1_DAT(7);

  

    set(rj1_DAT(8),'linestyle','-','markersize',8);
    rj1_DAT(1)=R;  % set amplitude and frequency
    rj1_DAT(2)=C;
    % set(gcf,'userdata',u);
    rj1('redraw');

elseif strcmp(action,'done'),
    % close the figure window that is showing the window fnction:
    % u = get(gcf,'userdata');
    show_window=findobj('Tag','window_window');
    if ( ~isempty(show_window) & rj1_DAT(12)~=-1 )
    	close(rj1_DAT(12));
    end;
    close(gcf);
    clear global rj1_DAT
    clear global ADDIT_DAT
    clear global fun_str
    clear show_window

elseif strcmp(action,'redraw'),
    % recomputes time and frequency waveforms and updates display
     %u = get(gcf,'userdata');
    R=rj1_DAT(1);
    C=rj1_DAT(2);
    N=rj1_DAT(3);
    M=rj1_DAT(4);
    C_field=rj1_DAT(5);
    amp_line=rj1_DAT(8);
    pha_line=rj1_DAT(9);
    R_field=rj1_DAT(10);
    popup=rj1_DAT(11);
    w=rj1_DAT(14:14+N-1);
    window=rj1_DAT(14+N:14+N+N-1);
    val = get(popup,'Value');
      t=R*C;
       if (val == 1),
            num=[R*R];den=[1 2*R*C R*R];

       %     num=[0 1];den=[t 1];
     [m,p]=bode(num,den,w);
   p=p*pi./180;
    elseif (val == 2),   % high pass
  num=[t 0];den=[t 1];
[m,p]=bode(num,den,w);
  p=p*pi./180;
end;

       set(amp_line,'YData', 20*log10(m));
    %  amp_line= semilogx(w,20*log10(m));
  %grid
       set(pha_line,'YData',p);
    set(R_field,'String',num2str(R));
    set(C_field,'String',num2str(C));
    drawnow;

   
 elseif strcmp(action,'setR'),
       x = str2num(get(rj1_DAT(10),'String'));
    if isempty(x),   % handle the non-numeric case
        set(rj1_DAT(10),'String',num2str(rj1_DAT(1)));
    else
        rj1_DAT(1)=x;
end;

elseif strcmp(action,'setC'),
       x = str2num(get(rj1_DAT(5),'String'));
    if isempty(x),   % handle the non-numeric case
        set(rj1_DAT(10),'String',num2str(rj1_DAT(2)));
    else
        rj1_DAT(2)=x;
    end;



end
