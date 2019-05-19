function setmenu(menuHndl,labelList,callbackList,setSeparator);
% SETMENU Function for quickly setting up hierarchical menus.
%         Used by SNSMENU.

if nargin<4, setSeparator=0; end;

for count=1:size(labelList,1),
   if count==1 & setSeparator,
      uimenu(menuHndl, ...
         'Label',deblank(labelList(count,:)), ...
         'Callback',callbackList(count,:), ...
         'Separator','on');
   else,
      uimenu(menuHndl, ...
         'Label',deblank(labelList(count,:)), ...
         'Callback',callbackList(count,:));
   end;
end;

