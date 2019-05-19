function mytext1(ind)    %,s1,s2,s3,s4,s5,s6)

%cla reset
%set(gca,'Box','on','XTick',[],'YTick',[],'Visible','off');
slideData=get(gcf,'Userdata');
doi=16;
%switch ind 
%    case doi+15
%       s1='现在,需确定LPDF的参数:';
%       s2='通带截止频率fp(Hz):';
%       s3='通带最大衰减Rp(dB):';
%       s4='阻带最低频率fs(Hz):';
%       s5='阻带最小衰减Rs(dB):';
%       s6='采样频率fsa(Hz):';
%    case doi+16
%       s1='现在,需确定HPDF的参数:';
 %      s2='通带下限频率fp(Hz):';
 %      s3='通带最大衰减Rp(dB):';
 %      s4='阻带上限频率fs(Hz):';
 %      s5='阻带最小衰减Rs(dB):';
 %      s6='采样频率fsa(Hz):';
 %   case doi+17
 %      s1='现在,需确定BPDF的参数:';
 %      s2='通带频率fp(Hz)=[fpl,fph]:';
 %      s3='通带最大衰减Rp(dB):';
 %      s4='阻带频率fs(Hz)=[fsl,fsh]:';
 %      s5='阻带最小衰减Rs(dB):';
 %      s6='采样频率fsa(Hz):';                                                  
%end;       
%for i = 1:nargin-1
   %disp('This is for mytext')
   %disp(get(gca,'position'))
