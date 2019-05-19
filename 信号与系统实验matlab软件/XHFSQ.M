function [ret,x0,str,ts,xts]=xhfsq(t,x,u,flag);
%XHFSQ	is the M-file description of the SIMULINK system named XHFSQ.
%	The block-diagram can be displayed by typing: XHFSQ.
%
%	SYS=XHFSQ(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes XHFSQ to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling XHFSQ with a FLAG of zero:
%	[SIZES]=XHFSQ([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[102,31,602,224])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '999999')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '10')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',   '')


%     Subsystem  'Subsystem'.

new_system([sys,'/','Subsystem'])
set_param([sys,'/','Subsystem'],'Location',[103,232,423,437])

add_block('built-in/MATLAB Fcn',[sys,'/','Subsystem/MATLAB Fcn'])
set_param([sys,'/','Subsystem/MATLAB Fcn'],...
		'MATLAB Fcn','name',...
		'position',[145,93,205,127])

add_block('built-in/Clock',[sys,'/','Subsystem/Clock'])
set_param([sys,'/','Subsystem/Clock'],...
		'position',[75,100,95,120])

add_block('built-in/Outport',[sys,'/','Subsystem/out_1'])
set_param([sys,'/','Subsystem/out_1'],...
		'position',[270,100,290,120])
add_line([sys,'/','Subsystem'],[210,110;265,110])
add_line([sys,'/','Subsystem'],[100,110;140,110])
set_param([sys,'/','Subsystem'],...
		'Mask Display','连续时间\n信号发生器',...
		'Mask Type','连续时间信号发生器',...
		'Mask Dialogue','连续时间信号发生器|请输入信号函数表达式（时间参数用 u 来表示）：',...
		'Mask Translate','name=@1;')
set_param([sys,'/','Subsystem'],...
		'Mask Help','    时间参数用 u 来表示，如 sin(t) 表示为 sin(u)。现在已有的信号函数有：\n         阶跃信号 jy(u,t)\n        方波信号 rect(u,T,r)\n        sinc 函数 sinc(u)\n        ',...
		'Mask Entries','sin\/')


%     Finished composite block 'Subsystem'.

set_param([sys,'/','Subsystem'],...
		'position',[210,77,290,133])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'Vgain','1.000000',...
		'Hgain','12.000000',...
		'Vmax','2.000000',...
		'Hmax','24.000000',...
		'Window',[122,262,453,435])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[330,90,360,120])
add_line(sys,[295,105;325,105])

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
