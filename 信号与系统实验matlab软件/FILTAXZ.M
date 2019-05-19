%FILTAXZ Signal Processing filter demo.


% Demo initialization ====================
if ~exist('SlideShowGUIFlag'), figNumber=0; end;

Fs=100;
t=(1:100)/Fs;
s1=sin(2*pi*t*5); s2=sin(2*pi*t*15); s3=sin(2*pi*t*30);
s=s1+s2+s3;

if cssinit(figNumber),
    plot(t,s);
    xlabel('时间（秒）');
    ylabel('时间波形');
    drawnow;

    str = str2mat( ...
      ' 按下“开始”按钮可以看到滤波的演示。', ...
      ' ');
    cssdisp(figNumber,str);                                      
    if figNumber, return; end
end

% Beginning of the demo ==================
str = str2mat( ...
  ' 这是一个滤波演示。', ...  
  ' 首先，使用三个正弦波分量（频率分别是 5、15、30Hz）', ...
  ' 相加合成了一个信号，我们将对此信号进行处理。', ...
  ' 【pi=3.1415926】', ...
  ' ∵ s1=sin(2*pi*t*5); s2=sin(2*pi*t*15);', ...
  ' 　 s3=sin(2*pi*t*30);', ...
  ' ∴ s=s1+s2+s3;');
cssdisp(figNumber,str);                                         

if csspause(figNumber), return; end;


[b,a]=ellip(4,0.1,40,[10 20]*2/Fs);
[H,w]=freqz(b,a,512);
plot(w*Fs/(2*pi),abs(H));
xlabel('频率（Hz）');
ylabel('频率响应幅值');
grid;
drawnow;
astr=['          ' poly2str(a,'s')];
bstr=['          ' poly2str(b,'s')];

str = str2mat( ...
  ' 我们将设计一个滤波器，使得：', ...
  ' 15Hz的分量得以通过，而5Hz和30Hz的分量被滤除。', ...
  ' 我们建立一个八阶的10至20Hz的带通IIR滤波器。', ...
  ' 这是其频率响应。', ...
  ' 该滤波器是椭圆函数滤波器。', ...
  ' ', ...
  bstr, ...
  ' H(s)=--------------------------------------------------------------', ...
  astr, ...
  ' ' ...
);

cssdisp(figNumber,str);                                           

if csspause(figNumber), return; end;


sf=filter(b,a,s);
plot(t,sf);
xlabel('时间（秒）');
ylabel('时间波形');
axis([0 1 -1 1]);
drawnow; pause(1);

str = str2mat( ...
  ' 滤波之后，所得信号是一个15Hz正弦波，符合原先的设想。', ...
  ' ');

cssdisp(figNumber,str);                                       

if csspause(figNumber), return; end;


S=fft(s,512);
SF=fft(sf,512);
w=(0:255)/256*(Fs/2);
plot(w,abs(S(1:256)'),'b',w,abs(SF(1:256)'),'r');
xlabel('频率（Hz）');
ylabel('傅立叶变换幅值');
grid;

str = str2mat ( ...
  ' 最后，这是在滤波前（蓝色）、后（红色），信号的频率成分。', ...  
  ' 注意：在频率点 5、30 Hz 处的尖峰被有效地消除了。', ... 
  ' ');

cssdisp(figNumber,str);                                     

% End of the demo ========================
