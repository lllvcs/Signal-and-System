R=10;C=1;
Wn=10;s=0.1;
w=logspace(-3,3);
t=R*C;
num=[Wn*Wn];den=[1 2*Wn*s Wn*Wn];
[m,p]=bode(num,den,w);

subplot(211),semilogx(w,20*log10(m));
grid
p=p*pi./180;
subplot(212),semilogx(w,p);
grid