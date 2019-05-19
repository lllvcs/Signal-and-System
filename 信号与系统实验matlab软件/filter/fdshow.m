function fdshow(action);
% fdshow   Play the Filter Design Part of the "xhsy" from disk files.
%
% 该软件使用MATLAB语言(版本: 5.1以上), 实现数字滤波器的交互性教学设计. 学生进行实验
% 时, 在软件的指导下, 选择滤波器子类型(如FIR, IIR选择), 输入必要参数(采样频率, 通,
% 阻带频率及衰减), 计算中间数据, 直至得出所要求的滤波器数据, 并进行简单的分析. 从而
% 使学生对数字滤波器设计有一感性认识, 对于其基本步骤和原理有所了解. 能够独立设计数字
% 滤波器.
%
% 西安交通大学,  6/17/99
% See Also：fdslide, mytext1, lbqsjBtns, yhzfdview, yhzzpact, yhzfiltdes...
doi=16;

if nargin<1,
   filename='fdslide';
   action='initialize';
else
   if strmatch('#', action) 
      action=action(2:end);   
   end;   
end;

switch action
case 'initialize',
   LocalInitFigure(filename);
   
case 'next',
   LocalDoCmd(gcbf,+1);
   
case 'back',
   LocalDoCmd(gcbf,-1);

case 'reset',
   %slideData=get(gcbf,'UserData');
   %slideData.index=1;
   %set(gcbf, 'UserData', slideData);   
   LocalDoCmd(gcbf,0);

case 'autoplay',
   figNumber1 = gcbf;
   autoHndl=findobj(figNumber1, 'Type', 'uicontrol', ...
           'Style', 'pushbutton', ...
           'Tag', 'autoPlay');
   if isempty(autoHndl) 
      autoHndl=findobj(figNumber1, 'Type', 'uicontrol', ...
           'Style', 'pushbutton', ...
           'Tag', 'stop');
   end %if    
   allBtns=findobj(figNumber1, 'Type', 'uicontrol', ...
           'Style', 'pushbutton');
   % to check whether Handle is still there in case figure is closed
   if ishandle(autoHndl)
      btnStr=get(autoHndl, 'Tag');
   else
      btnStr='';
   end
   
   if strcmp(btnStr, 'autoPlay')
      slideData=get(figNumber1, 'UserData');
      %cmdlen=length(slideData.slide);
      %n=slideData.index;
      set(allBtns, 'Enable', 'off');
      set(autoHndl, 'String', '停止', 'Enable', 'on','Tag','stop');    
      currentSlide=slideData.path(slideData.index);
      while (currentSlide~=doi+9) & (currentSlide~=doi+26)...
                 & ishandle(autoHndl)...
                 & strcmp(get(autoHndl, 'tag'), 'stop'),
         figure(figNumber1);
      %   slideData=get(figNumber1, 'UserData');
         LocalDoCmd(figNumber1,+1);  
         slideData=get(figNumber1, 'UserData');
         drawnow;
         pause(2);
         %n=n+1;
         currentSlide=slideData.path(slideData.index);
      end;
   end
   if ishandle(autoHndl)
      set(autoHndl, 'String', '演示','Tag','autoPlay');    
      set(allBtns, 'Enable', 'on');
      slideData=get(figNumber1, 'UserData');
     % n=slideData.index;
      LocalEnableBtns(slideData.path(slideData.index), slideData)
   end
   
   % elseif strcmp(action,'info'),
   %    helpwin(mfilename);
   
end;    % switch action
% End of function fdshow

%===========================================
% function LocalInitUserData(nextHndl, backHndl, thandle)
% % Initialize index, slide, param, ...
%     slideData.index=1;
%     slideData.nexthandle=nextHndl;
%     slideData.backhandle=backHndl;
%     slideData.txthandle=thandle;
%     slideData.slide(1).code={''};
%     slideData.slide(1).text={''};
%     slideData.param(1).vars={};
%     set(gcf, 'Userdata', slideData);
%     LocalDoCmd(0);

%==========================================
function LocalDoCmd(figNumber1, rltvpath)
% execute the command in the command window 
% when ichange = 1, go to the next slide;
% when ichange = -1, go to the previous slide;
% when ichange = 0, initialize the original slide;

set(figNumber1, 'Pointer', 'watch');
% retrieve variables from saved UserData workspace

slideData=get(figNumber1,'UserData');

