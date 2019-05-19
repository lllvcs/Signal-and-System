function [ret,x0,str,ts,xts]=ps2(t,x,u,flag);
%PS2	is the M-file description of the SIMULINK system named PS2.
%	The block-diagram can be displayed by typing: PS2.
%
%	SYS=PS2(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes PS2 to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling PS2 with a FLAG of zero:
%	[SIZES]=PS2([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[303,145,600,400])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '999999')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '10')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',   '')


%     Subsystem  ['频谱分析仪1',13,'（系统1的频谱）'].

new_system([sys,'/',['频谱分析仪1',13,'（系统1的频谱）']])
set_param([sys,'/',['频谱分析仪1',13,'（系统1的频谱）']],'Location',[0,0,371,185])

add_block('built-in/Inport',[sys,'/',['频谱分析仪1',13,'（系统1的频谱）/system input']])
set_param([sys,'/',['频谱分析仪1',13,'（系统1的频谱）/system input']],...
		'position',[55,30,75,50])

add_block('built-in/S-Function',[sys,'/',['频谱分析仪1',13,'（系统1的频谱）/S-function block',13,'which calls M-file']])
set_param([sys,'/',['频谱分析仪1',13,'（系统1的频谱）/S-function block',13,'which calls M-file']],...
		'function name','sfuntf',...
		'parameters','fftpts,npts,HowOften,offset,ts,0',...
		'position',[250,72,295,108])

add_block('built-in/Inport',[sys,'/',['频谱分析仪1',13,'（系统1的频谱）/system output']])
set_param([sys,'/',['频谱分析仪1',13,'（系统1的频谱）/system output']],...
		'Port','2',...
		'position',[55,110,75,130])

add_block('built-in/Mux',[sys,'/',['频谱分析仪1',13,'（系统1的频谱）/Mux']])
set_param([sys,'/',['频谱分析仪1',13,'（系统1的频谱）/Mux']],...
		'inputs','2',...
		'position',[145,71,175,104])
add_line([sys,'/',['频谱分析仪1',13,'（系统1的频谱）']],[180,90;245,90])
add_line([sys,'/',['频谱分析仪1',13,'（系统1的频谱）']],[80,40;110,40;110,80;140,80])
add_line([sys,'/',['频谱分析仪1',13,'（系统1的频谱）']],[80,120;110,120;110,95;140,95])
set_param([sys,'/',['频谱分析仪1',13,'（系统1的频谱）']],...
		'Mask Display','plot(0,0,100,100,[11,93,93,11,11],[90,90,40,40,90],[90,80,72,64,55,45,41,36,20],[50,50,52,59,67,75,78,80,80])',...
		'Mask Type','Spectrum analyzer.')
set_param([sys,'/',['频谱分析仪1',13,'（系统1的频谱）']],...
		'Mask Dialogue','Spectrum analyser using graph window.\nHook input 1 to system input.\nHook input 2 to system output.|Length of buffer:|Number of points for fft:|Plot after how many points:|Sample time:')
set_param([sys,'/',['频谱分析仪1',13,'（系统1的频谱）']],...
		'Mask Translate','npts=@1; fftpts=@2; HowOften=@3; ts=@4(1); if length(@4) > 1, offset = @4(2), else, offset = 0; end')
set_param([sys,'/',['频谱分析仪1',13,'（系统1的频谱）']],...
		'Mask Help','Hook the system''s input to the first port of this block and the system''s output to second port. Results are displayed as the frequency response of this system. Use signals with high harmonic content for best results. ')
set_param([sys,'/',['频谱分析仪1',13,'（系统1的频谱）']],...
		'Mask Entries','512\/1024\/100\/0.05\/')


%     Finished composite block ['频谱分析仪1',13,'（系统1的频谱）'].

set_param([sys,'/',['频谱分析仪1',13,'（系统1的频谱）']],...
		'Font Name','宋体',...
		'Drop Shadow',4,...
		'position',[110,67,140,103])

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
