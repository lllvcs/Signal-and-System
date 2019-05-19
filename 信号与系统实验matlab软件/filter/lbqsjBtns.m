function BtnHandles=lbqsjBtns
% LbqsjBtn initialize the checkboxes in every step of the filter design.
%   When completed, all the checkboxes is invisible.There handles is place in the gcf's 'UserData'
%   property which could be available later in evrey step when the corresponing ones need to be 
%   displayed.

Checked=1;
UnChecked=0;
O_x=0.05;
O_y=0.55;
X=0.7;
Y=0.3;
%spacing=0.07;
uiX=O_x+0.05;
uiY=O_y+Y-0.07;
uiWidth=0.66;
uiHeight=0.06;
dfOriginalIndex=16; %it is a temp variable for connecting the work by Wei Guo
%radioStyle='RadioButton';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize the doi+29 slides
default=ones(1,dfOriginalIndex+29);
for i=1:dfOriginalIndex+29,
   myslide(i).LblStr={};
   myslide(i).CBStr={};
   myslide(i).radioStyle='radiobutton';   
   myslide(i).position=[uiX uiY uiWidth uiHeight];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 1st slide
myslide(1).LblStr={'//模拟滤波器';'数字滤波器'};
myslide(1).CBStr={'';''};

default(1)=2;

%myslide(1).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2nd slide
myslide(2).LblStr={'低通滤波器';'高通滤波器';'带通滤波器'};
myslide(2).CBStr={'';'';''};

%myslide(2).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3rd slide
myslide(3).LblStr={'巴特沃思（Butterworth）';...
                   '切比雪夫I型（Chebyshev type I)';...
                   '切比雪夫II型（Chebyshev type II)'}; 
myslide(3).CBStr={'';'';''};

%myslide(3).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4th slide---dfOriginalIndex slide
for i=4:dfOriginalIndex-1
   myslide(i).LblStr={'';''};
   myslide(i).CBStr={'';''};
   
%   myslide(i).default=1;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1st slide in DF--dfOriginalIndex
doi=dfOriginalIndex;

myslide(doi).LblStr={'有限冲激响应数字滤波器的设计(FIR DF)';...
                     '无限冲激响应数字滤波器的设计(IIR DF)'};
myslide(doi).CBStr={'';''};

%myslide(doi).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2nd slide in DF--dfOriginalIndex+1
myslide(doi+1).LblStr={'窗口法（傅利叶级数法）';' 频率采样法'};
myslide(doi+1).CBStr={'';''};

%myslide(doi+1).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3rd slide in DF-dfOriginalIndex+2
myslide(doi+2).radioStyle='edit';
myslide(doi+2).position=[0.3,0.8,0.16,0.05];
myslide(doi+2).LblStr={'0.25pi'};
myslide(doi+2).CBStr={'mytext1(18)'};

%myslide(doi+2).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4th slide in DF-dfOriginalIndex+3
myslide(doi+3).radioStyle='edit';
myslide(doi+3).position=[0.3,0.8,0.16,0.05];
myslide(doi+3).LblStr={'0.75pi'};
myslide(doi+3).CBStr={'mytext1(19)'};

%myslide(doi+3).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5th slide in DF-dfOriginalIndex+4
myslide(doi+4).radioStyle='edit';
myslide(doi+4).position=[0.44,0.8,0.26,0.05];
myslide(doi+4).LblStr={'[0.25pi,0.75pi]'};
myslide(doi+4).CBStr={'mytext1(20)'};

%myslide(doi+4).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 6th slide in DF-dfOriginalIndex+5
%myslide(doi+5).LblStr={};
%myslide(doi+5).CBStr={};

%myslide(doi+5).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 7th slide in DF-dfOriginalIndex+6
myslide(doi+6).LblStr={'矩形窗(Rectangular Window)';...
                       '升余弦窗(海宁窗，Hanning Window)';...
                       '改进的升余弦窗(汉明窗,Hamming Window)';...                       
                       '二阶升余弦窗(不莱克曼窗,Blackman Window)';...
                       '凯撒窗(Kaiser Window), Beta=';...
                                              '7.865'};
myslide(doi+6).CBStr={'winplot(gcf,''boxcar'');';...
                      'winplot(gcf,''hanning'');';...
                      'winplot(gcf,''hamming'');';...
                      'winplot(gcf,''blackman'');';...
                      'winplot(gcf,''kaiser'');';...
                   %'betaBtn=findobj(''style'',''edit'',''visible'',''on'');set(betaBtn,''enable'',''on''); beta=get(betaBtn,''string''); winplot(gcf,''kaiser'',beta);';...
                      'winplot(gcf,''kaiser'');'};

%myslide(doi+6).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 			
% 8th slide in DF-dfOriginalIndex+7
myslide(doi+7).LblStr={'10'};
myslide(doi+7).position=[0.1,0.8,0.16,0.05];
myslide(doi+7).CBStr={'mytext1(23)'};
myslide(doi+7).radioStyle='edit';

