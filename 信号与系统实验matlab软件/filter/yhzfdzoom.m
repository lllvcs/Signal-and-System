function yhzfdzoom(action,varargin)
%yhzfdzoom  Filter Designer zoom function.
%  Contains callbacks for Zoom button group of Filter Designer.
%    mousezoom
%    zoomout
%    zoominx
%    zoomoutx
%    zoominy
%    zoomouty
%    passband
%   Copyright (c) 1988-97 by The MathWorks, Inc.
%       $Revision: 1.8 $
 
if nargin < 2
    fig = gcf;
else
    fig = varargin{1};
end

ud = get(fig,'userdata');

if ud.pointer==2   % help mode
    if strcmp(action,'mousezoom')
        state = btnstate(fig,'zoomgroup',7);
        if state
              btnup(fig,'zoomgroup',7)  % toggle button state back to
                                        % the way it was
        else
              btndown(fig,'zoomgroup',7) 
        end
    end
    yhzspthelp('exit','yhzfdzoom',action)
    return
end

switch action

case 'mousezoom'
    state = btnstate(fig,'zoomgroup','mousezoom');
    if state == 1   % button is currently down
        set(ud.ht.magline,'buttondownfcn','')
        set(fig,'windowbuttondownfcn','sbswitch(''yhzfdzoom'',''mousedown'')')
        ud.pointer = 1;  
        set(fig,'userdata',ud)
        setptr(fig,'cross')
    else   % button is currently up - turn off zoom mode
        set(ud.ht.magline,'buttondownfcn','yhzfiltdes(''mdown'',3)');
        set(fig,'windowbuttondownfcn','')
        ud.pointer = 0;
        set(fig,'userdata',ud)
        setptr(fig,'arrow')
    end

case 'zoomout'
    set(ud.ht.ax1,'xlim',ud.limits.xlim,'ylimmode','auto')
    ud.limits.ylim = get(ud.ht.ax1,'ylim');
    set(ud.ht.ax1,'ylim',ud.limits.ylim)
    set(fig,'userdata',ud)
    
case 'zoominx'
    xlim = get(ud.ht.ax1,'xlim');
    newxlim = .25*[3 1]*xlim' + [0 diff(xlim)/2];
    if diff(newxlim) > ud.specs.Fs / (4*ud.prefs.nfft)
       set(ud.ht.ax1,'xlim',newxlim)
    end

case 'zoomoutx'
    xlim = get(ud.ht.ax1,'xlim');
    xlim = .5*[3 -1]*xlim' + [0 diff(xlim)*2];
    xlim = [max(xlim(1),ud.limits.xlim(1)) min(xlim(2),ud.limits.xlim(2))];
    set(ud.ht.ax1,'xlim',xlim)

case 'zoominy'
    ylim = get(ud.ht.ax1,'ylim');
    newylim = .25*[3 1]*ylim' + [0 diff(ylim)/2];
    if diff(newylim) > 0
       set(ud.ht.ax1,'ylim',newylim)
    end

case 'zoomouty'
    ylim = get(ud.ht.ax1,'ylim');
    ylim = .5*[3 -1]*ylim' + [0 diff(ylim)*2];
    ylim = [max(ylim(1),ud.limits.ylim(1)) min(ylim(2),ud.limits.ylim(2))];
    set(ud.ht.ax1,'ylim',ylim)

case 'passband'
    % set y-limits to be a close up on the passband
    %    140% of the specline1
    yd = get(ud.ht.specline1,'ydata');
    ylim = [yd(4) yd(1)];
    fudge = .2*(ylim(2)-ylim(1));
    ylim = [ylim(1)-fudge  ylim(2)+fudge];
    type = ud.specs.FType;    %   1 = lp, 2 = hp, 3 = bp, 4 = bs
    xd = get(ud.ht.specline1,'xdata');
    if type == 1
        xlim = [0 xd(2)*1.2];
    elseif type == 2
        xlim = [xd(1)-(xd(2)-xd(1))*.2  xd(2)];
    else %type == 3
        xlim = [xd(1)-(xd(2)-xd(1))*.2  xd(2)+(xd(2)-xd(1))*.2];
    %else  % type == 4
    %    Fs = get(ud.ht.FsHndl,'userdata');     % sampling frequency
    %    xlim = [0 Fs/2];
    end
    set(ud.ht.ax1,'ylim',ylim,'xlim',xlim)

