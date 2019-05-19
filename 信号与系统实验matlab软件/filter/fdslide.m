function slide=fdslide
% This is a slideshow file for use with fdshow.m 
% Too see it run, type 'fdshow', 

%   Copyright (c) 1984-97 by The MathWorks, Inc.
%   $Revision: 5.16 $

global doi;
if nargout<1,
   fdshow 
else
   %for slidenum=1:25
   %   slide(slidenum).code2={};
   %   slide(slidenum).next=slidenum+1;
   %end;   
   
   %---------------------------------------------------------------------------------------
   %for each slide:
   %    ttl:   the title of this slide which displays the path
   %    code1: the code which will be evaluated in the upper part of the figure(axes1)
   %    %%%%%%%code2: the code which will be evaluated in the lower part of the figure(axes2)
   %    next:  the index of next slide
   %           it is a row of indexes, paralize with the slide's next directions according 
   %           to the choice of the uicontrols
   %    nextcode:
   %---------------------------------------------------------------------------------------  
   dfOriginalIndex=16; % a temp varialbe for connecting with the work by Wei Guo
   %slideData=get(gcf,'UserData');
   
   for i=1: dfOriginalIndex+30
      slide(i).ttl={};
      slide(i).code1={};
    %  slide(i).code2={};
      slide(i).text={};
      slide(i).next=[];
   end
   %========== Slide 1 ==========
   %=====choose the DF/AF========
   slide(1).ttl='滤波器设计';
   %slide(1).title='Filter Bank Design';
   slide(1).code1={'滤波器设计类型为数字滤波器(Digital Filter)'};   
   %' load logo',
   %' surf(L,R), colormap(M)',
   %' n = length(L(:,1));',
   %' axis off, axis([1 n 1 n -.2 .8]), view(-37.5,30)',
   %'title(''MATLAB.  Picture the Power.'');' };
   %slide(1).code2={};
   slide(1).text={
      '欢迎您使用滤波器设计教学软件！',
      '',
      '　　作为您的向导，我将带领您领略滤波器设计的过程。整个旅程分为若干',
      '步骤，您在这里看到的是第一屏，即出发点。一“屏”就是量化的一个步骤',
      '。每一屏所做的工作或为选择一种数字滤波器子类，或为进行参数输入，或',
      '者输出相关的计算方法和中间结果。同时，在每一屏，您可以方便地通过“',
      '上一页”、“下一页”、“重置”来向前向后翻屏、重改数据等。此外，通',
      '过“演示”按钮，向导可以按照默认值自动设计滤波器，在演示过程中，您',
      '可以随时停止演示，并手动继续设计。',
      '',
      '　　现在，您将能设计出所需的数字滤波器了，开始吧，您不会后悔的！'};
   slide(1).next=[2,2]; 
   
   %========== Slide 2 ==========
   %======choose Lp/Bp/Hp in AF==
   %slide(2).ttl='';
   slide(2).code1={'请你选择滤波器类型(LP/HP/BP)：'};
   %slide(2).code2={'xptext( ''>> a = [1 2 3 4 6 4 3 4 5]'', '' '', ''a ='', '' '', ''   1   2   3   4   6   4   3   4   5'' );' };
   slide(2).text={
      '首先, 您需要确定要设计的滤波器是什么类型的, 只有这样, 才能做到"有的放矢".',
      '所以, 这之后的几个步骤都是用来确定您的设计目标. ',
      '',
      '低通, 高通和带通这样一种分类是基于滤波器的频率响应并在实际应用中滤波效果',
      '而划分的. 但是您心里应该清楚, 我们最后设计出的滤波器是绝对不可能像理想的',
      '那样具有刀切式的滤波效果, 那样的美梦是不可能实现的. 当然, 逼近理想的频率',
      '响应效果越好越符合人们的愿望. 但同时, 这耗费的资源也越来越大. 所以, 您在',
      '实际设计时, 需要权衡利弊, 做出合理的滤波器子类型的选择和参数的选择, 我们',
      '今天就给您这样的一个实践机会, 您可以从现在就开始积累经验值啦!'};
   slide(2).next=[1,0,0;3,0,0;dfOriginalIndex,dfOriginalIndex,dfOriginalIndex];
  %========== Slide 3 ==========
  %choose the AFLP original type
  slide(3).ttl='模拟';
  slide(3).code1={};
  %'xptext(''>> b = a + 2'','' '', ''b ='', '' '', ''   3   4   5   6   8   6   5   6   7'' );' };
  %slide(3).code2={};
  slide(3).text={
   ' Now let''s add 2 to each element of our vector, ''a'', and store',
   ' the result in a new vector.',
   '',
   ' Notice how MATLAB requires no special handling of vector',
   ' or matrix math.'};
  slide(3).next=[4,0,0];

  %=========temp================
  for i=4:dfOriginalIndex-1
     slide(i).ttl=num2str(i);
     slide(i).next=[i+1,dfOriginalIndex];
     %slide(i).code2={};
  end;   
  
  %========== Slide 4 ==========
  slide(4).code1={
   'cla';
   'a = [1 2 3 4 6 4 3 4 5];';
   'b = a + 2;';
   'plot(b)';
   'grid' };
  slide(4).text={
   ' Creating graphs in MATLAB is as easy as one command.',
   ' Let''s plot the result of our vector addition with grid lines.',
   '',
   ' >> plot(b)',
   ' >> grid off'};
  %slide(4).next=5;
  %========== Slide 5 ==========

  slide(5).code1={
   'bar(b)';
   'xlabel(''Sample #'')';
   'ylabel(''Pounds'')' };
  slide(5).text={
   ' MATLAB can make other graph types as well, with axis labels.',
   '',
   '>>bar(b)',
   '>>xlabel(''Sample #'')',
   '>>ylabel(''Pounds'')'};
  %slide(5).next=6;
