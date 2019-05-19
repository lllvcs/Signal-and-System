function snsmenu(figNumber)
% SNSMENU Initialize menu items for " Signal & System " CAI

if nargin<1,
   currentMap=' ';
end;

%====================================
% Menu 0 -- System Function
%====================================
h=uimenu(figNumber,'Label',' ��ѧϵͳ ');
   uimenu(h,'Label','���ڡ���', ...
      'Callback','snsmap(''aboutmain'');');
   uimenu(h,'Label','�ص�������', ...
      'Callback','snsmap(''showmain'');');
   uimenu(h,'Label','ϵͳ������Ϣ', ...
      'Callback','snsmap(''help'')');
   % -
   uimenu(h,'Label','�˳���ϵͳ', ...
      'Callback','close all', ...
      'Separator','on');
   uimenu(h,'Label','�˳� MATLAB', ...
      'Callback','quit');

%====================================
% Menu I -- Signal Analysis
%====================================
h=uimenu(figNumber,'Label',' �źŷ��� ');
   uimenu(h,'Label','�����źŷ���', ...
      'Callback','snsmap(''aboutsp'');');
   uimenu(h,'Label','ת���źŷ���', ...
      'Callback','snsmap(''showsp'');');
   % -
   [labelList,nameList]=snslist('sig_pro','items');
   for counter=1:size(labelList,1),
      if counter==1,
         h2=uimenu(h, ...
            'Label',deblank(labelList(counter,:)), ...
            'Separator','on');
      else,
         h2=uimenu(h, ...
            'Label',deblank(labelList(counter,:)));
      end
      [labelList1,nameList1]=snslist('sig_pro',nameList(counter,:));
      setmenu(h2,labelList1,nameList1);
      clear labelList1,nameList1;
   end;

%====================================
% Menu II -- Signal Sampling
%====================================
h=uimenu(figNumber,'Label',' �źų��� ');
   uimenu(h,'Label','�����źų���', ...
      'Callback','snsmap(''aboutsm'');');
   uimenu(h,'Label','ת���źų���', ...
      'Callback','snsmap(''showsm'');');
   % -
   [labelList,nameList]=snslist('sig_smpl','items');
   setmenu(h,labelList,nameList,1);

%====================================
% Menu III - LTI System Property
%====================================
h=uimenu(figNumber,'Label',' ϵͳ���� ');
   uimenu(h,'Label','����ϵͳ����', ...
      'Callback','snsmap(''aboutxt'');');
   uimenu(h,'Label','ת��ϵͳ����', ...
      'Callback','snsmap(''showxt'');');
   % -
   [labelList,nameList]=snslist('sys_pro','items');
   for counter=1:size(labelList,1),
      if counter==1,
         h2=uimenu(h, ...
            'Label',deblank(labelList(counter,:)), ...
            'Separator','on');
      else,
         h2=uimenu(h, ...
            'Label',deblank(labelList(counter,:)));
      end
      [labelList1,nameList1]=snslist('sys_pro',nameList(counter,:));
      setmenu(h2,labelList1,nameList1);
      clear labelList1,nameList1;
   end;
   
%====================================
% Menu IV - System Simulation
%====================================
h=uimenu(figNumber,'Label',' ϵͳ���� ');
   uimenu(h,'Label','����ϵͳ����', ...
      'Callback','snsmap(''aboutss'');');
   uimenu(h,'Label','ת��ϵͳ����', ...
      'Callback','snsmap(''showss'');');
   % -
   [labelList,nameList]=snslist('sim_sys','items');
   setmenu(h,labelList,nameList,1);
   
%====================================
% Menu V -- Filter
%====================================
h=uimenu(figNumber,'Label',' �˲����� ');
   uimenu(h,'Label','�����˲���', ...
      'Callback','snsmap(''aboutsf'');');
   uimenu(h,'Label','ת���˲���', ...
      'Callback','snsmap(''showsf'');');
   % -
   [labelList,nameList]=snslist('sig_flt','items');
   setmenu(h,labelList,nameList,1);

