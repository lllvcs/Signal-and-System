function winplot(figNumber,winS)
% winplot plots a specified window style(winSyle) in the proper position. 
% It is used in the slide show for DFSHOW of the (doi+6)th(22th) slide.
% the lvqsjBtns function also calls back it in evaluate form, because according to
% different values of this slide's buttons, the shown window style is also 
% different.
%
% by Huanzhou Yu and Wei Guo, Xi'an Jiaotong University, Kayak Tech. 4/14/99
% Copyright (C) 1998-1999, Version 2.0
% Any suggestion is welcomed: hzhyu@hotmail.com 

load yhzfd
winStyle=winS;
%set(0,'CurrentFigure',figNumber);
%load yhzfd winAxesHndl;
%if exist('winAxesHndl')==1
%   delete(winAxesHndl);
%end;
delete(findobj('Tag','winPlotAxes'));

x1=0.05;
x2=0.45;
y=0.1;
width=0.3;
height=0.3;
n=11;
nExt=5;

fignum=findobj('tag','fdshow','visible','on');
set(fignum,'currentaxes',findobj('tag','mainaxes','parent',fignum));
text(0.35,-0.25,[winS,' window:'],'fontsize',11,'tag','winPlotAxes');
%findobj('string',[winS,' Window'])
%save yhzfd winStyle;
betaBtn=findobj('style','edit','visible','on','parent',fignum);
if ~strcmp(winS,'kaiser')
   set(betaBtn,'enable','off')
   b=eval([winStyle '(n)']);
else 
   set(betaBtn,'enable','on');
   betaS=get(betaBtn,'string');
%   if nargin==3
   b=eval([winStyle '(n,' betaS ')']);
%   end 
end      
[w,f]=freqz(b/sum(b),1,1024);
% plot the time domain response
winAxesHndl(1)=axes('position',[x1,y,width,height]);
%yhzstem(b);
yhzstem([zeros(nExt,1);b;zeros(nExt,1)]);

set(gca,'color',[0.8,0.8,0.8],...
        'Xlim',[1,n+2*nExt],...
         'XTick',[(n+2*nExt+1)/2],...
         'XTickLabel','0',...
         'Tag','winPlotAxes');
XLabel('Time Domain');
      
%plot the frequency domain response
winAxesHndl(2)=axes('position',[x2,y,width,height]);
semilogy(f,(abs(w)));
set(gca,'color',[0.8,0.8,0.8],...
   'Xlim',[0,3],...
   'Tag','winPlotAxes');
Xlabel('Frequency Domain');
clear figNumber winS x1 x2 y width height n nExt b w f 
save yhzfd % yhzfd=yhzfd+'winStyle'+betaS %if kaiser
%save yhzfd.mat winAxesHndl;