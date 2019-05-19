function [ret,x0,str,ts,xts]=rlc3lp(t,x,u,flag);
%RLC3LP	is the M-file description of the SIMULINK system named RLC3LP.
%	The block-diagram can be displayed by typing: RLC3LP.
%
%	SYS=RLC3LP(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes RLC3LP to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling RLC3LP with a FLAG of zero:
%	[SIZES]=RLC3LP([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[49,71,424,193])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '20')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '0.01')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',   '')

add_block('built-in/Note',[sys,'/','一阶RC系统的特性：'])
set_param([sys,'/','一阶RC系统的特性：'],...
		'Font Name','宋体',...
		'Font Size',12,...
		'position',[125,10,130,15])

add_block('built-in/Scope',[sys,'/','阶跃响应'])
set_param([sys,'/','阶跃响应'],...
		'Font Name','宋体',...
		'Font Size',12,...
		'Vgain','1.500000',...
		'Hgain','20.000000',...
		'Vmax','3.000000',...
		'Hmax','40.000000',...
		'Window',[43,209,444,396])
open_system([sys,'/','阶跃响应'])
set_param([sys,'/','阶跃响应'],...
		'position',[305,45,335,85])

add_block('built-in/Step Fcn',[sys,'/','阶跃输入'])
set_param([sys,'/','阶跃输入'],...
		'Font Name','宋体',...
		'Font Size',12,...
		'position',[30,50,60,80])

add_block('built-in/Transfer Fcn',[sys,'/','单元5'])
set_param([sys,'/','单元5'],...
		'Font Name','宋体',...
		'Font Size',12,...
		'Drop Shadow',4,...
		'Denominator','[L*C1*C2*R L*C2 R*(C1+C2) 1]')
set_param([sys,'/','单元5'],...
		'Mask Display','plot([0 2 2 2],[2 2 1.5 2.5],[2 6],[2.5 2.5],[2 6],[1.5 1.5],[6 6],[2.5 1.5],[6 11],[2 2],[8 8 6 10],[2 0 0 0],[6 10],[-1 -1],[8 8 7 9],[-1 -3 -3 -3],[11:1/7:12],[2 2.5 2.707 2.866 2.866 2.707 2.5 2],[12:1/7:13],[2 2.5 2.707 2.866 2.866 2.707 2.5 2],[13:1/7:14],[2 2.5 2.707 2.866 2.866 2.707 2.5 2],[14:1/7:15],[2 2.5 2.707 2.866 2.866 2.707 2.5 2],[15 21],[2 2],[18 18 16 20],[2 0 0 0],[16 20],[-1 -1],[18 18 17 19],[-1 -3 -3 -3]);R     C1     L      C2')
set_param([sys,'/','单元5'],...
		'Mask Type','单元5',...
		'Mask Dialogue','单元5|电阻R（欧）：|电容C1（法）：|电感L（亨）：|电容C2（法）：',...
		'Mask Translate','R=@1;C1=@2;L=@3;C2=@4;',...
		'Mask Entries','1\/1\/1\/1\/')
set_param([sys,'/','单元5'],...
		'position',[95,33,265,97])
add_line(sys,[65,65;90,65])
add_line(sys,[270,65;300,65])

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
