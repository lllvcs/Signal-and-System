function [infostr,paraData]=uf_lp_norm(paraHandle);
% UF_LP_NORM �˲�����������ͨԭ�ͽ��в�����һ��
%            �����������Ϊuicontrol���󣬷ֱ�ָ��
%              paraHandle(1) - ���ģ��(BUTTER/CHEBY)
%              paraHandle(1) - ͨ����ʽ(LP/HP/BP/BS)
%              paraHandle(3:8) - �˲����������
%            ���������
%              infostr - ˵����Ϣ
%              paraData - ��һ�����
%                  ����BUTTER�ͣ����3dB��������
%
%                  ����CHEBY�ͣ���������
%
%            axz 1999-11-05

fltModel=get(paraHandle(1),'Value');
fltBtype=get(paraHandle(2),'Value');

infostr = '' ;
order = 0 ;
B = 0;

switch fltBtype,
case 1,         % LP
   fp=str2num(get(paraHandle(3),'String'));   % ͨ����ֹƵ��
   Ap=str2num(get(paraHandle(4),'String'));   % ͨ�����˥��
   fr=str2num(get(paraHandle(5),'String'));   % ������Ƶ��
   Ar=str2num(get(paraHandle(6),'String'));   % �����С˥��
   Ro=str2num(get(paraHandle(7),'String'));   % ��׼����ֵ
   if fltModel==1 & Ap~=3,
      % �õ����������İ�����˹��ͨԭ���˲�������С����
      order = ceil( log10( (10 .^ (0.1*abs(Ar)) - 1)./ ...
         (10 .^ (0.1*abs(Ap)) - 1) ) / (2*log10(fr/fp)) );
      % ���� 3dB Ƶ�ʴ���
      fp = fp / ( (10^(0.1*abs(Ap)) - 1)^(1/(2*order)) );
      Ap = 3;
      infostr=['ע���ð�����˹��ͨ�˲�����ͨ������ָ�겻��3dB������������ɵ���3dB����Ϊ' num2str(fp) 'Hz��' char(10)];
   end
   flr_n = fr / fp;
   infostr = [infostr ...
         ' �� ������������' char(10) ...
         '�������ݹ�ʽ����r=��r/��c���ɵù�һ�����Ƶ��Ϊ ' num2str(flr_n) '��' char(10)];
   ls_xh = ' �� ';
   fc = fp;
   ls_omega = '';
case 2,         % HP
   fp=str2num(get(paraHandle(3),'String'));   % ͨ����ֹƵ��
   Ap=str2num(get(paraHandle(4),'String'));   % ͨ�����˥��
   fr=str2num(get(paraHandle(5),'String'));   % ������Ƶ��
   Ar=str2num(get(paraHandle(6),'String'));   % �����С˥��
   Ro=str2num(get(paraHandle(7),'String'));   % ��׼����ֵ
   if fltModel==1 & Ap~=3,
      Ap = 3;
      infostr=['ע�����������˹��ͨ�˲�����ͨ������ָ���޶�Ϊ3dB����' char(10)];
      set(paraHandle(4),'String','3');
   end;
   fhr_n = fr / fp;
   flr_n = 1 / fhr_n;
   infostr=[infostr ' �� �Ը�ͨ�˲�������ָ�����Ƶ�ʹ�һ������ͨ����ֹƵ��Ϊ��һ�������У�' char(10)];
   infostr=[infostr '������      ����' char(10)];
   infostr=[infostr '������hp = 1����hr = ' num2str(fhr_n) char(10)];
   infostr=[infostr ' �� ����ͨ�ļ���ָ��ת���ɵ�ͨԭ�͵ļ���ָ�꣬���ݹ�ʽ ��l=1/��h��' ...
         '�ɵ���Ӧ��ͨԭ�͵Ĺ�һ����ֹƵ��Ϊ' char(10)];
   infostr=[infostr '������     ��    ����     ��' char(10)];
   infostr=[infostr '������lp=1/��hp=1����lr=1/��hr=' num2str(flr_n) char(10)];
   ls_xh = ' �� ';
   fc = fp;
   ls_omega = '';
