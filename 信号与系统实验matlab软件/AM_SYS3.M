function [ret,x0,str,ts,xts]=am_sys3(t,x,u,flag);
%AM_SYS3	is the M-file description of the SIMULINK system named AM_SYS3.
%	AM_SYS3 has a the following characteristics:
%		20 continuous states
%		0 discrete states
%		0 outputs
%		0 inputs
%		does not have direct feedthrough
%		1 sample times
%
%	The block-diagram can be displayed by typing: AM_SYS3.
%
%	SYS=AM_SYS3(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes AM_SYS3 to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling AM_SYS3 with a FLAG of zero:
%	[SIZES]=AM_SYS3([],[],[],0),  returns a vector, SIZES, which
%	contains the sizes of the state vector and other parameters.
%		SIZES(1) number of states
%		SIZES(2) number of discrete states
%		SIZES(3) number of outputs
%		SIZES(4) number of inputs
%		SIZES(5) number of roots (currently unsupported)
%		SIZES(6) direct feedthrough flag
%		SIZES(7) number of sample times
%
%	For the definition of other parameters in SIZES, see SFUNC.
%	See also, TRIM, LINMOD, LINSIM, EULER, RK23, RK45, ADAMS, GEAR.

% Note: This M-file is only used for saving graphical information;
%       after the model is loaded into memory an internal model
%       representation is used.

% the system will take on the name of this mfile:
sys = mfilename;
new_system(sys)
simver(1.3)
if (0 == (nargin + nargout))
     set_param(sys,'Location',[46,48,563,441])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '1000')
set_param(sys,'Min step size', '0.00001')
set_param(sys,'Max step size', '0.001')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',   '')

add_block('built-in/Note',[sys,'/','同步解调'])
set_param([sys,'/','同步解调'],...
		'Font Name','宋体',...
		'Font Size',12,...
		'position',[260,350,265,355])

add_block('built-in/Note',[sys,'/','同步调制//解调 AM 系统 （ 单边带 SSB ）—— 滤波器法'])
set_param([sys,'/','同步调制//解调 AM 系统 （ 单边带 SSB ）—— 滤波器法'],...
		'Font Name','宋体',...
		'Font Size',12,...
		'position',[270,20,275,25])

add_block('built-in/Scope',[sys,'/','解调信号'])
set_param([sys,'/','解调信号'],...
		'Font Name','宋体',...
		'Font Size',12,...
		'Vgain','1.000000',...
		'Hgain','1.000000',...
		'Vmax','2.000000',...
		'Hmax','2.000000',...
		'Window',[121,143,452,457],...
		'position',[435,305,465,335])

add_block('built-in/Note',[sys,'/','上边带 SSB'])
set_param([sys,'/','上边带 SSB'],...
		'Font Name','宋体',...
		'Font Size',12,...
		'position',[190,290,195,295])

add_block('built-in/Note',[sys,'/','导频信号'])
set_param([sys,'/','导频信号'],...
		'Font Name','宋体',...
		'Font Size',12,...
		'position',[185,330,190,335])

add_block('built-in/Product',[sys,'/','乘法器1'])
set_param([sys,'/','乘法器1'],...
		'Font Name','宋体',...
		'Font Size',12,...
		'Mask Display','plot([0 1],[1 0],[0 1],[0 1]);',...
		'Mask Type','乘法器',...
		'Mask Dialogue','乘法器',...
		'position',[230,309,260,331])

add_block('built-in/Zero-Pole',[sys,'/',['Butterworth',13,'LP 滤波器']])
set_param([sys,'/',['Butterworth',13,'LP 滤波器']],...
		'Font Name','宋体',...
		'Font Size',12,...
		'Zeros','z',...
		'Poles','p',...
		'Gain','k',...
		'Mask Display','plot(20*log10(w),20*log10(abs(h)))',...
		'Mask Type','buttap')
set_param([sys,'/',['Butterworth',13,'LP 滤波器']],...
		'Mask Dialogue','Analog Butterworth low pass filter.\n\n(Requires Signal Processing Toolbox)|Cutoff frequency (rad/sec)|Order')
set_param([sys,'/',['Butterworth',13,'LP 滤波器']],...
		'Mask Translate','[z,p,k]=buttap(@2); z=@1*z; p=@1*p; k=real(prod(-p)); [num,den]=zp2tf(z,p,k); w=logspace(log10(@1/10),log10(10*@1),20); h=freqs(num,den,w); ')
