function cplayshow(action);
% CPLAYSHOW   Play demo style slide shows from disk files.
%   CPLAYSHOW filename plays slide show from file filename.
%   Slide shows can be created using MAKESHOW.
%    
%   See also MAKESHOW.
%
%   Kelly Liu, 5-20-1996
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 1.23 $  $Date: 1997/11/21 23:26:46 $
%   汉化版 axz 1999-10-10

if nargin<1,
   disp('幻灯片的播放需要先指定一个幻灯片脚本文件，例如：cplayshow intro');
   break
else
   if strmatch('#', action) 
      action=action(2:end);
   else
      filename=action;
      action='initialize';
   end;
end;

switch action
case 'initialize',
   LocalInitFigure(filename);
   
case 'next',
   LocalDoCmd(gcbf,1);
   
case 'back',
   LocalDoCmd(gcbf,-1);

case 'reset',
   slideData=get(gcbf,'UserData');
   slideData.index=1;
   set(gcbf, 'UserData', slideData);   
   LocalDoCmd(gcbf,0);

case 'autoplay',
   figNumber = gcbf;
   autoHndl=findobj(figNumber, 'Type', 'uicontrol', ...
           'Style', 'pushbutton', ...
           'Tag', 'autoPlay');
   allBtns=findobj(figNumber, 'Type', 'uicontrol', ...
           'Style', 'pushbutton');
   % to check whether Handle is still there in case figure is closed
   if ishandle(autoHndl)
      btnStr=get(autoHndl, 'String');
   else
      btnStr='';
   end
   
   if strcmp(btnStr, '自动播放')
      slideData=get(figNumber, 'UserData');
      cmdlen=length(slideData.slide);
      n=slideData.index;
      set(allBtns, 'Enable', 'off');
      set(autoHndl, 'String', '停止', 'Enable', 'on');    
      while (n<cmdlen) ...
                 & ishandle(autoHndl)...
                 & strcmp(get(autoHndl, 'String'), '停止'),
         figure(figNumber);
         LocalDoCmd(figNumber,1);  
         drawnow;
         pause(2);
         n=n+1;
      end;
   end
   if ishandle(autoHndl)
      set(autoHndl, 'String', '自动播放');    
      set(allBtns, 'Enable', 'on');
      slideData=get(figNumber, 'UserData');
      n=slideData.index;
      LocalEnableBtns(n, slideData)
   end
   
   % elseif strcmp(action,'info'),
   %    helpwin(mfilename);
   
end;    % switch action
% End of function cplayshow

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
function LocalDoCmd(figNumber, ichange)
% execute the command in the command window 
% when ichange = 1, go to the next slide;
% when ichange = -1, go to the previous slide;
% when ichange = 0, stay with the current slide;

set(figNumber, 'Pointer', 'watch');
% retrieve variables from saved UserData workspace

slideData=get(figNumber,'UserData');
SlideShowi=slideData.index+ichange;
cmdlen=length(slideData.slide);
if SlideShowi>1
   SlideShowVars=slideData.param(SlideShowi-1).vars;
   for SlideShown=1:size(SlideShowVars,1); 
      eval([SlideShowVars{SlideShown,1} '=SlideShowVars{SlideShown,2};']);
   end;
end;

%  guarantee the index is always inside the boundary
if SlideShowi<=0,
   SlideShowi=1;
elseif SlideShowi>cmdlen
   SlideShowi=cmdlen;
end   
autoHndl=findobj(figNumber, 'style', 'pushbutton', 'tag', 'autoPlay');
if strcmp(get(autoHndl,'String'), '自动播放')
   LocalEnableBtns(SlideShowi, slideData); 
end
% get slides
SlideShowcmdS=slideData.slide(SlideShowi).code;
if length(SlideShowcmdS)>0
   SlideShowcmdS=char(SlideShowcmdS);
else
   SlideShowcmdS='';
end
SlideShowcmdNum=size(SlideShowcmdS, 1);   
SlideShowtextStr=slideData.slide(SlideShowi).text;

% consider the empty case
if length(SlideShowtextStr)==0
   SlideShowtextStr='';
   % else leave it alone: no need to call char(SlideShowtextStr)
