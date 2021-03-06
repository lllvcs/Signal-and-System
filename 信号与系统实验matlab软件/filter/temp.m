%===========================
% START
global hrb gi_value;
global li_ftype li_passband li_model;
plot(0)
hrb=zeros(1,6);
l_cbstr='global hrb gi_value; set(hrb,''Value'',0); set(gco,''Value'',1); gi_value=get(gco,''UserData'');';
hfig=gcf;
l_color=get(hfig,'Color');
haxes=get(hfig,'CurrentAxes');
hinfo=findobj(hfig,'Tag','comments');
set(haxes,'Visible','off');
htitle=findobj(hfig,'Tag','afd_title_01');
hfrm=findobj(hfig,'Tag','afd_frame_01');
hstr=findobj(hfig,'Tag','afd_string_01');
hrb=[findobj(hfig,'Tag','afd_radio_01'),findobj(hfig,'Tag','afd_radio_02'),findobj(hfig,'Tag','afd_radio_03'),findobj(hfig,'Tag','afd_radio_04'),findobj(hfig,'Tag','afd_radio_05'),findobj(hfig,'Tag','afd_radio_06')];
htxt1=[findobj(hfig,'Tag','afd_txt1_01'),findobj(hfig,'Tag','afd_txt1_02'),findobj(hfig,'Tag','afd_txt1_03'),findobj(hfig,'Tag','afd_txt1_04'),findobj(hfig,'Tag','afd_txt1_05')];
hedit=[findobj(hfig,'Tag','afd_edit_01'),findobj(hfig,'Tag','afd_edit_02'),findobj(hfig,'Tag','afd_edit_03'),findobj(hfig,'Tag','afd_edit_04'),findobj(hfig,'Tag','afd_edit_05')];
htxt2=[findobj(hfig,'Tag','afd_txt2_01'),findobj(hfig,'Tag','afd_txt2_02'),findobj(hfig,'Tag','afd_txt2_03'),findobj(hfig,'Tag','afd_txt2_04'),findobj(hfig,'Tag','afd_txt2_05')];
if ~isempty(htitle),
   set(htitle,'Visible','on');
else,
   htitle=uicontrol(hfig,'Style','text','String','滤波器设计','Units','normalized','Position',[0.1 0.92 0.2 0.05],'FontSize',14,'BackgroundColor',l_color,'HorizontalAlignment','left','Tag','afd_title_01');
end;
if ~isempty(hfrm),
   set(hfrm,'Visible','off');
else,
   hfrm=uicontrol(hfig,'Style','frame','Units','normalized','Position',[0.12 0.5 0.55 0.4],'Visible','off','Tag','afd_frame_01');
end;
if ~isempty(hstr),
   set(hstr,'Visible','off');
else,
   hstr=uicontrol(hfig,'Style','text','String',' ','Units','normalized','Position',[0.15 0.83 0.5 0.05],'FontSize',10,'HorizontalAlignment','left','Visible','off','Tag','afd_string_01');
end;
if ~isempty(hrb),
   set(hrb,'Visible','off');
else,
   hrb(1)=uicontrol(hfig,'Style','radiobutton','String','单项选择钮一','Units','normalized','Position',[0.23 0.77 0.4 0.05],'FontSize',10,'HorizontalAlignment','left','Callback',l_cbstr,'UserData',1,'Visible','off','Tag','afd_radio_01');
   hrb(2)=uicontrol(hfig,'Style','radiobutton','String','单项选择钮二','Units','normalized','Position',[0.23 0.72 0.4 0.05],'FontSize',10,'HorizontalAlignment','left','Callback',l_cbstr,'UserData',2,'Visible','off','Tag','afd_radio_02');
   hrb(3)=uicontrol(hfig,'Style','radiobutton','String','单项选择钮三','Units','normalized','Position',[0.23 0.67 0.4 0.05],'FontSize',10,'HorizontalAlignment','left','Callback',l_cbstr,'UserData',3,'Visible','off','Tag','afd_radio_03');
   hrb(4)=uicontrol(hfig,'Style','radiobutton','String','单项选择钮四','Units','normalized','Position',[0.23 0.62 0.4 0.05],'FontSize',10,'HorizontalAlignment','left','Callback',l_cbstr,'UserData',4,'Visible','off','Tag','afd_radio_04');
   hrb(5)=uicontrol(hfig,'Style','radiobutton','String','单项选择钮五','Units','normalized','Position',[0.23 0.57 0.4 0.05],'FontSize',10,'HorizontalAlignment','left','Callback',l_cbstr,'UserData',5,'Visible','off','Tag','afd_radio_05');
   hrb(6)=uicontrol(hfig,'Style','radiobutton','String','单项选择钮六','Units','normalized','Position',[0.23 0.52 0.4 0.05],'FontSize',10,'HorizontalAlignment','left','Callback',l_cbstr,'UserData',6,'Visible','off','Tag','afd_radio_06');
