function uf_setpara(ah_pop);
% UF_SETPARA �����˲�������ͨ/��ͨ/��ͨ/���裩���������
%            ���ڡ�������ģ���˲�����
%            ���������
%             ah_pop - ����ʽ�˵���������anflttbl1.m��

if nargin<1, ah_pop=gco; end

li_value=get(ah_pop,'Value');
lh_paras=get(ah_pop,'UserData');

switch li_value,
case 1,     % ��ͨ
   ls_paratxt=['ͨ����ֹƵ��';'ͨ�����˥��';'�����ֹƵ��';'�����С˥��';'����׼����ֵ'];
   ls_paraval=['1000';'   3';'1500';'  20';' 100'];
   ls_paraunt=['Hz';'dB';'Hz';'dB';'�� '];
case 2,     % ��ͨ
   ls_paratxt=['ͨ����ֹƵ��';'ͨ�����˥��';'�����ֹƵ��';'�����С˥��';'����׼����ֵ'];
   ls_paraval=['1000';'   3';' 500';'  20';' 100'];
   ls_paraunt=['Hz';'dB';'Hz';'dB';'�� '];
case 3,     % ��ͨ
   ls_paratxt=['ͨ������Ƶ��';'����ͨ������';'ͨ�����˥��';'�����Сƫ��';'�����С˥��';'����׼����ֵ'];
   ls_paraval=['1000';' 200';'   3';' 200';'  20';' 100'];
   ls_paraunt=['Hz';'Hz';'dB';'Hz';'dB';'�� '];
case 4,     % ����
   ls_paratxt=['�������Ƶ��';'�����������';'ͨ�����˥��';'�涨���ƫ��';'��Ӧ���˥��';'����׼����ֵ'];
   ls_paraval=['1000';' 200';'   3';'  50';'  20';' 100'];
   ls_paraunt=['Hz';'Hz';'dB';'Hz';'dB';'�� '];
otherwise,
   disp('�޴˲˵���')
   return
end;

li_paranum=size(ls_paratxt,1);

for i = 1:li_paranum,
   set(lh_paras(i,1),'String',deblankall(ls_paratxt(i,:)));
   set(lh_paras(i,2),'String',deblankall(ls_paraval(i,:)));
   set(lh_paras(i,3),'String',deblankall(ls_paraunt(i,:)));
   set(lh_paras(i,:),'Visible','on');
end

set(lh_paras((li_paranum+1):size(lh_paras,1),:),'Visible','off');

return
