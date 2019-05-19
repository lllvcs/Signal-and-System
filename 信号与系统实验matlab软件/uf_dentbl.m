function [TblTitle,TblList,TblDenpoly]=uf_dentbl(fmodel,forder,annex);

fmodel=lower(fmodel);

if nargin<2, forder=3; end;
if nargin<3, annex=0.099; end;

order=10;
kk=ones(order,1);     % ����

if strcmp(fmodel,'butter'),
   if forder<2,
      error('���������˹�˲�������Ӧ���ڵ��ڣ���');
   end;
   if ~exist('anflt_butter_den_tbl.mat','file'),
      uf_setbutden(order);
   end;
   load anflt_butter_den_tbl;
   % Formatted Table
   ls_head=[' ���� |  ��ĸ����ʽϵ�����ߴ�����ʹ������У�'];
   den_str=num2str(den_array);
   [lrow,lcoll]=size(den_str);
   for i=1:lrow,
      if i<10,
         ls_left(i,:)=['   ' int2str(i) '  |  '];
      else,
         ls_left(i,:)=['  ' int2str(i)  '  |  '];
      end;
   end;
   TblTitle='��һ��Ƶ�ʵİ�����˹��ĸ����ʽϵ��';
   TblList=str2mat(ls_head, [ls_left den_str]);
   TblDenpoly=den_array(forder,1:(forder+1));
elseif strcmp(fmodel,'cheby1'),
   if forder<2,
      error('�����б�ѩ���˲�������Ӧ���ڵ��ڣ���');
   end;
   den_array=zeros(order,order+1);   % ��ĸ����ʽϵ��
   epsilon = sqrt(10^(.1*annex)-1);  % ��
   % ���� 1 �� order �׷�ĸ����ʽ
   for n=1:order,
      [z,p,k] = cheb1ap(n, annex);        % Chebyshev type I analog lowpass filter prototype.
      den_array(n,1:(n+1))=real(poly(p)); % Convert roots to polynomial
      kk(n)=den_array(n,n+1);      
   end;
   kk(2:2:order)=kk(2:2:order)./sqrt(1+epsilon^2);
   % Formatted Table
   ls_head=[' ���� |  ��ĸ����ʽϵ�����ߴ�����ʹ������У�' ...
         ' ע��ͨ������' num2str(annex) 'dB����=' num2str(epsilon) '��'];
   den_str=num2str(den_array);
   [lrow,lcoll]=size(den_str);
   for i=1:lrow,
      if i<10,
         ls_left(i,:)=['   ' int2str(i) '  |  '];
      else,
         ls_left(i,:)=['  ' int2str(i)  '  |  '];
      end;
   end;
   TblTitle=['��һ���б�ѩ���ͨ�˲���Hc(s)�ķ�ĸ����ʽ'];
   TblList=str2mat(ls_head, [ls_left den_str]);
   TblDenpoly=[kk(forder) den_array(forder,1:(forder+1))];

elseif strcmp(fmodel,''),
   
   
end;

% ֻ���� 1 �� order �׷�ĸ����ʽ�б�����
if nargout==2,
   clear TblTitle TblList;
   TblTitle=kk;
   TblList=den_array;
end;