%========== Slide 6 ==========

  slide(6).code1={
   'plot(b,''*'')';
   'axis([0 10 0 10])' };
  slide(6).text={};
  % ' MATLAB can use symbols in plots as well. Here is an',
  % ' example using *''s to mark the points.  MATLAB offers a',
  % ' variety of other symbols and line types.',
  % '',
  % ' >> plot(b,''*'')',
  % ' >> axis([0 10 0 10])'};
  slide(6).code2={
   'xptext(''>> B = A'''''','' '',''B ='','' '', ''     1     2     4'',''     2     5    10'',''     0    -1    -1'');' };

 %slide(6).next=7; 

  %========== Slide 7 ==========

  slide(7).code1={
   'A = [1 2 0; 2 5 -1; 4 10 -1];',
   'xptext( ''>> A = [1 2 0; 2 5 -1; 4 10 -1]'','' '',''A ='', '' '',''     1     2     0'',''     2     5    -1'',''     4    10    -1'' );' };
  slide(7).text={
   ' One area in which MATLAB excels is matrix computation.',
   '',
   ' Creating a matrix is as easy as making a vector, using',
   ' semicolons (;) to separate the rows of a matrix.'};
  %slide(7).next=8;
  %========== Slide 8 ==========

  slide(8).code1={
   'xptext(''>> B = A'''''','' '',''B ='','' '', ''     1     2     4'',''     2     5    10'',''     0    -1    -1'');' };
  slide(8).text={
   'We can easily find the transpose of the matrix ''A''.'};

  %========== Slide 9 ==========

  slide(9).code1={
   'xptext(''>> C = A * B'','' '',''C ='','' '',''     5    12    24'',''    12    30    59'',''    24    59   117'');' };
  slide(9).text={
   ' Now let''s multiply these two matrices together.',
   '',
   ' Note again that MATLAB doesn''t require you to deal with',
   ' matrices as a collection of numbers.  MATLAB knows when',
   ' you are dealing with matrices and adjusts your calculations',
   ' accordingly.'};

  %========== Slide 10 ==========

  slide(10).code1={
   'xptext(''>> C = A .* B'','' '', ''C ='','' '',''     1     4     0'',''     4    25   -10'', ''     0   -10     1'' );' };
  slide(10).text={
   'Instead of doing a matrix multiply, we can multiply the,',
   'corresponding elements of two matrices or vectors',
   'using the .* operator.'};

  %========== Slide 11 ==========

  slide(11).code1={
   'xptext( ''>> X = inv(A)'', '' '', ''X ='', '' '',  ''     5     2    -2'',  ''    -2    -1     1'', ''     0    -2     1'' );' };
  slide(11).text={
   ' Let''s find the inverse of a matrix ...'};

  %========== Slide 12 ==========

  slide(12).code1={
   'xptext(  ''>> I = inv(A) * A'',   '' '',   ''I ='',  '' '',  ''     1     0     0'',  ''     0     1     0'',  ''     0     0     1'' );' };
  slide(12).text={
   ' ... and then illustrate the fact that a matrix times its inverse is',
   ' the identity matrix.'};

  %========== Slide 13 ==========

  slide(13).code1={
   'xptext(  ''>> eig(A)'',   '' '',   ''ans ='',  '' '',  ''    3.7321'',  ''    0.2679'',  ''    1.0000'' );' };
  slide(13).text={
   ' MATLAB has functions for nearly every type of common',
   ' matrix calculation.',
   '',
   ' There are functions to obtain eigenvalues ...'};

  %========== Slide 14 ==========

  slide(14).code1={
   'xptext( ''>> svd(A)'',  '' '',  ''ans ='',  '' '',  ''   12.3171'',  ''    0.5149'',  ''    0.1577'');' };
  slide(14).text={
   ' ... as well as the singular value decomposition.'};

  %========== Slide 15 ==========

  slide(15).code1={
   'p = round(poly(A));';
   'xptext(  ''>> p = round(poly(A))'',  '' '',  ''p ='',  '' '',   ''     1    -5     5    -1'' );' };
  slide(15).text={
   ' The characteristic polynomial of a matrix A is',
   '',
   '     det(lambda*I - A)',
   '',
   ' The "poly" function generates a vector containing the',
   ' coefficients of the characteristic polynomial.'};

  %========== Slide 16 ==========
  doi=dfOriginalIndex;
  slide(doi).ttl='数字';
  slide(doi).code1={
    '请选择要设计的数字滤波器类型(FIR/IIR)：'};
   %'xptext(  ''>> roots(p)'',   '' '',   ''ans ='',   '' '',   ''    3.7321'',   ''    1.0000'',   ''    0.2679'' );' };
  %slide(doi).code2={}; 
  slide(doi).text={
     'IIR和FIR数字滤波器的分类时基于滤波器在时域的脉冲响应特性而划分的. 这是',
     '两类截然不同的数字滤波器.',
     '',
     'IIR DF的设计出发点是借助于相应的模拟滤波器来设计. 这个途径比较省劲, 因',
     '为模拟滤波器设计技巧已相当成熟, 有大量简单的公式和图表作为强大的工具后',
     '盾, 因此设计起来相当方便简单, 且可以得到一封闭公式表示的设计结果. IIR时',
     '域无限, 自然极点到处蔓延, 导致的结果是系统可能不稳定. 且IIR最大的问题是',
     '它的非线性相位性.',
     '',
     '理想滤波器往往在频域是带限的, 对应于时域却是无限的, 显然是不可能实现的, ',
     'FIR DF的设计思想就是通过对要求设计的频率响应(如理想低通滤波器)进行某种逼',
     '近. FIR在时域有限, 所以是稳定可实现的. 且其最诱人的一点是其线性相位性.',
     '',
     '所以, IIR用于对相位要求不敏感的场合. FIR则用于对线性相位要求较高的场合.'};
  slide(doi).next=[2,0;doi+1,doi+15;doi+1,doi+16;doi+1,doi+17];

  %========== Slide 17 ==========

  slide(doi+1).ttl='FIR';
  slide(doi+1).code1={
      '请你选择设计FIR DF的方法:'} ;
  %slide(doi+1).code2={};
  %'q = conv(p,p);',
   %'xptext(  ''>> q = conv(p,p)'',  '' '',   ''q ='',  '' '',   ''    1  -10   35  -52   35  -10    1'' );' };
  slide(doi+1).text={
     '用一个有限时域响应去逼近无限时域就是FIR方法的基本思路, 一般有两种方法:',
     '',
     '窗口法是直接在原无限的时域响应上截取有限的一段, 最容易想到的就是直接截',
     '取, 这就是矩形窗法, 它产生的效果是最小平方意义上的对原信号的最佳逼近, ',
     '且窗口长度越长, 误差越小. 为了减小过冲和欠冲(即增大阻带衰减), 采用了对',
     '矩形窗加权的办法, 即窗函数, 代价是过渡带的加宽, 当然, 加权以后的设计方',
     '法, 已经不再是最小逼近.',
     '',
     '频率采样在时域表现起来就是周期延拓. 对理想的带限的滤波器的频率采样, 就',
     '是无限延伸的时域信号的周期延拓, 显然这就会带来一定程度的混淆. 所谓逼近,',
     '就是在这里体现的. 即频率采样法的思路是用时域中有一定混淆的脉冲响应来逼',
     '近没有混淆的理想情形. 在采样点上, 逼近出来的频响将于理想的严格一致, 其',
     '它点是内插而来. 所以, 频率采样法是基于插值法的逼近方法.'};  
  slide(doi+1).next=[2,0;doi+2,doi+2;doi+3,doi+3;doi+4,doi+4];
  
  %========== Slide 18 ==========

  slide(doi+2).ttl='低通';
  slide(doi+2).code1={'现在，请你输入你要用窗口法逼近的理想LPDF的参数：';'低通截止频率 Ws='};
  slide(doi+2).text={
     '该截止频率是要用FIR窗口法/频率响应法逼近的理想低通滤波器频率响应从"1"跳',
     '变为"0"的临界频率. 要改变默认值(π/4), 则在输入框中输入需要的值即可, 值',
     '应该在0到π之间. 其理想的频率响应相应的绘于该屏输入框下方. 在输入完毕后,',
     '回车以表示确认, 同时, 下面的频率响应图也会应以更新到新的截止频率下的频响',
     '图. 在这里, π用pi来表示, 如π/4输入0.25pi或0.25*pi, 当然也可以直接输入',
     'π/4的值: 0.785. '  };   
  slide(doi+2).next=[doi+1;doi+5;doi+10];
  
%============Slide 19============
%=====doi+3======================

slide(doi+3).ttl='高通';
slide(doi+3).code1={'现在，请你输入你要用窗口法逼近的理想HPDF的参数：';'高通截止频率 Ws='};
%slide(doi+3).code2={};
slide(doi+3).text={ 
     '该截止频率是要用FIR窗口法/频率响应法逼近的理想高通滤波器频率响应从"0"跳',
     '变为"1"的临界频率. 要改变默认值(3π/4), 则在输入框中输入需要的值即可, 值',
     '应该在0到π之间. 其理想的频率响应相应的绘于该屏输入框下方. 在输入完毕后,',
     '回车以表示确认, 同时, 下面的频率响应图也会应以更新到新的截止频率下的频响',
     '图. 在这里, π用pi来表示, 如π/4输入0.25pi或0.25*pi, 当然也可以直接输入',
     'π/4的值: 0.785. '  };   

slide(doi+3).next=[doi+1;doi+5;doi+10];


%============Slide 20============
%===========doi+4================

slide(doi+4).ttl='带通';
slide(doi+4).code1={'现在，请你输入你要用窗口法逼近的理想BPDF的参数：';'带通截止频率 Ws='};
%slide(doi+4).code2={};
slide(doi+4).text={
     '该截止频率是要用FIR窗口法/频率响应法逼近的理想带通滤波器频率响应"0","1"',
     '跳变的临界频率. 要改变默认值([π/4,3π/4]), 则在输入框中输入需要的值即',
     '可, 值应该在0到π之间, 且两值递增. 其理想的频率响应相应的绘于该屏输入框',
     '下方. 在输入完毕后, 回车以表示确认, 同时, 下面的频率响应图也会应以更新到',
     '新的截止频率下的频响图. 在这里, π用pi来表示, 如π/4输入0.25pi或0.25*pi,',
     '当然也可以直接输入π/4的值: 0.785. '  };   

slide(doi+4).next=[doi+1;doi+5;doi+10];

%========== Slide 21 ==========

  %slide(doi+5).ttl='';
  slide(doi+5).code1={
    '将刚才的理想滤波器展成傅利叶级数，可得：'};
    %'Ws=get(slideData.BtnHandles(doi+2),''string'');',
    %'Wsnor=Ws/pi;' }; 
    
  % 'xptext(  ''>> whos'',   ''Name        Size      Bytes  Class'',   '' '',   ''A           3x3          72  double array'',   ''p           1x4          32  double array'',   ''q           1x7          56  double array'',   ''r           1x10         80  double array'',   '' '',   ''Grand total is 30 elements using 240 bytes'' );',
  % '' };
 % slide(doi+5).code2={};
  slide(doi+5).text={
     '按照窗口法理论, 窗口是在时域加上去的, 故此一步把理想目标转到时域, 即作反傅',
     '利叶变换. 得到的h(n)应是无限延伸的, 但在这里我们不可能将它全部绘出. 但是您',
     '心里应该明白, 即使是计算机显示屏之外, h(n)也是存在的.'};  
  slide(doi+5).next=[doi+6];
  %========== Slide 22 ==========

  %slide(doi+6).ttl='';
  slide(doi+6).code1={'选择窗口类型:'};
                    %   'text(0.5,0.7,''适宜市'');'};
%   'set(gca,''box'',''on'')',
%   'xptext(  ''>> A'',   '' '',   ''A ='',   '' '',   ''     1     2     0'',   ''     2     5    -1'',   ''     4    10    -1'' );' };
%slide(doi+6).code2={}; %'currentBtn=findobj(''visible'',''on'',''style'',''radiobutton'',''value'',1);',
                    %'winTypeS=get(currentBtn,''string'');',
                    %'if ~isempty(findstr(winTypeS,''Rectangular'')) winType=''boxcar''; end;',
                    %'if ~isempty(findstr(winTypeS,''Hanning'')) winType=''hanning''; end;',
                    %'if ~isempty(findstr(winTypeS,''Hamming'')) winType=''hamming''; end;',
                    %'if ~isempty(findstr(winTypeS,''Blackman'')) winType=''blackman''; end;',
                    %'if ~isempty(findstr(winTypeS,''Kaiser'')) winType=''kaiser''; end;',
                    %'save yhzfd winType',
                    %'winplot(gcf,winType)',
                    %'clear winType currentBtn;',
                    %'clear winTypeS;'};
  slide(doi+6).text={};
 %  ' You can get the value of a particular variable by typing its',
 %  ' name.'};
  slide(doi+6).next=(doi+7)*ones(1,5);

 
  %========== Slide 23 ==========

  slide(doi+7).ttl='窗口法';
  slide(doi+7).code1={'你需输入窗口长度 N=2M+1:';'M='};
%   'xptext(   '' >> sqrt(-1), log(0)'',   ''  '',   '' ans ='',   ''         0 + 1.0000i'',  '' '',  '' Warning: Log of zero'',  '' '',  '' ans ='',  ''   -Inf'');',
 %  '' };
 %slide(doi+7).code2={};
 slide(doi+7).text={
    '大家知道, 有四种线性相位的FIR数字滤波器. 我们在这里用窗口法设计的是第I类,',
    '即时域偶对称, 长度为奇数. 显然, 偶对称是自然满足的, 为了保证您输入窗口长',
    '度是奇数, 您要输入的是M, 而窗口长度N=2*M+1. 窗口长度显然是越大逼近效果越',
    '好, 但同时点数也加大, 系统负担加重, 所以您可以多试几次, 看一看效果如何. ',
    '输入完毕, 回车, 您会看到您选择的窗口马上听从你的命令而变化.',
    '',
    '对于凯撒窗, 满足一定条件的窗口长度可以用下式计算:'};
 slide(doi+7).next=[doi+8];

  %===========Slide 24==========
  %========doi+8================
%slide(doi+8).ttl='';
slide(doi+8).code1={'然后,为了保证线性相位和因果性';'将窗口和hi(n)都向右平移M'};
%slide(doi+8).code2={};
%   'xptext(   '' >> sqrt(-1), log(0)'',   ''  '',   '' ans ='',   ''         0 + 1.0000i'',  '' '',  '' Warning: Log of zero'',  '' '',  '' ans ='',  ''   -Inf'');',
 %  '' };
slide(doi+8).text={
   ' '};
slide(doi+8).next=[doi+9];
  %========== Slide 25 ==========

  slide(doi+9).ttl='';
  slide(doi+9).code1={'最后，将窗口和hi相乘就得到需设计FIRDF的脉冲响应'};
 % slide(doi+9).code2={};
  %slide(doi+9).code1={
  % 'cla',
  % 'A = zeros(32); A(14:16,14:16) = ones(3);',
  % 'y = fft2(A);',
  % 'mesh(abs(y));',
  % 'title(''Magnitude of Two-Dimensional FFT of a Matrix'')',
  % '' };
  slide(doi+9).text={};
 %  ' MATLAB has functions which make it ideal as a signal',
 % ' processing tool.',
 %  '',
 %  ' For more details, see the demos of the Signal',
 %  ' Processing Toolbox',
 %  '',
 %  ' >> A = zeros(32); A(14:16,14:16) = ones(3);',
 %  ' >> y = fft2(A);',
 %  ' >> mesh(abs(y));',
 %  ' >> title(''Magnitude of Two-Dimensional FFT of a Matrix'')'};
  slide(doi+9).next=[1];
  %========== Slide 26 ==========
 % slide(doi+10).ttl='';
  slide(doi+10).code1={'你要设计哪种线性相位的滤波器:'};
  %slide(doi+10).code2={};
  slide(doi+10).text={};
  slide(doi+10).next=(doi+11)*ones(1,4);
   
  %===========Slide 27============
  slide(doi+11).ttl='频率采样法';
  slide(doi+11).code1={ '然后,请输入采样点数N(在一个2\pi周期内)'};
                        %,'''',''M=''); 
                        %'j=1;',
                        %'while  ~get(slideData.BtnHandles(26,j),''value'')  j=j+1;  end ',
                        %'if (j==1)|(j=3) mytext1(27,''然后,请输入采样点数N=2M+1(在一个2\pi周期内)'','''',''M='');',
                        %'else mytext1(27,''然后,请输入采样点数N=2M(在一个2\pi周期内)'','''',''M=''); end' };
 %  'cla',
 %  'view(2)',
 % 'fplot(''humps'',[0,2]), hold on',
 %  'patch([0.5 0.5:0.01:1 1 0.5],[0 humps(0.5:0.01:1) 0 0],''r'');',
 %  'hold off',
 %  'title(''A region under an interesting function.'')',
 %  '' };
  %slide(doi+11).code2={}; 
  slide(doi+11).text={};
 %  ' MATLAB also allows you to create and analyze functions',
 %  ' easily.',
 %  ' For examples, see the demo "Functions of functions" under',
 %  ' MATLAB Numerics.',
 %  ' >> fplot(''humps'',[0,2]), hold on',
 % ' >> patch([0.5 0.5:0.02:1 1 0.5],[0 humps(0.5:0.02:1) 0 0],''r'');',
 %  ' >> hold off',
 %  ' >> title(''A region under an interesting function.'')'};
  slide(doi+11).next=[doi+12];
  
  %========== Slide 28 ==========

  %slide(doi+12).ttl='';
  slide(doi+12).code1={'这是采样后的H(k):'};
  %if isstudent
  %slide(27).code1={
  % ' membrane(5,15,9,4)',
  % ' axis([-1 1 -1 1 -1 .5])',
  % ' colormap(hot)'};
  %slide(doi+12).code2={};
  slide(doi+12).text={
   ''};
  slide(doi+12).next=[doi+13];