%-------------- these are self callbacks:
case 'mousedown'
    ud.justzoom = get(fig,'currentpoint'); 
    set(fig,'userdata',ud)

    pstart = get(fig,'currentpoint');

    % don't do anything if click is outside mainaxes_port
    fp = get(fig,'position');   % in pixels already
    sz = ud.sz;
    toolbar_ht = sz.ih;
    left_width = sz.rw;
    mp = [left_width 0 fp(3)-left_width fp(4)-toolbar_ht];

    %click is outside of main panel:
    if ~Localpinrect(pstart,[mp(1) mp(1)+mp(3) mp(2) mp(2)+mp(4)])
        if ~ud.prefs.tool.zoompersist
            % if click was on Mouse Zoom button, don't turn off button because
            % it will get turned off by its own callback  
            zg = findobj(fig,'type','axes','tag','zoomgroup');
            zgPos = get(zg,'position');
            if ~Localpinrect(pstart,[zgPos(1)+5*zgPos(3)/6 zgPos(1)+zgPos(3) ...
                                zgPos(2) zgPos(2)+zgPos(4)])
                btnup(fig,'zoomgroup','mousezoom');
                yhzfdzoom('mousezoom')
            end
        end
        return
    end

    r=rbbox([pstart 0 0],pstart);

    if all(r([3 4])==0)
        % just a click - zoom about that point
        p1 = get(ud.ht.ax1,'currentpoint');

        xlim = get(ud.ht.ax1,'xlim');
        ylim = get(ud.ht.ax1,'ylim');

        switch get(fig,'selectiontype')
        case 'normal'     % zoom in
            xlim = p1(1,1) + [-.25 .25]*diff(xlim);
            ylim = p1(1,2) + [-.25 .25]*diff(ylim);
        otherwise    % zoom out
            xlim = p1(1,1) + [-1 1]*diff(xlim);
            ylim = p1(1,2) + [-1 1]*diff(ylim);
        end

    elseif any(r([3 4])==0)  
        % zero width or height - stay in zoom mode and 
        % try again
        return

    else 
        % zoom to the rectangle dragged
        set(fig,'currentpoint',[r(1) r(2)])
        p1 = get(ud.ht.ax1,'currentpoint');
        set(fig,'currentpoint',[r(1)+r(3) r(2)+r(4)])
        p2 = get(ud.ht.ax1,'currentpoint');
        
        xlim = [p1(1,1) p2(1,1)];
        ylim = [p1(1,2) p2(1,2)];
    end

    newxlim = yhzinbounds(xlim,ud.limits.xlim);
    newylim = yhzinbounds(ylim,ud.limits.ylim);
    if diff(newxlim) > ud.specs.Fs/(4*ud.prefs.nfft)
       set(ud.ht.ax1,'xlim',newxlim)
    end
    if diff(newylim) > 0
       set(ud.ht.ax1,'ylim',newylim)
    end
    if ~ud.prefs.tool.zoompersist
        setptr(fig,'arrow')
        set(fig,'windowbuttondownfcn','')
        btnup(fig,'zoomgroup','mousezoom');
        ud.pointer = 0;  
        set(ud.ht.magline,'buttondownfcn','yhzfiltdes(''mdown'',3)');
    end
    set(fig,'currentpoint',ud.justzoom)
    set(fig,'userdata',ud)
end
function bool = Localpinrect(pts,rect)
%PINRECT Determine if points lie in or on rectangle.
%   Inputs:
%     pts - n-by-2 array of [x,y] data
%     rect - 1-by-4 vector of [xlim ylim] for the rectangle
%   Outputs:
%     bool - length n binary vector 
 
%   Copyright (c) 1988-97 by The MathWorks, Inc.
% $Revision: 1.4 $

    [i,j] = find(isnan(pts));
    bool = (pts(:,1)<rect(1))|(pts(:,1)>rect(2))|...
           (pts(:,2)<rect(3))|(pts(:,2)>rect(4));
    bool = ~bool;
    bool(i) = 0;
