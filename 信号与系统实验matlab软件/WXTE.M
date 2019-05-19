function [ret,x0,str,ts,xts]=wxte(t,x,u,flag);
%WXTE	is the M-file description of the SIMULINK system named WXTE.
%	The block-diagram can be displayed by typing: WXTE.
%
%	SYS=WXTE(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes WXTE to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling WXTE with a FLAG of zero:
%	[SIZES]=WXTE([],[],[],0),  returns a vector, SIZES, which
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
     set_param(sys,'Location',[8,42,454,324])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '100')
set_param(sys,'Min step size', '0.00001')
set_param(sys,'Max step size', '0.1')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',   '')

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'Vgain','1.500000',...
		'Hgain','20.000000',...
		'Vmax','3.000000',...
		'Hmax','40.000000',...
		'Window',[309,39,640,229])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[330,45,360,75])

add_block('built-in/Transfer Fcn',[sys,'/','单元7'])
set_param([sys,'/','单元7'],...
		'Font Name','宋体',...
		'Font Size',12,...
		'Drop Shadow',4,...
		'Denominator','[L*C R*C 1]')
set_param([sys,'/','单元7'],...
		'Mask Display','plot([3 5 5 5],[2 2 1.5 2.5],[5 9],[2.5 2.5],[5 9],[1.5 1.5],[9 9],[2.5 1.5],[9 11],[2 2],[11:1/7:12],[2 2.5 2.707 2.866 2.866 2.707 2.5 2],[12:1/7:13],[2 2.5 2.707 2.866 2.866 2.707 2.5 2],[13:1/7:14],[2 2.5 2.707 2.866 2.866 2.707 2.5 2],[14:1/7:15],[2 2.5 2.707 2.866 2.866 2.707 2.5 2],[15 21],[2 2],[18 18 16 20],[2 0 0 0],[16 20],[-1 -1],[18 18 17 19],[-1 -3 -3 -3]);')
set_param([sys,'/','单元7'],...
		'Mask Type',' 单元7',...
		'Mask Dialogue',' 单元7|电阻值（欧）：|电感值（亨）：|电容值（法）：',...
		'Mask Translate','R=@1;L=@2;C=@3;',...
		'Mask Entries','4\/1\/.01\/',...
		'position',[130,140,250,190])


%     Subsystem  'Spectrum Analyzer'.

new_system([sys,'/','Spectrum Analyzer'])
set_param([sys,'/','Spectrum Analyzer'],'Location',[0,0,371,185])

add_block('built-in/Mux',[sys,'/','Spectrum Analyzer/Mux'])
set_param([sys,'/','Spectrum Analyzer/Mux'],...
		'inputs','2',...
		'position',[145,71,175,104])

add_block('built-in/Inport',[sys,'/','Spectrum Analyzer/system output'])
set_param([sys,'/','Spectrum Analyzer/system output'],...
		'Port','2',...
		'position',[55,110,75,130])

add_block('built-in/S-Function',[sys,'/',['Spectrum Analyzer/S-function block',13,'which calls M-file']])
set_param([sys,'/',['Spectrum Analyzer/S-function block',13,'which calls M-file']],...
		'function name','sfuntf',...
		'parameters','fftpts,npts,HowOften,offset,ts,0',...
		'position',[250,72,295,108])

add_block('built-in/Inport',[sys,'/','Spectrum Analyzer/system input'])
set_param([sys,'/','Spectrum Analyzer/system input'],...
		'position',[55,30,75,50])
add_line([sys,'/','Spectrum Analyzer'],[80,120;110,120;110,95;140,95])
add_line([sys,'/','Spectrum Analyzer'],[80,40;110,40;110,80;140,80])
add_line([sys,'/','Spectrum Analyzer'],[180,90;245,90])
set_param([sys,'/','Spectrum Analyzer'],...
		'Mask Display','plot(0,0,100,100,[11,93,93,11,11],[90,90,40,40,90],[90,80,72,64,55,45,41,36,20],[50,50,52,59,67,75,78,80,80])',...
		'Mask Type','Spectrum analyzer.')
