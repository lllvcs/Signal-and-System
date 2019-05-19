function snsmap(action);
% SNSMAP Handles initialization and GUI interface for
%        " Signal & System " maps.

figName='《信号与系统》实验教学系统';

global dc_flag clk_timer pVal
global runbtnHndl rbHndl editHndl listHndl
%global sihiHndl

%====================================
% Default events
if nargin<1, action='showmain'; end;

action=lower(action);

%====================================
% Handle the START events
if strcmp(action,'start'),
   figNumber=clf;
   set(figNumber,'colormap',white,'Pointer','watch', ...
      'Color',[0 0 0],'Visible','on');
   axHndl1=gca;
   set(axHndl1,'Units','Normalized', ...
      'Position',[0 0 1 1], ...
      'XLim',[-1 1],'YLim',[-1 1], ...
      'Visible','off');
   h=text(0,0,'正在载入《信号与系统》实验教学系统主界面...');
   set(h,'HorizontalAlignment','center', ...
      'FontSize',12, ...
      'Color',[1 1 1], ...
      'FontAngle','italic', ...
      'FontWeight','demi');
   pause(1.5);
   snsmap;
   close(figNumber);

%====================================
% Handle the SHOW events
elseif strcmp(action(1:4),'show'),
   dc_flag=0;
   [existFlag,figHandle]=figflag(figName);
   if ~existFlag,
      snsmap('initialize');
      [existFlag,figHandle]=figflag(figName);
   end;
   
   set(figHandle,'Pointer','watch');
   set(0,'DefaultAxesColor','w')
   axesHandle=findobj(figHandle,'Tag','SnS_WinMain_Axes');
   
   % Load map info from disk
   [mapIndex,img,areaName,sectionName]=uf_entry(action);
   load(img);

   hndlMatrix=get(figHandle,'UserData');

   % Turn off old uicontrols, turn on new uicontrols
   oldMapIndex=get(axesHandle,'UserData');
   if isempty(oldMapIndex), oldMapIndex=1; end

   offHndlVector=hndlMatrix(oldMapIndex,:);
   offHndlVector(find(offHndlVector==0))=[];
   onHndlVector=hndlMatrix(mapIndex,:);
   onHndlVector(find(onHndlVector==0))=[];
   
   % Initializing Public Components
   if mapIndex>1,
      set(rbHndl,'Value',0);
      if mapIndex==2,
         set(rbHndl(1),'Value',1);
      elseif mapIndex==4,
         set(rbHndl(3),'Value',1);
      end;
      areaText=[areaName '|' sectionName];
      [labelList,nameList,infoFile]=snslist(areaName,sectionName);
      set(listHndl,'Value',1, ...
         'String',str2mat('请选择下面一项实验',labelList), ...
         'UserData',str2mat(areaText,nameList));
      set(runbtnHndl,'UserData',' ','String','运行');
      setinfo(editHndl,infoFile);
      set(editHndl,'String',getinfo(editHndl,1));
   end;
   
   set(offHndlVector,'Visible','off');
   
   % Show background image
   axes(axesHandle);
   colormap(map);
   image(x);
   clear x map;
   
   set(onHndlVector,'Visible','on');
   
   set(figHandle,'UserData',hndlMatrix, ...
      'Pointer','arrow', ...
      'Visible','on');
   set(axesHandle,'Units','normalized', ...
      'Position',[0 0 1 1], ...
      'Tag','SnS_WinMain_Axes', ...
      'UserData',mapIndex, ...
      'Visible','off');
   %  set(figHandle,'NextPlot','replace');

%====================================
% Handle POPUP MENU event
elseif strcmp(action,'popupmenu'),
   popupHndl=gco;
   demoVal=get(popupHndl,'Value');
   % If demoVal=1, then take no action, because no demo has
   % been chosen : demoVal=1 -> '选择项目' option.
   if demoVal>1,
      figHandle=watchon;
      drawnow;
      demoList=get(popupHndl,'UserData');
      demoName=demoList(demoVal,:);
      eval(demoName);
      set(popupHndl,'Value',1);
      watchoff(figHandle);
   end
   
