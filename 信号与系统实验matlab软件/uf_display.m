function uf_display(option)

h_frame=get(gcf,'UserData');
h_option=get(h_frame(4),'UserData');
h_button=get(h_frame(3),'UserData');
h_fmenus=get(h_frame(1),'UserData');

li_model=get(h_fmenus(1),'Value');
paraData=get(h_option(6),'UserData');
n=paraData(8);             % 滤波器阶数
Ap=abs(paraData(11));      % 通带起伏

axes(h_option(1));

switch option,
case 1,
   ls_style=lower(deblankall(get(h_option(4),'Style')));
   zoom out
   if get(h_option(7),'Value'),
      zoom off;
      set(h_option(7),'Value',0)
   end;
   if strcmp(ls_style(1:5),'check'),
      % [min(l_omega);max(l_omega);min(l_array);max(l_array);Flp;Alp]
      lxylim=get(h_option(3),'UserData');
      lb_showpass=get(h_option(4),'Value');
      lb_showstop=get(h_option(5),'Value');
      if lb_showpass & lb_showstop,       % 全频带
         set(h_option(1),'Visible','on', ...
            'XLim',lxylim([1 2]),'XGrid','on', ...
            'YLim',lxylim([3 4]),'YGrid','on');
      elseif lb_showpass & ~lb_showstop,  % 通带
         set(h_option(1),'Visible','on', ...
            'XLim',lxylim([1 5]),'XGrid','on', ...
            'YLim',lxylim([6 4]),'YGrid','on');
      elseif ~lb_showpass & lb_showstop,  % 阻带
         set(h_option(1),'Visible','on', ...
            'XLim',lxylim([5 2]),'XGrid','on', ...
            'YLim',lxylim([3 6]),'YGrid','on');
      else,
         set(h_option(1),'XLim',[0 0.1],'YLim',[0 0.1]);
      end;
   elseif strcmp(ls_style(1:5),'radio'),
      set(h_option([4 5]),'Value',0);
      set(gco,'Value',1);
      if li_model==1,
         fmodel='butter';
         annex=0;
      elseif li_model==2,
         fmodel='cheby1';
         annex=Ap;
      elseif li_model==3,
         
      end;
      if get(h_option(4),'Value'),         % 分母多项式系数表
         [TblTitle,TblList,Tbldenpoly]=uf_dentbl(fmodel,n,annex);
         set(h_option(8),'UserData',Tbldenpoly);
         set(h_option(6),'Visible','off','String','定位');
      else,
         [TblTitle,TblList,TblComponent]=uf_cmptbl(fmodel,n,annex);
         set(h_option(9),'UserData',TblComponent);
         set(h_option(6),'Visible','on','String','电路');
      end;
      set(h_option(9),'String',TblTitle);
      set(h_option(8),'String',TblList, ...
         'Value',n+1,'Enable','inactive');
   end;
case 2,
   %
   if strcmp(get(h_option(6),'String'),'电路'),
      uf_fltcircuit(get(h_fmenus(2),'Value'));
      return;
   end;
   %
   set(gcf,'Pointer','watch');
   set(h_option(6),'Enable','off');
   h_tmp=paraData(1:4);
   Omega_norm=paraData(6);       % 归一化阻带频率
   Ar=paraData(7);               % 阻带最小衰减
   h_curve=get(h_option(1),'UserData');
   set(h_option(1),'NextPlot', 'add');  % , ...  'XTick',[],'YTick',[]
   set(h_curve,'LineWidth',0.5,'Visible','on');
   if h_tmp(1)~=0, delete(h_tmp); end
   % scan x
   Omega=linspace(0.1,Omega_norm,10);
   h_tmp(1)=semilogx([0 0],[0 1],':');
   for i=1:length(Omega),
      delete(h_tmp(1));
      h_tmp(1)=semilogx([Omega(i) Omega(i)],[-200 1],'-.');
      drawnow
      pause(0.3)
   end;
   % scan y
   magnitude=linspace(0.1,Ar,10);
   h_tmp(2)=semilogx([0.1 10],[1 1],':');
   for i=1:length(magnitude),
      delete(h_tmp(2));
      h_tmp(2)=semilogx([0.1 10],[-magnitude(i) -magnitude(i)],'-.');
      drawnow
      pause(0.3)
   end;
   % point
   h_tmp(3)=semilogx(Omega_norm,-abs(Ar),'ro');
   drawnow
   pause(0.3)
   % show order selecting
   Ar_order=0;  n=0;
   epsilon = sqrt(10^(.1*Ap)-1);
   h_tmp(4)=semilogx(Omega_norm,0);
   while (abs(Ar_order)<abs(Ar) & n<10),
      delete(h_tmp(4));
      n=n+1;
      if li_model==1,     % butter
         Ar_order = - 10 * log10( 1 + Omega_norm.^(2*n) );
      elseif li_model==2, % cheby1
         Tn = cosh(n*acosh(Omega_norm));
         Ar_order = - 10 * log10( 1 + epsilon^2 * Tn^2 );
      elseif li_model==3, % cheby2
         
         
      end;
      h_tmp(4)=semilogx(Omega_norm,Ar_order,'ms');
      drawnow
      pause(0.3)
   end;
   h_tmp=h_tmp(:);
   paraData(1:4)=h_tmp;
   paraData(8)=n;                % 滤波器最小阶数
   ls_string=get(h_option(2),'String');
   if n < 10,
      ls_info = ['查图可知，满足设计条件的滤波器最小阶数应为' int2str(n) '阶。'];
      set(h_curve((n+1):length(h_curve)),'Visible','off');
      set(h_button(3),'Enable','on');
   else,
      ls_info = '抱歉，满足设计要求的滤波器阶数将大于9阶，本向导尚不能支持，请重新选择滤波器参数。';
      set(h_button(3),'Enable','off');
   end;
   ls_string = str2mat( ls_string, ls_info );
   set(h_option(1),'NextPlot','replace');  % , ...
   %   'XTick',Omega_norm,'XTickLabel',['Ωc=' num2str(Omega_norm)], ...
   %   'YTick',-Ar,'YTickLabel',[num2str(-Ar) 'dB']
   set(h_curve(n),'LineWidth',2,'Visible','on');
   set(h_option(2),'String',ls_string);
   set(h_option(6),'UserData',paraData,'Enable','on');
   set(gcf,'Pointer','arrow');
case 3,
   if get(h_option(7),'Value'),
      zoom on;
   else,
      zoom off;
   end;
end;

   