set_param([sys,'/',['Butterworth',13,'LP 滤波器']],...
		'Mask Help','Butterworth low pass filter using MATLAB''s butter command.',...
		'Mask Entries','15\/4\/',...
		'position',[315,298,375,342])

add_block('built-in/Scope',[sys,'/','上边带信号'])
set_param([sys,'/','上边带信号'],...
		'ForeGround',3,...
		'Font Name','宋体',...
		'Font Size',12,...
		'Vgain','2.000000',...
		'Hgain','1.000000',...
		'Vmax','4.000000',...
		'Hmax','2.000000',...
		'Window',[66,10,397,324])
set_param([sys,'/','上边带信号'],...
		'position',[435,100,465,130])

add_block('built-in/Scope',[sys,'/','下边带信号'])
set_param([sys,'/','下边带信号'],...
		'ForeGround',3,...
		'Font Name','宋体',...
		'Font Size',12,...
		'Vgain','2.000000',...
		'Hgain','1.000000',...
		'Vmax','4.000000',...
		'Hmax','2.000000',...
		'Window',[61,154,392,468])
set_param([sys,'/','下边带信号'],...
		'position',[435,170,465,200])

add_block('built-in/Note',[sys,'/','DSB'])
set_param([sys,'/','DSB'],...
		'ForeGround',3,...
		'Font Name','宋体',...
		'Font Size',12,...
		'position',[250,120,255,125])

add_block('built-in/State-Space',[sys,'/',['Butterworth',13,'BP 滤波器 1']])
set_param([sys,'/',['Butterworth',13,'BP 滤波器 1']],...
		'ForeGround',3,...
		'Font Name','宋体',...
		'Font Size',12,...
		'A','at',...
		'B','bt',...
		'C','ct',...
		'D','dt',...
		'Mask Display','plot(w,mag)',...
		'Mask Type','buttap,lp2bp')
set_param([sys,'/',['Butterworth',13,'BP 滤波器 1']],...
		'Mask Dialogue','Analog Butterworth band pass filter.\n\n(Requires Signal Processing Toolbox)|Center frequency (rad/sec)|Bandwidth (rad/sec):|Order')
set_param([sys,'/',['Butterworth',13,'BP 滤波器 1']],...
		'Mask Translate','[at,bt,ct,dt,w,mag]=filtm(''buttap'',''lp2bp'',@1,@2,50,@3);',...
		'Mask Help','Butterworth band pass filter using MATLAB''s butter and lp2bp command.')
set_param([sys,'/',['Butterworth',13,'BP 滤波器 1']],...
		'Mask Entries','110\/5\/4\/',...
		'position',[295,94,355,136])

add_block('built-in/State-Space',[sys,'/',['Butterworth',13,'BP 滤波器 2']])
set_param([sys,'/',['Butterworth',13,'BP 滤波器 2']],...
		'ForeGround',3,...
		'Font Name','宋体',...
		'Font Size',12,...
		'A','at',...
		'B','bt',...
		'C','ct',...
		'D','dt',...
		'Mask Display','plot(w,mag)',...
		'Mask Type','buttap,lp2bp')
set_param([sys,'/',['Butterworth',13,'BP 滤波器 2']],...
		'Mask Dialogue','Analog Butterworth band pass filter.\n\n(Requires Signal Processing Toolbox)|Center frequency (rad/sec)|Bandwidth (rad/sec):|Order')
set_param([sys,'/',['Butterworth',13,'BP 滤波器 2']],...
		'Mask Translate','[at,bt,ct,dt,w,mag]=filtm(''buttap'',''lp2bp'',@1,@2,50,@3);',...
		'Mask Help','Butterworth band pass filter using MATLAB''s butter and lp2bp command.')
set_param([sys,'/',['Butterworth',13,'BP 滤波器 2']],...
		'Mask Entries','90\/5\/4\/',...
		'position',[295,164,355,206])

add_block('built-in/Signal Generator',[sys,'/',['信号发生器',13,'频率（弧度//秒）']])
set_param([sys,'/',['信号发生器',13,'频率（弧度//秒）']],...
		'ForeGround',3,...
		'Font Name','宋体',...
		'Font Size',12,...
		'Peak','1.000000',...
		'Peak Range','5.000000',...
		'Freq','10.000000',...
		'Freq Range','50.000000')
set_param([sys,'/',['信号发生器',13,'频率（弧度//秒）']],...
		'Wave','Sin',...
		'Units','Rads',...
		'position',[45,93,90,127])

