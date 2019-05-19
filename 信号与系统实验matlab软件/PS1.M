function [ret,x0,str,ts,xts]=ps1(t,x,u,flag);
%PS1	is the M-file description of the SIMULINK system named PS1.
%	The block-diagram can be displayed by typing: PS1.
%
%	SYS=PS1(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes PS1 to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling PS1 with a FLAG of zero:
%	[SIZES]=PS1([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[270,194,600,400])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '999999')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '10')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',   '')


%     Subsystem  ['Power Spectral',13,'Sensity'].

new_system([sys,'/',['Power Spectral',13,'Sensity']])
set_param([sys,'/',['Power Spectral',13,'Sensity']],'Location',[0,0,276,140])

add_block('built-in/S-Function',[sys,'/',['Power Spectral',13,'Sensity/S-function block ',13,'which calls M-file']])
set_param([sys,'/',['Power Spectral',13,'Sensity/S-function block ',13,'which calls M-file']],...
		'function name','sfunpsd',...
		'parameters','fftpts,npts,HowOften,offset,ts,0',...
		'position',[160,46,210,84])

add_block('built-in/Inport',[sys,'/',['Power Spectral',13,'Sensity/input signal']])
set_param([sys,'/',['Power Spectral',13,'Sensity/input signal']],...
		'position',[50,55,70,75])
add_line([sys,'/',['Power Spectral',13,'Sensity']],[75,65;155,65])
set_param([sys,'/',['Power Spectral',13,'Sensity']],...
		'Mask Display','plot(0,0,100,100,[14,91,91,14,14],[86,86,40,40,86],[85,82,80,79,75,67,63,60,57,53,41,36,33,27,24],[49,50,53,50,49,51,54,66,54,50,50,52,81,51,49])')
set_param([sys,'/',['Power Spectral',13,'Sensity']],...
		'Mask Type','Spectrum analyzer.',...
		'Mask Dialogue','Spectrum analyser using graph window.|Length of buffer:|Number of points for fft:|Plot after how many points:|Sample time:')
set_param([sys,'/',['Power Spectral',13,'Sensity']],...
		'Mask Translate','npts=@1; fftpts=@2; HowOften=@3; ts=@4(1); if length(@4) > 1, offset = @4(2), else, offset = 0; end')
set_param([sys,'/',['Power Spectral',13,'Sensity']],...
		'Mask Help','This block when hooked to the output of a system displays the frequency content of the buffer in the graph window. For more see the M-file specanal.')
set_param([sys,'/',['Power Spectral',13,'Sensity']],...
		'Mask Entries','128\/512\/64\/0.1\/')


%     Finished composite block ['Power Spectral',13,'Sensity'].

set_param([sys,'/',['Power Spectral',13,'Sensity']],...
		'Drop Shadow',4,...
		'position',[160,55,190,95])

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
