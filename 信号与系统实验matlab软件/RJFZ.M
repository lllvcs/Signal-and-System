function [ret,x0,str,ts,xts]=rjfz(t,x,u,flag);
%RJFZ	is the M-file description of the SIMULINK system named RJFZ.
%	The block-diagram can be displayed by typing: RJFZ.
%
%	SYS=RJFZ(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes RJFZ to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling RJFZ with a FLAG of zero:
%	[SIZES]=RJFZ([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[4,92,379,299])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '20')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '0.01')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',   '')

add_block('built-in/Note',[sys,'/','二阶RC系统的特性：'])
set_param([sys,'/','二阶RC系统的特性：'],...
		'Font Name','宋体',...
		'Font Size',12,...
		'position',[105,10,110,15])

add_block('built-in/Transfer Fcn',[sys,'/','二阶RLC系统'])
set_param([sys,'/','二阶RLC系统'],...
		'Font Name','宋体',...
		'Font Size',12,...
		'Drop Shadow',4,...
		'Denominator','[L*C R*C 1]')
set_param([sys,'/','二阶RLC系统'],...
		'Mask Display','plot([3 5 5 5],[2 2 1.5 2.5],[5 9],[2.5 2.5],[5 9],[1.5 1.5],[9 9],[2.5 1.5],[9 11],[2 2],[11:1/7:12],[2 2.5 2.707 2.866 2.866 2.707 2.5 2],[12:1/7:13],[2 2.5 2.707 2.866 2.866 2.707 2.5 2],[13:1/7:14],[2 2.5 2.707 2.866 2.866 2.707 2.5 2],[14:1/7:15],[2 2.5 2.707 2.866 2.866 2.707 2.5 2],[15 21],[2 2],[18 18 16 20],[2 0 0 0],[16 20],[-1 -1],[18 18 17 19],[-1 -3 -3 -3]);')
set_param([sys,'/','二阶RLC系统'],...
		'Mask Type',' 单元7',...
		'Mask Dialogue',' 单元7|电阻值（欧）：|电感值（亨）：|电容值（法）：',...
		'Mask Translate','R=@1;L=@2;C=@3;',...
		'Mask Entries','20\/1\/0.01\/')
set_param([sys,'/','二阶RLC系统'],...
		'position',[120,115,240,165])

add_block('built-in/Scope',[sys,'/','系统响应'])
set_param([sys,'/','系统响应'],...
		'Font Name','宋体',...
		'Font Size',12,...
		'Vgain','1.500000',...
		'Hgain','20.000000',...
		'Vmax','3.000000',...
		'Hmax','40.000000',...
		'Window',[298,234,640,421])
open_system([sys,'/','系统响应'])
set_param([sys,'/','系统响应'],...
		'position',[300,120,335,160])

add_block('built-in/Scope',[sys,'/','输入信号'])
set_param([sys,'/','输入信号'],...
		'Font Name','宋体',...
		'Font Size',12,...
		'Vgain','1.500000',...
		'Hgain','20.000000',...
		'Vmax','3.000000',...
		'Hmax','40.000000',...
		'Window',[330,46,640,233])
open_system([sys,'/','输入信号'])
set_param([sys,'/','输入信号'],...
		'position',[300,45,330,75])

add_block('built-in/Step Fcn',[sys,'/','阶跃输入'])
set_param([sys,'/','阶跃输入'],...
		'Font Name','宋体',...
		'Font Size',12,...
		'position',[25,118,55,162])
add_line(sys,[60,140;115,140])
add_line(sys,[245,140;295,140])
add_line(sys,[75,140;75,60;295,60])

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
