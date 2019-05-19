function [ret,x0,str,ts,xts]=sys_eg(t,x,u,flag);
%SYS_EG	is the M-file description of the SIMULINK system named SYS_EG.
%	The block-diagram can be displayed by typing: SYS_EG.
%
%	SYS=SYS_EG(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes SYS_EG to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling SYS_EG with a FLAG of zero:
%	[SIZES]=SYS_EG([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[6,264,300,449])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '200')
set_param(sys,'Min step size', '1e-6')
set_param(sys,'Max step size', '1e-4')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',   '')

add_block('built-in/Transfer Fcn',[sys,'/','微分单元'])
set_param([sys,'/','微分单元'],...
		'Numerator','[R*C 0]',...
		'Denominator','[R*C 1]')
set_param([sys,'/','微分单元'],...
		'Mask Display','plot([0 2 2 2],[2 2 0 4],[3 3 3 8],[0 4 2 2],[6 6 5.5 6.5],[2 0 0 0],[5.5 5.5],[0 -4],[6.5 6.5],[0 -4],[5.5 6.5 6 6],[-4 -4 -4 -5.5],[5.5 6.5],[-5.5 -5.5]);',...
		'Mask Type','微分')
set_param([sys,'/','微分单元'],...
		'Mask Dialogue','微分|电容量（法）：|电阻值（欧姆）：',...
		'Mask Translate','C=@1;R=@2;',...
		'Mask Entries','4.7e-6\/500\/',...
		'position',[125,42,195,98])

add_block('built-in/Signal Generator',[sys,'/','信号发生器'])
set_param([sys,'/','信号发生器'],...
		'Peak','1.000000',...
		'Peak Range','5.000000',...
		'Freq','100.000000',...
		'Freq Range','500.000000',...
		'Wave','Sqr',...
		'Units','Rads',...
		'position',[15,53,60,87])

add_block('built-in/Scope',[sys,'/','微分所得'])
set_param([sys,'/','微分所得'],...
		'Vgain','2.000000',...
		'Hgain','0.500000',...
		'Vmax','4.000000',...
		'Hmax','1.000000',...
		'Window',[320,0,640,241])
open_system([sys,'/','微分所得'])
set_param([sys,'/','微分所得'],...
		'position',[240,54,270,86])

add_block('built-in/Scope',[sys,'/','输入信号'])
set_param([sys,'/','输入信号'],...
		'Vgain','2.000000',...
		'Hgain','0.500000',...
		'Vmax','4.000000',...
		'Hmax','1.000000',...
		'Window',[320,203,640,452])
open_system([sys,'/','输入信号'])
set_param([sys,'/','输入信号'],...
		'position',[235,0,265,30])

add_block('built-in/Transfer Fcn',[sys,'/','积分单元'])
set_param([sys,'/','积分单元'],...
		'Denominator','[R*C 1]',...
		'Mask Display','plot([0 2 2 2],[2 2 1.5 2.5],[2 6],[2.5 2.5],[2 6],[1.5 1.5],[6 6],[2.5 1.5],[6 11],[2 2],[8 8 6 10],[2 0 0 0],[6 10],[-1 -1],[8 8 7 9],[-1 -3 -3 -3]);')
set_param([sys,'/','积分单元'],...
		'Mask Type','积分',...
		'Mask Dialogue','积分|电容量（法）：|电阻值（欧姆）：',...
		'Mask Translate','C=@1;R=@2;',...
		'Mask Entries','4.7e-5\/500\/',...
		'position',[125,120,195,170])

add_block('built-in/Scope',[sys,'/','积分所得'])
set_param([sys,'/','积分所得'],...
		'Vgain','2.000000',...
		'Hgain','0.500000',...
		'Vmax','4.000000',...
		'Hmax','1.000000',...
		'Window',[0,0,320,205])
open_system([sys,'/','积分所得'])
set_param([sys,'/','积分所得'],...
		'position',[240,130,270,160])
add_line(sys,[65,70;120,70])
add_line(sys,[200,70;235,70])
add_line(sys,[75,70;75,145;120,145])
add_line(sys,[200,145;235,145])
add_line(sys,[75,70;75,15;230,15])

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
