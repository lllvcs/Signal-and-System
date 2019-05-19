z=0;r=3/4;r1=1/2;
%Wn=10;s=0.1;
w=linspace(-2*pi,2*pi);
%t=R*C;
T=100;
num=[1 0 0];den=[1 -2*r*cos(z) r*r];
%[mag,phase]=dbode(num,den,T,w);
den=[1 -2*r1*cos(z) r1*r1];
%[mag1,phase1]=dbode(num,den,T,w);
dbode(num,den,T,w);

%subplot(211),plot(w,20*log10(mag),w,20*log10(mag1));
%grid
%p=phase;
%p=p*pi./180;
%p1=phase1;


%p1=p1*pi./180;
%subplot(212),plot(w,p,w,p1);
%grid