set_param([sys,'/','Spectrum Analyzer'],...
		'Mask Dialogue','Spectrum analyser using graph window.\nHook input 1 to system input.\nHook input 2 to system output.|Length of buffer:|Number of points for fft:|Plot after how many points:|Sample time:')
set_param([sys,'/','Spectrum Analyzer'],...
		'Mask Translate','npts=@1; fftpts=@2; HowOften=@3; ts=@4(1); if length(@4) > 1, offset = @4(2), else, offset = 0; end')
set_param([sys,'/','Spectrum Analyzer'],...
		'Mask Help','Hook the system''s input to the first port of this block and the system''s output to second port. Results are displayed as the frequency response of this system. Use signals with high harmonic content for best results. ')
set_param([sys,'/','Spectrum Analyzer'],...
		'Mask Entries','512\/512\/100\/0.05\/')


%     Finished composite block 'Spectrum Analyzer'.

set_param([sys,'/','Spectrum Analyzer'],...
		'Drop Shadow',4,...
		'position',[330,135,360,175])

add_block('built-in/Scope',[sys,'/','Scope1'])
set_param([sys,'/','Scope1'],...
		'Vgain','1.500000',...
		'Hgain','20.000000',...
		'Vmax','3.000000',...
		'Hmax','40.000000',...
		'Window',[309,224,640,429])
open_system([sys,'/','Scope1'])
set_param([sys,'/','Scope1'],...
		'position',[340,212,370,248])


%     Subsystem  ['Pulse',13,'Generator'].

new_system([sys,'/',['Pulse',13,'Generator']])
set_param([sys,'/',['Pulse',13,'Generator']],'Location',[158,441,759,682])

add_block('built-in/Unit Delay',[sys,'/',['Pulse',13,'Generator/Unit Delay1']])
set_param([sys,'/',['Pulse',13,'Generator/Unit Delay1']],...
		'orientation',2,...
		'Sample time','[Ts,st2]',...
		'x0','ini',...
		'position',[140,165,190,185])

add_block('built-in/Unit Delay',[sys,'/',['Pulse',13,'Generator/Unit Delay']])
set_param([sys,'/',['Pulse',13,'Generator/Unit Delay']],...
		'orientation',2,...
		'Sample time','[Ts,st1]',...
		'position',[145,75,195,95])

add_block('built-in/Constant',[sys,'/',['Pulse',13,'Generator/Constant']])
set_param([sys,'/',['Pulse',13,'Generator/Constant']],...
		'position',[25,30,45,50])

add_block('built-in/Sum',[sys,'/',['Pulse',13,'Generator/Sum']])
set_param([sys,'/',['Pulse',13,'Generator/Sum']],...
		'hide name',0,...
		'inputs','+-',...
		'position',[135,35,155,55])

add_block('built-in/Sum',[sys,'/',['Pulse',13,'Generator/Sum1']])
set_param([sys,'/',['Pulse',13,'Generator/Sum1']],...
		'hide name',0,...
		'inputs','+-',...
		'position',[130,120,150,140])

add_block('built-in/Relational Operator',[sys,'/',['Pulse',13,'Generator/Relational',13,'operator']])
set_param([sys,'/',['Pulse',13,'Generator/Relational',13,'operator']],...
		'hide name',0,...
		'position',[370,102,400,133])

add_block('built-in/Clock',[sys,'/',['Pulse',13,'Generator/Clock1']])
set_param([sys,'/',['Pulse',13,'Generator/Clock1']],...
		'hide name',0,...
		'position',[295,100,315,120])

add_block('built-in/Constant',[sys,'/',['Pulse',13,'Generator/Constant1']])
set_param([sys,'/',['Pulse',13,'Generator/Constant1']],...
		'Value','stt',...
		'position',[295,149,320,171])

add_block('built-in/Logical Operator',[sys,'/',['Pulse',13,'Generator/Logical',13,'Operator']])
set_param([sys,'/',['Pulse',13,'Generator/Logical',13,'Operator']],...
		'Operator','XOR',...
		'position',[285,38,315,62])