%  else
%  slide(27).code1={
%   ' load clown',
%   '   cla reset',
%   '   image(X), colormap(map), axis image',
%   '   set(gca,''XTick'',[],''YTick'',[])' };
%  slide(27).text={
%   'Thanks you for viewing this introduction to MATLAB.',
%   '',
%   ' ',
%   '',
%%
 %  ' >> image(X), colormap(map), axis image',
 %  ' >> set(gca,''XTick'',[],''YTick'',[])'};
  %end
  %set(gcf,'UserData',slideData);

%=============Slide 29 =============

 %slide(doi+13).ttl='';
 slide(doi+13).code1={ '为了保证线性相位,根据你所选择的滤波器类型,';'还需对H(k)作一些处理:'};
 %slide(doi+13).code2={};
 slide(doi+13).text={};
 slide(doi+13).next=[doi+14];

%=============Slide 30 =============
 %slide(doi+14).ttl='';
 slide(doi+14).code1={ '将H(k)作快速反傅立叶变换(IFFT),即可得h(n)' };
 %slide(doi+14).code2={};
 slide(doi+14).text={};
 slide(doi+14).next=[1]; 

%=============Slide 31 =============
 slide(doi+15).ttl='低通_IIR';
 slide(doi+15).code1={ '现在,需确定LPDF的参数:';
                       '通带截止频率fp(Hz):';
                       '通带最大衰减Rp(dB):';
                       '阻带最低频率fs(Hz):';
                       '阻带最小衰减Rs(dB):';
                       '采样频率fsa(Hz):' };
                    %,''现在,需确定LPDF的参数:'',''通带截止频率Wp(Hz):'',''通带最大衰减Rp(dB):'',''阻带最低频率Ws(Hz):'',''阻带最小衰减Rs(dB):'',''采样频率fs(Hz):'');'};
 %slide(doi+15).code2={};
 slide(doi+15).text={};
 slide(doi+15).next=[doi+18,doi+18,doi+18,doi+18,doi+18];

