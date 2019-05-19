function ii_rtn = uf_fltstp ( ah_figNumber, ai_dir ) ;
% UF_FLTSTP ���ڡ�������ģ���˲���������Ʋ�����ʾ����
%           ���������
%             ah_figNumber - �˲������GUI��������anflttbl1.m��
%             ai_dir - ��ʾ����1����һ����Ĭ�ϣ���-1����һ����0����ʼ����

if nargin<1, error('����ָ�����������ͼ������'); end

if nargin<2, ai_dir=1; end

h_frame=get(ah_figNumber,'UserData');

li_step=h_frame(5);
if ai_dir==-1,
   if li_step>0,
      li_step=li_step-1;
   else,         % �����һ������
      li_step=3;
   end;
elseif ai_dir==1,
   li_step=li_step+1;
end

h_fmenus=get(h_frame(1),'UserData');
h_fparas=get(h_frame(2),'UserData');
h_button=get(h_frame(3),'UserData');
h_option=get(h_frame(4),'UserData');

if li_step==0,
   uf_fltclose(0);
   set(h_fmenus,'Enable','on');
   set(h_fparas(:,2),'Enable','on');
   if ai_dir==0,
      set(h_fmenus,'Value',1);
      uf_setpara(h_fmenus(2));
   end
   set(h_button(2),'Visible','off');
   set(h_button(3),'String','����ʼ');
   set(h_frame(4),'Visible','off');
   set(h_option(3:9),'Visible','off');
   %
   axes(h_option(1));
   %[x,map]=imread('images/sns1.bmp','bmp');
   load('.\images\fig_cover.mat');
   image(x);
   colormap(map);
   clear x map;
   set(h_option(1),'Visible','off');
   %
   set(h_option(2),'String','��ʼ���˲�����������')
elseif li_step==1,
   set(h_fmenus,'Enable','inactive');
   set(h_fparas(:,2),'Enable','inactive');
   set(h_button(2),'Visible','on');
   set(h_button(3),'String','��һ��');
   set(h_button(3),'Enable','on');
   set(h_frame(4),'Visible','off');
   set(h_option(3:9),'Visible','off');
   %
   [ls_info,ld_para]=uf_lp_norm([h_fmenus;h_fparas(:,2)]);
   %
   set(h_option(2),'String',['��һ�����˲��������ͨԭ�Ͳ�����һ��' char(10) ls_info])
   set(h_option(6),'UserData',[zeros(4,1); ld_para])
elseif li_step==2,
   uf_fltclose(0);
   set(h_button(3),'Enable','off');
   set(h_frame(4),'Visible','on');
   set(h_option,'Visible','on');
   set(h_option([8 9]),'Visible','off');
   set(h_option(4),'Value',1,'Style','check','String','ͨ��');
   set(h_option(5),'Value',1,'Style','check','String','���');
   paraData=get(h_option(6),'UserData');
   paraData(1:4)=zeros(4,1);
   Omega_norm=paraData(6);       % ��һ�����Ƶ��
   Ar=paraData(7);               % �����С˥��
   Alp=paraData(11);             % ͨ�����˥��
   set(h_option(6),'UserData',paraData,'String','��λ');
   % ˵������
   set(h_option(2),'String',['�ڶ�������ͼ����ȷ������' char(10) ...
         '�ɵ�һ���ļ�����֪��' char(10) ...
         '������һ�����Ƶ��Ϊ ' num2str(Omega_norm) char(10) ...
         '�����������С˥��Ϊ ' num2str(Ar) 'dB' char(10) ...
         '����������������ͨ�������Ϸ���ͼ�������˲���������' char(10) ...
         '���¡���λ����ť���ɿ�����̬��ʾ��'])
   % ��Ƶ��������
   li_model=get(h_fmenus(1),'Value');
   ls_label=get(h_fmenus(1),'String');
   if li_model==1,
      [l_omega,l_array]=uf_lp_curve('butter');
   elseif li_model==2,
      [l_omega,l_array]=uf_lp_curve('cheby1',abs(Alp));  % Alp ͨ�����
   elseif li_model==3,
      [l_omega,l_array]=uf_lp_curve('cheby2',abs(Ar));   % Ar  ������
   end
   % ��������
   axes(h_option(1));
   h_curve=semilogx(l_omega,l_array);
   set(h_curve,'LineWidth',0.5);
   set(h_option(1),'UserData',h_curve);
   xlabel('��һ��Ƶ��','Fontsize',8);
   ylabel('��ֵ��dB��','Fontsize',8);
   title(['1��' int2str(size(l_array,1)) '��' deblankall(ls_label(li_model,:)) '��ͨԭ���˲�����Ƶ����' ])
   set(h_option(3),'UserData',[min(l_omega);max(l_omega);-100;0;1;Alp]);
   uf_display(1);
