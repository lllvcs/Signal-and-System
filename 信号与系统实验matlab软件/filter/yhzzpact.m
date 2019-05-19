function yhzzpact(varargin)
% function yhzzpact operates response actions in zeros-poles design method
% 
% All Rights Reserved, Kayak Tech., Xi'an Jiaotong University
% Authors: Huanzhou Yu, Wei Guo, 6-9-99

if nargin==0
   fignum = yhzzpini;
   
   zpud = get(fignum,'UserData');
   if get(zpud.ht.modepop,'value')==1 %point by mouse mode
      yhzzpact('mousepoint');
   else % point by inputs mode
      yhzzpact('inputpoint');
   end 
   return
end

fignum=findobj('type','figure','tag','yhzzp');
action = varargin{1};

switch action
   
case 'modechange'
%==========================================================================
% yhzzpact('modechange')   
%
zpud=get(fignum,'UserData');
if get(zpud.ht.modepop,'value')==1 %point by mouse mode
      yhzzpact('mousepoint');
else % point by inputs mode
      yhzzpact('inputpoint');
end 

case 'inputpoint'
%============================================================================
% yhzzpact('inputpoint')
%
zpud = get(fignum,'UserData');
if get(zpud.ht.zerosBtn,'value')
   set(zpud.ht.zerosEdit,'enable','on');
else 
   set(zpud.ht.polesEdit,'enable','on');
end   
set(fignum,'windowButtonMotionFcn','');
set(zpud.ht.zpAxes,'ButtonDownFcn','');
set(fignum,'UserData',zpud);

case 'mousepoint'
%==========================================================================
% yhzzpact('mousepoint') 
% set the scenario for point-getting by mouse
%
zpud = get(fignum,'UserData');

set([zpud.ht.zerosEdit,zpud.ht.polesEdit],'enable','inactive');
set(fignum,'windowButtonMotionFcn','SetMouseStyle');
%getpts(fignum);
set(zpud.ht.zpAxes,'ButtonDownFcn','zpGetPoint');
set(fignum,'UserData',zpud);

case 'drawresponse'
%=========================================================================   
% yhzzpact('drawresponse')
% plot the frequency response according to current poles and zeros
%
zpud = get(fignum,'UserData');

%set(zpud.ht.zpAxes,'Xlimmode','auto','Ylimmode','auto');
yhzzpzoom('zpzoomout',fignum);
z = zpud.zeros;
p = zpud.poles;
[b,a] = zp2tf(z,p,1);
[H,F] = freqz(b,a,1024);
magH = 20*log10(abs(H));
set(fignum,'currentaxes',zpud.ht.respAxes);
grid on;
%plot(F,magH);
set(zpud.ht.respAxes,'Xlim',[0,pi],'ylimmode','auto');
set(zpud.ht.respline,'xdata',F,'ydata',magH);
zpud.respxlim=get(zpud.ht.respAxes,'xlim');
zpud.respylim=get(zpud.ht.respAxes,'ylim');
set(fignum,'UserData',zpud);

case 'choosezeros'
%=================================================================
%   yhzzpact('choosezeros')   
%
zpud = get(fignum,'UserData');
if ~get(zpud.ht.zerosBtn,'value')
   set(zpud.ht.zerosBtn,'value',1);
   return;
end
if get(zpud.ht.modepop,'value')==2
   set(zpud.ht.polesEdit,'enable','inactive');
   set(zpud.ht.zerosEdit,'enable','on');
end   
set(zpud.ht.polesBtn,'value',0);
set(fignum,'UserData',zpud);

case 'choosepoles'
%=================================================================
%   yhzzpact('choosepoles')   
%
zpud = get(fignum,'UserData');
if ~get(zpud.ht.polesBtn,'value')
   set(zpud.ht.polesBtn,'value',1);
   return;
end
if get(zpud.ht.modepop,'value')==2
   set(zpud.ht.zerosEdit,'enable','inactive');
   set(zpud.ht.polesEdit,'enable','on');
end   
set(zpud.ht.zerosBtn,'value',0);
set(fignum,'UserData',zpud);

case 'zEditChange'
%==================================================================
%   yhzzpact('zEditChange')
%
zpud = get(fignum,'UserData');
set(fignum,'currentaxes',zpud.ht.zpAxes);
[x y]=LocalgetEditPoint(zpud.ht.zerosEdit);
if any(isempty([x y]))
   disp('输入格式错误!');
   return
end   
zpPlotzp(fignum,x,y);
yhzzpact('drawresponse');

