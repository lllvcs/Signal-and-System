function uf_fltclose(cFlag);

if nargin < 1, cFlag = 1; end;

AFC_Handle = findobj('Type','figure','Tag','Analog_Filter_Circuit');
if ~isempty(AFC_Handle),
   close(AFC_Handle);
end;

if cFlag,
   delete(get(0,'CurrentFigure'));
end;