end;
if ~isempty(htxt1),
   set(htxt1,'Visible','off');
else,
   htxt1(1)=uicontrol(hfig,'Style','text','String','文本一','Units','normalized','Position',[0.23 0.77 0.25 0.05],'FontSize',10,'HorizontalAlignment','right','Visible','off','Tag','afd_txt1_01');
   htxt1(2)=uicontrol(hfig,'Style','text','String','文本二','Units','normalized','Position',[0.23 0.72 0.25 0.05],'FontSize',10,'HorizontalAlignment','right','Visible','off','Tag','afd_txt1_02');
   htxt1(3)=uicontrol(hfig,'Style','text','String','文本三','Units','normalized','Position',[0.23 0.67 0.25 0.05],'FontSize',10,'HorizontalAlignment','right','Visible','off','Tag','afd_txt1_03');
   htxt1(4)=uicontrol(hfig,'Style','text','String','文本四','Units','normalized','Position',[0.23 0.62 0.25 0.05],'FontSize',10,'HorizontalAlignment','right','Visible','off','Tag','afd_txt1_04');
   htxt1(5)=uicontrol(hfig,'Style','text','String','文本五','Units','normalized','Position',[0.23 0.57 0.25 0.05],'FontSize',10,'HorizontalAlignment','right','Visible','off','Tag','afd_txt1_05');
end;
if ~isempty(hedit),
   set(hedit,'Visible','off');
else,
   hedit(1)=uicontrol(hfig,'Style','edit','String','','Units','normalized','Position',[0.485 0.772 0.1 0.045],'FontSize',9,'HorizontalAlignment','right','Visible','off','Tag','afd_edit_01','BackgroundColor',[1 1 1]);
   hedit(2)=uicontrol(hfig,'Style','edit','String','','Units','normalized','Position',[0.485 0.722 0.1 0.045],'FontSize',9,'HorizontalAlignment','right','Visible','off','Tag','afd_edit_02','BackgroundColor',[1 1 1]);
   hedit(3)=uicontrol(hfig,'Style','edit','String','','Units','normalized','Position',[0.485 0.672 0.1 0.045],'FontSize',9,'HorizontalAlignment','right','Visible','off','Tag','afd_edit_03','BackgroundColor',[1 1 1]);
   hedit(4)=uicontrol(hfig,'Style','edit','String','','Units','normalized','Position',[0.485 0.622 0.1 0.045],'FontSize',9,'HorizontalAlignment','right','Visible','off','Tag','afd_edit_04','BackgroundColor',[1 1 1]);
   hedit(5)=uicontrol(hfig,'Style','edit','String','','Units','normalized','Position',[0.485 0.572 0.1 0.045],'FontSize',9,'HorizontalAlignment','right','Visible','off','Tag','afd_edit_05','BackgroundColor',[1 1 1]);
end;
if ~isempty(htxt2),
   set(htxt2,'Visible','off');
