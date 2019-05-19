function [TblTitle,TblList,TblDenpoly]=uf_dentbl(fmodel,forder,annex);

fmodel=lower(fmodel);

if nargin<2, forder=3; end;
if nargin<3, annex=0.099; end;

order=10;
kk=ones(order,1);     % 增益

if strcmp(fmodel,'butter'),
   if forder<2,
      error('输入巴特沃斯滤波器阶数应大于等于２。');
   end;
   if ~exist('anflt_butter_den_tbl.mat','file'),
      uf_setbutden(order);
   end;
   load anflt_butter_den_tbl;
   % Formatted Table
   ls_head=[' 阶数 |  分母多项式系数（高次项→低次项排列）'];
   den_str=num2str(den_array);
   [lrow,lcoll]=size(den_str);
   for i=1:lrow,
      if i<10,
         ls_left(i,:)=['   ' int2str(i) '  |  '];
      else,
         ls_left(i,:)=['  ' int2str(i)  '  |  '];
      end;
   end;
   TblTitle='归一化频率的巴特沃斯分母多项式系数';
   TblList=str2mat(ls_head, [ls_left den_str]);
   TblDenpoly=den_array(forder,1:(forder+1));
elseif strcmp(fmodel,'cheby1'),
   if forder<2,
      error('输入切比雪夫滤波器阶数应大于等于２。');
   end;
   den_array=zeros(order,order+1);   % 分母多项式系数
   epsilon = sqrt(10^(.1*annex)-1);  % ε
   % 计算 1 至 order 阶分母多项式
   for n=1:order,
      [z,p,k] = cheb1ap(n, annex);        % Chebyshev type I analog lowpass filter prototype.
      den_array(n,1:(n+1))=real(poly(p)); % Convert roots to polynomial
      kk(n)=den_array(n,n+1);      
   end;
   kk(2:2:order)=kk(2:2:order)./sqrt(1+epsilon^2);
   % Formatted Table
   ls_head=[' 阶数 |  分母多项式系数（高次项→低次项排列）' ...
         ' 注：通带波纹' num2str(annex) 'dB（ε=' num2str(epsilon) '）'];
   den_str=num2str(den_array);
   [lrow,lcoll]=size(den_str);
   for i=1:lrow,
      if i<10,
         ls_left(i,:)=['   ' int2str(i) '  |  '];
      else,
         ls_left(i,:)=['  ' int2str(i)  '  |  '];
      end;
   end;
   TblTitle=['归一化切比雪夫低通滤波器Hc(s)的分母多项式'];
   TblList=str2mat(ls_head, [ls_left den_str]);
   TblDenpoly=[kk(forder) den_array(forder,1:(forder+1))];

elseif strcmp(fmodel,''),
   
   
end;

% 只返回 1 至 order 阶分母多项式列表（矩阵）
if nargout==2,
   clear TblTitle TblList;
   TblTitle=kk;
   TblList=den_array;
end;
