% show window script
%

figure

axes('Position',[.15 .62 .8 .3]);
plot(t,window); 
title('窗口函数');
xlabel('时间（秒）');
grid;
ylabel('窗口');

axes('Position',[.15 .2 .8 .3]);
[W,omega]=freqz(window,1,512);
plot(omega/2/pi/T,20*log10(abs(W))); 
set(gca,'xlim',[0 1/(2*T)]);
xlabel('频率 (Hz)');
ylabel('幅度 (dB)');
grid;
windclose=uicontrol('Style','Pushbutton','Position',[.85 .02 .12 .08],...
	'Units','normalized','Callback','close','String','关闭');
