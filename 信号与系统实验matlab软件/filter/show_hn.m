function show_hn();

%===============
% axz 1999-12-18
%===============

h_button=gco;
h_cmp=get(h_button,'UserData');

if strcmp(get(h_button,'String'),'��ʾ������Ӧ'),
   set(h_cmp([2 3 6 7]),'Visible','off');
   set(h_cmp(4),'Visible','on');
   set(h_button,'String','��ʾƵ����Ӧ');
else,
   set(h_cmp([2 3 6 7]),'Visible','on');
   set(h_cmp(4),'Visible','off');
   set(h_button,'String','��ʾ������Ӧ');
end;

