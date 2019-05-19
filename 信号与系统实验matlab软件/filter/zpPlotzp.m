function zpPlotzp(fignum,x,y)
%
%
%
%
zpud = get(fignum,'UserData');
newpt= x+j*y;
SS='';
if y~=0
   newpt=[newpt;x-j*y];
   SS=['ʿj',abs(num2str(y))];
end
newptS=[num2str(x),SS];
if get(zpud.ht.zerosBtn,'value')
   newzpHndl1=text(x,y,'o','color',[1 0 0]);
   newzpHndl2=NaN;
   newzp=1;
   if y~=0
      newzpHndl2=text(x,-y,'o','color',[1 0 0]);
%      newzpHndl=[newzpHndl;newzpHndl2];
   end
   set(zpud.ht.zerosEdit,'string',newptS,'ForegroundColor',[1 0 0]);
   zpud.zeros=[zpud.zeros;newpt];
else
   newzpHndl1=text(x,y,'x','color',[0 1 0]);
   newzpHndl2=NaN;
   if y~=0
      newzpHndl2=text(x,-y,'x','color',[0 1 0]);
%      newzpHndl=[newzpHndl;newzpHndl2];
   end
   set(zpud.ht.polesEdit,'string',newptS,'ForegroundColor',[0 1 0]);
   zpud.poles = [zpud.poles;newpt];
   newzp=0;
end
newzpHndl=[newzp,newzpHndl1,newzpHndl2];
zpud.zpHndl=[zpud.zpHndl;newzpHndl];
set(fignum,'UserData',zpud);