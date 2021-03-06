r=[0:1/255:1]';
g=[0:1/255:1]';
b=[0:1/255:1]';
map=[r g b];
hf_2=figure('colormap',map);
set(hf_2,'menubar','none',...
         'name','图像处理系统',...
         'color',[.6 .7 .8],...
         'numbertitle','off')
      axis off           
subplot(2,3,2),image(flower),axis off
a=abs(fft2(flower));
x=abs(ifft2(a));
c=angle(fft2(flower));
d=7000*(exp(c*i));
y=abs(ifft2(d));
e=abs(fft2(pout));
f=e.*(exp(c*i));
z=abs(ifft2(f));
hc_1=uicontrol(gcf,'position',[100 180 100 25],...
                   'string','取模，相位置0',...
                   'callback',[...
                      'subplot(2,3,3),image(x),axis off']);
hc_2=uicontrol(gcf,'position',[100 140 100 25],...
                   'string','取相位，模置1',...
                   'callback',[...
                      'subplot(2,3,5),image(y),axis off']);
hc_3=uicontrol(gcf,'position',[100 100 100 25],...
                   'string','取相位，任意模',...
                   'callback',[...
                      'subplot(2,3,6),image(z),axis off']);
hc_4=uicontrol(gcf,'position',[100 60 100 25],...
                   'string','返      回',...
                   'callback','close,zz1');