%============Slide 32 ==============
 slide(doi+16).ttl='高通_IIR';
 slide(doi+16).code1={'现在,需确定HPDF的参数:';
                      '通带下限频率fp(Hz):';
                      '通带最大衰减Rp(dB):';
                      '阻带上限频率fs(Hz):';
                      '阻带最小衰减Rs(dB):';
                      '采样频率fsa(Hz):' }; 
 %slide(doi+16).code2={};
 slide(doi+16).text={};
 slide(doi+16).next=(doi+18)*ones(1,5);

%============Slide 33 ==============
 slide(doi+17).ttl='带通_IIR';
 slide(doi+17).code1={'现在,需确定BPDF的参数:';
                      '通带频率fp(Hz)=[fpl,fph]:';
                      '通带最大衰减Rp(dB):';
                      '阻带频率fs(Hz)=[fsl,fsh]:';
                      '阻带最小衰减Rs(dB):';
                      '采样频率fsa(Hz):' } ;          %mytext1(33,'' '','' '','' '','' '','' '','' '');'}; 
 %slide(doi+17).code2={};
 slide(doi+17).text={};
 slide(doi+17).next=(doi+18)*ones(1,5);

%============Slide 34 ===============
 %slide(doi+18).ttl='';
 slide(doi+18).code1={'然后,选择一种模拟低通原型:' };
 %slide(doi+18).code2={};
 slide(doi+18).text={};
 slide(doi+18).next=[doi+19,doi+19,doi+19];