add_block('built-in/Sine Wave',[sys,'/','载波'])
set_param([sys,'/','载波'],...
		'ForeGround',3,...
		'Font Name','宋体',...
		'Font Size',12,...
		'frequency','100',...
		'position',[55,160,75,180])

add_block('built-in/Note',[sys,'/',['cos ( Wc * t + p )',13,'Wc 载波角频率',13,'p 载波初始相位']])
set_param([sys,'/',['cos ( Wc * t + p )',13,'Wc 载波角频率',13,'p 载波初始相位']],...
		'ForeGround',3,...
		'Font Name','宋体',...
		'Font Size',12,...
		'position',[75,190,80,195])

add_block('built-in/Note',[sys,'/','调制信号'])
set_param([sys,'/','调制信号'],...
		'ForeGround',3,...
		'Font Name','宋体',...
		'Font Size',12,...
		'position',[65,65,70,70])

add_block('built-in/Note',[sys,'/','X(t)'])
set_param([sys,'/','X(t)'],...
		'ForeGround',3,...
		'Font Name','宋体',...
		'Font Size',12,...
		'position',[125,85,130,90])

add_block('built-in/Product',[sys,'/','乘法器'])
set_param([sys,'/','乘法器'],...
		'ForeGround',3,...
		'Font Name','宋体',...
		'Font Size',12,...
		'Mask Display','plot([0 1],[1 0],[0 1],[0 1]);',...
		'Mask Type','乘法器',...
		'Mask Dialogue','乘法器',...
		'position',[170,104,200,126])

add_block('built-in/Note',[sys,'/','Y(t) = X(t)*cos(Wc*t+p)'])
set_param([sys,'/','Y(t) = X(t)*cos(Wc*t+p)'],...
		'ForeGround',3,...
		'Font Name','宋体',...
		'Font Size',12,...
		'position',[240,70,245,75])

add_block('built-in/Note',[sys,'/','已调 SSB 信号'])
set_param([sys,'/','已调 SSB 信号'],...
		'ForeGround',3,...
		'Font Name','宋体',...
		'Font Size',12,...
		'position',[400,75,405,80])

add_block('built-in/Note',[sys,'/',['对 SSB 信号，无法',13,'直接从其中提取参考',13,'信号，故发送端在发',13,'射 SSB 信号的同时，',13,'还须发射受到一定程',13,'度抑制的载波信号。',13,'（称为导频信号）']])
set_param([sys,'/',['对 SSB 信号，无法',13,'直接从其中提取参考',13,'信号，故发送端在发',13,'射 SSB 信号的同时，',13,'还须发射受到一定程',13,'度抑制的载波信号。',13,'（称为导频信号）']],...
		'ForeGround',3,...
		'Font Name','宋体')
set_param([sys,'/',['对 SSB 信号，无法',13,'直接从其中提取参考',13,'信号，故发送端在发',13,'射 SSB 信号的同时，',13,'还须发射受到一定程',13,'度抑制的载波信号。',13,'（称为导频信号）']],...
		'Font Size',12,...
		'position',[70,245,75,250])

add_block('built-in/Note',[sys,'/','发送端'])
set_param([sys,'/','发送端'],...
		'Font Name','宋体',...
		'Font Size',12,...
		'position',[160,215,165,220])

add_block('built-in/Note',[sys,'/','接收端'])
set_param([sys,'/','接收端'],...
		'Font Name','宋体',...
		'Font Size',12,...
		'position',[135,325,140,330])
add_line(sys,[380,320;430,320])
add_line(sys,[265,320;310,320])
add_line(sys,[360,115;430,115])
add_line(sys,[385,115;385,235;155,235;155,315;225,315])
add_line(sys,[80,170;140,170;140,120;165,120])
add_line(sys,[140,170;140,325;225,325])
add_line(sys,[360,185;430,185])
add_line(sys,[205,115;290,115])
add_line(sys,[235,115;235,185;290,185])
add_line(sys,[95,110;165,110])

drawnow

% Return any arguments.
if (nargin | nargout)
	% Must use feval here to access system in memory
	if (nargin > 3)
		if (flag == 0)
			eval(['[ret,x0,str,ts,xts]=',sys,'(t,x,u,flag);'])
		else
			eval(['ret =', sys,'(t,x,u,flag);'])
		end
	else
		[ret,x0,str,ts,xts] = feval(sys);
	end
else
	drawnow % Flash up the model and execute load callback
end