case 3,         % BP
   fpo=str2num(get(paraHandle(3),'String'));   % ͨ������Ƶ��
   fpw=str2num(get(paraHandle(4),'String'));   % ͨ������
   Ap =str2num(get(paraHandle(5),'String'));   % ͨ�����˥��
   frb=str2num(get(paraHandle(6),'String'));   % �����Сƫ��
   Ar =str2num(get(paraHandle(7),'String'));   % �����С˥��
   Ro =str2num(get(paraHandle(8),'String'));   % ��׼����ֵ
   if fltModel==1 & Ap~=3,
      Ap = 3;
      infostr=['ע�����������˹��ͨ�˲�����ͨ������ָ���޶�Ϊ3dB����' char(10)];
      set(paraHandle(5),'String','3');
   end;
   fp2 = ( fpw + sqrt(fpw^2 + 4*fpo^2) ) / 2;    % ��ͨ����ֹƵ��
   fp1 = ( - fpw + sqrt(fpw^2 + 4*fpo^2) ) / 2;  % ��ͨ����ֹƵ��
   flp_n = (fp2^2 - fpo^2) / (fpw * fp2);
   flr_n = ((fpo+frb)^2 - fpo^2) / (fpw * (fpo+frb));
   infostr=[infostr ' �� �����ͨ�˲����ļ���ָ�꣬���ݹ�ʽ ��o=sqrt(��1*��2)��B=��2-��1��' ...
         '���Եõ��ô�ͨ�˲������ϡ���ͨ����ֹƵ�ʷֱ�Ϊ' char(10) ...
         '��������2=2��*' num2str(fp2) 'rad/s����1=2��*' num2str(fp1) 'rad/s' char(10)];
   infostr=[infostr ' �� ����ͨ�˲����ļ���ָ��ת���ɵ�ͨԭ�͵ļ���ָ��' char(10) ...
         '�������ݹ�ʽ ��l = (��b^2 - ��o^2) / (B * ��b)��' char(10) ...
         '��������ͨ����ֹƵ��ת��Ϊ��ͨԭ�͵�ͨ����ֹƵ�ʣ��������ֹƵ��ת��Ϊ��ͨԭ�͵������ֹƵ�ʣ�' char(10) ...
         '��������lp=' num2str(flp_n) '����lr=' num2str(flr_n) char(10)];
   ls_xh = ' �� ';
   fc = fpo; B = fpw;
   ls_omega = '=��o';
case 4,         % BS
   fro=str2num(get(paraHandle(3),'String'));   % �������Ƶ��
   frw=str2num(get(paraHandle(4),'String'));   % �������
   Ap =str2num(get(paraHandle(5),'String'));   % ͨ�����˥��
   frb=str2num(get(paraHandle(6),'String'));   % �涨���ƫ��
   Ar =str2num(get(paraHandle(7),'String'));   % ��Ӧ���˥��
   Ro =str2num(get(paraHandle(8),'String'));   % ��׼����ֵ
   if fltModel==1 & Ap~=3,
      Ap = 3;
      infostr=['ע�����������˹�����˲�����ͨ������ָ���޶�Ϊ3dB��' char(10)];
      set(paraHandle(5),'String','3');
   end;
   fr2 = ( frw + sqrt(frw^2 + 4*fro^2) ) / 2;    % �������ֹƵ��
   fr1 = ( - frw + sqrt(frw^2 + 4*fro^2) ) / 2;  % �������ֹƵ��
   flp_n = (frw * fr1) / (fro^2 - fr1^2) ;
   flr_n = (frw * (fro-frb)) / (fro^2 - (fro-frb)^2) ;
   infostr=[infostr ' �� ��������˲����ļ���ָ�꣬���ݹ�ʽ ��o=sqrt(��1*��2)��B=��2-��1��' ...
         '���Եõ��ô����˲������ϡ��������ֹƵ�ʷֱ�Ϊ' char(10) ...
         '��������2=2��*' num2str(fr2) 'rad/s����1=2��*' num2str(fr1) 'rad/s' char(10)];
   infostr=[infostr ' �� �������˲����ļ���ָ��ת���ɵ�ͨԭ�͵ļ���ָ��' char(10) ...
         '�������ݹ�ʽ ��l = B * ��r / (��o^2 - ��r^2)��' char(10) ...
         '����������½�ֹƵ��ת��Ϊ��ͨԭ�͵�ͨ����ֹƵ�ʣ����涨�������ƫ��Ƶ��ת��Ϊ��ͨԭ�͵������ֹƵ�ʣ�' char(10) ...
         '��������lp=' num2str(flp_n) '����lr=' num2str(flr_n) char(10)];
   ls_xh = ' �� ';
   fc = fro; B = frw;
   ls_omega = '=��o';
end;

Kl = Ro/(2*pi*fc);
Kc = 1 /(Ro*2*pi*fc);
infostr=[infostr ls_xh '�迹��һ��ת��ϵ�������� ��c' ls_omega '=2��*' num2str(fc) 'rad/s' char(10) ...
      '�������ݹ�ʽ Kl=Ro/��c�� �õ��ת��ϵ��Ϊ ' num2str(Kl) char(10) ...
      '�������ݹ�ʽ Kc=1/��cRo���õ���ת��ϵ��Ϊ ' num2str(Kc)];

% index : 5  6     7  8     9  10 11  12 13
paraData=[fc;flr_n;Ar;order;Kl;Kc;-Ap;Ro;B];
   
