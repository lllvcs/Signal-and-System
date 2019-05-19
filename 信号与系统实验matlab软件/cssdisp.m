function cssdisp(figNumber,string)
%CSSDISP Display text from the Slide Show format.
%
%	CSSDISP(figNumber,string) will display the supplied string
%	in the Comment Window of a Slide Show figure. If the Slide
%	Show GUI shell is not being used, CSSDISP will display directly
%	to the command window.

if figNumber==0,
    clc
    disp(' ');
    disp(string);
    disp(' ');
else
    hndlList=get(figNumber,'UserData');
    txtHndl=hndlList(1);
    set(txtHndl,'String',string);
end
