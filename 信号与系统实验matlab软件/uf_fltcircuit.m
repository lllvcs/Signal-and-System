function fig = uf_fltcircuit(findex);
% UF_FLTCIRCUIT 绘出归一化低通原型滤波器的电路图，以
%               及相对于其它型滤波器的元件转换关系。

if nargin < 1, findex = 1; end;

figName='滤波器电路设计之一';

figHandle = findobj('Type','figure','Name',figName);

if isempty(figHandle),
   load uf_fltcircuit;
      
   rootUnits=get(0,'Units');
   set(0,'Units','pixels');
   rootScreen=get(0,'ScreenSize');
   l_left=floor((rootScreen(3)-406)/2);
   l_bttm=floor((rootScreen(4)-480)/2);
   
% 主窗口
figHandle = figure('Color',[0.8 0.8 0.8], ...
   'Colormap',mat0, ...
   'MenuBar','none', ...
   'Name',figName, ...
   'NumberTitle','off', ...
   'Units','pixels', ...
   'Position',[l_left l_bttm 406 475], ...
   'RendererMode','manual', ...
   'Resize','off', ...
   'Tag','Analog_Filter_Circuit');

   set(0,'Units',rootUnits);

% 第一坐标轴：画出电路图
axisHandle(1) = axes('Parent',figHandle, ...
   'Units','pixels', ...
   'CameraUpVector',[0 1 0], ...
   'Color',[1 1 1], ...
   'ColorOrder',mat1, ...
   'Position',[2 169 402 304], ...
   'Tag','Axes1', ...
   'UserData',[60 34 60 159 280 85]);

% 第二坐标轴：画出电路元件转换关系
axisHandle(2) = axes('Parent',figHandle, ...
	'Units','pixels', ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'ColorOrder',mat4, ...
	'Position',[2 2 402 165], ...
	'Tag','Axes2');

set(figHandle,'UserData',axisHandle);

%% custom pointor
%[cpnt,map] = imread('images/pointor.bmp','bmp'); % boolean 型矩阵
%colNum = length(cpnt);
%cpointor = ones(colNum,colNum); % numeric 型矩阵
%cpointor(find(~cpnt)) = 0;
%for n = 1 : colNum,
%   lv_tmp = cpointor(:,n);
%   l0 = find(lv_tmp==0);
%   if ~isempty(l0),
%      l0min = min(l0);
%      l0max = max(l0);
%      if l0min > 1,
%         lv_tmp([1:l0min-1]) = NaN;
%      end;
%      if l0max < colNum,
%         lv_tmp([l0max+1:colNum]) = NaN;
%      end;
%   end;
%   cpointor(:,n) = lv_tmp;
%end;
%cpointor(find(cpointor==1)) = 2;
%cpointor(find(cpointor==0)) = 1;
%% custom pointor
load uf_fltpointor; % cpointor
set(figHandle, ...
   'WindowButtonDownFcn','uf_fltcct2', ...
   'WindowButtonMotionFcn','uf_fltcct1', ...
   'PointerShapeCData',cpointor);

end;

figure(figHandle);

axisHandle=get(figHandle,'UserData');

load uf_fltfig;

axes(axisHandle(1));
image(lf_flt);
colormap(map);
set(axisHandle(1),'Visible','off', ...
   'UserData',[60 34 60 159 280 85]);
text('Units','data', ...
   'Position',[201 295], ...
   'String','选择点击Π型或Ｔ型电路图可得相应滤波器的实际电路', ...
   'FontName','楷体_GB2312', ...
   'FontSize',8, ...
   'Color',[0 0 1], ...
   'HorizontalAlignment','center', ...
   'VerticalAlignment','middle');

axes(axisHandle(2));
switch findex,
case 1,
   image(lf_lp2lp);
case 2,
   image(lf_lp2hp);
case 3,
   image(lf_lp2bp);
case 4,
   image(lf_lp2bs);
end;
colormap(map);
set(axisHandle(2),'Visible','off');

set(figHandle,'UserData',axisHandle);

clear lf_flt lf_lp2lp lf_lp2hp lf_lp2bp lf_lp2bs map;

if nargout > 0, fig = figHandle; end