%   eval(['text(0.01,' num2str(1.1-0.2*i) ',s' num2str(i) ...
%         ',''FontUnits'',''points'',''FontSize'',' num2str(12) ');']);
%end
switch ind
  case {doi+2,doi+3} 
  %axes('position',[0.25,0.55,0.3,0.2],'XTick',[0,pi/4,pi/2,pi]);
  %w=0:pi/100:2*pi;
  %Hw=ones(size(w));
  %Hw(26:176)=0;
  %plot(w,Hw);
  %set(gca,'color',[0.8,0.8,0.8]);
    delete(findobj('tag','doi+2/3'));
    axes('position',[0.25,0.57,0.3,0.15]);
    w=0:pi/500:2*pi;
    Hw=ones(size(w));
    Wsstr=get(slideData.BtnHandles(ind),'string');
    Ws=LocalStrTrans(Wsstr);
    WsNum=round(Ws/pi*500);
    Hw(WsNum:1001-WsNum)=0;
   % Title('理想低通频响');
   Ws1=[0,Ws,2*pi-Ws,2*pi];    % Ws1 record the range whose value is 1
   if (ind==doi+3) 
      Hw=1-Hw;
      Ws1=[Ws,pi,pi,2*pi-Ws];
    %   Title('理想高通频响');
    end   
    plot(w,Hw);
    axis([0,2*pi,0,1]);
  %axis off;
   % set(gca,'color',[0.8,0.8,0.8],...
   %  'XTick',[]);
  if ind==doi+2 
     Title('理想低通频响');
  else Title('理想高通频响');
  end 
   xTckPos=[0,Ws,pi,2*pi-Ws,pi*2];%-[0.05,0.1,0.05,0.3,0.07];
   set(gca,'XTick',xTckPos,...
      'XTickLabel',{'0',Wsstr,'pi',strcat('2pi-',Wsstr),'2pi'},...
      'Tag','doi+2/3');
   save yhzfd Ws Ws1;
   %XlblHnd=text(xTckPos,...
   %  -0.10*ones(1,5),{'0','Ws','\pi','2\pi-Ws','2\pi'});
   % set(XlblHnd,'fontsize',11);
    
  case doi+4
    delete(findobj('tag','doi+4')); 
    axes('position',[0.15,0.57,0.45,0.15]);
    w=0:pi/500:2*pi;
    Hw=zeros(size(w));
    Wsstr=get(slideData.BtnHandles(doi+4),'string');
    Ws=LocalStrTrans(Wsstr);
    WsNum=round(Ws/pi*500);
    Hw(WsNum(1):WsNum(2))=1;
    Hw(1001-WsNum(2):1001-WsNum(1))=1;
    Ws1=[Ws(1),Ws(2),2*pi-Ws(2),2*pi-Ws(1)];
    plot(w,Hw);
    set(gca,'XTick',[],'Xlim',[0,2*pi]);
    Title('理想带通频响');
    xTicPos=[0,Ws(1),Ws(2),pi,pi*2]; %-...
           % [0.05,0.1,0.2,0.05,0.4,0.4,0.07];
    %XlblHnd=text(xTicPos,-0.1*ones(1,7),...
    %        {'0','Wsl','Wsh','\pi','2\pi-Wsh','2\pi-Wsl','2\pi'});
    %set(XlblHnd,'fontsize',9);
    set(gca,'XTick',xTicPos,'XTickLabel',{'0','Wsl','Wsh','pi','2pi'},'tag','doi+4'); 
    save yhzfd Ws Ws1
 case doi+5
    j=1;
    while ~get(slideData.BtnHandles(2,j),'value') 
          j=j+1;
    end
    
    % switch j
   % case 1
    Wsstr=get(slideData.BtnHandles(doi+1+j),'string');
    % transfer the string to caculable digits
   % for i=1:length(Wsstr)-1
   %    if (Wsstr(i:i+1)=='pi')& (Wsstr(i-1)~='*')
   %       Wsstr=strcat(Wsstr(1:i-1),'*',Wsstr(i:length(Wsstr)));
   %    end
   % end
   % Ws=str2num(Wsstr);
   Ws=LocalStrTrans(Wsstr);
   Wsnor=Ws/pi;
    hi=LocalPlotHi(50,Wsnor,j);
  %  switch j
  %   case 1
  %      hi=firls(50,[0,Wsnor,Wsnor,1],[1,1,0,0]);
  %   case 2
  %      hi=firls(50,[0,Wsnor,Wsnor,1],[0,0,1,1]);
  %   case 3
  %      hi=firls(50,[0,Wsnor(1),Wsnor(1),Wsnor(2),Wsnor(2),1],...
  %         [0,0,1,1,0,0]);
  %   end %switch j   
        %disp(length(hi));
    axes('position',[0.15,0.57,0.6,0.28]);
    yhzstem(hi);
    hold on; 
    plot(zeros(size(hi)));
    %axis([1,51,-0.1,0.3]);
    set(gca,'Xlim',[1,51]);
    set(gca,'XTick',[26],'XTickLabel','0');
    Xlabel('n');
    yLabel('hi(n)');
    filType=j;
    clear doi j i ind Wsstr hi slideData   
    save yhzfd 
    % save Ws, Wsnor, filType 
    %end %switch j
 case doi+6
    currentBtn=findobj('visible','on','style','radiobutton','value',1);
    winTypeS=get(currentBtn,'string');
    ls_strtmp=''; winType='boxcar';
    for li_row=1:size(winTypeS,1),
       ls_strtmp=char(winTypeS(li_row,:));
       if ~isempty(findstr(ls_strtmp,'窗')), break; end;
    end;
    if ~isempty(findstr(ls_strtmp,'Rectangular')) winType='boxcar'; end;
    if ~isempty(findstr(ls_strtmp,'Hanning')) winType='hanning'; end;
    if ~isempty(findstr(ls_strtmp,'Hamming')) winType='hamming'; end;
    if ~isempty(findstr(ls_strtmp,'Blackman')) winType='blackman'; end;
    if ~isempty(findstr(ls_strtmp,'Kaiser')) winType='kaiser'; end;
    %'save yhzfd winType',
    winplot(gcf,winType),
    clear winType currentBtn;
    clear winTypeS ls_strtmp li_row;
 case doi+7
    %mytext1(21,'');
    delete(findobj('Tag','slide23Axes'));
    load yhzfd 
    winLenM=str2num(get(slideData.BtnHandles(doi+7),'string'));
    winLenN=2*winLenM+1;
    % yhzfd: Ws, Wsnor, filType, winStyle,and possibly: winLenM,winLenN,win
    if strcmp(winStyle,'kaiser')
       win=eval([winStyle '(' num2str(winLenN) ',' betaS ')']);
    else  
       win=eval([winStyle '(' num2str(winLenN) ')']);
    end   
    % plot the time domain response
    %save yhzfd winStyle;
    axes('position',[0.15,0.57,0.6,0.18]);
    %yhzstem(b);
    nExt=3;
    yhzstem([zeros(nExt,1);win;zeros(nExt,1)]);
    oPos=(winLenN+2*nExt+1)/2;
    set(gca,...
           'Xlim',[1,winLenN+2*nExt],...
           'XTick',[oPos-winLenM,oPos,oPos+winLenM],...
           'XTickLabel',{strcat('-',num2str(winLenM)),'0',num2str(winLenM)},...
           'Tag','slide23Axes');
    %save winStyle;
    clear doi ind nExt oPos i slideData  
    save yhzfd %winStyle winLenM winLenN win Ws Wsnor filType 
 case doi+8
    load yhzfd
    % yhzfd:=7 varibles winStyle, winLenM, winLenN, win, Ws, Wsnor, filType 
    hi=LocalPlotHi(winLenN-1,Wsnor,filType);
    axes('position',[0.15,0.57,0.6,0.18]);
    nExt=3;
    winN=[zeros(1,nExt),win',zeros(1,nExt)];
    hiN=[zeros(1,nExt),hi,zeros(1,nExt)];
    %N=[1:size(winN)];
    yhzstem(winN','c:');
    hold on;
    yhzstem(hiN');
    hold on;
    plot(zeros(size(winN)));
    set(gca,...
           'Xlim',[1,winLenN+2*nExt],...
           'XTick',[nExt+1,nExt+winLenM+1,nExt+winLenN],...
           'XTickLabel',{'1',strcat('M+1=',num2str(winLenM+1)),strcat('N=',num2str(winLenN))});
    clear doi ind nExt N slideData   
    save yhzfd %winStyle winLenM winLenN win Ws Wsnor filType hi winN hiN
    
 case doi+9
    load yhzfd
    % yhzfd: winStyle winLenM winLenN win Ws Wsnor filType hi winN hiN
    h=win'.*hi;
    hN=winN.*hiN;
    [w,f]=freqz(h/sum(h),1,1024);
    nExt=3;
    XTickLabel1={'1',strcat('M+1=',num2str(winLenM+1)),strcat('N=',num2str(winLenN))};
    LocalResult(hN',[1,winLenN+2*nExt],[nExt+1,nExt+winLenM+1,nExt+winLenN],XTickLabel1,w,f,Wsnor,winLenN,1);
   % plot the time domain response
   % axes('position',[0.1,0.57,0.6,0.28]);
   % yhzstem(hN');
   % hold on; 
   % plot(zeros(size(hN')));
   % nExt=3;
   % set(gca,...%'color',[0.8,0.8,0.8],...
   %        'Xlim',[1,winLenN+2*nExt],...
   %        'XTick',[nExt+1,nExt+winLenM+1,nExt+winLenN],...
   %        'XTickLabel',{'1',strcat('M+1=',num2str(winLenM+1)),strcat('N=',num2str(winLenN))});
    % plot the frequency domain response
   % [w,f]=freqz(h/sum(h),1,1024);
   % axes('position',[0.1,0.17,0.3,0.28]);
   % semilogy(f,(abs(w)));
   % WsstrT=strcat(num2str(Wsnor'),'pi');
   % [M,N]=size(WsstrT);
   % if M==1
   %    Wsstr={'0',WsstrT,'pi'};
   %else
   %    Wsstr={'0',WsstrT(1,:),WsstrT(2,:),'pi'};
   % end;   
   % set(gca,....%'color',[0.8,0.8,0.8],...
   %    'Xlim',[0,pi],...
   %    'XTick',[0,Wsnor*pi,pi],...
   %    'XTickLabel',Wsstr);
    %plot the phase response
   % XLabel('幅频响应');
    %axes('position',[0.45,0.17,0.27,0.28]);
    %plot(f,angle(w));%unwrap(angle(w)));
    %set(gca,...%'color',[0.8,0.8,0.8],...
    %       'Xlim',[0,4*pi/(winLenN-1)],...
    %       'XTick',[0,4*pi/(winLenN-1)],...%Wsnor*pi,pi],...
    %       'XTickLabel',{'0','4pi/(N-1)'},...
    %       'Ylim',[-pi,pi],...
    %       'YTick',[-pi,-pi/2,0,pi/2,pi],...
    %       'YTickLabel',{'-pi','-pi/2','0','pi/2','pi'});
    %XLabel('相频响应');  
    % Prepare the data transfered to the yhzfdview, which is used to analysis the result
    label=get(gcf,'name');
    bz=h;
    az=1;
    WsstrT=strcat(num2str(Wsnor'),'pi');
    [MM,NN]=size(WsstrT);
    if MM~=1 
       WsstrT=[WsstrT(1,:),'  ',WsstrT(2,:)]; 
    end;
    paraLabel={['窗口:',winStyle];['长度:',num2str(length(h))];['截止频率:',WsstrT]};
    %paraLabel=char(paraLabel);
    clear doi ind slideData nExt w f XTickLabel1 WsstrT MM NN
    %clear WsstrT Wsstr 
    save yhzfd;
    %  yhzfd: winStyle winLenM winLenN win Ws Wsnor filType hi winN hiN h hN label bz az paraLabel
 case doi+10
    set(slideData.BtnHandles(doi+10,1:4),'Enable','on');
    j=1;
    while ~get(slideData.BtnHandles(2,j),'value')
       j=j+1;
    end
    if j==1
       set(slideData.BtnHandles(doi+10,3:4),'Enable','off');
%       if get(slideData.BtnHandles(doi+10,3),'value')| get(slideData.BtnHandles(doi+10,4),'value')
 %        set(slideDataData.BtnHandles(doi+10,1),'value',1
    elseif j==2
        set(slideData.BtnHandles(doi+10,2:3),'Enable','off');
    end 
    enoffBtns=findobj('Enable','off','value',1);
    if ~isempty(enoffBtns)
       set(slideData.BtnHandles(doi+10,1),'value',1);
       set(enoffBtns,'value',0);
    end   
 case doi+11
    %load yhzfd;
    % Ws
    MStr=get(slideData.BtnHandles(doi+11),'string');
    j=1;
    while ~get(slideData.BtnHandles(26,j),'value')
       j=j+1;
    end
    set(gcf,'currentaxes',slideData.axesHandle(1));
    if (j==1)|(j==3)
       text(0.01,0.7,'N=2*M+1, M=');
       N=str2num(MStr)*2+1;
    else 
       text(0.01,0.7,'N=2*M, M=');
       N=str2num(MStr)*2;
    end   
    delete(findobj('tag','N='));
    text(0.01,0.5,strcat('N=',num2str(N)),'tag','N=');
    j=1;
    while ~get(slideData.BtnHandles(2,j),'value') 
          j=j+1;
    end
    jIndex=doi+1+j;
    mytext1(jIndex);
    load yhzfd;
    % yhzfd: Ws Ws1
    hold on;
    %    N=str2num(MStr);
    wN=(2*pi/N)*[0:N];
    yhzstem(wN,ones(size(wN)),'y:');
    clear doi ind slideData j jIndex MStr wN
    save yhzfd ;
    % save N Ws Ws1 
 case doi+12
    axes('position',[0.15,0.57,0.6,0.28]);
    load yhzfd;
    % yhzfd: N Ws Ws1
    for i=1:N
       wN=(2*pi/N)*(i-1);
       if ((wN>=Ws1(1)) & (wN<=Ws1(2))) | ((wN>=Ws1(3)) & (wN<=Ws1(4)))
          HK(i)=1;
       else HK(i)=0;
       end  % if   
    end  %for
    HK(N+1)=HK(1);
    %r=1000/N;
    %HwN=resample(Hw,N,1000);
    yhzstem(HK);
    set(gca,'Xlim',[1,N+1],'XTick',[1,N+1],'XTickLabel',{'0',strcat('N=',num2str(N))});
    clear i wN doi ind slideData 
    save yhzfd
    % save yhzfd: HK N Ws Ws1
 case doi+13
    load yhzfd
    % yhzfd: HK N Ws Ws1
    j=1;
    while ~get(slideData.BtnHandles(doi+10,j),'value')
       j=j+1;
    end   
    text(0.01,0.5,strcat('FILTER TYPE',' ',num2str(j),':'),'fontsize',10);
    Hk=HK;
    if j==1|j==4 
       HkStr={'H   =H        ';...
              '  k      N-k  '};
    else 
       HkStr={'H   = -H       ';...
              '  k        N-k '};
       for i=1:round(length(HK)/2)
          Hk(N+2-i)=-HK(i);
       end   
    end;
  
    %    HkStrC=cellstr(HkStr);
    phasek=-pi*(1-1/N)*[0:N];
    if j==1|j==2
       phsStr={'                        2\pi     N-1     ';...
               'PHASE:     -k x------ x -------  ';...
               '                         N        2      '};
    else      
       phsStr={'                       2\pi      N-1      \pi       ';...
                 'PHASE:     -k x------ x ------- - -----     ';...
                 '                        N        2        2         '};
       phasek=phasek-pi/2;    
    end
 %   phsStrC=cellstr(phsStr);       
    text([0.3,0.3],[0.5,0.47], HkStr,'fontsize',10);
   
    text([0.3,0.3,0.3],[0.2,0.15,0.1],phsStr,'fontsize',10);
    axes('position',[0.1,0.17,0.3,0.28]);
    yhzstem(Hk);
    set(gca,'XLim',[1,N+1],'XTick',[1,N+1],'XTickLabel',{'0',strcat('N=',num2str(N))});
    XLabel('Hk');
    axes('position',[0.45,0.17,0.27,0.28]);
    yhzstem(phasek);
    set(gca,'XLim',[1,N+1],'XTick',[1,N+1],'XTickLabel',{'0',strcat('N=',num2str(N))});
    XLabel('PHASE');
    
    clear j i HkStr phsStr doi slideData ind
    save yhzfd    %HK Hk phasek N Ws Ws1
    % yhzfd: HK Hk phasek N Ws Ws1
 case doi+14
    load yhzfd
    %yhzfd: HK Hk phasek N Ws Ws1
    j=sqrt(-1);
    H=Hk(1:N).*exp(j*phasek(1:N));
    h=real(ifft(H));  % k.*exp(j*phasek));
    Xlim1=[1,N];
    XTick1=[1,N];
    XTickLabel1={'0',strcat('N-1=',num2str(N-1))};
    [w,f]=freqz(h,1,512);
    Wsnor=Ws/pi;
    LocalResult(h,Xlim1,XTick1,XTickLabel1,w,f,Wsnor,N,1);  
    % prepare the data in yhzfd which will retrieved by yhzfdview
    label=get(gcf,'name');
    bz=h;
    az=1;
    j=1;
    while ~get(slideData.BtnHandles(doi+10,j),'value')
       j=j+1;
    end   
    if j==1|j==2
       firTypeS='h(n)=h(N-1-n)';
    else 
       firTypeS='h(n)=-h(N-1-n)';
    end   
    WsstrT=strcat(num2str(Wsnor'),'pi');
    [MM,NN]=size(WsstrT);
    if MM~=1 
       WsstrT=[WsstrT(1,:),'  ',WsstrT(2,:)]; 
    end;
    paraLabel={['采样点数:',num2str(N)];firTypeS;['截止频率:',WsstrT]};
    clear j H Xlim1 XTick1 XTickLabel1 w f Wsnor doi slideData ind MM NN WsstrT firTypeS
    save yhzfd 
    % yhzfd: HK Hk phasek N Ws Ws1 h label bz az paraLabel
    
 %============IIR=============   
case {doi+15,doi+16,doi+17}
   fp=str2num(get(slideData.BtnHandles(ind,1),'string'));
   Rp=str2num(get(slideData.BtnHandles(ind,2),'string'));
   fs=str2num(get(slideData.BtnHandles(ind,3),'string'));
   Rs=str2num(get(slideData.BtnHandles(ind,4),'string'));
   fsa=str2num(get(slideData.BtnHandles(ind,5),'string'));
   clear doi slideData ind
   save yhzfd
   % yhzfd: fp,Rp,fs,Rs,fsa
   
case doi+19
   load yhzfd
   % yhzfd: fp Rp fs Rs fsa
   Wp=2*pi*fp;
   Ws=2*pi*fs;
   Wsa=2*pi*fsa;
   j=1;
   while ~get(slideData.BtnHandles(34,j),'value')
       j=j+1;
   end
   switch j
     case 1
        afProto='butter';
        [N, Wn]=BUTTORD(Wp, Ws, Rp, Rs, 's');
     case 2
        afProto='cheby1';
        [N, Wn] =CHEB1ORD(Wp, Ws, Rp, Rs, 's');
     case 3
        afProto='cheby2';
        [N, Wn] =CHEB2ORD(Wp, Ws, Rp, Rs, 's');
   end;
   text(0.01,0.5,['LPAF Prototype:',afProto],'fontsize',11);
   text(0.01,0.3,['ORDER N=',num2str(N)],'fontsize',11);
   text(0.01,0.1,['3dB Wn=',num2str(Wn),' rad/s'],'fontsize',11);
   clear j doi slideData ind
   save yhzfd
   % yhzfd: fp Rp fs Rs fsa Wp Ws Wsa N Wn afProto
case doi+20
   load yhzfd
   % yhzfd: fp Rp fs Rs fsa Wp Ws Wsa N Wn afProto
   text(0.01,0.7,[num2str(N),' order ',afProto,' AF']);
   switch afProto
     case 'butter'
          [z,p,k] = buttap(N);
     case 'cheby1'
          [z,p,k] = cheb1ap(N,Rp);
     case 'cheby2'
          [z,p,k] = cheb2ap(N,Rs);
   end     
   [num,den] = zp2tf(z,p,k); 
   numStr=LocalPolyStr(N,num,'p',0);
   denStr=LocalPolyStr(N,den,'p',0);
   sepStr(1:(N+1)*15)='-';
   sepStr=char(sepStr);
   text(0.01,0.4,'Ha(p)=','fontsize',11);
   text([0.15,0.12,0.15],[0.5,0.4,0.3],{numStr,sepStr,denStr},'fontsize',10);
   text(0.05,0.1,'p: after normalized','fontsize',9);
   clear doi slideData ind numStr denStr sepStr
   save yhzfd
   %yhzfd: fp Rp fs Rs fsa Wp Ws Wsa N Wn afProto num den
   %text(0.01,0.4,sepStr,'fontsize',12);
   % Str=' ';
  % for i=N:-1:0
  %    if 
%   poleStr=' ';
%   for i=1:length(p)
%     if abs(imag(p(i)))<=1e-6
%%         p(i)=real(p(i));
%      end;   
%      poleStr=strcat(poleStr,'(s-(',num2str(p(i)),'))');
%   end   
%   text(0.01,0.5,poleStr,'fontsize',9);
case doi+21
   set(slideData.BtnHandles(ind,[1:2]),'enable','on');
   if get(slideData.BtnHandles(2,2),'value')
      set(slideData.BtnHandles(ind,2),'enable','off')
   end %Impulse Response Invariance Method is not suited to HP and BP
case doi+22
   load yhzfd
   % yhzfd: fp Rp fs Rs fsa Wp Ws Wsa N Wn afProto num den
   numUnnStr=LocalPolyStr(N,num,'(s/Wn)',0);
   denUnnStr=LocalPolyStr(N,den,'(s/Wn)',0);
   sepStr(1:(N+1)*20)='-';
   sepStr=char(sepStr);
  % text(0.01,0.4,'Ha(s)=','fontsize',11);
   text([0.01,0.01,0.01],[0.5,0.4,0.3],{numUnnStr,sepStr,denUnnStr},'fontsize',9);
   text(0.05,0.1,['Wn=' num2str(Wn) 'rad/s'],'fontsize',9);
   clear numUnnStr denUnnStr sepStr doi ind slideData
   save yhzfd
   %yhzfd: fp Rp fs Rs fsa Wp Ws N Wsa Wn afProto num den
case doi+23
   load yhzfd
   % yhzfd: fp Rp fs Rs fsa Wp Ws N Wsa Wn afProto num den
   %[numZ,denZ]=impinvar(num,den,fsa);
   a=den;
   b=num;
   %[M,N] = size(a);
   %if M>1 & N>1
   % error(' A must be vector.')
%end
%[M,N] = size(b);
%if M>1 & N>1
%    error(' B must be vector.')
%end

   b = b(:);
   a = a(:);
   a1 = a(1);
   if a1 ~= 0
   % Ensure monotonicity of a
      a = a/a1;
   end    
   kimp=[];
    %if length(b) > length(a)
    %error('Numerator B(s) degree must be no more than denominator A(s) degree.')
%elseif  (length(b)==length(a))  
% remove direct feed-through term, restore later
    kimp = b(1)/a(1);
    b = b - kimp*a;  b(1)=[];
%end

%--- Achilles Heel is repeated roots, so I adapted code from residue
%---  and resi2 here.  Now I can group roots, and there is no division.
    pt = roots(a).';
    Npoles = length(pt);
    tol=1e-3;
    [mm,ip] = mpoles(pt,tol);
    pt = pt(ip);
    starts = find(mm==1);
    ends = [starts(2:length(starts))-1;Npoles];
    for k = 1:length(starts)
       jkl = starts(k):ends(k);
       polemult(jkl) = mm(ends(k))*ones(size(jkl));
       poleavg(jkl) = mean(pt(jkl))*ones(size(jkl));
    end
    rez = zeros(Npoles,1);
    kp = Npoles;
    while kp>0 
       pole = poleavg(kp);
       mulp = polemult(kp);
       numT = b;
       denT = poly( poleavg([1:kp-mm(kp),kp+1:Npoles]) );
       rez(kp) = polyval(numT,pole) ./ polyval(denT,pole);
       kp = kp-1;
     for k=1:mulp-1
         [numT,denT] = polyder(numT/k,denT);
         rez(kp) = polyval(numT,pole) ./ polyval(denT,pole);
         kp = kp-1;
     end
  end
  %rez=rez';
  %pt0=find(abs(imag(pt))<1e-6);
  %pt(pt0)=real(pt(pt0));
  %rez0=find(abs(imag(rez))<1e-6);
  %rez(rez0)=real(rez(rez0));
  %rezStr=['(',num2str(rez(,:)),')Wn'];
  pt=pt';
  rezStr=cell(size(rez));
  ptStr=cell(size(pt));
  for i=1:length(rez)
     %rezT1=num2str(rez(i));
     if abs(imag(rez(i)))>1e-6 
        rezStr(i)=cellstr(['(',num2str(rez(i)),')Wn']);
     else
        rezStr(i)=cellstr([num2str(rez(i)),'Wn']);
     end;
     %rezStr(i)=rezT2;
     if abs(imag(pt(i)))<1e-6 & real(pt(i))>1e-6
        ptStr(i)=cellstr(['s-',num2str(pt(i)),'Wn']);
     else
        ptStr(i)=cellStr(['s-(',num2str(pt(i)),')Wn']);
     end
     xPos=0.15+mod(i-1,2)*0.4;
     yPos=0.7-floor((i-1)/2)*0.28;
     text(0.01,0.65,'Ha(s)=','fontsize',11);
     if i==1
        sepStr='-------------------------------------';
     else
        sepStr='+ -------------------------------------';
     end
     text([xPos,xPos-0.02,xPos],[yPos,yPos-0.05,yPos-.12],{char(rezStr(i)),sepStr,char(ptStr(i))},'fontsize',10);
  end    
  %text(0.01,0.7,rezStr','fontsize',10);
  %text(0.01,0.5,ptStr','fontsize',10);
  clear doi ind slideData
  clear a b a1 kimp Npoles tol ip starts ends k jkl 
  clear poleavg polemult kp pole mulp
  clear numT denT ptStr sepStr xPos yPos i  
  save yhzfd
  %yhzfd: pt rez fp Rp fs Rs fsa Wp Ws N Wsa Wn afProto num den rezStr mm
  
case doi+24
   load yhzfd
   % yhzfd: pt rez fp Rp fs Rs fsa Wp Ws N Wsa Wn afProto num den rezStr mm
   for i=1:length(rez)
       ptS=num2str(pt(i));
       for j=1:length(ptS)
          ptSS(2*j-1)='^';
          ptSS(2*j)=ptS(j);
       end   
       if  abs(imag(pt(i)))<1e-6 & real(pt(i))>1e-6
          ptZStr(i)=cellstr(['1-e^(^W^n^/^2^\pi^f^s^a^)',ptSS,'z^-^1']);
       else 
          ptZStr(i)=cellstr(['1-e^(^W^n^/^2^\pi^f^s^a^)^(',ptSS,'^)z^-^1']);
       end
     xPos=0.13+mod(i-1,2)*0.45;
     yPos=0.7-floor((i-1)/2)*0.28;
     text(0.01,0.65,'H(z)=','fontsize',11);
     if i==1
        sepStr='------------------------------------------';
     else
        sepStr='+ ------------------------------------------';
     end
     text([xPos,xPos-0.02,xPos],[yPos,yPos-0.05,yPos-.12],{[char(rezStr(i)),'/2\pifsa'],sepStr,char(ptZStr(i))},'fontsize',9);
     clear ptSS
  end
  yPos=yPos-0.25;
  text(0.05,yPos,['Wn=',num2str(Wn),' rad/s;   fsa=',num2str(fsa),' Hz'],'fontsize',9);  
  clear i doi ind slideData
  clear ptS j ptZStr sepStr xPos yPos
  save yhzfd
  %yhzfd:  pt rez fp Rp fs Rs fsa Wp Ws N Wsa Wn afProto num den rezStr mm
  
case doi+25
   load yhzfd
   %yhzfd:  pt rez fp Rp fs Rs fsa Wp Ws N Wsa Wn afProto num den rezStr mm
   r = rez;
   p = pt;
   p=p';
   Fsa=fsa/Wn;%*2*pi/Wn;
   az = poly(exp(p/Fsa)).';
   tn = (0:length(rez)-1)'/Fsa;
   mm1 = mm(:).' - 1;
   tt = tn(:,ones(1,length(rez))) .^ mm1(ones(size(tn)),:);
   ee = exp(tn*p);
   hh = ( tt.*ee ) * r;
   bz = filter(az,1,hh);
   %if ~isempty(kimp)
% restore direct feed-through term
   bz = [bz(:);0];
%end
   bz = bz/Fsa;
   bz = bz(:).';   % make them row vectors
   az = az(:).';
   %cmplx_flag = any(imag(b)) | any(imag(a));
   %f ~cmplx_flag
   %if  norm(imag([bz az]))/norm([bz az]) > 1000*eps
   %  warnStr = sprintf( ...
   %  ['  The output is not correct/robust.\n' ...
   %   '  Coeffs of B(s)/A(s) are real, but B(z)/A(z) has complex coeffs.\n' ...
   %   '  Probable cause is rooting of high-order repeated poles in A(s).']);
   %  warning(warnStr)
   %end
   %bz = real(bz);  
   %az = real(az);
  %end
  %if a1~=0
  %  az = az*a1;
  %end
  %text(0.01,0.7,num2str(bz'),'fontsize',10);
  %text(0.31,0.7,num2str(az'),'fontsize',10);
  bz(find(abs(bz)<1e-6))=0;
  bz=real(bz);
  az(find(abs(az)<1e-6))=0;
  numZStr=LocalPolyStr(length(bz)-1,bz,'z',length(bz)-1);
  denZStr=LocalPolyStr(length(az)-1,az,'z',length(az)-1);
  %text(0.01,0.7,numZStr,'fontsize',10);
  %text(0.01,0.5,denZStr,'fontsize',10);
  sepStr(1:(N+1)*16)='-';
  sepStr=char(sepStr);
  text(0.01,0.7,'H(z)=','fontsize',11);
  text([0.01,0.01,0.01],[0.5,0.4,0.3],{numZStr,sepStr,denZStr},'fontsize',10);
  clear ind doi slideData
  clear r p Fsa tn mm1 tt ee hh numZStr denZStr sepStr
  save yhzfd
  %yhzfd: pt rez fp Rp fs Rs fsa Wp Ws N Wsa Wn afProto num den rezStr mm az bz
case doi+26
  load yhzfd
  %yhzfd: pt rez fp Rp fs Rs fsa Wp Ws N Wsa Wn afProto num den rezStr mm az bz
  % or   fp Rp fs Rs fsa Wp Ws Wsa N Wn afProto num den Wpre j cosW0(if BP) bz az (if from BLT)
  n=50;
  [h,t]=impz(bz,az,n);
  %yhzstem(t,h);
  [w,f]=freqz(bz,az,512);
  Xlim1=[1,n];
  XTick1=[1,11,21,31,41];
  XTickLabel1={'0','10','20','30','40'};
  Wsnor=(Wn/fsa)/pi;
  LocalResult(h,Xlim1,XTick1,XTickLabel1,w,f,Wsnor,n);
  % prepare the data for yhzfdview which are saved in yhzfd.mat
  label=get(gcf,'name');
  %jj=1;
  % while ~get(slideData.BtnHandles(doi+21,jj),'value')
  %     jj=jj+1;
  %end
  %if jj==1
  %   transTypeS='双线性变换法';
  %else 
  %   transTypeS='脉冲响应不变法';
  %end
  if length(fp)>1
     paraS=['fpass=',num2str(fp),'(Hz)'];%,',Fsa=',num2str(fsa),'(Hz)'];
  else
     paraS=['fpass=',num2str(fp),',fstop=',num2str(fs),'(Hz)']; %,',Fsa=',num2str(fsa),'(Hz)'];
  end   
  paraLabel={['模拟低通原型:',num2str(N),'阶 ',afProto];paraS;['Fsa=',num2str(fsa),'(Hz)']};
  clear doi ind slideData paraS
  clear Xlim1 XTick1 XTickLabel1 Wsnor
  save yhzfd
  % yhzfd: pt rez fp Rp fs Rs fsa Wp Ws N Wsa Wn afProto num den rezStr mm az bz h t w f n
  % or fp Rp fs Rs fsa Wp Ws Wsa N Wn afProto num den Wpre j cosW0(if BP) bz az h t w f n
  % and both have: label az bz paraLabel
%----------------IIR BLT--------------------------  
case doi+27 
  load yhzfd
  % yhzfd: fp Rp fs Rs fsa Wp Ws Wsa N Wn afProto num den
  j=1;
  while ~get(slideData.BtnHandles(2,j),'value')
      j=j+1;
  end
  % j=1: LP; 2:HP; 3:BP 
  switch j
    case 1 %LP
       Wpre=tan(Wn/(2*fsa));
       text(0.01,0.5,['Low Pass: Wpre=tg(Wn/(2fsa))=',num2str(Wpre)],'fontsize',11);
    case 2 %HP
       Wpre=1/tan(Wn/(2*fsa));
       text(0.01,0.5,['High Pass: Wpre=ctg(Wn/(2fsa))=',num2str(Wpre)],'fontsize',11);
    case 3 %BP
       Wnz=Wn/fsa;
       cosW0=sin(sum(Wnz))/sum(sin(Wnz));
       Wpre=(cosW0-cos(Wnz(2)))/sin(Wnz(2));
       text(0.01,0.55,'Band Pass:','fontsize',11);
       text(0.01,0.45,['1. Wnz=Wn/fsa=[',num2str(Wnz),']'],'fontsize',11);
       text(0.01,0.35,'                   sin(Wnz1+Wnz2) ','fontsize',10);
       text(0.01,0.30,['2. cosW0=----------------------------=',num2str(cosW0)],'fontsize',11);
       text(0.01,0.25,'                   sin(Wnz1)+sin(Wnz2)  ','fontsize',10);
       text(0.01,0.15,['3. Wpre=(cosW0-cosWnz2)/sin(Wnz2)=',num2str(Wpre)],'fontsize',11);
       %text([0.01,0.01,0.01,0.01,0.01],[0.55,0.45,0.4,0.35,0.25],{'Band Pass:',...
       %                   ['1. Wnz=Wn/fsa=[',num2str(Wnz),']'],...
       %                    '             sin(Wnz1+Wnz2) ',...
       %                   ['2. cosW0=------------------------=',num2str(cosW0)],...
       %                    '             sin(Wnz1)+sin(Wnz2) ',...
       %%                   ['3. Wpre=(cos(W0)-cos(Wnz1))/sin(Wnz1)=',num2str(Wpre)]},...
       %                'fontsize',11); 
       clear Wnz %cosW0
   end     
   clear doi ind slideData
   save yhzfd 
   % yhzfd: fp Rp fs Rs fsa Wp Ws Wsa N Wn afProto num den Wpre j cosW0(if BP)
case doi+28 
   load yhzfd
   % yhzfd: fp Rp fs Rs fsa Wp Ws Wsa N Wn afProto num den Wpre j cosW0(if BP)
   numUnnStr=LocalPolyStr(N,num,'(s/Wp)',0);
   denUnnStr=LocalPolyStr(N,den,'(s/Wp)',0);
   sepStr(1:(N+1)*20)='-';
   sepStr=char(sepStr);
  % text(0.01,0.4,'Ha(s)=','fontsize',11);
   text([0.01,0.01,0.01],[0.5,0.4,0.3],{numUnnStr,sepStr,denUnnStr},'fontsize',9);
   text(0.05,0.1,['Wp=' num2str(Wpre) ' (Prewarping 3dB Frequency)'],'fontsize',9);
   clear numUnnStr denUnnStr sepStr doi ind slideData
   save yhzfd
   % yhzfd: fp Rp fs Rs fsa Wp Ws Wsa N Wn afProto num den Wpre j cosW0(if BP)
case doi+29
   load yhzfd
   % yhzfd: fp Rp fs Rs fsa Wp Ws Wsa N Wn afProto num den Wpre j cosW0(if BP)
   [z p k]=tf2zp(num,den);
   z=z.*Wpre;
   p=p.*Wpre;
   switch j
      case 1
      pd = (1+p)./(1-p); % Do bilinear transformation
	   zd = (1+z)./(1-z);
      % real(kd) or just kd?
	   kd = (k*prod(1-z)./prod(1-p));
	   zd = [zd;-ones(length(pd)-length(zd),1)];  % Add extra zeros at -1
      kd=kd*(Wpre^(length(pd)-length(zd)));
      text(0.01,0.7,'Low Pass: s=f(z^-^1)=--------------------','fontsize',10);
      text([0.35,0.35],[0.62,0.75],{'1-z^-^1',...
            '1+z^-^1'},'fontsize',9);
      case 2
      pd = -(1+p)./(1-p); % Do bilinear transformation
	   zd = -(1+z)./(1-z);
      % real(kd) or just kd?
	   kd = (k*prod(1-z)./prod(1-p));
	   zd = [zd;ones(length(pd)-length(zd),1)];  % Add extra zeros at -1
      kd=kd*(Wpre^(length(pd)-length(zd)));
      text(0.01,0.7,'High Pass: s=f(z^-^1)=--------------------','fontsize',10);
      text([0.35,0.35],[0.62,0.75],{'1+z^-^1',...
            '1-z^-^1'},'fontsize',9);
      case 3
         for i=1:length(p)
           % nd=[1,2*cosW0/(1-z(i)),(1+z(i))/(1-z(i))];
            dd=[1,2*cosW0/(1-p(i)),(1+p(i))/(1-p(i))];
            %[zdd,pdd,kk]=tf2zp(nd,dd);
            pdd=roots(dd');
            pd(2*i-1:2*i)=pdd;
            %zd(2*i-1:2*i)=nd;
         end
         zd=[];
         for i=1:length(z)
           % nd=[1,2*cosW0/(1-z(i)),(1+z(i))/(1-z(i))];
            nd=[1,2*cosW0/(1-z(i)),(1+z(i))/(1-z(i))];
            %[zdd,pdd,kk]=tf2zp(nd,dd);
            ndd=roots(nd');
            zd(2*i-1:2*i)=ndd;
            %zd(2*i-1:2*i)=nd;
         end
         pd=pd';
         zd=zd';
         kd = (k*prod(1-z)./prod(1-p));
         zd = [zd;-ones(length(p)-length(z),1);ones(length(p)-length(z),1)];
         %zd=  [zd;ones(length(pd)-length(zd),1)];
         % Add extra zeros at -1
         kd=kd*(Wpre^(length(p)-length(z)));
         text(0.01,0.7,'Band Pass: s=f(z^-^1)=-----------------------------------','fontsize',10);
         text([0.35,0.35],[0.75,0.62],{'1-2cosW0z^-^1+z^-^2',...
                                       '1-z^-^2'},'fontsize',9);

         clear dd pdd i nd ndd 
      end   
      [bz,az]=zp2tf(zd,pd,kd);
      bz(find(abs(bz)<1e-6))=0;
      bz=real(bz);
      az(find(abs(az)<1e-6))=0;
      numZStr=LocalPolyStr(length(bz)-1,bz,'z',length(bz)-1);
      denZStr=LocalPolyStr(length(az)-1,az,'z',length(az)-1);
      %text(0.01,0.7,numZStr,'fontsize',10);
      %text(0.01,0.5,denZStr,'fontsize',10);
      sepStr(1:(length(bz/2)*16))='-';
      sepStr=char(sepStr);
      text(0.01,0.5,'H(z)=','fontsize',11);
      text([0.01,0.01,0.01],[0.3,0.2,0.1],{numZStr,sepStr,denZStr},'fontsize',10);
      clear doi ind slideData
      clear z p k pd zd kd numZStr denZStr sepStr
      save yhzfd
      % yhzfd: fp Rp fs Rs fsa Wp Ws Wsa N Wn afProto num den Wpre j cosW0(if BP) bz az
end; %switch
 
 function polyStr=LocalPolyStr(N,nd,var,inv)
   polyStr=' ';
   for i=N:-1:0
      if abs(nd(N+1-i))<=1e-6
         if strcmp(polyStr(length(polyStr)),' ') 
            polyStr=[polyStr,'    '];   
         end   
      else
         if ~strcmp(polyStr(length(polyStr)),' ') & nd(N+1-i)>0
            polyStr=[polyStr,'+'];
         end   
         if nd(N+1-i)~=1 | i==inv
            polyStr=[polyStr,num2str(nd(N+1-i))];
         end
         if i~=inv
            varStr=num2str(i-inv);
            for j=1:length(varStr);
               varSS(2*j-1)='^';
               varSS(2*j)=varStr(j);
            end               
            polyStr=[polyStr,var,varSS];
         end   
      end
   end; 
   %sepStr(1:(N+1)*15)='-';
   %epStr=char(sepStr);
   %text(0.01,0.4,['Ha(' var ')='],'fontsize',11);
   %text([0.15,0.12,0.15],[0.5,0.4,0.3],{numStr,sepStr,denStr},'fontsize',10);

 
 
 
 function hi=LocalPlotHi(N,Wsnor,filType)
    switch filType
      case 1
        hi=firls(N,[0,Wsnor,Wsnor,1],[1,1,0,0]);
      case 2
        hi=firls(N,[0,Wsnor,Wsnor,1],[0,0,1,1]);
      case 3
        hi=firls(N,[0,Wsnor(1),Wsnor(1),Wsnor(2),Wsnor(2),1],...
           [0,0,1,1,0,0]);
   end %switch filType   
             
function Ws=LocalStrTrans(Wsstr)
     %Wsstr=get(slideData.BtnHandles(BtnHndlInd),'string');
     % transfer the string to caculable digits
     for i=1:length(Wsstr)-1
        if (Wsstr(i:i+1)=='pi')& (Wsstr(i-1)~='*')
           Wsstr=strcat(Wsstr(1:i-1),'*',Wsstr(i:length(Wsstr)));
        end
     end
     Ws=str2num(Wsstr);
     



%==========
%==========
function LocalResult(h,Xlim1,XTick1,XTickLabel1,w,f,Wsnor,n,showFlag);

if nargin < 9, showFlag = 0; end;

h_tmp(1) = axes('position',[0.1,0.57,0.6,0.28]);
yhzstem(h);
hold on; 
plot(zeros(size(h)));
% nExt=3;
set( h_tmp(1), ... %'color',[0.8,0.8,0.8],...
   'Xlim',Xlim1, ...
   'XTick',XTick1, ...
   'XTickLabel',XTickLabel1);  % +1=',num2str(winLenM+1)),strcat('N=',num2str(winLenN))});

% plot the frequency domain response
%[w,f]=freqz(h/sum(h),1,1024);
h_tmp(2)=axes('position',[0.1,0.17,0.3,0.28]);
h_plot(1) = semilogy(f,(abs(w)));
WsstrT=strcat(num2str(Wsnor'),'pi');
[M,N]=size(WsstrT);
if M==1,
   Wsstr={WsstrT};
else,
   Wsstr={WsstrT(1,:),WsstrT(2,:)};
end;   
myeps=0.001*pi;
set( h_tmp(2), ...  %'color',[0.8,0.8,0.8],...
   'Xlim',[myeps,pi-myeps], ...
   'XTick',[Wsnor*pi], ...
   'XTickLabel',Wsstr);
XLabel('幅频响应');

%plot the phase response
h_tmp(3) = axes('position',[0.45,0.17,0.27,0.28]);
h_plot(2) = plot(f,angle(w)); %unwrap(angle(w)));
set( h_tmp(3), ... %'color',[0.8,0.8,0.8],...
   'Xlim',[0,4*pi/(n-1)], ...
   'XTick',[0,4*pi/(n-1)], ... %Wsnor*pi,pi],...
   'XTickLabel',{'0',['4pi/(' num2str(n) '-1)']}, ...
   'Ylim',[-pi,pi], ...
   'YTick',[-pi,-pi/2,0,pi/2,pi], ...
   'YTickLabel',{'-pi','-pi/2','0','pi/2','pi'});
XLabel('相频响应');  


%===============
% axz 1999-12-18

if showFlag,
   
   Hpr=h(XTick1(1):(XTick1(1)+n-1));
   Hpr=Hpr(:);
   ls_tmp = char(XTickLabel1(1));
   li = str2num(ls_tmp);
   for j = 1 : n,
      if li < 10,
         ls_tmp = '0';
      else,
         ls_tmp = '';
      end;
      lstr_head(j,:) = [' h(' ls_tmp int2str(li) ') = '];
      li = li + 1;
   end;
   
%list the time domain response
h_tmp(4) = uicontrol(gcf,'Style','listbox', ...
   'Units','normalized', ...
   'Position',[0.18,0.15,0.46,0.33], ...
   'Tag','tmp_ShowHn', ...
   'String',[lstr_head num2str(Hpr)], ...
   'Visible','off');

% the button
h_tmp(5) = uicontrol(gcf,'Style','pushbutton', ...
   'Units','normalized', ...
   'position',[0.31,0.04,0.2,0.06], ...
   'Fontsize',9, ...
   'String','显示脉冲响应', ...
   'Tag','tmp_ShowHn', ...
   'Callback','show_hn', ...
   'Visible','on');
set(h_tmp(5),'UserData',[h_tmp(:); h_plot(:)]);

end;

% axz 1999-12-18
%===============

   