function uf_setpara(ah_pop);
% UF_SETPARA 设置滤波器（低通/高通/带通/带阻）的输入参数
%            用于“查表法设计模拟滤波器”
%            输入参数：
%             ah_pop - 弹出式菜单对象句柄（anflttbl1.m）

if nargin<1, ah_pop=gco; end

li_value=get(ah_pop,'Value');
lh_paras=get(ah_pop,'UserData');

switch li_value,
case 1,     % 低通
   ls_paratxt=['通带截止频率';'通带最大衰减';'阻带截止频率';'阻带最小衰减';'　基准电阻值'];
   ls_paraval=['1000';'   3';'1500';'  20';' 100'];
   ls_paraunt=['Hz';'dB';'Hz';'dB';'Ω '];
case 2,     % 高通
   ls_paratxt=['通带截止频率';'通带最大衰减';'阻带截止频率';'阻带最小衰减';'　基准电阻值'];
   ls_paraval=['1000';'   3';' 500';'  20';' 100'];
   ls_paraunt=['Hz';'dB';'Hz';'dB';'Ω '];
case 3,     % 带通
   ls_paratxt=['通带中心频率';'　　通带带宽';'通带最大衰减';'阻带最小偏移';'阻带最小衰减';'　基准电阻值'];
   ls_paraval=['1000';' 200';'   3';' 200';'  20';' 100'];
   ls_paraunt=['Hz';'Hz';'dB';'Hz';'dB';'Ω '];
case 4,     % 带阻
   ls_paratxt=['阻带中心频率';'　　阻带带宽';'通带最大衰减';'规定阻带偏移';'对应阻带衰减';'　基准电阻值'];
   ls_paraval=['1000';' 200';'   3';'  50';'  20';' 100'];
   ls_paraunt=['Hz';'Hz';'dB';'Hz';'dB';'Ω '];
otherwise,
   disp('无此菜单项')
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
