function SetMouseStyle
% function SetMouseStyle serves for yhzzpact for set the proper mouse style in zpAxes a
%     according to different situations
%


zpud = get(gcf,'UserData');

state = btnstate(gcf,'zoomgroup','mousezoom');
zpPos=get(zpud.ht.zpAxes,'position');
respPos=get(zpud.ht.respAxes,'position');
cPos=get(gcf,'currentpoint');
if ~(cPos(1)>=zpPos(1) & cPos(1)<=zpPos(1)+zpPos(3) ...
      & cPos(2)>=zpPos(2) & cPos(2)<=zpPos(2)+zpPos(4) )
   if state==1 & (cPos(1)>=respPos(1) & cPos(1)<=respPos(1)+respPos(3) ...
      & cPos(2)>=respPos(2) & cPos(2)<=respPos(2)+respPos(4) )
      set(gcf,'pointer','cross');
   else
      set(gcf,'pointer','arrow');
   end   
else
   zorp=get(zpud.ht.zerosBtn,'value');
   if zorp
      setptr(gcf,'circle');
      
   else 
      setptr(gcf,'crosshair');
   end
   
end  