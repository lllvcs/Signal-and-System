function ii_rtn = uf_fltstp ( ah_figNumber, ai_dir ) ;
% UF_FLTSTP 用于“查表法设计模拟滤波器”的设计步骤演示函数
%           输入参数：
%             ah_figNumber - 滤波器设计GUI界面句柄（anflttbl1.m）
%             ai_dir - 演示方向。1，下一步（默认）；-1，上一步；0，初始化。

if nargin<1, error('必须指定输入参数：图像句柄。'); end

if nargin<2, ai_dir=1; end

h_frame=get(ah_figNumber,'UserData');

li_step=h_frame(5);
if ai_dir==-1,
   if li_step>0,
      li_step=li_step-1;
   else,         % 从最后一步倒退
      li_step=3;
   end;
elseif ai_dir==1,
   li_step=li_step+1;
end

h_fmenus=get(h_frame(1),'UserData');
h_fparas=get(h_frame(2),'UserData');
h_button=get(h_frame(3),'UserData');
h_option=get(h_frame(4),'UserData');

if li_step==0,
   uf_fltclose(0);
   set(h_fmenus,'Enable','on');
   set(h_fparas(:,2),'Enable','on');
   if ai_dir==0,
      set(h_fmenus,'Value',1);
      uf_setpara(h_fmenus(2));
   end
   set(h_button(2),'Visible','off');
   set(h_button(3),'String','开　始');
   set(h_frame(4),'Visible','off');
   set(h_option(3:9),'Visible','off');
   %
   axes(h_option(1));
   %[x,map]=imread('images/sns1.bmp','bmp');
   load('.\images\fig_cover.mat');
   image(x);
   colormap(map);
   clear x map;
   set(h_option(1),'Visible','off');
   %
   set(h_option(2),'String','开始，滤波器参数输入')
elseif li_step==1,
   set(h_fmenus,'Enable','inactive');
   set(h_fparas(:,2),'Enable','inactive');
   set(h_button(2),'Visible','on');
   set(h_button(3),'String','下一步');
   set(h_button(3),'Enable','on');
   set(h_frame(4),'Visible','off');
   set(h_option(3:9),'Visible','off');
   %
   [ls_info,ld_para]=uf_lp_norm([h_fmenus;h_fparas(:,2)]);
   %
   set(h_option(2),'String',['第一步，滤波器面向低通原型参数归一化' char(10) ls_info])
   set(h_option(6),'UserData',[zeros(4,1); ld_para])
elseif li_step==2,
   uf_fltclose(0);
   set(h_button(3),'Enable','off');
   set(h_frame(4),'Visible','on');
   set(h_option,'Visible','on');
   set(h_option([8 9]),'Visible','off');
   set(h_option(4),'Value',1,'Style','check','String','通带');
   set(h_option(5),'Value',1,'Style','check','String','阻带');
   paraData=get(h_option(6),'UserData');
   paraData(1:4)=zeros(4,1);
   Omega_norm=paraData(6);       % 归一化阻带频率
   Ar=paraData(7);               % 阻带最小衰减
   Alp=paraData(11);             % 通带最大衰减
   set(h_option(6),'UserData',paraData,'String','定位');
   % 说明文字
   set(h_option(2),'String',['第二步，查图表以确定阶数' char(10) ...
         '由第一步的计算已知：' char(10) ...
         '　　归一化阻带频率为 ' num2str(Omega_norm) char(10) ...
         '　　　阻带最小衰减为 ' num2str(Ar) 'dB' char(10) ...
         '根据上述参数可以通过查右上方的图表来定滤波器阶数。' char(10) ...
         '按下“定位”按钮，可看到动态演示。'])
   % 幅频特性数据
   li_model=get(h_fmenus(1),'Value');
   ls_label=get(h_fmenus(1),'String');
   if li_model==1,
      [l_omega,l_array]=uf_lp_curve('butter');
   elseif li_model==2,
      [l_omega,l_array]=uf_lp_curve('cheby1',abs(Alp));  % Alp 通带起伏
   elseif li_model==3,
      [l_omega,l_array]=uf_lp_curve('cheby2',abs(Ar));   % Ar  阻带起伏
   end
   % 绘制曲线
   axes(h_option(1));
   h_curve=semilogx(l_omega,l_array);
   set(h_curve,'LineWidth',0.5);
   set(h_option(1),'UserData',h_curve);
   xlabel('归一化频率','Fontsize',8);
   ylabel('幅值（dB）','Fontsize',8);
   title(['1至' int2str(size(l_array,1)) '阶' deblankall(ls_label(li_model,:)) '低通原型滤波器幅频特性' ])
   set(h_option(3),'UserData',[min(l_omega);max(l_omega);-100;0;1;Alp]);
   uf_display(1);
elseif li_step==3,
   set(h_button(3),'Enable','on','String','下一步');
   set(h_frame(4),'Visible','on');
   set(h_option,'Visible','on');
   set(h_option([1 6 7]),'Visible','off');
   set(h_option(4),'Value',1,'Style','radio','String','系统函数');
   set(h_option(5),'Value',0,'Style','radio','String','元件值');
   paraData=get(h_option(6),'UserData');
   order=paraData(8);
   % 说明文字
   set(h_option(2),'String',['第三步，归一化分母多项式与元件值表' char(10) ...
         '由第二步的幅频特性曲线查得：' char(10) ...
         '　　滤波器最小阶数为 ' num2str(order) '阶' char(10) ...
         '则对应的归一化低通原型滤波器的分母多项式系数和电路元件值如上表所示。'])
   % 
   set(ah_figNumber,'CurrentObject',h_option(4));
   uf_display(1);
elseif li_step==4,
   set(gcf,'Pointer','watch')
   set(h_button(3),'Enable','off');
   set(h_frame(4),'Visible','on');
   set(h_option,'Visible','on');
   set(h_option([4 5 6 8 9]),'Visible','off');
   set(h_option(4),'Value',1,'Style','check','String','通带');
   set(h_option(5),'Value',1,'Style','check','String','阻带');
   paraData=get(h_option(6),'UserData');
   paraData(1:4)=zeros(4,1);
   order=paraData(8);
   set(h_option(6),'UserData',paraData);
   li_type=get(h_fmenus(1),'Value');
   ls_type=get(h_fmenus(1),'String');
   li_pass=get(h_fmenus(2),'Value');
   ls_pass=get(h_fmenus(2),'String');
   PassBandStr=['lp';'hp';'bp';'bs'];
   % 幅频特性数据、说明文字
   [Fsystrans,l_omega,l_array,Textinfo]=uf_rfltsys(PassBandStr(li_pass,:));
   % 绘制曲线
   axes(h_option(1));
   semilogx(l_omega,l_array)
   xlabel('频率（Hz）','Fontsize',8);
   ylabel('幅值（dB）','Fontsize',8);
   title([int2str(order) '阶' deblankall(ls_type(li_type,:)) ...
         deblankall(ls_pass(li_pass,:)) '的幅频特性' ]);
   set(h_option(2),'String',Textinfo);
   set(h_option(3),'UserData',[min(l_omega);max(l_omega);min(l_array);5;0;0])
   uf_display(1);
   li_step = -1;
   set(gcf,'Pointer','arrow');
   set(h_button(3),'String','结　束','Enable','on');
elseif li_step==5,
   
end;

h_frame(5)=li_step;
set(ah_figNumber,'UserData',h_frame);

if nargout > 0, ii_rtn=1; end