else,
   htxt2(1)=uicontrol(hfig,'Style','text','String','单位一','Units','normalized','Position',[0.59 0.77 0.04 0.05],'FontSize',10,'HorizontalAlignment','left','Visible','off','Tag','afd_txt2_01');
   htxt2(2)=uicontrol(hfig,'Style','text','String','单位二','Units','normalized','Position',[0.59 0.72 0.04 0.05],'FontSize',10,'HorizontalAlignment','left','Visible','off','Tag','afd_txt2_02');
   htxt2(3)=uicontrol(hfig,'Style','text','String','单位三','Units','normalized','Position',[0.59 0.67 0.04 0.05],'FontSize',10,'HorizontalAlignment','left','Visible','off','Tag','afd_txt2_03');
   htxt2(4)=uicontrol(hfig,'Style','text','String','单位四','Units','normalized','Position',[0.59 0.62 0.04 0.05],'FontSize',10,'HorizontalAlignment','left','Visible','off','Tag','afd_txt2_04');
   htxt2(5)=uicontrol(hfig,'Style','text','String','单位五','Units','normalized','Position',[0.59 0.57 0.04 0.05],'FontSize',10,'HorizontalAlignment','left','Visible','off','Tag','afd_txt2_05');
end;
set(hstr,'Visible','on','String','欢迎使用滤波器设计向导');
gi_value=1;
li_ftype=1;
li_passband=1;
li_model=1;
li_step=0;

%===========================
% STEP 1
set(haxes,'Visible','off');
set(htxt1,'Visible','off')
set(hedit,'Visible','off')
set(htxt2,'Visible','off')
set(hfrm,'Visible','on');
set(hstr,'Visible','on','String','请您选择滤波器类型（AF／DF）：');
set(hrb,'Visible','off');
set(hrb(1),'Visible','on','String','模拟滤波器');
set(hrb(2),'Visible','on','String','数字滤波器');
set(hrb,'Value',0);
set(hrb(li_ftype),'Value',1);
li_step=1;

%===========================
% STEP 2
if li_step==1,
   li_ftype=get(findobj(hrb,'Value',1),'UserData');
end;
if li_ftype==1,
   set(haxes,'Visible','off');
   set(htxt1,'Visible','off')
   set(hedit,'Visible','off')
   set(htxt2,'Visible','off')
   set(hfrm,'Visible','on');
   set(hstr,'Visible','on','String','请您选择滤波器的通带形式（LP/BP/HP）：');
   set(hrb,'Value',0);
   set(hrb(li_passband),'Value',1);
   set(hrb,'Visible','off');
   set(hrb(1),'Visible','on','String','低通滤波器');
   set(hrb(2),'Visible','on','String','带通滤波器');
   set(hrb(3),'Visible','on','String','高通滤波器');
end;
li_step=2;

%===========================
% STEP 3
if li_ftype==1,
   if li_step==2,
      li_passband=get(findobj(hrb,'Value',1),'UserData');
   end;
   set(haxes,'Visible','off');
   set(htxt1,'Visible','off')
   set(hedit,'Visible','off')
   set(htxt2,'Visible','off')
   set(hfrm,'Visible','on');
   set(hstr,'Visible','on','String','请您选择滤波器的设计模型：');
   set(hrb,'Value',0);
   set(hrb(li_model),'Value',1);
   set(hrb,'Visible','off');
   set(hrb(1),'Visible','on','String','巴特沃斯(Butterworth)');
   set(hrb(2),'Visible','on','String','切比雪夫Ⅰ型(Chebyshev type Ⅰ)');
   set(hrb(3),'Visible','on','String','切比雪夫Ⅱ型(Chebyshev type Ⅱ)');
   %TagStr={'Butter';'Cheb1';'Cheb2'};
end;
li_step=3;

