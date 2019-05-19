function [infostr,paraData]=uf_lp_norm(paraHandle);
% UF_LP_NORM 滤波器设计面向低通原型进行参数归一化
%            输入参数：均为uicontrol对象，分别指向
%              paraHandle(1) - 设计模型(BUTTER/CHEBY)
%              paraHandle(1) - 通带形式(LP/HP/BP/BS)
%              paraHandle(3:8) - 滤波器各项参数
%            输出参量：
%              infostr - 说明信息
%              paraData - 归一化结果
%                  对于BUTTER型，输出3dB带宽、……
%
%                  对于CHEBY型，带宽、……
%
%            axz 1999-11-05

fltModel=get(paraHandle(1),'Value');
fltBtype=get(paraHandle(2),'Value');

infostr = '' ;
order = 0 ;
B = 0;

switch fltBtype,
case 1,         % LP
   fp=str2num(get(paraHandle(3),'String'));   % 通带截止频率
   Ap=str2num(get(paraHandle(4),'String'));   % 通带最大衰减
   fr=str2num(get(paraHandle(5),'String'));   % 阻带最低频率
   Ar=str2num(get(paraHandle(6),'String'));   % 阻带最小衰减
   Ro=str2num(get(paraHandle(7),'String'));   % 基准电阻值
   if fltModel==1 & Ap~=3,
      % 得到满足条件的巴特沃斯低通原型滤波器的最小阶数
      order = ceil( log10( (10 .^ (0.1*abs(Ar)) - 1)./ ...
         (10 .^ (0.1*abs(Ap)) - 1) ) / (2*log10(fr/fp)) );
      % 计算 3dB 频率带宽
      fp = fp / ( (10^(0.1*abs(Ap)) - 1)^(1/(2*order)) );
      Ap = 3;
      infostr=['注：该巴特沃斯低通滤波器的通带技术指标不是3dB带宽，经过换算可得其3dB带宽为' num2str(fp) 'Hz。' char(10)];
   end
   flr_n = fr / fp;
   infostr = [infostr ...
         ' ⑴ 　　　　　＿' char(10) ...
         '　　根据公式　Ωr=Ωr/Ωc，可得归一化阻带频率为 ' num2str(flr_n) '。' char(10)];
   ls_xh = ' ⑵ ';
   fc = fp;
   ls_omega = '';
case 2,         % HP
   fp=str2num(get(paraHandle(3),'String'));   % 通带截止频率
   Ap=str2num(get(paraHandle(4),'String'));   % 通带最大衰减
   fr=str2num(get(paraHandle(5),'String'));   % 阻带最高频率
   Ar=str2num(get(paraHandle(6),'String'));   % 阻带最小衰减
   Ro=str2num(get(paraHandle(7),'String'));   % 基准电阻值
   if fltModel==1 & Ap~=3,
      Ap = 3;
      infostr=['注：这里，巴特沃斯高通滤波器的通带技术指标限定为3dB带宽。' char(10)];
      set(paraHandle(4),'String','3');
   end;
   fhr_n = fr / fp;
   flr_n = 1 / fhr_n;
   infostr=[infostr ' ⑴ 对高通滤波器技术指标进行频率归一化，以通带截止频率为归一化因子有：' char(10)];
   infostr=[infostr '　　＿      　＿' char(10)];
   infostr=[infostr '　　Ωhp = 1；Ωhr = ' num2str(fhr_n) char(10)];
   infostr=[infostr ' ⑵ 将高通的技术指标转换成低通原型的技术指标，根据公式 Ωl=1/Ωh，' ...
         '可得相应低通原型的归一化截止频率为' char(10)];
   infostr=[infostr '　　＿     ＿    　＿     ＿' char(10)];
   infostr=[infostr '　　Ωlp=1/Ωhp=1；Ωlr=1/Ωhr=' num2str(flr_n) char(10)];
   ls_xh = ' ⑶ ';
   fc = fp;
   ls_omega = '';
