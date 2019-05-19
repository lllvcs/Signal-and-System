function [b,a] = yhzFirSamp(fp,N,FType)
% function yhzFirSamp designs the FIR(Type I Linear Phase Responese) DF 
%                with Frequency Sampling Method 
% fp: cutoff frequency with Fsa normalized	
% N: sampling Numbers
% FType: 1: LP; 2:HP; 3:BP
% 6/15/99
% XJTU, All Rights Reserved.
%
if nargin~=3
   disp('Input Parameters Error!');
   return;
end
Ws=2*pi*fp;
w=0:pi/500:2*pi;
Hw=ones(size(w));
WsNum=round(Ws/pi*500);
Hw(WsNum:1001-WsNum)=0;
switch FType
case 1
   Ws1=[0,Ws,2*pi-Ws,2*pi];    % Ws1 record the range whose value is 1
case 2 
   Hw=1-Hw;
   Ws1=[Ws,pi,pi,2*pi-Ws];
case 3   
   Hw=zeros(size(w));
   Hw(WsNum(1):WsNum(2))=1;
   Hw(1001-WsNum(2):1001-WsNum(1))=1;
   Ws1=[Ws(1),Ws(2),2*pi-Ws(2),2*pi-Ws(1)];
end
% do the sampling
for i=1:N
    wN=(2*pi/N)*(i-1);
    if ((wN>=Ws1(1)) & (wN<=Ws1(2))) | ((wN>=Ws1(3)) & (wN<=Ws1(4)))
          HK(i)=1;
       else HK(i)=0;
    end  % if   
end  %for
HK(N+1)=HK(1);
% Type I Linear Phase 
Hk=HK;
phasek=-pi*(1-1/N)*[0:N];
j=sqrt(-1);
H=Hk(1:N).*exp(j*phasek(1:N));
h=real(ifft(H));  % k.*exp(j*phasek));
b=h;
a=1;
