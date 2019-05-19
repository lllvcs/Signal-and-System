function yhzfdmotion(toolnum)
%yhzfdmotion - Filter Designer motion function for changing pointer.
%   regular mouse motion in figure - update cursor
%     fig - the figure number of the tool
 
%   Copyright (c) 1988-97 by The MathWorks, Inc.
% $Revision: 1.7 $

    figname = prepender(['Filter Designer']);
    fig = findobj('name',figname);
    if isempty(fig)
      return
    end
    ud = get(fig,'userdata');

    switch ud.pointer
    case 0  % normal mode
        % change cursor when on top of specifications line
        % change cursor to arrow when not on top of specifications line
        pt = get(ud.ht.ax1,'currentpoint');   % in data units, top axes
        pt = pt(1,1:2);        
        
        switch yhzfdregion(fig,pt)
        case 0      % no region
            ptr = 'arrow';
        case 1      % over band end
            ptr = 'lrdrag';
        case 2      % over horizontal band
            ptr = 'uddrag';
        end
	    
    case 1  % zoom mode
	     pos = get(ud.ht.consoleframe,'position');
	     figpos = get(fig,'position');
	     pt = get(fig,'currentpoint');
	     if pt(1)>pos(3) & pt(2)<(figpos(4)-ud.sz.ih)
	         ptr = 'cross';
	     else
	         ptr = 'arrow';
	     end
    case 2  % help mode
	     ptr = 'help';
    case -1  % watch cursor
	     ptr = 'watch';
	 otherwise
	     ptr = 'arrow';
	 end
   
   setptr(fig,ptr)

