function fig = anflttbl()
% This is the machine-generated representation of a Handle Graphics object
% and its children.  Note that handle values may change when these objects
% are re-created. This may cause problems with any callbacks written to
% depend on the value of the handle at the time the object was saved.
% This problem is solved by saving the output as a FIG-file.
%
% To reopen this object, just type the name of the M-file at the MATLAB
% prompt. The M-file and its associated MAT-file must be on your path.
% 
% NOTE: certain newer features in MATLAB may not have been saved in this
% M-file due to limitations of this format, which has been superseded by
% FIG-files.  Figures which have been annotated using the plot editor tools
% are incompatible with the M-file/MAT-file format, and should be saved as
% FIG-files.

load anflttbl

h0 = figure('Units','normalized', ...
	'Color',[0.8 0.8 0.8], ...
	'Colormap',mat0, ...
	'FileName','D:\user\axz\xhsy\filter\anflttbl.m', ...
	'MenuBar','none', ...
	'Name','查表法设计模拟滤波器', ...
	'NumberTitle','off', ...
	'PaperPosition',[18 180 576.0000000000001 432.0000000000002], ...
	'PaperUnits','points', ...
	'Position',[0.150390625 0.140625 0.69921875 0.69921875], ...
	'Resize','off', ...
	'Tag','Fig1', ...
	'ToolBar','none', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[0.0195530726256983 0.810408921933085 0.35195530726257 0.157992565055762], ...
	'Style','frame', ...
	'Tag','FrameModel', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.913725490196078 0.913725490196078 0.913725490196078], ...
	'ListboxTop',0, ...
	'Position',[0.015 0.12 0.97 0.006], ...
	'Style','frame', ...
	'Tag','FrameLine', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'ListboxTop',0, ...
	'Position',mat1, ...
	'String','帮　助', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'ListboxTop',0, ...
	'Position',[0.27094972067039 0.0371747211895911 0.124301675977654 0.0613382899628253], ...
	'String','上一步', ...
	'Tag','Pushbutton2');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'ListboxTop',0, ...
	'Position',[0.41340782122905 0.0371747211895911 0.124301675977654 0.0613382899628253], ...
	'String','开　始', ...
	'Tag','Pushbutton3');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'ListboxTop',0, ...
	'Position',[0.8100000000000001 0.0371747211895911 0.124301675977654 0.0613382899628253], ...
	'String','退　出', ...
	'Tag','Pushbutton4');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'ForegroundColor',[0 0 0.501960784313725], ...
	'ListboxTop',0, ...
	'Position',[0.032122905027933 0.947955390334572 0.185754189944134 0.0371747211895911], ...
	'String','滤波器设计目标', ...
	'Style','text', ...
	'Tag','StaticText0');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'HorizontalAlignment','right', ...
	'ListboxTop',0, ...
	'Position',mat2, ...
	'String','通带形式', ...
	'Style','text', ...
	'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'HorizontalAlignment','right', ...
	'ListboxTop',0, ...
	'Position',mat3, ...
	'String','设计模型', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'ListboxTop',0, ...
	'Position',[0.1564245810055866 0.8438661710037174 0.1857541899441341 0.03717472118959107], ...
	'String',['低通滤波器';'高通滤波器';'带通滤波器';'带阻滤波器'], ...
	'Style','popupmenu', ...
	'Tag','BandMenu', ...
	'Value',1);
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'ListboxTop',0, ...
	'Position',[0.156424581005587 0.905204460966543 0.185754189944134 0.0371747211895911], ...
	'String',['巴特沃斯  ';'切比雪夫Ⅰ型';'切比雪夫Ⅱ型'], ...
	'Style','popupmenu', ...
	'Tag','ModelMenu', ...
	'Value',1);
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[0.0195530726256983 0.455390334572491 0.35195530726257 0.323420074349442], ...
	'Style','frame', ...
	'Tag','FramePara');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'ForegroundColor',[0 0 0.501960784313725], ...
	'ListboxTop',0, ...
	'Position',[0.032122905027933 0.756505576208178 0.136871508379888 0.0371747211895911], ...
	'String','滤波器参数', ...
	'Style','text', ...
	'Tag','StaticText3');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'HorizontalAlignment','right', ...
	'ListboxTop',0, ...
	'Position',[0.026536312849162 0.717472118959108 0.156424581005587 0.0371747211895911], ...
	'String','123', ...
	'Style','text', ...
	'Tag','ParaText1', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'HorizontalAlignment','right', ...
	'ListboxTop',0, ...
	'Position',[0.026536312849162 0.669144981412639 0.156424581005587 0.0371747211895911], ...
	'String','123', ...
	'Style','text', ...
	'Tag','ParaText2', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'HorizontalAlignment','right', ...
	'ListboxTop',0, ...
	'Position',[0.026536312849162 0.620817843866171 0.156424581005587 0.0371747211895911], ...
	'String','123', ...
	'Style','text', ...
	'Tag','ParaText3', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'HorizontalAlignment','right', ...
	'ListboxTop',0, ...
	'Position',[0.026536312849162 0.574349442379182 0.156424581005587 0.0371747211895911], ...
	'String','123', ...
	'Style','text', ...
	'Tag','ParaText4', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'HorizontalAlignment','right', ...
	'ListboxTop',0, ...
	'Position',[0.026536312849162 0.526022304832714 0.156424581005587 0.0371747211895911], ...
	'String','123', ...
	'Style','text', ...
	'Tag','ParaText5', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'HorizontalAlignment','right', ...
	'ListboxTop',0, ...
	'Position',[0.1857541899441341 0.7174721189591078 0.1075418994413408 0.04275092936802974], ...
	'String','1000', ...
	'Style','edit', ...
	'Tag','ParaVal1', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'HorizontalAlignment','right', ...
	'ListboxTop',0, ...
	'Position',[0.185754189944134 0.669144981412639 0.107541899441341 0.0427509293680297], ...
	'String','3', ...
	'Style','edit', ...
	'Tag','ParaVal2', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'HorizontalAlignment','right', ...
	'ListboxTop',0, ...
	'Position',[0.1857541899441341 0.6189591078066914 0.1075418994413408 0.04275092936802974], ...
	'String','1500', ...
	'Style','edit', ...
	'Tag','ParaVal3', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'HorizontalAlignment','right', ...
	'ListboxTop',0, ...
	'Position',[0.185754189944134 0.5706319702602231 0.107541899441341 0.0427509293680297], ...
	'String','20', ...
	'Style','edit', ...
	'Tag','ParaVal4', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'HorizontalAlignment','right', ...
	'ListboxTop',0, ...
	'Position',[0.185754189944134 0.5223048327137551 0.107541899441341 0.0427509293680297], ...
	'String','0', ...
	'Style','edit', ...
	'Tag','ParaVal5', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.298882681564246 0.717472118959108 0.0642458100558659 0.0371747211895911], ...
	'String','123', ...
	'Style','text', ...
	'Tag','ParaUnit1', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.298882681564246 0.669144981412639 0.0642458100558659 0.0371747211895911], ...
	'String','123', ...
	'Style','text', ...
	'Tag','ParaUnit2', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.298882681564246 0.6189591078066909 0.0642458100558659 0.0371747211895911], ...
	'String','123', ...
	'Style','text', ...
	'Tag','ParaUnit3', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.298882681564246 0.5706319702602231 0.0642458100558659 0.0371747211895911], ...
	'String','123', ...
	'Style','text', ...
	'Tag','ParaUnit4', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.298882681564246 0.524163568773234 0.0642458100558659 0.0371747211895911], ...
	'String','123', ...
	'Style','text', ...
	'Tag','ParaUnit5', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'HorizontalAlignment','right', ...
	'ListboxTop',0, ...
	'Position',[0.185754189944134 0.473977695167287 0.107541899441341 0.0427509293680297], ...
	'String','100', ...
	'Style','edit', ...
	'Tag','ParaVal6');
