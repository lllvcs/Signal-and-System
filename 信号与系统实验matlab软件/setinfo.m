function setinfo(editHndl,infoFile);
% SETINFO Read help information about SnS items from help files, 
%         and then store them in the uicontrols' UserData. 

strMat=' ';
fid=fopen(infoFile);
lineStr=fgetl(fid);
while (lineStr~=-1),
   strMat=str2mat(strMat,lineStr);
   lineStr=fgetl(fid);
end;
fclose(fid);
rowNum=size(strMat,1);
strMat=strMat(2:(rowNum-1),:);
set(editHndl,'UserData',strMat);