end
set(slideData.txthandle, 'String', SlideShowtextStr);
sHndl=findobj(figNumber, 'Type', 'uicontrol', 'Tag', 'slide');
set(sHndl, 'String', ['第 ' num2str(SlideShowi) ' 屏']);

% take comments out of the commands before eval them
SlideShowNoCmt=SlideShowcmdS;
if ~isempty(SlideShowcmdS)
   SlideShowNoCmt=LocalNoComments(SlideShowcmdS);
end
SlideShowerrorFlag=0;
% add ',' at the end of each command 
SlideShowcmdStemp=[SlideShowNoCmt char(','*ones(size(SlideShowcmdS,1),1))];   
% make SlideShowcmdStemp in one line for eval (it has to be that way with 'for' or 'if')
SlideShowcmdStemp=SlideShowcmdStemp';
% evaluate the whole command window's code
eval(SlideShowcmdStemp(:)', 'SlideShowerrorFlag=1;');  

if SlideShowerrorFlag,
   break;
end     
slideData.index=SlideShowi;
set(figNumber, 'UserData', slideData); 

% clear all cplayshow specific variables  
clear SlideShowVars SlideShowcmdS SlideShowNoCmt cmdlen SlideShowi ichange 
clear SlideShown mcwHndl SlideShowtextStr slideData SlideShowcmdNum
% put variables into UserData workspace
vars=who;
slideData=get(figNumber, 'UserData');
for SlideShown=1:size(vars,1),
   vars{SlideShown,2}=eval(vars{SlideShown,1});
end

slideData.param(slideData.index).vars=vars;
set(figNumber, 'UserData', slideData);

set(figNumber, 'Pointer', 'arrow');

%==================================================
function NoComments=LocalNoComments(SlideShowcmdS)
% take out comments from command window commands
SlideShowNoCmt=SlideShowcmdS;
for SlideShowj=1:size(SlideShowcmdS,1)
   SlideShowCmt=find(SlideShowcmdS(SlideShowj,:)=='%');
   if ~isempty(SlideShowCmt)
      if SlideShowCmt(1)==1
         SlideShowNoCmt(SlideShowj,:)=';';
      else
         % check whether '%' is inside quotes
         SlideShowQut=find(SlideShowcmdS(SlideShowj,:)=='''');
         if ~isempty(SlideShowQut)
            str=SlideShowcmdS(SlideShowj,:);  %to find out % inside '', and ignore it
            a=(str=='''');
            b=1-rem(cumsum(a),2);
            c=(str=='%');
            d=b.*c;
            SlideShowCmt=find(d==1); 
            if isempty(SlideShowCmt),
               SlideShowCmt(1)=length(SlideShowcmdS(SlideShowj,:))+1;
            end
         end
         SlideShowNoCmt(SlideShowj,1:(SlideShowCmt(1)-1))=SlideShowcmdS(SlideShowj, 1:(SlideShowCmt(1)-1));
         SlideShowNoCmt(SlideShowj,SlideShowCmt(1):end)=' ';
      end   
   else
      SlideShowNoCmt(SlideShowj,:)=SlideShowcmdS(SlideShowj, :);
   end
end
NoComments=SlideShowNoCmt;

%====================================================
function LocalEnableBtns(i, slideData)
% control the enable property for Next and Prev. buttons
cmdlen=length(slideData.slide);
nextHndl=slideData.nexthandle;
backHndl=slideData.backhandle;  
autoHndl=findobj(gcbf, 'Type', 'uicontrol', 'Style', 'pushbutton', 'Tag', 'autoPlay');  
set(autoHndl, 'Enable', 'on');
if i==cmdlen,
   set(nextHndl, 'Enable', 'off');
   set(backHndl, 'Enable', 'on');
   set(autoHndl, 'Enable', 'off');
elseif i==1,
   set(backHndl, 'Enable', 'off');
   set(nextHndl, 'Enable', 'on', 'String', '开始 >>');
else
   set(nextHndl, 'Enable', 'on', 'String', '下一步 >>');
   set(backHndl, 'Enable', 'on');        
end

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
        'ForegroundColor',[1 1 1], ...             %generates an edge
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
elseif strcmp(labelStr, '帮助信息')==1
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

figNumber=figure( ...
        'Name','幻灯片播放器', ...
        'NumberTitle','off', ...
        'IntegerHandle','off', ...
        'MenuBar','none', ...
        'Visible','off');

%set(figNumber,'MenuBar','figure');

axes(   'Units','normalized', ...
        'Position',[0.075 0.47 0.65 0.45]);

% ===================================
top=0.37;
left=0.05;
right=0.75;
bottom=0.05;
spacing=0.005;
frmBorder=0.02;

% =====Set up the text Window==========       
% First, the Text Window frame 
frmPos=[left-frmBorder bottom-frmBorder ...
           (right-left)+2*frmBorder (top-bottom+2*frmBorder)];
frmHandle=LocalBuildFrmTxt(frmPos, '', 'frame', '', '');
% Then the editable text field
mcwPos=[left bottom (right-left) top-bottom]; 
slideData.txthandle=LocalBuildFrmTxt(mcwPos, '', 'text', 'comments', 'cplayshow #changetext');
set(slideData.txthandle, 'BackgroundColor', [1 1 1], 'ForegroundColor', [0 0 0]);

% =====Information for all buttons======
left=0.80;
btnWid=0.15;

% ======The CONSOLE frame===============
frmBorder=0.02;
yPos=bottom-frmBorder;
frmPos=[left-frmBorder yPos btnWid+2*frmBorder 0.9+2*frmBorder];
frmHandle=LocalBuildFrmTxt(frmPos, '', 'frame', '', '');

% ======The frame ======================
frmBorder=0.02;
btnHt=0.04;
yPos=top+.55;
btnPos=[left yPos btnWid btnHt];
slideHandle=LocalBuildFrmTxt(btnPos, '第 1 屏', 'text', 'slide', '');
set(slideHandle, 'HorizontalAlignment','center');

% ======The Next button=================
btnNumber=1;
labelStr='开始 >>';
callbackStr='cplayshow #next';  
slideData.nexthandle=LocalBuildBtn('pushbutton', btnNumber, labelStr, callbackStr, 'next');

% ======The back button=================
btnNumber=2;
labelStr='上一步 <<';
callbackStr='cplayshow #back';
slideData.backhandle=LocalBuildBtn('pushbutton', btnNumber, labelStr, callbackStr, 'back');

% =======The reset button===============    
btnNumber=3;
labelStr='重置';
callbackStr='cplayshow #reset';
resetHndl=LocalBuildBtn('pushbutton', btnNumber, labelStr, callbackStr, 'reset');

% =======The autoplay button===============
btnNumber=4;
labelStr='自动播放';
callbackStr='cplayshow #autoplay';
resetHndl=LocalBuildBtn('pushbutton', btnNumber, labelStr, callbackStr, 'autoPlay');

% =======The INFO button===============
infoHndl=LocalBuildBtn('pushbutton', 0, '帮助信息', ['helpinfo(''' filename  '.txt'')'], 'info');

% =======The CLOSE button==============    
closeHndl=LocalBuildBtn('pushbutton', 0, '关闭', 'close(gcbf)', 'close');

% Now initiate userdata and uncover the figure
% LocalInitUserData(nextHndl, backHndl, textHndl); 


slideData.slide(1).code={''};
slideData.slide(1).text={''};
slideData.param(1).vars={};

% slideData.index=1;
% set(figNumber, 'Userdata', slideData);
% LocalDoCmd(figNumber,0);

%============ open script =============      
% the script "filename" creates a structure called slideData  

%     slideData=get(figNumber, 'UserData');
slideData.slide=eval(filename);
slideData.index=1;
slideData.filename=filename; 
set(figNumber, 'UserData', slideData);
LocalDoCmd(figNumber,0);   


% last thing: turn it on
% we are calling slide show code above, so don't switch
% HandleVis until we have computed the first slide: in case
% the code calls gcf or some such thing, if the demo is
% invoked from the command line, the fig won't be visible if
% we set handlevis to callback before computing...

set(figNumber, ...
        'Visible','on',...
        'HandleVisibility','callback');