%===========================
% STEP 4
plot(0)
if li_ftype==1,
   if li_step==3,
      li_model=get(findobj(hrb,'Value',1),'UserData');
      if li_passband==1,
         Wp=1000; % 通带截止频率 Hz
         Rp=3;    % 通带最大衰减 dB
         Ws=1500; % 阻带最低频率 Hz
         Rs=20;   % 阻带最小衰减 dB
      elseif li_passband==2,
         W0=1000; % 通带中心频率 Hz
         Bp=200;  % 通带带宽     Hz
         Rp=3;    % 通带最大衰减 dB
         Bs=300;  % 阻带最小偏移 Hz
         Rs=20;   % 阻带最小衰减 dB
      elseif li_passband==3,
         Wp=1000; % 通带截止频率 Hz
         Rp=3;    % 通带最大衰减 dB
         Ws=500;  % 阻带最高频率 Hz
         Rs=20;   % 阻带最小衰减 dB
      end;
   end;
   set(haxes,'Visible','off');
   set(hfrm,'Visible','on');
   set(hrb,'Visible','off');
   if li_passband==1,
      set(hstr,'Visible','on','String','请输入低通滤波器的特征参数：');
      set(htxt1(1),'Visible','on','String','通带截止频率')
      set(hedit(1),'Visible','on','String',num2str(Wp))
      set(htxt2(1),'Visible','on','String','Hz')
      set(htxt1(2),'Visible','on','String','通带最大衰减')
      set(hedit(2),'Visible','on','String',num2str(Rp))
      set(htxt2(2),'Visible','on','String','dB')
      set(htxt1(3),'Visible','on','String','阻带最低频率')
      set(hedit(3),'Visible','on','String',num2str(Ws))
      set(htxt2(3),'Visible','on','String','Hz')
      set(htxt1(4),'Visible','on','String','阻带最小衰减')
      set(hedit(4),'Visible','on','String',num2str(Rs))
      set(htxt2(4),'Visible','on','String','dB')
      set(htxt1(5),'Visible','off')
      set(hedit(5),'Visible','off')
      set(htxt2(5),'Visible','off')
   elseif li_passband==2,
      set(hstr,'Visible','on','String','请输入带通滤波器的特征参数：');
      set(htxt1(1),'Visible','on','String','通带中心频率')
      set(hedit(1),'Visible','on','String',num2str(W0))
      set(htxt2(1),'Visible','on','String','Hz')
      set(htxt1(2),'Visible','on','String','通带带宽')
      set(hedit(2),'Visible','on','String',num2str(Bp))
      set(htxt2(2),'Visible','on','String','Hz')
      set(htxt1(3),'Visible','on','String','通带最大衰减')
      set(hedit(3),'Visible','on','String',num2str(Rp))
      set(htxt2(3),'Visible','on','String','dB')
      set(htxt1(4),'Visible','on','String','阻带最小偏移')
      set(hedit(4),'Visible','on','String',num2str(Bs))
      set(htxt2(4),'Visible','on','String','Hz')
      set(htxt1(5),'Visible','on','String','阻带最小衰减')
      set(hedit(5),'Visible','on','String',num2str(Rs))
      set(htxt2(5),'Visible','on','String','dB')
   elseif li_passband==3,
      set(hstr,'Visible','on','String','请输入高通滤波器的特征参数：');
      set(htxt1(1),'Visible','on','String','通带截止频率')
      set(hedit(1),'Visible','on','String',num2str(Wp))
      set(htxt2(1),'Visible','on','String','Hz')
      set(htxt1(2),'Visible','on','String','通带最大衰减')
      set(hedit(2),'Visible','on','String',num2str(Rp))
      set(htxt2(2),'Visible','on','String','dB')
      set(htxt1(3),'Visible','on','String','阻带最高频率')
      set(hedit(3),'Visible','on','String',num2str(Ws))
      set(htxt2(3),'Visible','on','String','Hz')
      set(htxt1(4),'Visible','on','String','阻带最小衰减')
      set(hedit(4),'Visible','on','String',num2str(Rs))
      set(htxt2(4),'Visible','on','String','dB')
      set(htxt1(5),'Visible','off')
      set(hedit(5),'Visible','off')
      set(htxt2(5),'Visible','off')
   end;
end;
li_step=4;