%============Slide 35 ===============
 %slide(doi+19).ttl='';
 slide(doi+19).code1={'根据参数我们可以通过查表或计算,';'得出低通原型的阶数和3dB点:'};
 %slide(doi+19).code2={};
 slide(doi+19).text={};
 slide(doi+19).next=[doi+20];

%============Slide 36 ===============
 %slide(doi+20).ttl='';
 slide(doi+20).code1={'现在可以得到模拟低通原型:'};
 %slide(doi+20).code2={};
 slide(doi+20).text={};
 slide(doi+20).next=[doi+21];

%============Slide 37 ===============
 %slide(doi+21).ttl='';
 slide(doi+21).code1={'选择一种将模拟原型变换为数字滤波器的方法:'};
 %slide(doi+21).code2={};
 slide(doi+21).text={};
 slide(doi+21).next=[doi+27,doi+22];
 
%============Slide 38 ================
 slide(doi+22).ttl='脉冲响应不变法';
 slide(doi+22).code1={'用3dB频率Wn作为归一化频率进行反归一化,';'即用s/Wn代入p,得Ha(s)='};
 %slide(doi+22).code2={};
 slide(doi+22).text={};
 slide(doi+22).next=[doi+23];

%============Slide 39 =================
 %slide(doi+23).ttl='';
 slide(doi+23).code1={'为了转换到数字域,将Ha(s)展成部分分式:'};
 %slide(doi+23).code2={};
 slide(doi+23).text={};
 slide(doi+23).next=[doi+24];

