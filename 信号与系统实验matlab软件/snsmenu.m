function snsmenu(figNumber)
% SNSMENU Initialize menu items for " Signal & System " CAI

if nargin<1,
   currentMap=' ';
end;

%====================================
% Menu 0 -- System Function
%====================================
h=uimenu(figNumber,'Label',' 教学系统 ');
   uimenu(h,'Label','关于……', ...
      'Callback','snsmap(''aboutmain'');');
   uimenu(h,'Label','回到主界面', ...
      'Callback','snsmap(''showmain'');');
   uimenu(h,'Label','系统帮助信息', ...
      'Callback','snsmap(''help'')');
   % -
   uimenu(h,'Label','退出本系统', ...
      'Callback','close all', ...
      'Separator','on');
   uimenu(h,'Label','退出 MATLAB', ...
      'Callback','quit');

%====================================
% Menu I -- Signal Analysis
%====================================
h=uimenu(figNumber,'Label',' 信号分析 ');
   uimenu(h,'Label','关于信号分析', ...
      'Callback','snsmap(''aboutsp'');');
   uimenu(h,'Label','转到信号分析', ...
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
h=uimenu(figNumber,'Label',' 信号抽样 ');
   uimenu(h,'Label','关于信号抽样', ...
      'Callback','snsmap(''aboutsm'');');
   uimenu(h,'Label','转到信号抽样', ...
      'Callback','snsmap(''showsm'');');
   % -
   [labelList,nameList]=snslist('sig_smpl','items');
   setmenu(h,labelList,nameList,1);

%====================================
% Menu III - LTI System Property
%====================================
h=uimenu(figNumber,'Label',' 系统特性 ');
   uimenu(h,'Label','关于系统特性', ...
      'Callback','snsmap(''aboutxt'');');
   uimenu(h,'Label','转到系统特性', ...
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
h=uimenu(figNumber,'Label',' 系统仿真 ');
   uimenu(h,'Label','关于系统仿真', ...
      'Callback','snsmap(''aboutss'');');
   uimenu(h,'Label','转到系统仿真', ...
      'Callback','snsmap(''showss'');');
   % -
   [labelList,nameList]=snslist('sim_sys','items');
   setmenu(h,labelList,nameList,1);
   
%====================================
% Menu V -- Filter
%====================================
h=uimenu(figNumber,'Label',' 滤波器　 ');
   uimenu(h,'Label','关于滤波器', ...
      'Callback','snsmap(''aboutsf'');');
   uimenu(h,'Label','转到滤波器', ...
      'Callback','snsmap(''showsf'');');
   % -
   [labelList,nameList]=snslist('sig_flt','items');
   setmenu(h,labelList,nameList,1);

