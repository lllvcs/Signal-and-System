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
   slide(1).ttl='�˲������';
   %slide(1).title='Filter Bank Design';
   slide(1).code1={'�˲����������Ϊ�����˲���(Digital Filter)'};   
   %' load logo',
   %' surf(L,R), colormap(M)',
   %' n = length(L(:,1));',
   %' axis off, axis([1 n 1 n -.2 .8]), view(-37.5,30)',
   %'title(''MATLAB.  Picture the Power.'');' };
   %slide(1).code2={};
   slide(1).text={
      '��ӭ��ʹ���˲�����ƽ�ѧ�����',
      '',
      '������Ϊ�����򵼣��ҽ������������˲�����ƵĹ��̡������ó̷�Ϊ����',
      '���裬�������￴�����ǵ�һ�����������㡣һ����������������һ������',
      '��ÿһ�������Ĺ�����Ϊѡ��һ�������˲������࣬��Ϊ���в������룬��',
      '�������صļ��㷽�����м�����ͬʱ����ÿһ���������Է����ͨ����',
      '��һҳ��������һҳ���������á�����ǰ��������ظ����ݵȡ����⣬ͨ',
      '������ʾ����ť���򵼿��԰���Ĭ��ֵ�Զ�����˲���������ʾ�����У���',
      '������ʱֹͣ��ʾ�����ֶ�������ơ�',
      '',
      '�������ڣ���������Ƴ�����������˲����ˣ���ʼ�ɣ��������ڵģ�'};
   slide(1).next=[2,2]; 
   
   %========== Slide 2 ==========
   %======choose Lp/Bp/Hp in AF==
   %slide(2).ttl='';
   slide(2).code1={'����ѡ���˲�������(LP/HP/BP)��'};
   %slide(2).code2={'xptext( ''>> a = [1 2 3 4 6 4 3 4 5]'', '' '', ''a ='', '' '', ''   1   2   3   4   6   4   3   4   5'' );' };
   slide(2).text={
      '����, ����Ҫȷ��Ҫ��Ƶ��˲�����ʲô���͵�, ֻ������, ��������"�еķ�ʸ".',
      '����, ��֮��ļ������趼������ȷ���������Ŀ��. ',
      '',
      '��ͨ, ��ͨ�ʹ�ͨ����һ�ַ����ǻ����˲�����Ƶ����Ӧ����ʵ��Ӧ�����˲�Ч��',
      '�����ֵ�. ����������Ӧ�����, ���������Ƴ����˲����Ǿ��Բ������������',
      '�������е���ʽ���˲�Ч��, �����������ǲ�����ʵ�ֵ�. ��Ȼ, �ƽ������Ƶ��',
      '��ӦЧ��Խ��Խ�������ǵ�Ը��. ��ͬʱ, ��ķѵ���ԴҲԽ��Խ��. ����, ����',
      'ʵ�����ʱ, ��ҪȨ������, ����������˲��������͵�ѡ��Ͳ�����ѡ��, ����',
      '����͸���������һ��ʵ������, �����Դ����ھͿ�ʼ���۾���ֵ��!'};
   slide(2).next=[1,0,0;3,0,0;dfOriginalIndex,dfOriginalIndex,dfOriginalIndex];
  %========== Slide 3 ==========
  %choose the AFLP original type
  slide(3).ttl='ģ��';
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
  slide(doi).ttl='����';
  slide(doi).code1={
    '��ѡ��Ҫ��Ƶ������˲�������(FIR/IIR)��'};
   %'xptext(  ''>> roots(p)'',   '' '',   ''ans ='',   '' '',   ''    3.7321'',   ''    1.0000'',   ''    0.2679'' );' };
  %slide(doi).code2={}; 
  slide(doi).text={
     'IIR��FIR�����˲����ķ���ʱ�����˲�����ʱ���������Ӧ���Զ����ֵ�. ����',
     '�����Ȼ��ͬ�������˲���.',
     '',
     'IIR DF����Ƴ������ǽ�������Ӧ��ģ���˲��������. ���;���Ƚ�ʡ��, ��',
     'Ϊģ���˲�����Ƽ������൱����, �д����򵥵Ĺ�ʽ��ͼ����Ϊǿ��Ĺ��ߺ�',
     '��, �����������൱�����, �ҿ��Եõ�һ��չ�ʽ��ʾ����ƽ��. IIRʱ',
     '������, ��Ȼ���㵽������, ���µĽ����ϵͳ���ܲ��ȶ�. ��IIR����������',
     '���ķ�������λ��.',
     '',
     '�����˲���������Ƶ���Ǵ��޵�, ��Ӧ��ʱ��ȴ�����޵�, ��Ȼ�ǲ�����ʵ�ֵ�, ',
     'FIR DF�����˼�����ͨ����Ҫ����Ƶ�Ƶ����Ӧ(�������ͨ�˲���)����ĳ�ֱ�',
     '��. FIR��ʱ������, �������ȶ���ʵ�ֵ�. ���������˵�һ������������λ��.',
     '',
     '����, IIR���ڶ���λҪ�����еĳ���. FIR�����ڶ�������λҪ��ϸߵĳ���.'};
  slide(doi).next=[2,0;doi+1,doi+15;doi+1,doi+16;doi+1,doi+17];

  %========== Slide 17 ==========

  slide(doi+1).ttl='FIR';
  slide(doi+1).code1={
      '����ѡ�����FIR DF�ķ���:'} ;
  %slide(doi+1).code2={};
  %'q = conv(p,p);',
   %'xptext(  ''>> q = conv(p,p)'',  '' '',   ''q ='',  '' '',   ''    1  -10   35  -52   35  -10    1'' );' };
  slide(doi+1).text={
     '��һ������ʱ����Ӧȥ�ƽ�����ʱ�����FIR�����Ļ���˼·, һ�������ַ���:',
     '',
     '���ڷ���ֱ����ԭ���޵�ʱ����Ӧ�Ͻ�ȡ���޵�һ��, �������뵽�ľ���ֱ�ӽ�',
     'ȡ, ����Ǿ��δ���, ��������Ч������Сƽ�������ϵĶ�ԭ�źŵ���ѱƽ�, ',
     '�Ҵ��ڳ���Խ��, ���ԽС. Ϊ�˼�С�����Ƿ��(���������˥��), �����˶�',
     '���δ���Ȩ�İ취, ��������, �����ǹ��ɴ��ļӿ�, ��Ȼ, ��Ȩ�Ժ����Ʒ�',
     '��, �Ѿ���������С�ƽ�.',
     '',
     'Ƶ�ʲ�����ʱ���������������������. ������Ĵ��޵��˲�����Ƶ�ʲ���, ��',
     '�����������ʱ���źŵ���������, ��Ȼ��ͻ����һ���̶ȵĻ���. ��ν�ƽ�,',
     '�������������ֵ�. ��Ƶ�ʲ�������˼·����ʱ������һ��������������Ӧ����',
     '��û�л�������������. �ڲ�������, �ƽ�������Ƶ�콫��������ϸ�һ��, ��',
     '�������ڲ����. ����, Ƶ�ʲ������ǻ��ڲ�ֵ���ıƽ�����.'};  
  slide(doi+1).next=[2,0;doi+2,doi+2;doi+3,doi+3;doi+4,doi+4];
  
  %========== Slide 18 ==========

  slide(doi+2).ttl='��ͨ';
  slide(doi+2).code1={'���ڣ�����������Ҫ�ô��ڷ��ƽ�������LPDF�Ĳ�����';'��ͨ��ֹƵ�� Ws='};
  slide(doi+2).text={
     '�ý�ֹƵ����Ҫ��FIR���ڷ�/Ƶ����Ӧ���ƽ��������ͨ�˲���Ƶ����Ӧ��"1"��',
     '��Ϊ"0"���ٽ�Ƶ��. Ҫ�ı�Ĭ��ֵ(��/4), �����������������Ҫ��ֵ����, ֵ',
     'Ӧ����0����֮��. �������Ƶ����Ӧ��Ӧ�Ļ��ڸ���������·�. ��������Ϻ�,',
     '�س��Ա�ʾȷ��, ͬʱ, �����Ƶ����ӦͼҲ��Ӧ�Ը��µ��µĽ�ֹƵ���µ�Ƶ��',
     'ͼ. ������, ����pi����ʾ, ���/4����0.25pi��0.25*pi, ��ȻҲ����ֱ������',
     '��/4��ֵ: 0.785. '  };   
  slide(doi+2).next=[doi+1;doi+5;doi+10];
  
