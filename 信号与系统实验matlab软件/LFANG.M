function x=lfang(t)
N=input('input N=');
N1=input('input N1=');
t=-N/2:N/2;
for i=1:N+1
 if abs(i-N/2-1)<N1/2
x(i)=1;
else 
x(i)=0;
end
end
figure;
subplot(2,1,1);
stem(t,x)
set(gcf,'color','b')
xlabel('n'),ylabel('x[n]'),title('离散非周期性方波信号的频谱分析')