%===========================
% STEP 5
if li_ftype==1,
   ls_text=['==================================' char(10)];
   ls_text=[ls_text '　滤波器设计向导第五步：原型变换' char(10)];
   ls_text=[ls_text '==================================' char(10)];
   if li_step==4,
      ParamStrs=get(hedit,'string');
   end;
   set(haxes,'Visible','off');
   set(hfrm,'Visible','off');
   set(hstr,'Visible','off');
   set(hrb,'Visible','off');
   set(htxt1,'Visible','off')
   set(hedit,'Visible','off')
   set(htxt2,'Visible','off')
   if li_passband==1,                   % 低通滤波器的特征参数
      Wp=str2num(char(ParamStrs(1))); % 通带截止频率 Hz
      Rp=str2num(char(ParamStrs(2))); % 通带最大衰减 dB
      Ws=str2num(char(ParamStrs(3))); % 阻带最低频率 Hz
      Rs=str2num(char(ParamStrs(4))); % 阻带最小衰减 dB
      Normal_Ws=Ws/Wp;
      ls_text=[ls_text '　　归一化低通原型结果为' char(10) '　截止频率：1Hz；' char(10) '　阻带最低频率：' num2str(Normal_Ws) 'Hz。'];
   elseif li_passband==2,               % 带通滤波器的特征参数
      W0=str2num(char(ParamStrs(1))); % 通带中心频率 Hz
      Bp=str2num(char(ParamStrs(2))); % 通带带宽     Hz
      Rp=str2num(char(ParamStrs(3))); % 通带最大衰减 dB
      Bs=str2num(char(ParamStrs(4))); % 阻带最小偏移 Hz
      Rs=str2num(char(ParamStrs(5))); % 阻带最小衰减 dB
      Ws_LP=((W0+Bs)/W0-1/((W0+Bs)/W0))/(Bp/W0);
      Normal_Ws=Ws_LP;
      ls_text=[ls_text '　　首先以带通滤波器的中心频率为单位频率，进行参数归一化：'];
      ls_text=[ls_text '则归一化带通滤波器的中心频率为1Hz，带宽为' num2str(Bp/W0) 'Hz，'];
      ls_text=[ls_text '阻带最小偏移为' num2str(Bs/W0) 'Hz。' char(10)];
      ls_text=[ls_text '由频率变换公式 Ω=(β-1/β)/α，得到此带通滤波器的归一化低通原型为：'];
      ls_text=[ls_text '截止频率 1Hz，通带最大衰减 ' num2str(Rp) 'dB，'];
      ls_text=[ls_text '阻带最低频率 ' num2str(Ws_LP) 'Hz，阻带最小衰减 ' num2str(Rs) 'dB。'];
   elseif li_passband==3,               % 高通滤波器的特征参数
      Wp=str2num(char(ParamStrs(1))); % 通带截止频率 Hz
      Rp=str2num(char(ParamStrs(2))); % 通带最大衰减 dB
      Ws=str2num(char(ParamStrs(3))); % 阻带最高频率 Hz
      Rs=str2num(char(ParamStrs(4))); % 阻带最小衰减 dB
      Normal_Ws=Ws/Wp;
      ls_text=[ls_text '　　对高通滤波器的特征参数进行归一化：将通带截至频率归一化为1Hz，则阻带最高频率相应为' num2str(Normal_Ws) 'Hz。'];
      ls_text=[ls_text char(10) '再利用频率变换公式 Ω=1/β，得到此归一化高通滤波器的低通原型：'];
      ls_text=[ls_text '通带截止频率 1Hz；通带最大衰减 ' char(ParamStrs(2)) 'dB；'];
      ls_text=[ls_text '阻带最低频率 ' num2str(1/Normal_Ws) 'Hz；阻带最小衰减 ' char(ParamStrs(4)) 'dB。'];
      Normal_Ws=1/Normal_Ws;
   end;
   set(haxes,'visible','on');
   semilogy([0:0.2:1 1:0.2:Normal_Ws Normal_Ws:0.2:2*Normal_Ws],[logspace(0,-Rp,1/0.2+1) logspace(-Rp,-Rs,(Normal_Ws-1)/0.2+1) logspace(-Rs,-(Rs+2),Normal_Ws/0.2+1)]);
   set(hinfo,'String',ls_text)
end;
li_step=5;

