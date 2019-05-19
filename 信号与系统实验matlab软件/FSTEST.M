function [ret,x0,str,ts,xts]=fstest(t,x,u,flag);
%FSTEST	is the M-file description of the SIMULINK system named FSTEST.
%	The block-diagram can be displayed by typing: FSTEST.
%
%	SYS=FSTEST(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes FSTEST to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling FSTEST with a FLAG of zero:
%	[SIZES]=FSTEST([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[118,51,618,351])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '999999')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '0.01')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',   '')

add_block('built-in/Signal Generator',[sys,'/',['Signal',13,'Generator']])
set_param([sys,'/',['Signal',13,'Generator']],...
		'Peak','1.000000',...
		'Peak Range','5.000000',...
		'Freq','10.000000',...
		'Freq Range','50.000000',...
		'Wave','Sin',...
		'Units','Rads',...
		'position',[90,68,135,102])

add_block('built-in/Product',[sys,'/','Product'])
set_param([sys,'/','Product'],...
		'position',[195,78,225,102])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'Vgain','1.000000',...
		'Hgain','1.000000',...
		'Vmax','2.000000',...
		'Hmax','2.000000',...
		'Window',[137,110,468,424],...
		'position',[345,160,375,190])


%     Subsystem  ['Frequency Spectra',13,'Analyzer1'].

new_system([sys,'/',['Frequency Spectra',13,'Analyzer1']])
set_param([sys,'/',['Frequency Spectra',13,'Analyzer1']],'Location',[130,212,390,362])

add_block('built-in/S-Function',[sys,'/',['Frequency Spectra',13,'Analyzer1/S-function block ',13,'which calls M-file']])
set_param([sys,'/',['Frequency Spectra',13,'Analyzer1/S-function block ',13,'which calls M-file']],...
		'function name','sfunfs',...
		'parameters','fftpts,npts,HowOften,offset,ts',...
		'position',[140,56,190,94])

add_block('built-in/Inport',[sys,'/',['Frequency Spectra',13,'Analyzer1/in_1']])
set_param([sys,'/',['Frequency Spectra',13,'Analyzer1/in_1']],...
		'position',[30,65,50,85])
add_line([sys,'/',['Frequency Spectra',13,'Analyzer1']],[55,75;135,75])
set_param([sys,'/',['Frequency Spectra',13,'Analyzer1']],...
		'Mask Display','plot(0,0,100,100,[14,91,91,14,14],[86,86,40,40,86],[85,82,80,79,75,67,63,60,57,53,41,36,33,27,24],[49,50,53,50,49,51,54,66,54,50,50,52,81,51,49])')
set_param([sys,'/',['Frequency Spectra',13,'Analyzer1']],...
		'Mask Type','Spectrum analyzer.',...
		'Mask Dialogue','Spectrum analyser using graph window.|Length of buffer:|Number of points for fft:|Plot after how many points:|Sample time:')
set_param([sys,'/',['Frequency Spectra',13,'Analyzer1']],...
		'Mask Translate','npts=@1; fftpts=@2; HowOften=@3; ts=@4(1); if length(@4) > 1, offset = @4(2), else, offset = 0; end')
set_param([sys,'/',['Frequency Spectra',13,'Analyzer1']],...
		'Mask Help','This block when hooked to the output of a system displays the frequency content of the buffer in the graph window. For more see the M-file specanal.')
set_param([sys,'/',['Frequency Spectra',13,'Analyzer1']],...
		'Mask Entries','1024\/1024\/64\/0.02\/')


%     Finished composite block ['Frequency Spectra',13,'Analyzer1'].

set_param([sys,'/',['Frequency Spectra',13,'Analyzer1']],...
		'Drop Shadow',4,...
		'position',[345,67,380,113])

add_block('built-in/Sine Wave',[sys,'/','Sine Wave'])
set_param([sys,'/','Sine Wave'],...
		'frequency','50',...
		'position',[100,132,125,158])
add_line(sys,[140,85;190,85])
add_line(sys,[230,90;340,90])
add_line(sys,[130,145;165,95;190,95])
add_line(sys,[270,90;270,175;340,175])

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