%-------------------------------------------------------------
% make the buttons and texts of last slide invisible
%-------------------------------------------------------------
aHTemp=findobj(figNumber1,'type','axes');
set(aHTemp,'visible','off');
for i=1:length(aHTemp)
   delete(get(aHTemp(i),'Children'));
end   
%delete(get(slideData.axesHandle(2),'Children'));
BtnHandlesTemp=slideData.BtnHandles(slideData.path(slideData.index),:);
for i=1:length(BtnHandlesTemp)
   if BtnHandlesTemp(i)~=0
      set(BtnHandlesTemp(i),'visible','off');
   end;
end;   
%---------------------------------------------------------
%update the next callback string     
%---------------------------------------------------------
[M,N]=size(slideData.slide(slideData.path(slideData.index)).next);
if M~=1
   rltvIndex=slideData.slide(slideData.path(slideData.index)).next(1,1);
   BtnHandlesTemp=slideData.BtnHandles(rltvIndex,:); 
   for i=1:length(BtnHandlesTemp)
       if BtnHandlesTemp(i)~=0 
          if get(BtnHandlesTemp(i),'value')
             nexttemp=slideData.slide(slideData.path(slideData.index)).next(i+1,:);
          end;   
       end;
   end;   % if the next slide index has something to do with the choice before
else nexttemp=slideData.slide(slideData.path(slideData.index)).next;
end;
BtnHandlesTemp=slideData.BtnHandles(slideData.path(slideData.index),:); 
if BtnHandlesTemp(1)==0
   slideData.next=nexttemp(1);
else   
  for i=1:length(BtnHandlesTemp)
     if BtnHandlesTemp(i)~=0
        if (get(BtnHandlesTemp(i),'value'))==1
           slideData.next=nexttemp(i);
        end;   
     end;
  end;
end;  

%-----------------------------------------------------------------
% update the slideData.path which stores the path the fdshow shows
%-----------------------------------------------------------------
if rltvpath==1,
   SlideShowi=slideData.next;
   slideData.index=slideData.index+1;
   slideData.path(slideData.index)=SlideShowi;
elseif rltvpath==-1,
   if slideData.index > 1,
      slideData.index=slideData.index-1;
   end;
   SlideShowi=slideData.path(slideData.index);
else, %rltvpath=0
   slideData.index=1;
   SlideShowi=slideData.path(slideData.index);
end;

cmdlen=length(slideData.slide);

% retrieve the varialbles in the whole program
%if SlideShowi>1
%   SlideShowVars=slideData.param(slideData.index-1).vars;
%  for SlideShown=1:size(SlideShowVars,1); 
%     eval([SlideShowVars{SlideShown,1} '=SlideShowVars{SlideShown,2};']);
%  end;
%end;

%  guarantee the index is always inside the boundary
if SlideShowi<=0,
   SlideShowi=1;
elseif SlideShowi>cmdlen
   SlideShowi=cmdlen;
end   
autoHndl=findobj(figNumber1, 'style', 'pushbutton', 'tag', 'autoPlay');
%stringtemp=get(autoHnd1,'string');
%disp(stringtemp);
if strcmp(get(autoHndl,'tag'), 'autoPlay')
   LocalEnableBtns(SlideShowi, slideData); 
end
% get slides
%SlideShowcmdS=slideData.slide(SlideShowi).code1;
%if length(SlideShowcmdS)>0
%   SlideShowcmdS=char(SlideShowcmdS);
%else
%   SlideShowcmdS='';
%end
%SlideShowcmdNum=size(SlideShowcmdS, 1);   

%------------------------------------------------------------
%display this slide's buttons
%------------------------------------------------------------
BtnHandlesTemp=slideData.BtnHandles(SlideShowi,:);
for i=1:length(BtnHandlesTemp)
   if BtnHandlesTemp(i)~=0
      set(BtnHandlesTemp(i),'visible','on');
      % axz 1999-11-30
      if SlideShowi==1,
         ls_tmp=deblankall(get(BtnHandlesTemp(i),'String'));
         if strcmp(ls_tmp(1:2),'//'),
            set(BtnHandlesTemp(i),'visible','off');
         end;
      end;
      % axz 1999-11-30
   end;
end;   
   
%-------------------------------------------------------------
%display this slide's text
%-------------------------------------------------------------
SlideShowtextStr=slideData.slide(SlideShowi).text;
% consider the empty case
if length(SlideShowtextStr)==0
   set(slideData.txthandle,'visible','off');
   set(slideData.frmHandle,'visible','off');
   % if there is no text, then this area should be prepared to show code2