case 3,         % BP
   fpo=str2num(get(paraHandle(3),'String'));   % 通带中心频率
   fpw=str2num(get(paraHandle(4),'String'));   % 通带带宽
   Ap =str2num(get(paraHandle(5),'String'));   % 通带最大衰减
   frb=str2num(get(paraHandle(6),'String'));   % 阻带最小偏移
   Ar =str2num(get(paraHandle(7),'String'));   % 阻带最小衰减
   Ro =str2num(get(paraHandle(8),'String'));   % 基准电阻值
   if fltModel==1 & Ap~=3,
      Ap = 3;
      infostr=['注：这里，巴特沃斯带通滤波器的通带技术指标限定为3dB带宽。' char(10)];
      set(paraHandle(5),'String','3');
   end;
   fp2 = ( fpw + sqrt(fpw^2 + 4*fpo^2) ) / 2;    % 上通带截止频率
   fp1 = ( - fpw + sqrt(fpw^2 + 4*fpo^2) ) / 2;  % 下通带截止频率
   flp_n = (fp2^2 - fpo^2) / (fpw * fp2);
   flr_n = ((fpo+frb)^2 - fpo^2) / (fpw * (fpo+frb));
   infostr=[infostr ' ⑴ 计算带通滤波器的技术指标，根据公式 Ωo=sqrt(Ω1*Ω2)；B=Ω2-Ω1，' ...
         '可以得到该带通滤波器的上、下通带截止频率分别为' char(10) ...
         '　　　Ω2=2π*' num2str(fp2) 'rad/s；Ω1=2π*' num2str(fp1) 'rad/s' char(10)];
   infostr=[infostr ' ⑵ 将带通滤波器的技术指标转换成低通原型的技术指标' char(10) ...
         '　　根据公式 Ωl = (Ωb^2 - Ωo^2) / (B * Ωb)，' char(10) ...
         '　　将上通带截止频率转换为低通原型的通带截止频率，上阻带截止频率转换为低通原型的阻带截止频率：' char(10) ...
         '　　　Ωlp=' num2str(flp_n) '；Ωlr=' num2str(flr_n) char(10)];
   ls_xh = ' ⑶ ';
   fc = fpo; B = fpw;
   ls_omega = '=Ωo';
case 4,         % BS
   fro=str2num(get(paraHandle(3),'String'));   % 阻带中心频率
   frw=str2num(get(paraHandle(4),'String'));   % 阻带带宽
   Ap =str2num(get(paraHandle(5),'String'));   % 通带最大衰减
   frb=str2num(get(paraHandle(6),'String'));   % 规定阻带偏移
   Ar =str2num(get(paraHandle(7),'String'));   % 对应阻带衰减
   Ro =str2num(get(paraHandle(8),'String'));   % 基准电阻值
   if fltModel==1 & Ap~=3,
      Ap = 3;
      infostr=['注：这里，巴特沃斯带阻滤波器的通带技术指标限定为3dB。' char(10)];
      set(paraHandle(5),'String','3');
   end;
   fr2 = ( frw + sqrt(frw^2 + 4*fro^2) ) / 2;    % 上阻带截止频率
   fr1 = ( - frw + sqrt(frw^2 + 4*fro^2) ) / 2;  % 下阻带截止频率
   flp_n = (frw * fr1) / (fro^2 - fr1^2) ;
   flr_n = (frw * (fro-frb)) / (fro^2 - (fro-frb)^2) ;
   infostr=[infostr ' ⑴ 计算带阻滤波器的技术指标，根据公式 Ωo=sqrt(Ω1*Ω2)；B=Ω2-Ω1，' ...
         '可以得到该带阻滤波器的上、下阻带截止频率分别为' char(10) ...
         '　　　Ω2=2π*' num2str(fr2) 'rad/s；Ω1=2π*' num2str(fr1) 'rad/s' char(10)];
   infostr=[infostr ' ⑵ 将带阻滤波器的技术指标转换成低通原型的技术指标' char(10) ...
         '　　根据公式 Ωl = B * Ωr / (Ωo^2 - Ωr^2)，' char(10) ...
         '　　将阻带下截止频率转换为低通原型的通带截止频率，所规定的阻带下偏移频率转换为低通原型的阻带截止频率：' char(10) ...
         '　　　Ωlp=' num2str(flp_n) '；Ωlr=' num2str(flr_n) char(10)];
   ls_xh = ' ⑶ ';
   fc = fro; B = frw;
   ls_omega = '=Ωo';
end;

Kl = Ro/(2*pi*fc);
Kc = 1 /(Ro*2*pi*fc);
infostr=[infostr ls_xh '阻抗归一化转换系数，这里 Ωc' ls_omega '=2π*' num2str(fc) 'rad/s' char(10) ...
      '　　根据公式 Kl=Ro/Ωc， 得电感转换系数为 ' num2str(Kl) char(10) ...
      '　　根据公式 Kc=1/ΩcRo，得电容转换系数为 ' num2str(Kc)];

% index : 5  6     7  8     9  10 11  12 13
paraData=[fc;flr_n;Ar;order;Kl;Kc;-Ap;Ro;B];
   