elseif li_step==3,
   set(h_button(3),'Enable','on','String','��һ��');
   set(h_frame(4),'Visible','on');
   set(h_option,'Visible','on');
   set(h_option([1 6 7]),'Visible','off');
   set(h_option(4),'Value',1,'Style','radio','String','ϵͳ����');
   set(h_option(5),'Value',0,'Style','radio','String','Ԫ��ֵ');
   paraData=get(h_option(6),'UserData');
   order=paraData(8);
   % ˵������
   set(h_option(2),'String',['����������һ����ĸ����ʽ��Ԫ��ֵ��' char(10) ...
         '�ɵڶ����ķ�Ƶ�������߲�ã�' char(10) ...
         '�����˲�����С����Ϊ ' num2str(order) '��' char(10) ...
         '���Ӧ�Ĺ�һ����ͨԭ���˲����ķ�ĸ����ʽϵ���͵�·Ԫ��ֵ���ϱ���ʾ��'])
   % 
   set(ah_figNumber,'CurrentObject',h_option(4));
   uf_display(1);
elseif li_step==4,
   set(gcf,'Pointer','watch')
   set(h_button(3),'Enable','off');
   set(h_frame(4),'Visible','on');
   set(h_option,'Visible','on');
   set(h_option([4 5 6 8 9]),'Visible','off');
   set(h_option(4),'Value',1,'Style','check','String','ͨ��');
   set(h_option(5),'Value',1,'Style','check','String','���');
   paraData=get(h_option(6),'UserData');
   paraData(1:4)=zeros(4,1);
   order=paraData(8);
   set(h_option(6),'UserData',paraData);
   li_type=get(h_fmenus(1),'Value');
   ls_type=get(h_fmenus(1),'String');
   li_pass=get(h_fmenus(2),'Value');
   ls_pass=get(h_fmenus(2),'String');
   PassBandStr=['lp';'hp';'bp';'bs'];
   % ��Ƶ�������ݡ�˵������
   [Fsystrans,l_omega,l_array,Textinfo]=uf_rfltsys(PassBandStr(li_pass,:));
   % ��������
   axes(h_option(1));
   semilogx(l_omega,l_array)
   xlabel('Ƶ�ʣ�Hz��','Fontsize',8);
   ylabel('��ֵ��dB��','Fontsize',8);
   title([int2str(order) '��' deblankall(ls_type(li_type,:)) ...
         deblankall(ls_pass(li_pass,:)) '�ķ�Ƶ����' ]);
   set(h_option(2),'String',Textinfo);
   set(h_option(3),'UserData',[min(l_omega);max(l_omega);min(l_array);5;0;0])
   uf_display(1);
   li_step = -1;
   set(gcf,'Pointer','arrow');
   set(h_button(3),'String','�ᡡ��','Enable','on');
elseif li_step==5,
   
end;

h_frame(5)=li_step;
set(ah_figNumber,'UserData',h_frame);

if nargout > 0, ii_rtn=1; end