else 
   set(slideData.txthandle,'visible','on');
   set(slideData.txthandle, 'String', SlideShowtextStr);
end


%------------------------------------------------------
% update the figure title
%------------------------------------------------------
      ttlstring=' ';
      for i=1:slideData.index
         if(i==1)
            ttlstring=strcat(slideData.slide(slideData.path(i)).ttl,ttlstring);
         else if ~isempty(slideData.slide(slideData.path(i)).ttl)           
                 ttlstring=strcat(slideData.slide(slideData.path(i)).ttl,'_',ttlstring);
              end;
         end;     
      end;   
      set(figNumber1,'name',ttlstring);
        
%------------------------------------------------------------
%evaluate the code1 %%%and code2
%------------------------------------------------------------
%for axesnum=1:2
%   if axesnum==1 SlideShowcmdS=slideData.slide(slideData.path(slideData.index)).code1;
%      else       SlideShowcmdS=slideData.slide(slideData.path(slideData.index)).code2;
%   end
 %SlideShowcmdS=slideData.slide(slideData.path(slideData.index)).code1;
 %if ~isempty(SlideShowcmdS)   
      %this code is not empty, so it will be evaluated and displayed
 %     set(gcf,'currentaxes',slideData.axesHandle(1));
 %     SlideShowcmdS=char(SlideShowcmdS);
%else SlideShowcmdS='';
%end
 %     SlideShowcmdNum=size(SlideShowcmdS, 1);   
%sHndl=findobj(figNumber1, 'Type', 'uicontrol', 'Tag', 'slide');
%set(sHndl, 'String', ['Slide ', num2str(SlideShowi)]);

% take comments out of the commands before eval them
%     SlideShowNoCmt=SlideShowcmdS;
%if ~isempty(SlideShowcmdS)
%      SlideShowNoCmt=LocalNoComments(SlideShowcmdS);
%end
%      SlideShowerrorFlag=0;
% add ',' at the end of each command 
%      SlideShowcmdStemp=[SlideShowNoCmt char(','*ones(size(SlideShowcmdS,1),1))];   
% make SlideShowcmdStemp in one line for eval (it has to be that way with 'for' or 'if')
%      SlideShowcmdStemp=SlideShowcmdStemp';
% evaluate the whole command window's code
set(gcf,'currentaxes',slideData.axesHandle(1));
slidePreTxt=slideData.slide(slideData.path(slideData.index)).code1;
for i=1: length(slidePreTxt)
   text(0.01,(1.1-0.2*i) ,slidePreTxt(i),'FontUnits','points','FontSize', 12);
end;   
clear slidePreTxt    
mytext1(slideData.path(slideData.index));  
%      set(slideData.axesHandle(1),'color',[0.8 0.8 0.8],'visible','off');
           
%      if SlideShowerrorFlag,
%        break;
%      end     
%   end %if
%end %for 


set(figNumber1, 'UserData', slideData);   


% clear all fdshow specific variables  
%clear SlideShowVars SlideShowcmdS SlideShowNoCmt cmdlen SlideShowi ichange 
%clear SlideShown mcwHndl SlideShowtextStr slideData SlideShowcmdNum
%clear BtnHandlesTemp i;
%clear nexttemp ttlstring;
%clear aHTemp M N;
% put variables into UserData workspace
%vars=who;
slideData=get(figNumber1, 'UserData');
%for SlideShown=1:size(vars,1),
%   vars{SlideShown,2}=eval(vars{SlideShown,1});
%end

%slideData.param(slideData.index).vars=vars;
%set(figNumber1, 'UserData', slideData);

set(figNumber1, 'Pointer', 'arrow');