%myslide(doi+7).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 9th slide in DF-dfOriginalIndex+8
%myslide(doi+8).LblStr={};
%myslide(doi+8).CBStr={};

%myslide(doi+8).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 10th slide in DF-dfOringinalIndex+9
%myslide(doi+9).LblStr={};
%myslide(doi+9).CBStr={};

%myslide(doi+9).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 11th slide in DF-dfOriginalIndex+10
myslide(doi+10).LblStr={'h(n)偶对称:h(n)=h(N-1-n); N为奇数; 相位: -w(N-1)/2';...
                        'h(n)偶对称:h(n)=h(N-1-n); N为偶数; 相位: -w(N-1)/2';...
                        'h(n)奇对称:h(n)=-h(N-1-n); N为奇数; 相位: -w(N-1)/2-pi/2';...
                        'h(n)奇对称:h(n)=-h(N-1-n); N为偶数; 相位: -w(N-1)/2-pi/2'};
myslide(doi+10).CBStr={'';'';'';''};

%myslide(doi+10).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 12th slide in DF-dfOriginal+11
myslide(doi+11).LblStr={'20'};
myslide(doi+11).CBStr={'mytext1(27)'};
myslide(doi+11).position=[0.25,0.8,0.16,0.05];
myslide(doi+11).radioStyle='edit';

%myslide(doi+11).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 13th slide in DF-dfOriginalIndex+12
%myslide(doi+12).LblStr={};
%myslide(doi+12).CBStr={};

%myslide(doi+12).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 14th slide in DF-dfOriginalIndex+13
%myslide(doi+13).LblStr={};
%myslide(doi+13).CBStr={};

%myslide(doi+13).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 15th slide in DF-dfOriginalIndex+14
%myslide(doi+14).LblStr={};
%myslide(doi+14).CBStr={};

%myslide(doi+14).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 16th slide in DF-dfOriginalIndex+15, 1st in IIR
myslide(doi+15).LblStr={'100';'3';'150';'15';'1000'};
CBtemp='mytext1(31)';
myslide(doi+15).CBStr={CBtemp;CBtemp;CBtemp;CBtemp;CBtemp};
myslide(doi+15).radioStyle='edit';
myslide(doi+15).position=[0.35,0.8,0.16,0.05];

%myslide(doi+15).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 17th slide in DF-dfOriginalIndex+16
myslide(doi+16).LblStr={'150';'3';'100';'15';'1000'};
CBtemp='mytext1(32)';
myslide(doi+16).CBStr={CBtemp;CBtemp;CBtemp;CBtemp;CBtemp};
myslide(doi+16).radioStyle='edit';
myslide(doi+16).position=[0.35,0.8,0.16,0.05];

%myslide(doi+16).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 18th slide in DF-dfOriginalIndex+17
myslide(doi+17).LblStr={'[300 700]','3','[200 800]','18','2000'};
CBtemp='mytext1(33)';
myslide(doi+17).CBStr={CBtemp;CBtemp;CBtemp;CBtemp;CBtemp};
myslide(doi+17).radioStyle='edit';
myslide(doi+17).position=[0.37,0.8,0.16,0.05];

%myslide(doi+17).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 19th slide in DF-dfOriginalIndex+18
myslide(doi+18).LblStr={'巴特沃思（Butterworth）';...
                        '切比雪夫I型（Chebyshev type I)';...
                        '切比雪夫II型（Chebyshev type II)'}; 
myslide(doi+18).CBStr={'';'';''};

%myslide(doi+18).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 20th slide in DF-dfOriginalIndex+19
%myslide(doi+19).LblStr={};
%myslide(doi+19).CBStr={};

%myslide(doi+19).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 21th slide in DF-dfOriginalIndex+20
%yslide(doi+20).LblStr={};
%yslide(doi+20).CBStr={};

%myslide(doi+20).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 22th slide in DF-dfOriginalIndex+21
myslide(doi+21).LblStr={'双线性变换法(Bilinear Transformation)';...
                        '脉冲响应不变法(Impulse Invariance Method)'};
myslide(doi+21).CBStr={'';''};

%myslide(doi+21).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 23th slide in DF-dfOriginalIndex+22
%myslide(doi+22).LblStr={};
%myslide(doi+22).CBStr={};

%myslide(doi+22).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 24th slide in DF-dfOriginalIndex+23
%myslide(doi+23).LblStr={};
%myslide(doi+23).CBStr={};

%myslide(doi+23).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 25th slide in DF-dfOriginalIndex+24
%myslide(doi+24).LblStr={};
%myslide(doi+24).CBStr={};

%myslide(doi+24).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 26th slide in DF-dfOriginalIndex+25
%myslide(doi+25).LblStr={};
%myslide(doi+25).CBStr={};

%myslide(doi+25).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 27th slide in DF-dfOriginalIndex+26
%myslide(doi+26).LblStr={};
%myslide(doi+26).CBStr={};

