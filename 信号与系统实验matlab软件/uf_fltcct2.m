function uf_fltcct2();

Cselected = uf_fltcct1;

if Cselected == 1,
   % Message = '您选择了Ｔ型电路。';
   fStruct = 'T';
   fStructName = '的Ｔ型网络电路';
elseif Cselected == 2,
   % Message = '您选择了Π型电路。';
   fStruct = 'n';
   fStructName = '的Π型网络电路';
else,
   return;
end;

% msgbox(Message,'提示信息','modal');

figHandle = findobj('Type','figure','Name','查表法设计模拟滤波器');

if ~isempty(figHandle),
   h_frame=get(figHandle,'UserData');
   h_fmenus=get(h_frame(1),'UserData');
   h_option=get(h_frame(4),'UserData');
   % ------
   li_tmp = get(h_fmenus(1),'Value');
   ls_fname = get(h_fmenus(1),'String');
   ls_fname = deblankall(ls_fname(li_tmp,:));
   % ------
   li_tmp = get(h_fmenus(2),'Value');
   switch li_tmp,
   case 1,
      fType = 'lowpass';
   case 2,
      fType = 'highpass';
   case 3,
      fType = 'bandpass';
   case 4,
      fType = 'bandstop';
   end;
   fTypeName = get(h_fmenus(2),'String');
   fTypeName = deblankall(fTypeName(li_tmp,:));
   % ------
   paraData = get(h_option(6),'UserData');
   cmpNVal = get(h_option(9),'UserData');
   fOrder = paraData(8);
   fParas = [paraData([5;9;10;12;13]); cmpNVal(:)];  % fc;Kl;Kc;Ro;B
   fTitle = [int2str(fOrder) '阶' ls_fname fTypeName fStructName];
else,
   fType = 'highpass';
   fOrder = 3;
   fParas = [ ];
   fTitle = '';
end;

[figNum,ValCmp,TagCmp] = uf_fltplot(fType,fStruct,fOrder,fParas,fTitle);

figure(figNum);
