function [t ,y]=fang(t)
t0=input('input t0=');
t=-1023:1024;
for i=1:1024*2
if abs(i-512)<=t0
y(i)=1;
else
y(i)=0;
end
end
plot(t,y)