%============Slide 19============
%=====doi+3======================

slide(doi+3).ttl='��ͨ';
slide(doi+3).code1={'���ڣ�����������Ҫ�ô��ڷ��ƽ�������HPDF�Ĳ�����';'��ͨ��ֹƵ�� Ws='};
%slide(doi+3).code2={};
slide(doi+3).text={ 
     '�ý�ֹƵ����Ҫ��FIR���ڷ�/Ƶ����Ӧ���ƽ��������ͨ�˲���Ƶ����Ӧ��"0"��',
     '��Ϊ"1"���ٽ�Ƶ��. Ҫ�ı�Ĭ��ֵ(3��/4), �����������������Ҫ��ֵ����, ֵ',
     'Ӧ����0����֮��. �������Ƶ����Ӧ��Ӧ�Ļ��ڸ���������·�. ��������Ϻ�,',
     '�س��Ա�ʾȷ��, ͬʱ, �����Ƶ����ӦͼҲ��Ӧ�Ը��µ��µĽ�ֹƵ���µ�Ƶ��',
     'ͼ. ������, ����pi����ʾ, ���/4����0.25pi��0.25*pi, ��ȻҲ����ֱ������',
     '��/4��ֵ: 0.785. '  };   

slide(doi+3).next=[doi+1;doi+5;doi+10];


