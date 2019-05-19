function [Fsystrans,omega,Array,Textinfo]=uf_rfltsys(pbtype);
% UF_RFLTSYS �ɵ�ͨԭ��ת����ʵ���˲����Ĵ��ݺ�����
%            ���������
%              pbtype - ͨ�����ͣ�lp/hp/bp/bs��

pbtype=deblankall(lower(pbtype));

h_frame=get(gcf,'UserData');
h_fmenus=get(h_frame(1),'UserData');
h_fparas=get(h_frame(2),'UserData');
h_button=get(h_frame(3),'UserData');
h_option=get(h_frame(4),'UserData');

paraData=get(h_option(6),'UserData');
denpoly=get(h_option(8),'UserData');

if get(h_fmenus(1),'Value')==1,  % butter
   k=1;               % ����
else,                            % cheby
   k=denpoly(1);      % ����
   denpoly=denpoly(2:length(denpoly));
end;

Fc=paraData(5);       % ��ͨ��ֹƵ��
order=paraData(8);    % ��ͨԭ�ͽ���

denpoly=round(denpoly(1:order+1).*1e4)./1e4;  % ��ȷ����λС��
strpoly=uf_deblank(poly2str(denpoly,'s'));
densympoly=poly2sym(denpoly,'s');
numerator=num2str(k); % ����

Textinfo = ['���Ĳ����ӹ�һ��ģ���ͨ�任��ʵ���˲���' char(10) ...
      '�ɵ������ļ���õ���һ����ͨԭ�͵�ϵͳ����Ϊ��' char(10) ...
      '��Hl(s) = ' numerator ' / (' strpoly ')' char(10) ];

Slen=400;
Array=zeros(1,Slen);

if strcmp(pbtype,'lp'),       % s �� s/��c
   replace_sub=['(s/(2*pi*' num2str(Fc) '))'];
   Fsystrans=subs(symdiv(numerator,densympoly),'s',replace_sub);
   Fsystrans=simple(Fsystrans);
   Textinfo=[Textinfo '���ݵ�ͨԭ�͡�ʵ�ʵ�ͨ�ı任��ϵʽ s �� s/��c��' ...
         '�� s = ' replace_sub ' ������ʽ�ɵ������ͨ�˲����Ĵ��ݺ���Ϊ' char(10)];
   MaxOmega=10*2*pi*Fc;
   MinOmega=max(2*pi*1,0.1*2*pi*Fc);
elseif strcmp(pbtype,'hp'),   % s �� ��c/s
   replace_sub=['(2*pi*' num2str(Fc) '/s)'];
   Fsystrans=subs(symdiv(numerator,densympoly),'s',replace_sub);
   Fsystrans=simple(Fsystrans);
   Textinfo=[Textinfo '���ݵ�ͨԭ�͡�ʵ�ʸ�ͨ�ı任��ϵʽ s �� ��c/s��' ...
         '�� s = ' replace_sub ' ������ʽ�ɵ������ͨ�˲����Ĵ��ݺ���Ϊ' char(10)];
   MaxOmega=10*2*pi*Fc;
   MinOmega=max(2*pi*1,0.1*2*pi*Fc);
elseif strcmp(pbtype,'bp'),
   fpo=str2num(get(h_fparas(1,2),'String'));   % ͨ������Ƶ��
   fpw=str2num(get(h_fparas(2,2),'String'));   % ͨ������
   frb=str2num(get(h_fparas(4,2),'String'));   % �����Сƫ��
   replace_sub=['((s^2+(2*pi*' num2str(fpo) ')^2)/(s*(2*pi*' num2str(fpw) ')))'];
   Fsystrans=subs(symdiv(numerator,densympoly),'s',replace_sub);
   Fsystrans=simple(Fsystrans);
   Textinfo=[Textinfo '���ݵ�ͨԭ�͡�ʵ�ʴ�ͨ�ı任��ϵʽ s �� (s^2+��o^2)/(s*B)��' ...
         '�� s = ' replace_sub ' ������ʽ�ɵ������ͨ�˲����Ĵ��ݺ���Ϊ' char(10)];
   %MaxOmega=2*pi*(fpo+50*frb);
   %MinOmega=max(2*pi*1,2*pi*(fpo-5*frb));
   MaxOmega=10*2*pi*fpo;
   MinOmega=max(2*pi*1,0.1*2*pi*fpo);
elseif strcmp(pbtype,'bs'),
   fro=str2num(get(h_fparas(1,2),'String'));   % �������Ƶ��
   frw=str2num(get(h_fparas(2,2),'String'));   % �������
   frb=str2num(get(h_fparas(4,2),'String'));   % �涨���ƫ��
   replace_sub=['((s*2*pi*' num2str(frw) ')/(s^2+(2*pi*' num2str(fro) ')^2))'];
   Fsystrans=subs(symdiv(numerator,densympoly),'s',replace_sub);
   Fsystrans=simple(Fsystrans);
   Textinfo=[Textinfo '���ݵ�ͨԭ�͡�ʵ�ʴ���ı任��ϵʽ s �� s*B/(s^2+��o^2)��' ...
         '�� s = ' replace_sub ' ������ʽ�ɵ���������˲����Ĵ��ݺ���Ϊ' char(10)];
   %MaxOmega=2*pi*(fpo+50*frb);
   %MinOmega=max(2*pi*1,2*pi*(fpo-5*frb));
   MaxOmega=10*2*pi*fro;
   MinOmega=max(2*pi*1,0.1*2*pi*fro);
end;

omega=linspace(MinOmega,MaxOmega,Slen);   % radians/second
[Fnum,Fden]=numden(Fsystrans);
Fnumpoly=sym2poly(Fnum);
Fdenpoly=sym2poly(Fden);
Fnumstr=uf_deblank(poly2str(Fnumpoly,'s'));
Fdenstr=uf_deblank(poly2str(Fdenpoly,'s'));
Textinfo=[Textinfo '��H(s) = ( ' Fnumstr ' ) / ( ' Fdenstr ' )' char(10) ...
      '���Ƶ����������ͼ��ʾ��'];
Fnumval=polyval(Fnumpoly,i.*omega);
Fdenval=polyval(Fdenpoly,i.*omega);
Array=abs(Fnumval./Fdenval);
omega=omega./(2*pi);
Array = 20 .* log10( Array );
