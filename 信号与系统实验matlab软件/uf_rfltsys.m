function [Fsystrans,omega,Array,Textinfo]=uf_rfltsys(pbtype);
% UF_RFLTSYS 由低通原型转换到实际滤波器的传递函数。
%            输入参数：
%              pbtype - 通带类型（lp/hp/bp/bs）

pbtype=deblankall(lower(pbtype));

h_frame=get(gcf,'UserData');
h_fmenus=get(h_frame(1),'UserData');
h_fparas=get(h_frame(2),'UserData');
h_button=get(h_frame(3),'UserData');
h_option=get(h_frame(4),'UserData');

paraData=get(h_option(6),'UserData');
denpoly=get(h_option(8),'UserData');

if get(h_fmenus(1),'Value')==1,  % butter
   k=1;               % 增益
else,                            % cheby
   k=denpoly(1);      % 增益
   denpoly=denpoly(2:length(denpoly));
end;

Fc=paraData(5);       % 低通截止频率
order=paraData(8);    % 低通原型阶数

denpoly=round(denpoly(1:order+1).*1e4)./1e4;  % 精确到四位小数
strpoly=uf_deblank(poly2str(denpoly,'s'));
densympoly=poly2sym(denpoly,'s');
numerator=num2str(k); % 分子

Textinfo = ['第四步，从归一化模拟低通变换到实际滤波器' char(10) ...
      '由第三步的计算得到归一化低通原型的系统函数为：' char(10) ...
      '　Hl(s) = ' numerator ' / (' strpoly ')' char(10) ];

Slen=400;
Array=zeros(1,Slen);

if strcmp(pbtype,'lp'),       % s → s/Ωc
   replace_sub=['(s/(2*pi*' num2str(Fc) '))'];
   Fsystrans=subs(symdiv(numerator,densympoly),'s',replace_sub);
   Fsystrans=simple(Fsystrans);
   Textinfo=[Textinfo '根据低通原型→实际低通的变换关系式 s → s/Ωc，' ...
         '将 s = ' replace_sub ' 代入上式可得所求低通滤波器的传递函数为' char(10)];
   MaxOmega=10*2*pi*Fc;
   MinOmega=max(2*pi*1,0.1*2*pi*Fc);
elseif strcmp(pbtype,'hp'),   % s → Ωc/s
   replace_sub=['(2*pi*' num2str(Fc) '/s)'];
   Fsystrans=subs(symdiv(numerator,densympoly),'s',replace_sub);
   Fsystrans=simple(Fsystrans);
   Textinfo=[Textinfo '根据低通原型→实际高通的变换关系式 s → Ωc/s，' ...
         '将 s = ' replace_sub ' 代入上式可得所求高通滤波器的传递函数为' char(10)];
   MaxOmega=10*2*pi*Fc;
   MinOmega=max(2*pi*1,0.1*2*pi*Fc);
elseif strcmp(pbtype,'bp'),
   fpo=str2num(get(h_fparas(1,2),'String'));   % 通带中心频率
   fpw=str2num(get(h_fparas(2,2),'String'));   % 通带带宽
   frb=str2num(get(h_fparas(4,2),'String'));   % 阻带最小偏移
   replace_sub=['((s^2+(2*pi*' num2str(fpo) ')^2)/(s*(2*pi*' num2str(fpw) ')))'];
   Fsystrans=subs(symdiv(numerator,densympoly),'s',replace_sub);
   Fsystrans=simple(Fsystrans);
   Textinfo=[Textinfo '根据低通原型→实际带通的变换关系式 s → (s^2+Ωo^2)/(s*B)，' ...
         '将 s = ' replace_sub ' 代入上式可得所求带通滤波器的传递函数为' char(10)];
   %MaxOmega=2*pi*(fpo+50*frb);
   %MinOmega=max(2*pi*1,2*pi*(fpo-5*frb));
   MaxOmega=10*2*pi*fpo;
   MinOmega=max(2*pi*1,0.1*2*pi*fpo);
elseif strcmp(pbtype,'bs'),
   fro=str2num(get(h_fparas(1,2),'String'));   % 阻带中心频率
   frw=str2num(get(h_fparas(2,2),'String'));   % 阻带带宽
   frb=str2num(get(h_fparas(4,2),'String'));   % 规定阻带偏移
   replace_sub=['((s*2*pi*' num2str(frw) ')/(s^2+(2*pi*' num2str(fro) ')^2))'];
   Fsystrans=subs(symdiv(numerator,densympoly),'s',replace_sub);
   Fsystrans=simple(Fsystrans);
   Textinfo=[Textinfo '根据低通原型→实际带阻的变换关系式 s → s*B/(s^2+Ωo^2)，' ...
         '将 s = ' replace_sub ' 代入上式可得所求带阻滤波器的传递函数为' char(10)];
   %MaxOmega=2*pi*(fpo+50*frb);
   %MinOmega=max(2*pi*1,2*pi*(fpo-5*frb));
   MaxOmega=10*2*pi*fro;
   MinOmega=max(2*pi*1,0.1*2*pi*fro);
end;

omega=linspace(MinOmega,MaxOmega,Slen);   % radians/second
[Fnum,Fden]=numden(Fsystrans);
Fnumpoly=sym2poly(Fnum);
Fdenpoly=sym2poly(Fden);
Fnumstr=uf_deblank(poly2str(Fnumpoly,'s'));
Fdenstr=uf_deblank(poly2str(Fdenpoly,'s'));
Textinfo=[Textinfo '　H(s) = ( ' Fnumstr ' ) / ( ' Fdenstr ' )' char(10) ...
      '其幅频特性如右上图所示。'];
Fnumval=polyval(Fnumpoly,i.*omega);
Fdenval=polyval(Fdenpoly,i.*omega);
Array=abs(Fnumval./Fdenval);
omega=omega./(2*pi);
Array = 20 .* log10( Array );
