function uf_fltcct2();

Cselected = uf_fltcct1;

if Cselected == 1,
   % Message = '��ѡ���ˣ��͵�·��';
   fStruct = 'T';
   fStructName = '�ģ��������·';
elseif Cselected == 2,
   % Message = '��ѡ���˦��͵�·��';
   fStruct = 'n';
   fStructName = '�Ħ��������·';
else,
   return;
end;

% msgbox(Message,'��ʾ��Ϣ','modal');

figHandle = findobj('Type','figure','Name','������ģ���˲���');

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
   fTitle = [int2str(fOrder) '��' ls_fname fTypeName fStructName];
else,
   fType = 'highpass';
   fOrder = 3;
   fParas = [ ];
   fTitle = '';
end;

[figNum,ValCmp,TagCmp] = uf_fltplot(fType,fStruct,fOrder,fParas,fTitle);

figure(figNum);