%===========================
% STEP 6
plot(0)
if li_ftype==1,
   ls_text=['==================================' char(10)];
   ls_text=[ls_text '　滤波器设计向导第六步：原型设计' char(10)];
   ls_text=[ls_text '==================================' char(10)];
   set(haxes,'Visible','on');
   set(hfrm,'Visible','off');
   set(hstr,'Visible','off');
   set(hrb,'Visible','off');
   set(htxt1,'Visible','off')
   set(hedit,'Visible','off')
   set(htxt2,'Visible','off')
   switch li_model
   case 1,
      ls_flt='巴特沃斯';
      [n,Wn]=buttord(2*pi,2*pi*Normal_Ws,Rp,Rs,'s');
      [B,A]=butter(n,Wn,'s');
   case 2,
      ls_flt='切比雪夫Ⅰ型';
      [n,Wn]=cheb1ord(2*pi,2*pi*Normal_Ws,Rp,Rs,'s');
      [B,A]=cheby1(n,Rp,Wn,'s');
   case 3,
      ls_flt='切比雪夫Ⅱ型';
      [n,Wn]=cheb2ord(2*pi,2*pi*Normal_Ws,Rp,Rs,'s');
      [B,A]=cheby2(n,Rs,Wn,'s');
   end;
   ls_text=[ls_text '　　根据上述要求，计算得' char(10) '　　“' ls_flt '”原型（归一化）低通滤波器的阶数为 ' num2str(n) '阶，'];
   ls_text=[ls_text '3dB频率点为 ' num2str(Wn/(2*pi)) 'Hz。'];
   ls_text=[ls_text char(10) '其频率响应如上图所示。'];
   freqss(B,A);
   set(hinfo,'String',ls_text)
end;
li_step=6;

%===========================
% STEP 7
if li_ftype==1,
   ls_text=['==================================' char(10)];
   ls_text=[ls_text '　滤波器设计向导第七步：逆向变换' char(10)];
   ls_text=[ls_text '==================================' char(10)];
   set(haxes,'Visible','on');
   set(hfrm,'Visible','off');
   set(hstr,'Visible','off');
   set(hrb,'Visible','off');
   set(htxt1,'Visible','off')
   set(hedit,'Visible','off')
   set(htxt2,'Visible','off')
   if li_passband==1,                   % 低通滤波器
      switch li_model,
      case 1,
         [B,A]=butter(n,Wn*Wp,'s');
      case 2,
         [B,A]=cheby1(n,Rp,Wn*Wp,'s');
      case 3,
         [B,A]=cheby2(n,Rs,Wn*Wp,'s');
      end;
      ls_text=[ls_text '　　最后，进行参数反归一化，便可得到欲设计的“' ls_flt '”低通滤波器'];
      ls_text=[ls_text char(10) '　　逼近阶数：' num2str(n) '阶'];
      ls_text=[ls_text char(10) '　　3dB频率点：' num2str(Wn*Wp/(2*pi)) 'Hz'];
      ls_text=[ls_text char(10) '其频率响应如上图所示。'];
      freqss(B,A);
   elseif li_passband==2,               % 带通滤波器
      Bp1=(Bp/2)/W0;
      Bs1=Bs/W0;
      Wp=2*pi*[1-Bp1 1+Bp1];
      Ws=2*pi*[1-Bs1 1+Bs1];
      switch li_model,
      case 1,
         [n,Wn]=buttord(Wp,Ws,Rp,Rs,'s');
         [B,A]=butter(n,Wn,'s');
      case 2,
         [n,Wn]=cheb1ord(Wp,Ws,Rp,Rs,'s');
         [B,A]=cheby1(n,Rp,Wn,'s');
      case 3,
         [n,Wn]=cheb2ord(Wp,Ws,Rp,Rs,'s');
         [B,A]=cheby2(n,Rs,Wn,'s');
      end;      
      ls_text=[ls_text '　　接着，应用频率反变换公式 β=sqrt(1+(αΩ/2)^2)±(αΩ/2)，'];
      ls_text=[ls_text '即可得到归一化的“' ls_flt '”带通滤波器的参数'];
      ls_text=[ls_text char(10) '　　逼近阶数：' num2str(n) '阶'];
      ls_text=[ls_text char(10) '　　3dB频率点：' num2str(Wn(1)/(2*pi)) 'Hz，' num2str(Wn(2)/(2*pi)) 'Hz'];
      ls_text=[ls_text char(10) '此归一化带通滤波器的频率响应如上图所示。'];
      freqss(B,A);
   elseif li_passband==3,               % 高通滤波器
      switch li_model,
      case 1,
         [n,Wn]=buttord(2*pi,2*pi*(1/Normal_Ws),Rp,Rs,'s');
         [B,A]=butter(n,Wn,'high','s');
      case 2,
         [n,Wn]=cheb1ord(2*pi,2*pi*(1/Normal_Ws),Rp,Rs,'s');
         [B,A]=cheby1(n,Rp,Wn,'high','s');
      case 3,
         [n,Wn]=cheb2ord(2*pi,2*pi*(1/Normal_Ws),Rp,Rs,'s');
         [B,A]=cheby2(n,Rs,Wn,'high','s');
      end;
      ls_text=[ls_text '　　接着，应用频率反变换公式 β=1/Ω，即可得到归一化的“' ls_flt '”高通滤波器的参数'];
      ls_text=[ls_text char(10) '　　逼近阶数：' num2str(n) '阶'];
      ls_text=[ls_text char(10) '　　3dB频率点:' num2str(Wn/(2*pi)) 'Hz'];
      ls_text=[ls_text char(10) '此归一化高通滤波器的频率响应如上图所示。'];
      freqss(B,A);
   end;
   set(hinfo,'String',ls_text)