%============Slide 20============
%===========doi+4================

slide(doi+4).ttl='��ͨ';
slide(doi+4).code1={'���ڣ�����������Ҫ�ô��ڷ��ƽ�������BPDF�Ĳ�����';'��ͨ��ֹƵ�� Ws='};
%slide(doi+4).code2={};
slide(doi+4).text={
     '�ý�ֹƵ����Ҫ��FIR���ڷ�/Ƶ����Ӧ���ƽ��������ͨ�˲���Ƶ����Ӧ"0","1"',
     '������ٽ�Ƶ��. Ҫ�ı�Ĭ��ֵ([��/4,3��/4]), �����������������Ҫ��ֵ��',
     '��, ֵӦ����0����֮��, ����ֵ����. �������Ƶ����Ӧ��Ӧ�Ļ��ڸ��������',
     '�·�. ��������Ϻ�, �س��Ա�ʾȷ��, ͬʱ, �����Ƶ����ӦͼҲ��Ӧ�Ը��µ�',
     '�µĽ�ֹƵ���µ�Ƶ��ͼ. ������, ����pi����ʾ, ���/4����0.25pi��0.25*pi,',
     '��ȻҲ����ֱ�������/4��ֵ: 0.785. '  };   

slide(doi+4).next=[doi+1;doi+5;doi+10];

%========== Slide 21 ==========

  %slide(doi+5).ttl='';
  slide(doi+5).code1={
    '���ղŵ������˲���չ�ɸ���Ҷ�������ɵã�'};
    %'Ws=get(slideData.BtnHandles(doi+2),''string'');',
    %'Wsnor=Ws/pi;' }; 
    
  % 'xptext(  ''>> whos'',   ''Name        Size      Bytes  Class'',   '' '',   ''A           3x3          72  double array'',   ''p           1x4          32  double array'',   ''q           1x7          56  double array'',   ''r           1x10         80  double array'',   '' '',   ''Grand total is 30 elements using 240 bytes'' );',
  % '' };
 % slide(doi+5).code2={};
  slide(doi+5).text={
     '���մ��ڷ�����, ��������ʱ�����ȥ��, �ʴ�һ��������Ŀ��ת��ʱ��, ��������',
     '��Ҷ�任. �õ���h(n)Ӧ�����������, �����������ǲ����ܽ���ȫ�����. ������',
     '����Ӧ������, ��ʹ�Ǽ������ʾ��֮��, h(n)Ҳ�Ǵ��ڵ�.'};  
  slide(doi+5).next=[doi+6];
  %========== Slide 22 ==========

  %slide(doi+6).ttl='';
  slide(doi+6).code1={'ѡ�񴰿�����:'};
                    %   'text(0.5,0.7,''������'');'};
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

  slide(doi+7).ttl='���ڷ�';
  slide(doi+7).code1={'�������봰�ڳ��� N=2M+1:';'M='};
