function [mapIndex,img,areaName,sectionName]=uf_entry(action);

action=lower(action);
if strcmp(action,'showmain'),
   mapIndex=1;
   img='.\images\fig_main.mat';
   areaName='';
   sectionName='';
elseif strcmp(action,'showsp'),
   mapIndex=2;
   img='.\images\fig_p1_sp.mat';
   areaName='sig_pro';
   sectionName='pinpu';
elseif strcmp(action,'showsm'),
   mapIndex=3;
   img='.\images\fig_p2_sm.mat';
   areaName='sig_smpl';
   sectionName='items';
elseif strcmp(action,'showxt'),
   mapIndex=4;
   img='.\images\fig_p3_xt.mat';
   areaName='sys_pro';
   sectionName='pytx';
elseif strcmp(action,'showss'),
   mapIndex=5;
   img='.\images\fig_p4_ss.mat';
   areaName='sim_sys';
   sectionName='items';
elseif strcmp(action,'showsf'),
   mapIndex=6;
   img='.\images\fig_p5_sf.mat';
   areaName='sig_flt';
   sectionName='items';
end;
