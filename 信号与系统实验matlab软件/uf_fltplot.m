function [figNum,ValCmp,TagCmp] = uf_fltplot(fType,fStruct,fOrder,fParas,fTitle);

fType = lower(fType);
fStruct = lower(fStruct);

% ��ʼ��
if strcmp(fType,'lowpass'),   % ��ͨ
   load uf_fltplot_ht1;
   load uf_fltplot_lp;
   if strcmp(fStruct,'t'),    % �� ��
      ls_cmp = 'L C ';
      li_pos = [91 20; 0 0; 113 59; 0 0];
   else,                      % �� ��
      la_tmp = cmp2;
      cmp2 = cmp1;
      cmp1 = la_tmp;
      ls_cmp = 'C L ';
      li_pos = [61 59; 0 0; 120 20; 0 0];
   end;
   
elseif strcmp(fType,'highpass'),
   load uf_fltplot_ht1;
   load uf_fltplot_hp;
   if strcmp(fStruct,'t'),    % �� ��
      ls_cmp = 'C L ';
      li_pos = [83 16; 0 0; 106 60; 0 0];
   else,                      % �� ��
      la_tmp = cmp2;
      cmp2 = cmp1;
      cmp1 = la_tmp;
      ls_cmp = 'L C ';
      li_pos = [71 60; 0 0; 118 16; 0 0];
   end;
   
elseif strcmp(fType,'bandpass'),
   load uf_fltplot_ht2;
   load uf_fltplot_bp;
   ls_cmp = 'CLCL';
   if strcmp(fStruct,'t'),    % �� ��
      li_pos = [75 16; 110 20; 128 74; 188 74];
   else,                      % �� ��
      la_tmp = cmp2;
      cmp2 = cmp1;
      cmp1 = la_tmp;
      li_pos = [65 74; 125 74; 124 16; 159 20];
   end;
   
elseif strcmp(fType,'bandstop'),
   load uf_fltplot_ht2;
   load uf_fltplot_bs;
   ls_cmp = 'CLCL';
   if strcmp(fStruct,'t'),    % �� ��
      li_pos = [103 63; 103 7; 130 56; 139 86];
   else,                      % �� ��
      la_tmp = cmp2;
      cmp2 = cmp1;
      cmp1 = la_tmp;
      li_pos = [65 56; 75 86; 130 63; 130 7];
   end;
   
end;

% ƴװ��·ͼ
fCircuit = fhead;

for m = 1 : fOrder,
   if mod(m,2),
      fCircuit = [fCircuit cmp1];
   else,
      fCircuit = [fCircuit cmp2];
   end;
end;

fCircuit = [fCircuit ftail];

% �����·ͼ
figNum = uf_fltcwin;
CHandle = get(figNum,'UserData');

[fHeight fWidth] = size(fCircuit);    % ���߶ȡ����  125��635
Wwid = 480;
Fwid = 450;
if fWidth <= 440,
   li_addw = 0;
else,
   li_addw = fWidth - 440;
end;

rootUnits=get(0,'Units');
set(0,'Units','pixels');
rootScreen=get(0,'ScreenSize');

lpos = get(figNum,'Position');
lpos(3) = Wwid + li_addw;
if lpos(1) + lpos(3) > rootScreen(3),
   lpos(1) = rootScreen(3)-lpos(3)-3;
end;
set(figNum,'Position',lpos);

lpos = get(CHandle(2),'Position');
lpos(3) = Fwid + li_addw;
set(CHandle(2),'Position',lpos);

set(0,'Units',rootUnits);

l_left = ceil(lpos(1) + (lpos(3) - fWidth)/2);
l_bttm = floor(195 + (150 - fHeight)/2);

axes(CHandle(7));
set(CHandle(7),'Position',[l_left l_bttm fWidth fHeight]);
image(fCircuit);
colormap(map);

% ��·Ԫ�����
li_spc = size(cmp1,2) + size(cmp2,2);
li_cnt = 0;
for m = 1 : 2 : fOrder,
   for n = 1 : 4,
      designator = 0;
      if li_pos(n,1),
         if n <= 2,
            li_cnt = li_cnt + 1;
            TagCmp(li_cnt,:) = [ls_cmp(n) num2str(m)];
            designator = 1;
         else,
            if m < fOrder,
               li_cnt = li_cnt + 1;
               TagCmp(li_cnt,:) = [ls_cmp(n) num2str(m+1)];
               designator = 1;
            end;
         end;
      end;
      if designator,
         h_cmp(li_cnt) = text('Units','data', ...
            'Position',[li_pos(n,1)+li_spc*((m-1)/2) li_pos(n,2)], ...
            'String',TagCmp(li_cnt,:), ...
            'FontSize',9, ...
            'HorizontalAlignment','center', ...
            'VerticalAlignment','middle');
      end;
   end;
