function helpinfo(filename);

if nargin==1 & ~isempty(filename),
   fid=fopen(filename);
   helptext=fscanf(fid,'%c');
   fclose(fid);
   pos=findstr(helptext,'[page]');
   ttlStr=helptext(1:pos(1)-2);
   hlpStr1='';  hlpStr2='';  hlpStr3='';
   lpos=length(pos);
   switch lpos
   case 1
      hlpStr1=str2mat(helptext(pos(1)+8:length(helptext)));
   case 2
      hlpStr1=str2mat(helptext(pos(1)+8:pos(2)-1));
      hlpStr2=str2mat(helptext(pos(2)+8:length(helptext)));
   case 3
      hlpStr1=str2mat(helptext(pos(1)+8:pos(2)-1));
      hlpStr2=str2mat(helptext(pos(2)+8:pos(3)-1));
      hlpStr3=str2mat(helptext(pos(3)+8:length(helptext)));
   end
   feval('helpwin',ttlStr,hlpStr1,hlpStr2,hlpStr3);                                   
end
