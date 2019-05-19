gwin=figure('Color',[0.3,0.8,0.4],...
	'Position',[0,0,800,800],...
	'Name','               信    号    与    系    统    试    验',...
	'Resize','off', ...
 	'NumberTitle','off', ...
	'MenuBar','none');
hfile=uimenu(gwin,'Label','文件[&f]');
hsample=uimenu(gwin,'Label','  抽样 [&s]');
hfreanal=uimenu(gwin,'Label','频谱分析 [&p]');
hlti=uimenu(gwin,'Label','连续LTI系统特性 [&c]');
hsimulink=uimenu(gwin,'Label','线性系统模拟 [&l]');
hhelp=uimenu(gwin,'Label','  帮助 [&h]');
uimenu(hfile,'Label','保存 [sa&ve]','Call','uiputfile');
uimenu(hfile,'Label','另存为 [&next s]','Call','uiputfile');
uimenu(hsample,'Label','实验说明 ');
uimenu(hfreanal,'Label','连续周期信号'，'Call','msin');
uimenu(hfreanal,'Label','连续非周期信号'，'Call','mstep');

uimenu(hlti, 'Label','LTI系统');
uimenu(hhelp,'Label','About..','Call','bang');
uimenu(hsimulink,'Label','模拟仿真'); 
hfilemore=uimenu (hfile, 'Label','More items');
uimenu(hfilemore,'Label','dig','Call','dig');

uimenu(hfile,'Label','&Quit','Call','close all');
hcsample=uimenu(hsample,'Label','连续时间抽样');
hdsample=uimenu(hsample,'Label','离散时间抽样');
hfsample=uimenu(hsample,'Label','频域抽样');
uimenu(hcsample,'Label','演示','call','chou');
uimenu(hcsample,'Label','实验开始','call','simulink');
uimenu(hdsample,'Label','演示','call','lchou');
uimenu(hdsample,'Label','实验开始','call','simulink');
uimenu(hfsample,'Label','演示','call','fchou');
uimenu(hfsample,'Label','实验开始','call','simulink');

dig