%myslide(doi+26).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 28th slide in DF-dfOriginalIndex+27
%myslide(doi+27).LblStr={};
%myslide(doi+27).CBStr={};

%myslide(doi+27).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 29th slide in DF-dfOriginalIndex+28
%myslide(doi+28).LblStr={};
%myslide(doi+28).CBStr={};

%myslide(doi+28).default=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 30th slide in DF-dfOriginalIndex+29
%myslide(doi+29).LblStr={};
%myslide(doi+29).CBStr={};

%myslide(doi+29).default=1;







for i=1:length(myslide)
   % if the radiostyle is not 'edit', it is radioButton
   %if ~strcmp(myslide(i).radioStyle,'edit')
   %   myslide(i).radioStyle='radiobutton';   
   %   myslide(i).position=[uiX uiY uiWidth uiHeight];
   %end;   
   for j=1:length(myslide(i).LblStr),
      if j==default(i),
         myslide(i).radio(j)=LocBldUI(myslide(i).radioStyle,char(myslide(i).LblStr(j)),...
            char(myslide(i).CBStr(j)),Checked,j,'',myslide(i).position);
      else,
         myslide(i).radio(j)=LocBldUI(myslide(i).radioStyle,char(myslide(i).LblStr(j)),...
            char(myslide(i).CBStr(j)),UnChecked,j,'',myslide(i).position);
      end;
   end;
   if i==doi+6
      %adjust the setting of the doi+6 's button, the last button should be edit
     set(myslide(doi+6).radio(6),'style','edit','position',[0.45,0.50,0.16,0.05],'enable','off','Backgroundcolor',[1 1 1]);
     betaPos=get(myslide(doi+6).radio(5),'position');
     betaPos(3)=0.45-betaPos(1);
     set(myslide(doi+6).radio(5),'position',betaPos);
   end
   GroupRadioBtns(myslide(i).radio);   
end

%adjust the setting of the doi+6 's button, the last button should be edit
%set(myslide(doi+6).radio(6),'style','edit','position',[0.45,0.50,0.16,0.05],'enable','off');
%betaPos=get(myslide(doi+6).radio(5),'position');
%betaPos(3)=0.45-betaPos(1);
%set(myslide(doi+6).radio(5),'position',betaPos);
% adjust the properties of those edit uicontrols
editHndls=findobj(gcf,'style','edit');
set(editHndls,'HorizontalAlignment','left');         

for i=1:length(myslide)
   if ~length(myslide(i).radio)
      BtnHandles(i,:)=0;
   else   
      for j=1:length(myslide(i).radio)
         BtnHandles(i,j)=myslide(i).radio(j);
      end;
   end;    
end;
%end lbqsjBtns


function uiHandle=LocBldUI(uiStyle,LblStr,CBStr,Value,uiNo,uiTag,uiPos)
% Build UI Controls

%O_x=0.05;
%O_y=0.55;
%X=0.7;
%Y=0.3;

%spacing=0.07;

%uiX=O_x+0.05;
%uiY=O_y+Y-uiNo*spacing;
%uiWidth=0.56;
%uiHeight=0.06;

bkgrndClr=get(gcf,'Color');

if strcmp(uiStyle,'edit')
   spacing=0.08;
else
   spacing=0.07;
end   
position=uiPos;
position(2)=position(2)-(uiNo-1)*spacing;

if strcmp(uiStyle,'edit')
%   position=uiPos;
  % uiX=uiX+0.2;
  % uiWidth=0.16;
  % uiHeight=0.05;
  % uiY=0.80;
   bkgrndClr=[1 1 1];
  %disp('this is for edit')
   %disp(get(gca,'position'))
end


uiHandle=uicontrol(...
   'Style',uiStyle,...
   'String',LblStr,...
   'CallBack',CBStr,...
   'Unit','Normalized',...
   'Position',position,...
   'BackgroundColor',bkgrndClr,...
   'Value',[Value],...
   'Visible','off',...
   'Tag',uiTag);
%end LocBldUI


function GroupRadioBtns(RadioBtns)
% Make those radiobuttons referred in RADIOBTNS mutual excluded
RadioBtns=findobj(RadioBtns,'flat','style','radiobutton');
if ~isempty(RadioBtns)
   for i=1:length(RadioBtns)
   CallBack=get(RadioBtns(i),'CallBack');
   if ~isempty(CallBack)
      CallBack=strcat(CallBack,';');
   end   
   set(RadioBtns(i),'UserData',RadioBtns);
   AddedCB=['Group=get(gco,''UserData'');'...
         'set(Group,''Value'',0);'...
         'set(gco,''Value'',1);'];
   if ~isempty(CallBack)
      CallBack=strcat(CallBack,AddedCB);
   else
      CallBack=AddedCB;
   end   
   set(RadioBtns(i),'CallBack',CallBack);
   end
end %GroupRadioBtns