h1 = axes('Parent',h0, ...
	'Box','on', ...
	'CameraUpVector',[0 1 0], ...
	'CameraUpVectorMode','manual', ...
	'Color',[1 1 1], ...
	'ColorOrder',mat4, ...
	'FontSize',9, ...
	'Position',[0.451117318435754 0.516728624535316 0.527932960893855 0.4182156133829], ...
	'Tag','Axes1', ...
	'XColor',[0 0 0], ...
	'XGrid','on', ...
	'YColor',[0 0 0], ...
	'YGrid','on', ...
	'ZColor',[0 0 0]);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'FontSize',9, ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[0.4986737400530503 -0.1205357142857142 9.160254037844386], ...
	'String','（ｘ标题）', ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'FontSize',9, ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[-0.08753315649867366 0.4955357142857143 9.160254037844386], ...
	'Rotation',90, ...
	'String','（ｙ标题）', ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Position',[-0.8594164456233421 1.151785714285714 9.160254037844386], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'FontSize',9, ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[0.4986737400530503 1.03125 9.160254037844386], ...
	'String','图标题', ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[1 1 1], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Max',100, ...
	'Position',[0.0195530726256983 0.154275092936803 0.7639664804469271 0.280669144981413], ...
	'String',['1';'2';'3';'4';'5';'6';'7';'8';'9'], ...
	'Style','edit', ...
	'Tag','InfoText');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'HorizontalAlignment','right', ...
	'ListboxTop',0, ...
	'Position',[0.0279329608938548 0.475836431226766 0.156424581005587 0.0371747211895911], ...
	'String','123', ...
	'Style','text', ...
	'Tag','ParaText6', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.298882681564246 0.475836431226766 0.0642458100558659 0.0371747211895911], ...
	'String','123', ...
	'Style','text', ...
	'Tag','ParaUnit6', ...
	'UserData','[ ]');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[0.8030726256983241 0.154275092936803 0.175977653631285 0.280669144981413], ...
	'Style','frame', ...
	'Tag','FrameOption');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'ListboxTop',0, ...
	'Position',[0.8086592178770951 0.3873370577281192 0.1201117318435754 0.037243947858473], ...
	'String','显示方式', ...
	'Style','text', ...
	'Tag','OptionText');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.840782122905028 0.335195530726257 0.111731843575419 0.037243947858473], ...
	'String','通带', ...
	'Style','checkbox', ...
	'Tag','Checkbox1');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'FontSize',9, ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[0.840782122905028 0.283054003724395 0.111731843575419 0.037243947858473], ...
	'String','阻带', ...
	'Style','checkbox', ...
	'Tag','Checkbox2');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'ListboxTop',0, ...
	'Position',[0.8198324022346371 0.17877094972067 0.0684357541899441 0.074487895716946], ...
	'String','定位', ...
	'Tag','Pushbutton5');
h1 = uicontrol('Parent',h0, ...
	'Units','normalized', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontName','宋体', ...
	'ListboxTop',0, ...
	'Position',[0.895 0.17877094972067 0.0684357541899441 0.074487895716946], ...
	'String','缩放', ...
	'Style','togglebutton', ...
	'Tag','Pushbutton6', ...
	'UserData','[ ]');
if nargout > 0, fig = h0; end
