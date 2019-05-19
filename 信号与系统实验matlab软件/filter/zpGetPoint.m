function zpGetPoint
%
%
%
%
%
zpud = get(gcf, 'UserData');
Gpts = get(zpud.ht.zpAxes,'CurrentPoint');
x= Gpts(1,1);
y= Gpts(1,2);
zpPlotzp(gcf,x,y);
%zpPlotzp(gcf,'poles',x,y);   

%set(gcf,'UserData',zpud);

yhzzpact('drawresponse');