%====================================
% Handle LIST BOX event
elseif strcmp(action,'listbox'),
   listHndl=gco;
   demoVal=get(listHndl,'Value');
   if demoVal<=1,
      set(runbtnHndl,'UserData',' ','String','运行');
   else,
      demoList=get(listHndl,'UserData');
      demoName=demoList(demoVal,:);
      labelList=get(listHndl,'String');
      labelName=labelList(demoVal,:);
      set(runbtnHndl,'UserData',demoName, ...
         'String',['运行：' labelName]);
   end
   set(editHndl,'String',getinfo(editHndl,demoVal));
   % Handle Doubled-Clicked event
   if dc_flag==0,
      clk_timer=clock;
      pVal=demoVal;
      dc_flag=1;
   else,
      if pVal==demoVal & pVal>1 & etime(clock,clk_timer)<0.3,
         figHandle=watchon;
         drawnow;
         eval(demoName);
         watchoff(figHandle);
         dc_flag=0;
      else,
         clk_timer=clock;
         pVal=demoVal;
         dc_flag=1;
      end;
   end;
         
%====================================
% Handle RADIO BUTTON event
elseif strcmp(action,'radiobutton'),
   rbHndl0=gco;
   set(rbHndl,'Value',0);
   set(rbHndl0,'Value',1);
   areaText=get(rbHndl0,'Tag');
   lpos=find(areaText=='|');
   [labelList,nameList,infoFile]=snslist(areaText(1:(lpos-1)), ...
      areaText((lpos+1):length(areaText)));
   set(listHndl,'Value',1, ...
      'String',str2mat('请选择下面一项实验',labelList), ...
      'UserData',str2mat(areaText,nameList));
   set(runbtnHndl,'UserData',' ','String','运行');
   setinfo(editHndl,infoFile);
   set(editHndl,'String',getinfo(editHndl,1));
   
%=====================================
% Handle HELP
elseif strcmp(action,'help'),
   helpinfo('.\help\help01.txt');                                            

%====================================
% Handle the ABOUT events
elseif strcmp(action,'aboutmain'),
   helpinfo('.\help\help02.txt');

elseif strcmp(action,'aboutsp'),
   helpinfo('.\help\help03.txt');

elseif strcmp(action,'aboutsm'),
   helpinfo('.\help\help04.txt');
   
elseif strcmp(action,'aboutxt'),
   helpinfo('.\help\help05.txt');
   
elseif strcmp(action,'aboutss'),
   helpinfo('.\help\help06.txt');

elseif strcmp(action,'aboutsf'),
   helpinfo('.\help\help07.txt');
   
%=====================================
% Handle INITIALIZATION
elseif strcmp(action,'initialize'),
   % Make sure the window is big enough
   % figurePos=get(0,'DefaultFigurePosition');
   % figurePos(3:4)=[560 420];
   figurePos=[0.01 0.008 0.98 0.92];
   
   % Close window securely
   my_closereq=[ ...
         'selection=questdlg(''退出本系统吗？'',''提示信息'',', ...
         '''是'',''否'',''否'');', ...
         'switch selection,', ...
         'case ''是'',delete(get(0,''CurrentFigure''));', ...
         'case ''否'',return;', ...
         'end;'];
   
   % New main window
   figHandle=figure('Visible','off', ...
      'Tag','SnS_WinMain_Figure', ...
      'Pointer','watch');
   axesHandle=axes('Visible','off', ...
      'Units','normalized', ...
      'Position',[0 0 1 1], ...
      'Tag','SnS_WinMain_Axes', ...
      'UserData',1);
   
   % Initialize map buttons
   % hndlMatrix is a matrix of handles to all uicontrols on the figure
   hndlMatrix=snsbtns(figHandle);
   set(figHandle,'Name',figName, ...
      'NumberTitle','off', ...
      'Resize','off', ...
      'MenuBar','none', ...
      'Units','normalized', ...
      'Position',figurePos, ...
      'CloseRequestFcn',my_closereq, ...
      'UserData',hndlMatrix);

   % Initialize menu
   snsmenu(figHandle);
   
   % SNSMAP Public Components' Handles
   runbtnHndl=findobj(figHandle,'Tag','SNSMAP_Run_Item_Button');
   rbHndl(1)=findobj(figHandle,'Tag','sig_pro|pinpu');
   rbHndl(2)=findobj(figHandle,'Tag','sig_pro|yanshi');
   rbHndl(3)=findobj(figHandle,'Tag','sys_pro|pytx');
   rbHndl(4)=findobj(figHandle,'Tag','sys_pro|sytx');
   editHndl=findobj(figHandle,'Tag','SNSMAP_Help_Infomation_Box');
   listHndl=findobj(figHandle,'Tag','SNSMAP_Item_List_Box');
   %sihiHndl=findobj(figHandle,'Tag','SNSMAP_Item_Help_InfoBox');

   % The next line prevents people from accidentally plotting into
   % the small image axes.
   % set(figHandle,'NextPlot','new');
   
   % Initialization is now complete.

end;  % if strcmp(action ...
