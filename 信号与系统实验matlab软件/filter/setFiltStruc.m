function filtStruc=setFiltStruc
% function setFiltStruc set the preparation data for yhzfiltdes
%
%
%


load yhzfd.mat
filtStruc.tf.num=bz;
filtStruc.tf.den=az;
filtStruc.ss=[];
filtStruc.zpk=[];
filtStruc.sos=[];
filtStruc.imp=[];
filtStruc.step=[];
filtStruc.t=[];
filtStruc.H=[];
filtStruc.G=[];
filtStruc.f=[];
filtStruc.Fs=1;
filtStruc.type='design';
filtStruc.lineinfo=[];
filtStruc.SPTIdentifier.type='Filter';
filtStruc.SPTIdentifier.version='2.0';
filtStruc.needEst=1;
%filter.Fs=fsa;
filtStruc.label=label;
[filtStruc.imp,filtStruc.t] = ...
   impz(bz,az,[],1);
% set default specs value:
specs.ir=[1,0]; % choose FIR
specs.FType=1; %LP
specs.firmethod=1; % Boxcar Window
specs.firN=41; %Window Length
specs.iirmethod=[1,1]; %buttorworth AP with BLT
specs.iirorder=7;
specs.f=[0.25;0.30];
specs.Rp=3;
specs.Rs=18;
specs.Fs=1;
specs.kaiserbeta=0;

% set specs according to the designed DF in fdshow
%showFigNum=findobj('tag','yhzfdshow');
%slideData=get(showFigNum,'UserData');
doi=16;
specs.FType=yhzfindvalue(2,'value');
fiir=yhzfindvalue(doi,'value');
specs.ir=[0,0];
specs.ir(fiir)=1;
if specs.ir(1) %FIR
   firmethod=yhzfindvalue(doi+1,'value'); %WINDOWS or FREQUENCY SAMPLING
   if  firmethod==2
       specs.firmethod=6;
       M=yhzfindvalue(doi+11,'edit');
       specs.firN=2*M+1;
       %Wsf=Ws/(2*pi);  %Load frequency parameters from yhzfd
       %specs.f=[Wsf;(0.5-Wsf)/2+Wsf];
       %% set Rp, Rs, Fs default value
    else %Windows Method
       specs.firmethod=yhzfindvalue(doi+6,'value');
       M=yhzfindvalue(doi+7,'edit');
       specs.firN=2*M+1;
       if specs.firmethod==5 %kaiser, set the beta
          specs.kaiserbeta=str2num(betaS); %from yhzfd.mat
          filtStruc.needEst=0;
       end
    end
    Wsf=Ws/(2*pi);  %Load frequency parameters from yhzfd
    specs.f=[Wsf; Wsf]; %(0.5-Wsf)/2+Wsf];
    % set Rp, Rs, Fs default value
 else %IIR 
    iirmethod1=yhzfindvalue(doi+18,'value');
    iirmethod2=yhzfindvalue(doi+21,'value');
    specs.iirmethod=[iirmethod1,iirmethod2];
    %iirPara=yhzfindvalue(doi+14+specs.FType,'edit');
    specs.Fs=fsa;
    filtStruc.Fs=fsa;
    specs.Rs=Rs; %iirPara(4);
    specs.Rp=Rp; %iirPara(3);
    specs.f=[fp;fs];       %[iirPara(1,:);iirPara(2,:)];
    specs.iirorder=N; %from yhzfd.mat
end   

filtStruc.specs=specs;

function jj=yhzfindvalue(index,style)
% find the choose button in slide(index)
showFigNum=findobj('tag','fdshow','visible','on');
slideData=get(showFigNum,'UserData');
if strcmp(style,'value')
 jj=1;
 while ~get(slideData.BtnHandles(index,jj),'value')
       jj=jj+1;
 end
else % style='edit'
   noneZero=find(slideData.BtnHandles(index,:));
   jjStr=get(slideData.BtnHandles(index,noneZero),'string');
   jj=str2num(jjStr);
end   
