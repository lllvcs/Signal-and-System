function cmpArray = uf_cmpval(fmodel,annex,forder);

fmodel = lower(fmodel);

if nargin<2, annex=0.099; end;
if nargin<3, forder=5; end;

% ������˲��������ķ�ĸ����ʽ
[kk den_array] = uf_dentbl(fmodel,forder,annex);
forder = size(den_array,1);   % ��������߽�����

cmpArray = zeros(forder,forder);

if strcmp(fmodel,'butter'),
   
elseif strcmp(fmodel,'cheby1'),
   for n=1:forder,
      den_array(n,:)=den_array(n,:)./kk(n);
      if den_array(n,n+1)~=1,
%         den_array(n,:)=den_array(n,:)./den_array(n,n+1);
         den_array(n,:)=den_array(n,:).*kk(n)^2./den_array(n,n+1);
      end;
   end;
   
elseif strcmp(fmodel,''),
   
end;

den_array=den_array.*2;

% ����һ��Ԫ��ֵ

rootFormat = get(0,'Format');
format long g;

for forder=1:6,
   eqstr = '';
   [equationStr,componentStr,paraIndex]=uf_eqstr(forder);
   cmpNum = size(equationStr,1);
   for n=1:cmpNum,
      eqn = ['eq' int2str(n)];
      equantionVal = den_array(forder,paraIndex(n));
      eval([eqn ' = [equationStr(n,:) num2str(equantionVal,16)];']) ;
      eqstr=[eqstr eqn];
      if n<cmpNum, eqstr=[eqstr ',']; end;
   end;
   eval( [ '[' componentStr '] = solve(' eqstr ',''' componentStr ''');' ] );
   ls_command=['componentVal=uf_cmpsel([' componentStr '],den_array(' int2str(forder) ',1:' int2str(forder+1) '));'];
   eval(ls_command);
   cmpArray(forder,1:cmpNum) = componentVal;
   for n=1:cmpNum,
      cmpArray(forder,forder-n+1)=cmpArray(forder,n);
   end;
end;

set(0,'Format',rootFormat);




%============================================================
% �˲�����·Ԫ����⡢У�鷽����
%============================================================
function [equationStr,componentStr,paraIndex]=uf_eqstr(forder,fcheck);

% �Ԧ�������Ϊ׼���г�Ԫ��������
% ����Ԫ��ֵ���ֲ�ǰ��Գ�

if nargin<2, fcheck=0; end;

switch forder,
case 1,
   % ����Ԫ��
   componentStr = 'c1';
   % ��ⷽ��
   equationStr = 'c1 = ';
   paraIndex = 1;
   % ��������
case 2,
   % ����Ԫ��
   componentStr = 'c1';
   % ��ⷽ��
   equationStr = 'c1 + c1 = ';
   paraIndex = 2;
   % ���㷽��
   proofStr = 'c1 * c1';
   testIndex = 1;
case 3,
   % ����Ԫ��
   componentStr = 'c1,c2';
   % ��ⷽ��
   equationStr = str2mat( ...
      'c1 * c2 + c2 * c1 = ', ...
      'c1 + c2 + c1 = ');
   paraIndex = [2 3];
   % ���㷽��
   proofStr = 'c1 * c2 * c1';
   testIndex = 1;
case 4,
   % ����Ԫ��
   componentStr = 'c1,c2';
   % ��ⷽ��
   equationStr = str2mat( ...
      'c1 * c2 * c2 + c2 * c2 * c1 = ', ...
      'c1 + c2 + c2 + c1 = ');
   paraIndex = [2 4];
   % ���㷽��
   proofStr = str2mat( ...
      'c1 * c2 * c2 * c1', ...
      '( c1 + c2 ) * ( c2 + c1 )');
   testIndex = [1 3];
case 5,
   % ����Ԫ��
   componentStr = 'c1,c2,c3';
   % ��ⷽ��
   equationStr = str2mat( ...
      'c1 * c2 * c3 + c2 * c3 * c2 + c3 * c2 *c1 + c2 * c1 * c1 + c1 * c1 * c2 = ', ...
      '( c1 + c3 + c1 ) * ( c2 + c2 ) = ', ...
      'c1 + c2 + c3 + c2 + c1 = ');
   paraIndex = [3 4 5];
   % ���㷽��
   proofStr = str2mat( ...
      'c1 * c2 * c3 * c2 * c1', ...
      'c1 * c2 * c3 * c2 + c2 * c3 * c2 * c1');
   testIndex = [1 2];
case 6,
   % ����Ԫ��
   componentStr = 'c1,c2,c3';
   % ��ⷽ��
   equationStr = str2mat( ...
      'c1 * c2 * c3 * c3 + c2 * c3 * c3 * c2 + c3 * c3 * c2 *c1 + c3 * c2 * c1 * c1 + c2 * c1 * c1 * c2 + c1 * c1 * c2 * c3 = ', ...
      '4 * c1 * c2 * c3 + 2 * c1 * c2 * c2 + 2 * c2 * c3 * c3 = ', ...
      'c1 + c2 + c3 + c3 + c2 + c1 = ');
   paraIndex = [3 4 6];
   % ���㷽��
   proofStr = str2mat( ...
      'c1 * c2 * c3 * c3 * c2 * c1', ...
      'c1 * c2 * c3 * c3 * c2 + c2 * c3 * c3 * c2 * c1', ...
      '( c1 + c3 + c2 ) * ( c2 + c3 + c1 )');
   testIndex = [1 2 5];
case 7,
   % ����Ԫ��
   componentStr = 'c1,c2,c3,c4';
   % ��ⷽ��
   equationStr = str2mat( ...
      'c1 * c2 * c3 * c3 + c2 * c3 * c3 * c2 + c3 * c3 * c2 *c1 + c3 * c2 * c1 * c1 + c2 * c1 * c1 * c2 + c1 * c1 * c2 * c3 = ', ...
      '4 * c1 * c2 * c3 + 2 * c1 * c2 * c2 + 2 * c2 * c3 * c3 = ', ...
      'c1 + c2 + c3 + c3 + c2 + c1 = ');
   paraIndex = [3 4 6];
   % ���㷽��
   proofStr = str2mat( ...
      'c1 * c2 * c3 * c3 * c2 * c1', ...
      'c1 * c2 * c3 * c3 * c2 + c2 * c3 * c3 * c2 * c1', ...
      '( c1 + c3 + c2 ) * ( c2 + c3 + c1 )');
   testIndex = [1 2 5];
otherwise,
   equationStr = '';
   componentStr = '';
   paraIndex = [];
end;

if fcheck,
   equationStr = proofStr;
   paraIndex = testIndex;
end;





%============================================================
% �˲�����·Ԫ��У����ѡ��
%============================================================
function componentVal=uf_cmpsel(Components,fden);

fden=numeric(fden);
Components = real(numeric(Components));
C_row = size(Components,1);
cmpIndex = 1;
forder = length(fden) - 1;

% �ҳ���ʵ����
m = 0;
for n = 1 : C_row,
   if isempty( find( Components(n,:) <= 0 ) ),
      m=m+1;
      row1(m)=n;
   end;
end;
Components=Components(row1,:);

li_num=size(Components,1);     % ������Ԫ������
testFlag=zeros(1,li_num);      % ���Ժϸ��־

% Ԫ��ֵУ����ѡ��
if li_num > 1,
   % ���鷽��
   [proofStr,componentStr,testIndex]=uf_eqstr(forder,1);
   componentStr=strrep(componentStr, ',' , ''',''');
   eval(['ls_cmp=str2mat(''' componentStr ''');']);
   li_testNum=length(testIndex);  % ÿ��Ԫ�����Դ���
   
   if li_testNum > 0,
      
   for m = 1 : li_num,
      
      for l=1:li_testNum,
         ls_proof = proofStr(l,:);
         for n=1:size(ls_cmp,1),
            ls_proof=strrep(ls_proof,ls_cmp(n,:),num2str(Components(m,n),10));
         end;
         testVal=eval(ls_proof);
         if abs(testVal-fden(testIndex(l)))<1e-2,
            testFlag(m)=testFlag(m)+1;
         end;
         
      end;
      
   end;
   
   testFlag=find(testFlag==li_testNum);
   if isempty(testFlag),
      warning(['��' int2str(forder) '���˲�����·Ԫ��У��δͨ����']);
   else,
      Components=Components(testFlag,:);
      cmpIndex = find( Components(:,1) == min(Components(:,1)) );
   end;
   
   end;
   
end;

componentVal=Components(cmpIndex(1),:);
