function [ret,x0,str,ts,xts]=fzxt(t,x,u,flag);
%FZXT	is the M-file description of the SIMULINK system named FZXT.
%	The block-diagram can be displayed by typing: FZXT.
%
%	SYS=FZXT(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes FZXT to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling FZXT with a FLAG of zero:
%	[SIZES]=FZXT([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[211,130,600,400])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '999999')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '10')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',   '')

add_block('built-in/Transfer Fcn',[sys,'/','单元1'])
set_param([sys,'/','单元1'],...
		'Font Name','宋体',...
		'Font Size',12,...
		'Drop Shadow',4,...
		'Denominator','[R*C 1]')
set_param([sys,'/','单元1'],...
		'Mask Display','plot([0 2 2 2],[2 2 1.5 2.5],[2 6],[2.5 2.5],[2 6],[1.5 1.5],[6 6],[2.5 1.5],[6 11],[2 2],[8 8 6 10],[2 0 0 0],[6 10],[-1 -1],[8 8 7 9],[-1 -3 -3 -3]);',...
		'Mask Type','积分')
set_param([sys,'/','单元1'],...
		'Mask Dialogue','积分|电容量（法）：|电阻值（欧姆）：',...
		'Mask Translate','C=@1;R=@2;',...
		'Mask Entries','1\/1\/',...
		'position',[130,79,195,121])

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