%   'xptext(   '' >> sqrt(-1), log(0)'',   ''  '',   '' ans ='',   ''         0 + 1.0000i'',  '' '',  '' Warning: Log of zero'',  '' '',  '' ans ='',  ''   -Inf'');',
 %  '' };
 %slide(doi+7).code2={};
 slide(doi+7).text={
    '���֪��, ������������λ��FIR�����˲���. �����������ô��ڷ���Ƶ��ǵ�I��,',
    '��ʱ��ż�Գ�, ����Ϊ����. ��Ȼ, ż�Գ�����Ȼ�����, Ϊ�˱�֤�����봰�ڳ�',
    '��������, ��Ҫ�������M, �����ڳ���N=2*M+1. ���ڳ�����Ȼ��Խ��ƽ�Ч��Խ',
    '��, ��ͬʱ����Ҳ�Ӵ�, ϵͳ��������, ���������Զ��Լ���, ��һ��Ч�����. ',
    '�������, �س�, ���ῴ����ѡ��Ĵ��������������������仯.',
    '',
    '���ڿ�����, ����һ�������Ĵ��ڳ��ȿ�������ʽ����:'};
 slide(doi+7).next=[doi+8];

  %===========Slide 24==========
  %========doi+8================
%slide(doi+8).ttl='';
slide(doi+8).code1={'Ȼ��,Ϊ�˱�֤������λ�������';'�����ں�hi(n)������ƽ��M'};
%slide(doi+8).code2={};
%   'xptext(   '' >> sqrt(-1), log(0)'',   ''  '',   '' ans ='',   ''         0 + 1.0000i'',  '' '',  '' Warning: Log of zero'',  '' '',  '' ans ='',  ''   -Inf'');',
 %  '' };
slide(doi+8).text={
   ' '};
