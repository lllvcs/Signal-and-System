function [ret,x0,str,ts,xts]=yj11(t,x,u,flag);
%YJ11	is the M-file description of the SIMULINK system named YJ11.
%	The block-diagram can be displayed by typing: YJ11.
%
%	SYS=YJ11(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes YJ11 to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling YJ11 with a FLAG of zero:
%	[SIZES]=YJ11([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[113,90,460,412])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '30')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '0.1')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',   '')

add_block('built-in/Scope',[sys,'/',['示波器',13,'（输入信号）']])
set_param([sys,'/',['示波器',13,'（输入信号）']],...
		'Font Name','宋体',...
		'Vgain','1.500000',...
		'Hgain','30.000000',...
		'Vmax','3.000000',...
		'Hmax','60.000000',...
		'Window',[307,9,639,161])
open_system([sys,'/',['示波器',13,'（输入信号）']])
set_param([sys,'/',['示波器',13,'（输入信号）']],...
		'position',[280,57,310,93])

add_block('built-in/Note',[sys,'/','一阶系统的时域特性：'])
set_param([sys,'/','一阶系统的时域特性：'],...
		'Font Name','楷体_GB2312',...
		'Font Size',14,...
		'position',[95,20,100,25])

add_block('built-in/Transfer Fcn',[sys,'/','一阶系统'])
set_param([sys,'/','一阶系统'],...
		'Font Name','宋体',...
		'Denominator','[R*C 1]')
set_param([sys,'/','一阶系统'],...
		'Mask Display','plot([0 2 2 2],[2 2 1.5 2.5],[2 6],[2.5 2.5],[2 6],[1.5 1.5],[6 6],[2.5 1.5],[6 11],[2 2],[8 8 6 10],[2 0 0 0],[6 10],[-1 -1],[8 8 7 9],[-1 -3 -3 -3]);',...
		'Mask Type','积分')
set_param([sys,'/','一阶系统'],...
		'Mask Dialogue','积分|电容量（法）：|电阻值（欧姆）：',...
		'Mask Translate','C=@1;R=@2;',...
		'Mask Entries','0.01\/10\/',...
		'position',[105,160,175,210])

add_block('built-in/Scope',[sys,'/',['示波器',13,'（系统的响应）']])
set_param([sys,'/',['示波器',13,'（系统的响应）']],...
		'Font Name','宋体',...
		'Vgain','1.500000',...
		'Hgain','30.000000',...
		'Vmax','3.000000',...
		'Hmax','60.000000',...
		'Window',[306,303,640,469])
open_system([sys,'/',['示波器',13,'（系统的响应）']])
set_param([sys,'/',['示波器',13,'（系统的响应）']],...
		'position',[280,167,310,203])


%     Subsystem  ['频谱分析仪',13,'（系统的频谱）'].

new_system([sys,'/',['频谱分析仪',13,'（系统的频谱）']])
set_param([sys,'/',['频谱分析仪',13,'（系统的频谱）']],'Location',[0,0,371,185])

add_block('built-in/Mux',[sys,'/',['频谱分析仪',13,'（系统的频谱）/Mux']])
set_param([sys,'/',['频谱分析仪',13,'（系统的频谱）/Mux']],...
		'inputs','2',...
		'position',[145,71,175,104])

add_block('built-in/Inport',[sys,'/',['频谱分析仪',13,'（系统的频谱）/system output']])
set_param([sys,'/',['频谱分析仪',13,'（系统的频谱）/system output']],...
		'Port','2',...
		'position',[55,110,75,130])

add_block('built-in/S-Function',[sys,'/',['频谱分析仪',13,'（系统的频谱）/S-function block',13,'which calls M-file']])
set_param([sys,'/',['频谱分析仪',13,'（系统的频谱）/S-function block',13,'which calls M-file']],...
		'function name','sfuntf',...
		'parameters','fftpts,npts,HowOften,offset,ts,0',...
		'position',[250,72,295,108])

add_block('built-in/Inport',[sys,'/',['频谱分析仪',13,'（系统的频谱）/system input']])
set_param([sys,'/',['频谱分析仪',13,'（系统的频谱）/system input']],...
		'position',[55,30,75,50])
add_line([sys,'/',['频谱分析仪',13,'（系统的频谱）']],[80,120;110,120;110,95;140,95])
add_line([sys,'/',['频谱分析仪',13,'（系统的频谱）']],[80,40;110,40;110,80;140,80])
add_line([sys,'/',['频谱分析仪',13,'（系统的频谱）']],[180,90;245,90])
set_param([sys,'/',['频谱分析仪',13,'（系统的频谱）']],...
		'Mask Display','plot(0,0,100,100,[11,93,93,11,11],[90,90,40,40,90],[90,80,72,64,55,45,41,36,20],[50,50,52,59,67,75,78,80,80])',...
		'Mask Type','Spectrum analyzer.')
set_param([sys,'/',['频谱分析仪',13,'（系统的频谱）']],...
		'Mask Dialogue','Spectrum analyser using graph window.\nHook input 1 to system input.\nHook input 2 to system output.|Length of buffer:|Number of points for fft:|Plot after how many points:|Sample time:')
set_param([sys,'/',['频谱分析仪',13,'（系统的频谱）']],...
		'Mask Translate','npts=@1; fftpts=@2; HowOften=@3; ts=@4(1); if length(@4) > 1, offset = @4(2), else, offset = 0; end')
set_param([sys,'/',['频谱分析仪',13,'（系统的频谱）']],...
		'Mask Help','Hook the system''s input to the first port of this block and the system''s output to second port. Results are displayed as the frequency response of this system. Use signals with high harmonic content for best results. ')
set_param([sys,'/',['频谱分析仪',13,'（系统的频谱）']],...
		'Mask Entries','1024\/1024\/100\/0.05\/')


%     Finished composite block ['频谱分析仪',13,'（系统的频谱）'].

set_param([sys,'/',['频谱分析仪',13,'（系统的频谱）']],...
		'Font Name','宋体',...
		'Drop Shadow',4,...
		'position',[215,106,245,144])

add_block('built-in/Step Fcn',[sys,'/','阶跃输入'])
set_param([sys,'/','阶跃输入'],...
		'Font Name','宋体',...
		'Font Size',12,...
		'position',[25,95,50,135])
add_line(sys,[55,115;70,115;70,185;100,185])
add_line(sys,[70,169;70,75;275,75])
add_line(sys,[180,185;275,185])
add_line(sys,[185,185;185,135;210,135])
add_line(sys,[70,115;210,115])

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