end;
li_step=7;

%===========================
% STEP 8
if li_ftype==1,
   ls_text=['==================================' char(10)];
   ls_text=[ls_text '　滤波器设计向导第八步：最终结果' char(10)];
   ls_text=[ls_text '==================================' char(10)];
   set(haxes,'Visible','on');
   set(hfrm,'Visible','off');
   set(hstr,'Visible','off');
   set(hrb,'Visible','off');
   set(htxt1,'Visible','off')
   set(hedit,'Visible','off')
   set(htxt2,'Visible','off')
   if li_passband==1,                   % 低通滤波器
      ls_text=[ls_text '　　“' ls_flt '”低通滤波器设计完毕。'];
   elseif li_passband==2,               % 带通滤波器
      Wp=2*pi*[W0-Bp/2 W0+Bp/2];
      Ws=2*pi*[W0-Bs W0+Bs];
      switch li_model,
      case 1,
         [n,Wn]=buttord(Wp,Ws,Rp,Rs,'s');
         [B,A]=butter(n,Wn,'s');
      case 2,
         [n,Wn]=cheb1ord(Wp,Ws,Rp,Rs,'s');
         [B,A]=cheby1(n,Rp,Wn,'s');
      case 3,
         [n,Wn]=cheb2ord(Wp,Ws,Rp,Rs,'s');
         [B,A]=cheby2(n,Rs,Wn,'s');
      end;      
      ls_text=[ls_text '　　最后，进行参数反归一化，便可得到欲设计的“' ls_flt '”带通滤波器'];
      ls_text=[ls_text char(10) '　　逼近阶数：' num2str(n) '阶'];
      ls_text=[ls_text char(10) '　　3dB频率点：' num2str(Wn(1)/(2*pi)) 'Hz，' num2str(Wn(2)/(2*pi)) 'Hz'];
      ls_text=[ls_text char(10) '其频率响应如上图所示。' char(10) '设计完毕。'];
      freqss(B,A);
   elseif li_passband==3,               % 高通滤波器
      switch li_model,
      case 1,
         [n,Wn]=buttord(2*pi*Wp,2*pi*Ws,Rp,Rs,'s');
         [B,A]=butter(n,Wn,'high','s');
      case 2,
         [n,Wn]=cheb1ord(2*pi*Wp,2*pi*Ws,Rp,Rs,'s');
         [B,A]=cheby1(n,Rp,Wn,'high','s');
      case 3,
         [n,Wn]=cheb2ord(2*pi*Wp,2*pi*Ws,Rp,Rs,'s');
         [B,A]=cheby2(n,Rs,Wn,'high','s');
      end;
      ls_text=[ls_text '　　最后，进行参数反归一化，便可得到欲设计的“' ls_flt '”高通滤波器'];
      ls_text=[ls_text char(10) '　　逼近阶数：' num2str(n) '阶'];
      ls_text=[ls_text char(10) '　　3dB频率点：' num2str(Wn/(2*pi)) 'Hz'];
      ls_text=[ls_text char(10) '其频率响应如上图所示。' char(10) '设计完毕。'];
      freqss(B,A);
   end;
   set(hinfo,'String',ls_text)
end;
li_step=8;