slide(doi+8).next=[doi+9];
  %========== Slide 25 ==========

  slide(doi+9).ttl='';
  slide(doi+9).code1={'��󣬽����ں�hi��˾͵õ������FIRDF��������Ӧ'};
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
  slide(doi+10).code1={'��Ҫ�������������λ���˲���:'};
  %slide(doi+10).code2={};
  slide(doi+10).text={};
  slide(doi+10).next=(doi+11)*ones(1,4);
   
  %===========Slide 27============
  slide(doi+11).ttl='Ƶ�ʲ�����';
  slide(doi+11).code1={ 'Ȼ��,�������������N(��һ��2\pi������)'};
                        %,'''',''M=''); 
                        %'j=1;',
                        %'while  ~get(slideData.BtnHandles(26,j),''value'')  j=j+1;  end ',
                        %'if (j==1)|(j=3) mytext1(27,''Ȼ��,�������������N=2M+1(��һ��2\pi������)'','''',''M='');',
                        %'else mytext1(27,''Ȼ��,�������������N=2M(��һ��2\pi������)'','''',''M=''); end' };
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
  slide(doi+12).code1={'���ǲ������H(k):'};
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
 slide(doi+13).code1={ 'Ϊ�˱�֤������λ,��������ѡ����˲�������,';'�����H(k)��һЩ����:'};
 %slide(doi+13).code2={};
 slide(doi+13).text={};
 slide(doi+13).next=[doi+14];

%=============Slide 30 =============
 %slide(doi+14).ttl='';
 slide(doi+14).code1={ '��H(k)�����ٷ�����Ҷ�任(IFFT),���ɵ�h(n)' };
 %slide(doi+14).code2={};
 slide(doi+14).text={};
 slide(doi+14).next=[1]; 

%=============Slide 31 =============
 slide(doi+15).ttl='��ͨ_IIR';
 slide(doi+15).code1={ '����,��ȷ��LPDF�Ĳ���:';
                       'ͨ����ֹƵ��fp(Hz):';
                       'ͨ�����˥��Rp(dB):';
                       '������Ƶ��fs(Hz):';
                       '�����С˥��Rs(dB):';
                       '����Ƶ��fsa(Hz):' };
                    %,''����,��ȷ��LPDF�Ĳ���:'',''ͨ����ֹƵ��Wp(Hz):'',''ͨ�����˥��Rp(dB):'',''������Ƶ��Ws(Hz):'',''�����С˥��Rs(dB):'',''����Ƶ��fs(Hz):'');'};
 %slide(doi+15).code2={};
 slide(doi+15).text={};
 slide(doi+15).next=[doi+18,doi+18,doi+18,doi+18,doi+18];

%============Slide 32 ==============
 slide(doi+16).ttl='��ͨ_IIR';
 slide(doi+16).code1={'����,��ȷ��HPDF�Ĳ���:';
                      'ͨ������Ƶ��fp(Hz):';
                      'ͨ�����˥��Rp(dB):';
                      '�������Ƶ��fs(Hz):';
                      '�����С˥��Rs(dB):';
                      '����Ƶ��fsa(Hz):' }; 
 %slide(doi+16).code2={};
 slide(doi+16).text={};
 slide(doi+16).next=(doi+18)*ones(1,5);

%============Slide 33 ==============
 slide(doi+17).ttl='��ͨ_IIR';
 slide(doi+17).code1={'����,��ȷ��BPDF�Ĳ���:';
                      'ͨ��Ƶ��fp(Hz)=[fpl,fph]:';
                      'ͨ�����˥��Rp(dB):';
                      '���Ƶ��fs(Hz)=[fsl,fsh]:';
                      '�����С˥��Rs(dB):';
                      '����Ƶ��fsa(Hz):' } ;          %mytext1(33,'' '','' '','' '','' '','' '','' '');'}; 
 %slide(doi+17).code2={};
 slide(doi+17).text={};
 slide(doi+17).next=(doi+18)*ones(1,5);

%============Slide 34 ===============
 %slide(doi+18).ttl='';
 slide(doi+18).code1={'Ȼ��,ѡ��һ��ģ���ͨԭ��:' };
 %slide(doi+18).code2={};
 slide(doi+18).text={};
 slide(doi+18).next=[doi+19,doi+19,doi+19];

%============Slide 35 ===============
 %slide(doi+19).ttl='';
 slide(doi+19).code1={'���ݲ������ǿ���ͨ���������,';'�ó���ͨԭ�͵Ľ�����3dB��:'};
 %slide(doi+19).code2={};
 slide(doi+19).text={};
 slide(doi+19).next=[doi+20];

%============Slide 36 ===============
 %slide(doi+20).ttl='';
 slide(doi+20).code1={'���ڿ��Եõ�ģ���ͨԭ��:'};
 %slide(doi+20).code2={};
 slide(doi+20).text={};
 slide(doi+20).next=[doi+21];

%============Slide 37 ===============
 %slide(doi+21).ttl='';
 slide(doi+21).code1={'ѡ��һ�ֽ�ģ��ԭ�ͱ任Ϊ�����˲����ķ���:'};
 %slide(doi+21).code2={};
 slide(doi+21).text={};
 slide(doi+21).next=[doi+27,doi+22];
 
%============Slide 38 ================
 slide(doi+22).ttl='������Ӧ���䷨';
 slide(doi+22).code1={'��3dBƵ��Wn��Ϊ��һ��Ƶ�ʽ��з���һ��,';'����s/Wn����p,��Ha(s)='};
 %slide(doi+22).code2={};
 slide(doi+22).text={};
 slide(doi+22).next=[doi+23];

%============Slide 39 =================
 %slide(doi+23).ttl='';
 slide(doi+23).code1={'Ϊ��ת����������,��Ha(s)չ�ɲ��ַ�ʽ:'};
 %slide(doi+23).code2={};
 slide(doi+23).text={};
 slide(doi+23).next=[doi+24];

%============Slide 40 ==================
 %slide(doi+24).ttl='';
 slide(doi+24).code1={'������p��e^(^p^/^f^s^a^)����,�������򴫵ݺ���H(z):'};
 %slide(doi+24).code2={};
 slide(doi+24).next=[doi+25];

%============Slide 41 ===================
 %slide(doi+25).ttl='';
 slide(doi+25).code1={'����Wn��fsa,������õ�Ҫ��Ƶ��˲����Ĵ��ݺ���:' };
 %slide(doi+25).code2={};
 slide(doi+25).next=[doi+26];

%============Slide 42 ===================
 %slide(doi+26).ttl='';
 slide(doi+26).code1={'������Ӧh(n):'};
 %slide(doi+26).code2={};
 slide(doi+26).next=[1];

%============Slide 43 ====================
 slide(doi+27).ttl='˫���Ա任��';
 slide(doi+27).code1={'����BLT�����ķ�������λ�任,';'��Ҫ����Ԥ���Ľ�ֹƵ��Wpre:'};
 %slide(doi+27).code2={};
 slide(doi+27).text={};
 slide(doi+27).next=[doi+28];

%============Slide 44 ====================
 %slide(doi+28).ttl='';
 slide(doi+28).code1={'��Wpre��Ϊ��һ��Ƶ�ʽ��з���һ��,';'����s/Wpre����p,��Ha(s)='};
 %slide(doi+28).code2={};
 slide(doi+28).text={};
 slide(doi+28).next=[doi+29];

%============Slide 45 ====================
 %slide(doi+29).ttl='';
 slide(doi+29).code1={ '���,���д�ģ�⵽���ֵ�ת��, ������s=f(z^-^1)'};
 %slide(doi+29).code2={};
 slide(doi+29).text={};
 slide(doi+29).next=[doi+26];
 
end