case 'pEditChange'
%==================================================================
%   yhzzpact('pEditChange')
%
zpud = get(fignum,'UserData');
set(fignum,'currentaxes',zpud.ht.zpAxes);
[x y]=LocalgetEditPoint(zpud.ht.polesEdit);
if any(isempty([x y]))
   disp('输入格式错误!');
   return
end   
zpPlotzp(fignum,x,y);
yhzzpact('drawresponse');

case 'clearLast'
%===================================================================
% yhzzpact('clearLast')
% clear last input zeros or poles
%
zpud = get(fignum,'UserData');
if isempty(zpud.zpHndl)
   disp('无零极点');
   return
end
%fndLst=find(ishandle(zpud.zpHndl(2)));
%lstIndex=fndLst(end);
% find the last zeros and poles' Handles
[M,N]=size(zpud.zpHndl);
lstIndex=M;
if zpud.zpHndl(lstIndex,1)  %1 for zeros and 0 for poles
   zpud.zeros(end)=[];
   if ishandle(zpud.zpHndl(lstIndex,3))
      zpud.zeros(end)=[];
   end
   set(zpud.ht.zerosEdit,'string','');
else
   zpud.poles(end)=[];
   if ishandle(zpud.zpHndl(lstIndex,3))
      zpud.poles(end)=[];
   end
   set(zpud.ht.polesEdit,'string','');
end
% update the poles and zeros lists
delete(zpud.zpHndl(lstIndex,2));
if ishandle(zpud.zpHndl(lstIndex,3))
   delete(zpud.zpHndl(lstIndex,3));
end   
zpud.zpHndl(lstIndex,:)=[];
% update the handles lists
if isempty(zpud.zeros) & isempty(zpud.poles)
   set(zpud.ht.respline,'xdata',[],'ydata',[]);
   set(fignum,'UserData',zpud);
else
   set(fignum,'UserData',zpud);
   yhzzpact('drawresponse');
end

case 'clearAll'
%=========================================================
% yhzzpact('clearAll')
% clear all the recorded zeros and poles
%
zpud = get(fignum,'UserData');
zpud.poles=[];
zpud.zeros=[];
zpud.zpHndl=[];
delete(get(zpud.ht.zpAxes,'childre'));
set(zpud.ht.zerosEdit,'string','');
set(zpud.ht.polesEdit,'string','');
set(zpud.ht.respline,'xdata',[],'ydata',[]);

set(fignum,'UserData',zpud);

case 'backFD'
%==========================================================
% yhzzpact('backFD')
% 
delete(fignum);
fdshow;

%------------------------------------------------------------------------
% yhzzpact('help')
% Callback of help button in toolbar
case 'help'
    %fig = gcf;
    zpud = get(fignum,'userdata');
    if  zpud.pointer ~= 2   % if not in help mode
       % enter help mode
        set(fignum,'windowButtonMotionFcn','');
        zpud.pointer=2;
        setptr('help');
        saveEnableControls = []; %ud.ht.FsHndl];
        ax = [zpud.ht.respAxes zpud.ht.zpAxes zpud.toolbar.toolbar];
        titleStr = '零极点设计滤波器_帮助';
        helpFcn = 'yhzzphelpstr';
        yhzspthelp('enter',fignum,saveEnableControls,ax,titleStr,helpFcn)
     else
        set(fignum,'windowButtonMotionFcn','SetMouseStyle');
        yhzspthelp('exit')
    end







end











function [x,y]=LocalgetEditPoint(editHndl)
%
%
%
ptsStr=get(editHndl,'string');
if ~isempty(str2num(ptsStr))
   orix=str2num(ptsStr);
   if length(orix)==1
      % 
      xx=real(orix);
      yy=imag(orix);
   elseif length(orix)==2 | isreal(orix)     
      % matrix, for real and imaginery part each
      xx=orix(1);
      yy=orix(2);
   else
      x=[]; 
      y=[];%disp('输入格式错误!');
      return
   end
else
   jjInd=findstr(ptsStr,'j');
   oriy=str2num(ptsStr(jjInd+1:end));
   if isempty(jjInd) | isempty(oriy)
      x=[];
      y=[]; %disp('输入格式错误!');
      return;
   end
   if jjInd==1
      % a imaginery number
      xx=0;
      yy=oriy;
   else
      orix=str2num(ptsStr(1:jjInd-2));
      if isempty(orix)
         x=[];
         y=[];%         disp('输入格式错误!');
         return
      end
      xx=orix;
      yy=oriy;
   end
end
x=xx;
y=yy;
   