%============Slide 40 ==================
 %slide(doi+24).ttl='';
 slide(doi+24).code1={'将极点p用e^(^p^/^f^s^a^)代替,得数字域传递函数H(z):'};
 %slide(doi+24).code2={};
 slide(doi+24).next=[doi+25];

%============Slide 41 ===================
 %slide(doi+25).ttl='';
 slide(doi+25).code1={'代入Wn和fsa,并整理得到要设计的滤波器的传递函数:' };
 %slide(doi+25).code2={};
 slide(doi+25).next=[doi+26];

%============Slide 42 ===================
 %slide(doi+26).ttl='';
 slide(doi+26).code1={'脉冲响应h(n):'};
 %slide(doi+26).code2={};
 slide(doi+26).next=[1];

%============Slide 43 ====================
 slide(doi+27).ttl='双线性变换法';
 slide(doi+27).code1={'由于BLT方法的非线性相位变换,';'需要计算预畸的截止频率Wpre:'};
 %slide(doi+27).code2={};
 slide(doi+27).text={};
 slide(doi+27).next=[doi+28];

%============Slide 44 ====================
 %slide(doi+28).ttl='';
 slide(doi+28).code1={'用Wpre作为归一化频率进行反归一化,';'即用s/Wpre代入p,得Ha(s)='};
 %slide(doi+28).code2={};
 slide(doi+28).text={};
 slide(doi+28).next=[doi+29];

%============Slide 45 ====================
 %slide(doi+29).ttl='';
 slide(doi+29).code1={ '最后,进行从模拟到数字的转换, 即代入s=f(z^-^1)'};
 %slide(doi+29).code2={};
 slide(doi+29).text={};
 slide(doi+29).next=[doi+26];
 
end
