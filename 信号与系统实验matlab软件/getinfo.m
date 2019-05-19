function HelpInfoStr=getinfo(editHndl,partNum);
% GETINFO Get help information about SnS items
%         Separators:
%           [part] - Identifies different items' help information;
%           [n]    - Puts 'next line' in help information of a item. 

infoMat=get(editHndl,'UserData');
rowNum=size(infoMat,1);
j=0;
infoStr='';

for i=1:rowNum,
   lineStr=deblank(infoMat(i,:));
   if strcmp(lineStr,'[part]'),
      j=j+1;
   end;
   if j==partNum & ~strcmp(lineStr,'[part]'),
      if ~strcmp(lineStr,'[n]'),
         infoStr=[infoStr lineStr];
      else
         infoStr=[infoStr char(10)];
      end;
   elseif j>partNum,
      break;
   end;
end;

if nargout<1,
   helpwin('关于此项目的帮助信息',infoStr);
else,
   HelpInfoStr=infoStr;
end;