%==================================================
%function NoComments=LocalNoComments(SlideShowcmdS)
% take out comments from command window commands
%SlideShowNoCmt=SlideShowcmdS;
%for SlideShowj=1:size(SlideShowcmdS,1)
%   SlideShowCmt=find(SlideShowcmdS(SlideShowj,:)=='%');
%   if ~isempty(SlideShowCmt)
%      if SlideShowCmt(1)==1
%         SlideShowNoCmt(SlideShowj,:)=';';
%      else
%         % check whether '%' is inside quotes
%         SlideShowQut=find(SlideShowcmdS(SlideShowj,:)=='''');
%         if ~isempty(SlideShowQut)
%            str=SlideShowcmdS(SlideShowj,:);  %to find out % inside '', and ignore it
%            a=(str=='''');
%            b=1-rem(cumsum(a),2);
%            c=(str=='%');
%            d=b.*c;
%            SlideShowCmt=find(d==1); 
%            if isempty(SlideShowCmt),
%               SlideShowCmt(1)=length(SlideShowcmdS(SlideShowj,:))+1;
%            end
%         end
%         SlideShowNoCmt(SlideShowj,1:(SlideShowCmt(1)-1))=SlideShowcmdS(SlideShowj, 1:(SlideShowCmt(1)-1));
%         SlideShowNoCmt(SlideShowj,SlideShowCmt(1):end)=' ';
%      end   
%   else
%      SlideShowNoCmt(SlideShowj,:)=SlideShowcmdS(SlideShowj, :);
%   end
%end
%NoComments=SlideShowNoCmt;

%====================================================
function LocalEnableBtns(i, slideData)
% control the enable property for Next and Prev. buttons
%cmdlen=length(slideData.slide);
doi=16;
nextHndl=slideData.nexthandle;
backHndl=slideData.backhandle;  
autoHndl=findobj(gcbf, 'Type', 'uicontrol', 'Style', 'pushbutton', 'Tag', 'autoPlay');  
set(autoHndl, 'Enable', 'on');

if i==doi+9 | i==doi+26 | i==doi+14,
   set(nextHndl, 'String', '结束','Callback','fdshow #reset');
   %set(nextHndl, 'String', '分析','Callback','yhzfdview');
   set(backHndl, 'Enable', 'on');
   %set(autoHndl,'String','快捷设计与比较','Callback','yhzfiltdes');
   set(autoHndl, 'Enable', 'off');
else,
   %autoCallbck=get(autoHndl,'callback');
   %if strcmp(autoCallbck,'yhzfiltdes')
   %   set(autoHndl,'String','演示','Callback','fdshow #autoplay');
   %end
   delete(findobj(gcf,'tag','tmp_ShowHn'));
   delete(findobj(gcf,'visible','on','tag','yhzview'));
   delete(findobj(gcf,'visible','on','tag','yhzfiltdes'));
   if i==1,
      set(backHndl, 'Enable', 'off');
      set(nextHndl, 'Enable', 'on', 'String', '开始','Callback','fdshow #next'); 
   else,
      set(nextHndl, 'Enable', 'on', 'String', '下一页>>','Callback','fdshow #next');
      set(backHndl, 'Enable', 'on');
   %autoCallbck=get(autoHndl,'callback');
   %if strcmp(autoCallbck,'yhzfiltdes')
   %   set(autoHndl,'String','演示','Callback','fdshow #autoplay');
   end;
end;


%===========build frame and label====================
function frmHandle=LocalBuildFrmTxt(frmPos, txtStr, uiStyle, uiTag, uiCallback)
% build frame and label
frmHandle=uicontrol( ...
        'Style', uiStyle, ...
        'HorizontalAlignment','left', ...
        'Units','normalized', ...
        'Max', 20, ...
        'Position',frmPos, ...
        'BackgroundColor',[0.50 0.50 0.50], ...
        'ForegroundColor',[0.50 0.50 0.50], ...             %generates an edge
        'String', txtStr, ...
        'Tag', uiTag);

%===================================================
function btHandle=LocalBuildBtn(btnStyle, btnNumber, labelStr, callbackStr, uiTag)
% build buttons and check boxes on the right panel
labelColor=[0.8 0.8 0.8];
top=0.9;
left=0.80;
btnWid=0.15;
btnHt=0.06;
bottom=0.05;
% Spacing between the button and the next command's label
spacing=0.03;

yPos=top-(btnNumber-1)*(btnHt+spacing);
if strcmp(labelStr, '关闭')==1
   yPos= bottom;
elseif strcmp(labelStr, '信息')==1
   yPos= bottom+btnHt+spacing; 
else
   yPos=top-(btnNumber-1)*(btnHt+spacing)-btnHt;
end
% ui position
btnPos=[left yPos btnWid btnHt];
btHandle=uicontrol( ...
        'Style', btnStyle, ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'Tag', uiTag, ...
        'Callback',callbackStr); 

function LocalInitFigure(filename)

figNumber1=figure( ...
   'Name','', ...
   'NumberTitle','off', ...
   'MenuBar','none', ...
   'IntegerHandle','off', ...
   'Visible','off',...
   'tag','fdshow');

slideData.axesHandle=axes('Units','normalized', ...
   'Position',[0.05 0.55 0.7 0.4],...
   'color',[0.8 0.8 0.8],...
   'visible','off',...
   'tag','mainaxes');
%axesHndl2=axes('Units','normalized', ...
%   'Position',[0.05 0.05 0.7 0.4],...
%   'color',[0.8 0.8 0.8],...
%   'visible','off');
%slideData.axesHandle=[axesHndl1];


% ===================================
top=0.5;
left=0.05;
right=0.75;
bottom=0.05;
spacing=0.005;
frmBorder=0.02;

% =====Set up the text Window==========       
% First, the Text Window frame 
frmPos=[left-frmBorder bottom-frmBorder ...
           (right-left)+2*frmBorder (top-bottom+2*frmBorder)];
slideData.frmHandle=LocalBuildFrmTxt(frmPos, '', 'frame', '', '');
% Then the editable text field
mcwPos=[left bottom (right-left) (top-bottom)]; 
slideData.txthandle=LocalBuildFrmTxt(mcwPos, '', 'text', 'comments', 'fdshow #changetext');
set(slideData.txthandle, ...
   'BackgroundColor',[1 1 1], ...
   'ForegroundColor',[0 0 0]);

% =====Information for all buttons======
left=0.80;
btnWid=0.15;

% ======The CONSOLE frame===============
frmBorder=0.02;
yPos=bottom-frmBorder;
frmPos=[left-frmBorder yPos btnWid+2*frmBorder 0.9+2*frmBorder];
frmHandle=LocalBuildFrmTxt(frmPos, '', 'frame', '', '');

% ======The frame ======================
%frmBorder=0.02;
%btnHt=0.04;
%yPos=top+.55;
%btnPos=[left yPos btnWid btnHt];
%slideHandle=LocalBuildFrmTxt(btnPos, '', 'text', 'slide', '');
%set(slideHandle, 'HorizontalAlignment','center');

% ======The Next button=================
btnNumber=1;
labelStr='开始 >>';
callbackStr='fdshow #next';  
slideData.nexthandle=LocalBuildBtn('pushbutton', btnNumber, labelStr, callbackStr, 'next');

% ======The back button=================
btnNumber=2;
labelStr='上一页<<';
callbackStr='fdshow #back';
slideData.backhandle=LocalBuildBtn('pushbutton', btnNumber, labelStr, callbackStr, 'back');

% =======The reset button===============    
btnNumber=3;
labelStr='重置';
callbackStr='fdshow #reset';
resetHndl=LocalBuildBtn('pushbutton', btnNumber, labelStr, callbackStr, 'reset');

% =======The autoplay button===============
btnNumber=4;
labelStr='演示';
callbackStr='fdshow #autoplay';
resetHndl=LocalBuildBtn('pushbutton', btnNumber, labelStr, callbackStr, 'autoPlay');

% =======The INFO button===============
infoHndl=LocalBuildBtn('pushbutton', 0, '信息', 'helpwindow fdshow', 'info');

% =======The CLOSE button==============    
closeHndl=LocalBuildBtn('pushbutton', 0, '关闭', 'close(gcbf)', 'close');

% Now initiate userdata and uncover the figure
% LocalInitUserData(nextHndl, backHndl, textHndl); 


slideData.slide(1).code1={''};
%slideData.slide(1).code2={''};
slideData.slide(1).text={''};
%slideData.param(1).vars={};

% slideData.index=1;
% set(figNumber1, 'Userdata', slideData);
% LocalDoCmd(figNumber1,0);

%============ open script =============      
% the script "filename" creates a structure called slideData  

%     slideData=get(figNumber1, 'UserData');
set(figNumber1,'DefaultTextFontSize',10,'DefaultUicontrolFontSize',12);
set(figNumber1,'DefaultAxesColor',[0.8,0.8,0.8]);
%set(
% default the text and uicontrol font size
slideData.slide=eval(filename);
%set(gcf,'currentaxes',slideData.axesHandle(1));
slideData.BtnHandles=eval('lbqsjBtns');
slideData.index=1;
slideData.path(slideData.index)=1;
slideData.filename=filename; 
%set(figNumber1,'name',slideData.slide(1).ttl);
set(figNumber1, 'UserData', slideData);
%allHandles=findobj(figNumber1);
LocalDoCmd(figNumber1,0);   


% last thing: turn it on
% we are calling slide show code above, so don't switch
% HandleVis until we have computed the first slide: in case
% the code calls gcf or some such thing, if the demo is
% invoked from the command line, the fig won't be visible if
% we set handlevis to callback before computing...

set(figNumber1, ...
        'Visible','on',...
        'HandleVisibility','callback');



