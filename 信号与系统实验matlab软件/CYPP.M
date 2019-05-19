%function cypp
%===========================================================
%
%CYPP  频谱显示 
%      CYPP是连续时间信号抽样中的频谱显示函数。使用该函数时，
%      必须先做连续时间信号的抽样实验。
%
%===========================================================

%global t z1 z2 z3 z4
  
if exist('chou_shi_t'),
   N=length(chou_shi_t);
   Ts=(chou_shi_t(N) - chou_shi_t(1))/N;
   m=floor(N/32);
   Ws=2*pi/Ts;  W=Ws*(0:m)/N;
   F=fft(chou_shi_z1,N);  FF=F(1:m+1)*Ts;  F11=abs(FF);  
   F=fft(chou_shi_z2,N);  FF=F(1:m+1)*Ts;  F12=abs(FF); 
   F=fft(chou_shi_z3,N);  FF=F(1:m+1)*Ts;  F13=abs(FF); 
   F=fft(chou_shi_z4,N);  FF=F(1:m+1)*Ts;  F14=abs(FF); 

   set(0,'DefaultAxesColor','k')
   set(0,'DefaultFigureColor',[0.7 0.7 0.7])
   figure,  zoom on
   subplot(2,2,1)
   plot(W,F11,'y',-W,F11,'y'),  title('输入信号的幅频特性')
   xlabel('频率（Rad/s）'),   grid
   subplot(2,2,2)
   plot(W,F12,'y',-W,F12,'y'),  title('滤波后信号的幅频特性')
   xlabel('频率（Rad/s）'),   grid
   subplot(2,2,3)
   plot(W,F13,'y',-W,F13,'y'),  title('抽样后信号的幅频特性')
   xlabel('频率（Rad/s）'),   grid
   subplot(2,2,4)
   plot(W,F14,'y',-W,F14,'y'),  title('恢复信号的幅频特性')
   xlabel('频率（Rad/s）'),   grid
   clear F FF F11 N m F12 Ts F13 W F14 Ws
else,
   helpdlg('    请先做抽样实验然后再看频谱！',...
           '     频谱显示');
end;