add_block('built-in/Logical Operator',[sys,'/',['Pulse',13,'Generator/Logical',13,'Operator1']])
set_param([sys,'/',['Pulse',13,'Generator/Logical',13,'Operator1']],...
		'Operator','NOT',...
		'Number of Input Ports','1',...
		'position',[355,38,385,62])

add_block('built-in/Product',[sys,'/',['Pulse',13,'Generator/Product']])
set_param([sys,'/',['Pulse',13,'Generator/Product']],...
		'hide name',0,...
		'position',[455,105,480,125])

add_block('built-in/Gain',[sys,'/',['Pulse',13,'Generator/Gain']])
set_param([sys,'/',['Pulse',13,'Generator/Gain']],...
		'hide name',0,...
		'Gain','ht',...
		'position',[510,102,535,128])

add_block('built-in/Outport',[sys,'/',['Pulse',13,'Generator/out_1']])
set_param([sys,'/',['Pulse',13,'Generator/out_1']],...
		'hide name',0,...
		'position',[560,105,580,125])
add_line([sys,'/',['Pulse',13,'Generator']],[155,130;245,130;245,55;280,55])
add_line([sys,'/',['Pulse',13,'Generator']],[160,45;280,45])
add_line([sys,'/',['Pulse',13,'Generator']],[50,40;70,40;70,125;125,125])
add_line([sys,'/',['Pulse',13,'Generator']],[135,175;100,175;100,135;125,135])
add_line([sys,'/',['Pulse',13,'Generator']],[155,130;210,130;210,175;195,175])
add_line([sys,'/',['Pulse',13,'Generator']],[50,40;130,40])
add_line([sys,'/',['Pulse',13,'Generator']],[160,45;230,45;230,85;200,85])
add_line([sys,'/',['Pulse',13,'Generator']],[140,85;105,85;105,50;130,50])
add_line([sys,'/',['Pulse',13,'Generator']],[320,110;365,110])
add_line([sys,'/',['Pulse',13,'Generator']],[405,120;450,120])
add_line([sys,'/',['Pulse',13,'Generator']],[485,115;505,115])
add_line([sys,'/',['Pulse',13,'Generator']],[540,115;555,115])
add_line([sys,'/',['Pulse',13,'Generator']],[325,160;345,160;345,125;365,125])
add_line([sys,'/',['Pulse',13,'Generator']],[320,50;350,50])
add_line([sys,'/',['Pulse',13,'Generator']],[390,50;430,50;430,110;450,110])
set_param([sys,'/',['Pulse',13,'Generator']],...
		'Mask Display','plot(0,0,100,100,[90,75,75,60,60,35,35,20,20,10],[20,20,80,80,20,20,80,80,20,20])',...
		'Mask Type','Pulse Generator')
set_param([sys,'/',['Pulse',13,'Generator']],...
		'Mask Dialogue','Pulse Generator.|Pulse period (secs):|Pulse width:|Pulse height:|Pulse start time:')
set_param([sys,'/',['Pulse',13,'Generator']],...
		'Mask Translate','Ts=@1; du=@2; ht=@3; stt=@4; ini=ones(length(ht),1); st1=rem(stt,Ts); st2=rem(stt+du,Ts);if(Ts<=1.2*du),ini=zeros(length(ht),1);end;')
set_param([sys,'/',['Pulse',13,'Generator']],...
		'Mask Help','Pulse generator which ensures pulse\ntransitions are hit. Provides a vector of pulses when the height is entered as a vector.\nUnmask to see how it works.')
set_param([sys,'/',['Pulse',13,'Generator']],...
		'Mask Entries','20\/10\/1\/0\/')


%     Finished composite block ['Pulse',13,'Generator'].

set_param([sys,'/',['Pulse',13,'Generator']],...
		'position',[40,41,85,79])
add_line(sys,[90,60;325,60])
add_line(sys,[100,60;100,165;125,165])
add_line(sys,[270,60;270,145;325,145])
add_line(sys,[255,165;325,165])
add_line(sys,[270,165;270,230;335,230])

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