end;

% ����ʵ�ʵ�·Ԫ��ֵ
if nargin >= 4 & ~isempty(fParas),
   % ��ʾ��֪�ĸ�������
   ls_conditions = str2mat( ...
         '1.�ο�Ƶ��', ...
         ['  Fc = ' num2str(fParas(1)) 'Hz'] );
   if fParas(5) ~= 0,
      alpha = fParas(5)/fParas(1);
      ls_conditions = str2mat( ls_conditions, ...
         ['  �� = B/fo = ' num2str(alpha)] );
   end;
   ls_conditions = str2mat( ls_conditions, ...
         '2.���ת��ϵ��', ...
         ['  Kl = ' num2str(fParas(2))], ...
         '3.����ת��ϵ��', ...
         ['  Kc = ' num2str(fParas(3))], ...
         '4.�ο�����ֵ', ...
         ['  Rs = ' num2str(fParas(4)) '��'] );
   if fParas(6) ~= 1,
      ls_conditions = str2mat( ls_conditions, ...
            '5.���ص���ֵ', ...
            ['  Rl = ' num2str(fParas(4)*fParas(6)) '��'] );
      ls_xh = '6.��һ��Ԫ��ֵ';
   else,
      ls_xh = '5.��һ��Ԫ��ֵ';
   end;
   if fStruct(1) == 't',
      ls_lab = 'lcHF';
   else,
      ls_lab = 'clFH';
   end;
   for n = 1 : 2 : fOrder,
      ls_cmpnorm(n,:) = ['  ' ls_lab(1) int2str(n) ''' = '];
      ls_unit(n,:) = ls_lab(3);
      if n < fOrder,
         ls_cmpnorm(n+1,:) = ['  ' ls_lab(2) int2str(n+1) ''' = '];
         ls_unit(n+1,:) = ls_lab(4);
      end;
   end;
   ls_cmpnorm = [ls_cmpnorm num2str(fParas(7:6+fOrder)) ls_unit];
   ls_conditions = str2mat( ls_conditions, ...
      ls_xh, ...
      ls_cmpnorm );
   % �����·Ԫ��ֵ
   CNum = size(TagCmp,1);
   ValCmp = zeros(CNum,1);
   for n = 1 : fOrder,
      if strcmp(fType,'lowpass'),   % ��ͨ
         if ls_cmpnorm(n,3) == 'c', % ��һ��Ԫ��Ϊ����
            ValCmp(n) = fParas(3) * fParas(6+n);              % -- C
            ls_unit(n,:) = 'F';
         else,                      % ��һ��Ԫ��Ϊ���
            ValCmp(n) = fParas(2) * fParas(6+n);              % -- L
            ls_unit(n,:) = 'H';
         end;
      elseif strcmp(fType,'highpass'),
         if ls_cmpnorm(n,3) == 'c', % ��һ��Ԫ��Ϊ����
            ValCmp(n) = fParas(2) * (1/fParas(6+n));          % -- L
            ls_unit(n,:) = 'H';
         else,                      % ��һ��Ԫ��Ϊ���
            ValCmp(n) = fParas(3) * (1/fParas(6+n));          % -- C
            ls_unit(n,:) = 'F';
         end;
      elseif strcmp(fType,'bandpass'),
         ls_unit([2*n-1 2*n],:) = ['F';'H'];
         if ls_cmpnorm(n,3) == 'c', % ��һ��Ԫ��Ϊ����
            ValCmp(2*n-1) = fParas(3) * (fParas(6+n)/alpha);  % -- C
            ValCmp(2*n)   = fParas(2) * (alpha/fParas(6+n));  % -- L
         else,                      % ��һ��Ԫ��Ϊ���
            ValCmp(2*n-1) = fParas(3) * (alpha/fParas(6+n));  % -- C
            ValCmp(2*n)   = fParas(2) * (fParas(6+n)/alpha);  % -- L
         end;
      elseif strcmp(fType,'bandstop'),
         ls_unit([2*n-1 2*n],:) = ['F';'H'];
         if ls_cmpnorm(n,3) == 'c', % ��һ��Ԫ��Ϊ����
            ValCmp(2*n-1) = fParas(3) * (fParas(6+n)*alpha);  % -- C
            ValCmp(2*n)   = fParas(2) * 1/(fParas(6+n)*alpha);% -- L
         else,                      % ��һ��Ԫ��Ϊ���
            ValCmp(2*n-1) = fParas(3) * 1/(fParas(6+n)*alpha);% -- C
            ValCmp(2*n)   = fParas(2) * (fParas(6+n)*alpha);  % -- L
         end;
      end;
   end;
   for n = 1 : CNum,
      ls_results(n,:) = ' = ';
   end;
   ls_results = [TagCmp ls_results num2str(ValCmp) ls_unit];

   set(CHandle(4),'String',ls_conditions);
   set(CHandle(6),'String',ls_results);

end;

% ��ʾ�������ݲ���
set(CHandle(7),'Visible','off', ...
   'Box','on');

if nargin == 5 & ~isempty(fTitle),
   set(CHandle(1),'String',fTitle);
end;


% ==============================
%  �ڲ����� - ��ʾʵ�ʵ�·ͼ����
% ==============================
function fig = uf_fltcwin();

figName = '�˲�����·���֮��';

[existFlag,figHandle] = figflag(figName);

if ~existFlag,
   bgcolor = [0.753 0.753 0.753];
     
   rootUnits=get(0,'Units');
   set(0,'Units','pixels');
   rootScreen=get(0,'ScreenSize');
   l_left=floor((rootScreen(3)-480)/2);
   l_bttm=floor((rootScreen(4)-400)/2);
   
% ������
figHandle = figure('Color',[0.8 0.8 0.8], ...
   'MenuBar','none', ...
   'Name',figName, ...
   'NumberTitle','off', ...
   'Units','pixels', ...
   'Position',[l_left l_bttm 480 400], ...
   'Resize','off', ...
   'Tag','Analog_Filter_Circuit');

   set(0,'Units',rootUnits);

CHandle(1) = uicontrol('Parent',figHandle, ...
   'Style','text', ...
   'BackgroundColor',bgcolor, ...
   'FontName','����_GB2312', ...
   'FontSize',12, ...
   'ForegroundColor',[0 0 0.627450980392157], ...
   'Units','pixels', ...
   'Position',[15 360 450 25], ...
   'String','�˲�����·', ...
   'Tag','AFC2_Title');

%CHandle(2) = uicontrol('Parent',figHandle, ...
%   'Style','frame', ...
%   'BackgroundColor',bgcolor, ...
%   'Units','pixels', ...
%   'Position',[15 195 450 150], ...
%   'Tag','AFC2_Frame','Visible','on');
CHandle(2) = axes('Parent',figHandle, ...
   'Units','pixels', ...
   'Box','on', ...
   'Color',bgcolor, ...
   'Position',[15 195 450 150], ...
   'XTick',[ ],'YTick',[ ], ...
   'Tag','AFC2_Frame');

CHandle(3) = uicontrol('Parent',figHandle, ...
   'Style','text', ...
   'BackgroundColor',bgcolor, ...
   'FontName','����', ...
   'FontSize',10, ...
   'HorizontalAlignment','left', ...
   'Units','pixels', ...
   'Position',[15 165 215 20], ...
   'String','��֪�˲�����Ʋ�����', ...
   'Tag','AFC2_STCond');

CHandle(4) = uicontrol('Parent',figHandle, ...
   'Style','listbox', ...
   'BackgroundColor',[1 1 1], ...
   'FontName','Fixedsys', ...
   'FontSize',9, ...
   'HorizontalAlignment','left', ...
   'Units','pixels', ...
   'Position',[15 15 215 145], ...
   'String','1|2|3|4', ...
   'Tag','AFC2_LBCond', ...
   'Value',1);

CHandle(5) = uicontrol('Parent',figHandle, ...
   'Style','text', ...
   'BackgroundColor',bgcolor, ...
   'FontName','����', ...
   'FontSize',10, ...
   'HorizontalAlignment','left', ...
   'Units','pixels', ...
   'Position',[250 165 215 20], ...
   'String','�˲���Ԫ��ֵ�б�', ...
   'Tag','AFC2_STReslt');

CHandle(6) = uicontrol('Parent',figHandle, ...
   'Style','listbox', ...
   'BackgroundColor',[1 1 1], ...
   'FontName','Fixedsys', ...
   'FontSize',9, ...
   'HorizontalAlignment','left', ...
   'Units','pixels', ...
   'Position',[250 15 215 145], ...
   'String','1|2|3|4', ...
   'Tag','AFC2_LBReslt', ...
   'Value',1);

CHandle(7) = axes('Parent',figHandle, ...
   'Units','pixels', ...
   'Box','on', ...
   'Position',[71 234 314 74], ...
   'Tag','AFC2_Axes');

set(figHandle,'UserData',CHandle);

end;

if nargout > 0, fig = figHandle; end;
