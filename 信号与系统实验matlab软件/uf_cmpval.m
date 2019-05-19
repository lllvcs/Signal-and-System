function cmpArray = uf_cmpval(fmodel,annex,forder);

fmodel = lower(fmodel);

if nargin<2, annex=0.099; end;
if nargin<3, forder=5; end;

% 先求得滤波器传函的分母多项式
[kk den_array] = uf_dentbl(fmodel,forder,annex);
forder = size(den_array,1);   % 行数（最高阶数）

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

% 求解归一化元件值

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
% 滤波器电路元件求解、校验方程组
%============================================================
function [equationStr,componentStr,paraIndex]=uf_eqstr(forder,fcheck);

% 以π型网络为准，列出元件方程组
% 网络元件值按分布前后对称

if nargin<2, fcheck=0; end;

switch forder,
case 1,
   % 待求元件
   componentStr = 'c1';
   % 求解方程
   equationStr = 'c1 = ';
   paraIndex = 1;
   % 无需验算
case 2,
   % 待求元件
   componentStr = 'c1';
   % 求解方程
   equationStr = 'c1 + c1 = ';
   paraIndex = 2;
   % 验算方程
   proofStr = 'c1 * c1';
   testIndex = 1;
case 3,
   % 待求元件
   componentStr = 'c1,c2';
   % 求解方程
   equationStr = str2mat( ...
      'c1 * c2 + c2 * c1 = ', ...
      'c1 + c2 + c1 = ');
   paraIndex = [2 3];
   % 验算方程
   proofStr = 'c1 * c2 * c1';
   testIndex = 1;
case 4,
   % 待求元件
   componentStr = 'c1,c2';
   % 求解方程
   equationStr = str2mat( ...
      'c1 * c2 * c2 + c2 * c2 * c1 = ', ...
      'c1 + c2 + c2 + c1 = ');
   paraIndex = [2 4];
   % 验算方程
   proofStr = str2mat( ...
      'c1 * c2 * c2 * c1', ...
      '( c1 + c2 ) * ( c2 + c1 )');
   testIndex = [1 3];
case 5,
   % 待求元件
   componentStr = 'c1,c2,c3';
   % 求解方程
   equationStr = str2mat( ...
      'c1 * c2 * c3 + c2 * c3 * c2 + c3 * c2 *c1 + c2 * c1 * c1 + c1 * c1 * c2 = ', ...
      '( c1 + c3 + c1 ) * ( c2 + c2 ) = ', ...
      'c1 + c2 + c3 + c2 + c1 = ');
   paraIndex = [3 4 5];
   % 验算方程
   proofStr = str2mat( ...
      'c1 * c2 * c3 * c2 * c1', ...
      'c1 * c2 * c3 * c2 + c2 * c3 * c2 * c1');
   testIndex = [1 2];
case 6,
   % 待求元件
   componentStr = 'c1,c2,c3';
   % 求解方程
   equationStr = str2mat( ...
      'c1 * c2 * c3 * c3 + c2 * c3 * c3 * c2 + c3 * c3 * c2 *c1 + c3 * c2 * c1 * c1 + c2 * c1 * c1 * c2 + c1 * c1 * c2 * c3 = ', ...
      '4 * c1 * c2 * c3 + 2 * c1 * c2 * c2 + 2 * c2 * c3 * c3 = ', ...
      'c1 + c2 + c3 + c3 + c2 + c1 = ');
   paraIndex = [3 4 6];
   % 验算方程
   proofStr = str2mat( ...
      'c1 * c2 * c3 * c3 * c2 * c1', ...
      'c1 * c2 * c3 * c3 * c2 + c2 * c3 * c3 * c2 * c1', ...
      '( c1 + c3 + c2 ) * ( c2 + c3 + c1 )');
   testIndex = [1 2 5];
case 7,
   % 待求元件
   componentStr = 'c1,c2,c3,c4';
   % 求解方程
   equationStr = str2mat( ...
      'c1 * c2 * c3 * c3 + c2 * c3 * c3 * c2 + c3 * c3 * c2 *c1 + c3 * c2 * c1 * c1 + c2 * c1 * c1 * c2 + c1 * c1 * c2 * c3 = ', ...
      '4 * c1 * c2 * c3 + 2 * c1 * c2 * c2 + 2 * c2 * c3 * c3 = ', ...
      'c1 + c2 + c3 + c3 + c2 + c1 = ');
   paraIndex = [3 4 6];
   % 验算方程
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
% 滤波器电路元件校验与选择
%============================================================
function componentVal=uf_cmpsel(Components,fden);

fden=numeric(fden);
Components = real(numeric(Components));
C_row = size(Components,1);
cmpIndex = 1;
forder = length(fden) - 1;

% 找出正实数解
m = 0;
for n = 1 : C_row,
   if isempty( find( Components(n,:) <= 0 ) ),
      m=m+1;
      row1(m)=n;
   end;
end;
Components=Components(row1,:);

li_num=size(Components,1);     % 待测试元件组数
testFlag=zeros(1,li_num);      % 测试合格标志

% 元件值校验与选择
if li_num > 1,
   % 检验方程
   [proofStr,componentStr,testIndex]=uf_eqstr(forder,1);
   componentStr=strrep(componentStr, ',' , ''',''');
   eval(['ls_cmp=str2mat(''' componentStr ''');']);
   li_testNum=length(testIndex);  % 每组元件测试次数
   
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
      warning(['第' int2str(forder) '阶滤波器电路元件校验未通过。']);
   else,
      Components=Components(testFlag,:);
      cmpIndex = find( Components(:,1) == min(Components(:,1)) );
   end;
   
   end;
   
end;

componentVal=Components(cmpIndex(1),:);
