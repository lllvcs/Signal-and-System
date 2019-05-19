function Cselected = uf_fltcct1();

figNum = findobj('Type','figure','Name','滤波器电路设计之一');
if isempty(figNum), return; end;

axisHandle = get(figNum,'UserData');
if isempty(axisHandle), return; end;

ppos = get(figNum,'CurrentPoint');
apos = get(axisHandle(1),'Position');
cpos = get(axisHandle(1),'UserData');
Cpointed = 0;

tpos = ppos - apos([1 2]);
if tpos(1) > 0 & tpos(1) < apos(3) & ...
   tpos(2) > 0 & tpos(2) < apos(4),
   s1pos = tpos - cpos([1 2]);
   s2pos = tpos - cpos([3 4]);
   if s1pos(1) > 0 & s1pos(1) < cpos(5) & ...
      s1pos(2) > 0 & s1pos(2) < cpos(6),
      set(figNum,'Pointer','custom');
      Cpointed = 1;
   elseif s2pos(1) > 0 & s2pos(1) < cpos(5) & ...
          s2pos(2) > 0 & s2pos(2) < cpos(6),
      set(figNum,'Pointer','custom');
      Cpointed = 2; 
   else,
      set(figNum,'Pointer','cross');
   end;
else,
   set(figNum,'Pointer','arrow');
end;

if nargout > 0,
   Cselected = Cpointed;
end;
