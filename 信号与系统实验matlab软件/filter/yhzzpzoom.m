function yhzzpzoom(action,varargin)
%yhzzpzoom  Filter Designer zoom function.
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

zpud = get(fig,'userdata');

if zpud.pointer==2   % help mode
    if strcmp(action,'mousezoom')
        state = btnstate(fig,'zoomgroup',7);
        if state
              btnup(fig,'zoomgroup',7)  % toggle button state back to
                                        % the way it was
        else
              btndown(fig,'zoomgroup',7) 
        end
    end
    yhzspthelp('exit','yhzzpzoom',action)
    return
end

switch action

case 'mousezoom'
    state = btnstate(fig,'zoomgroup','mousezoom');
    if state == 1   % button is currently down
        set(zpud.ht.respline,'buttondownfcn','')
        set(fig,'windowbuttondownfcn','yhzzpzoom(''mousedown'')')
        zpud.pointer = 1;  
        set(fig,'userdata',zpud)
        %set(fig,'pointer','cross');
        setptr(fig,'cross')
    else   % button is currently up - turn off zoom mode
        set(zpud.ht.respline,'buttondownfcn','yhzzpact(''mdown'',3)');
        set(fig,'windowbuttondownfcn','')
        zpud.pointer = 0;
        set(fig,'userdata',zpud)
        setptr(fig,'arrow')
    end

case 'zpzoomout'
    maxx=abs(max(abs(real([zpud.zeros;zpud.poles]))));
    maxx=max(ceil(maxx),maxx+0.5);
    maxy=abs(max(abs(imag([zpud.zeros;zpud.poles]))));
    maxy=max(ceil(maxy),maxy+0.5);
    set(zpud.ht.zpAxes,'xlim',[-maxx,maxx],'ylim',[-maxy,maxy]);
    %zpud.limits.ylim = get(zpud.ht.ax1,'ylim');
    %set(zpud.ht.ax1,'ylim',zpud.limits.ylim)
    %set(fig,'userdata',zpud)
    
case 'zoomout'
    set(zpud.ht.respAxes,'xlim',zpud.respxlim,'ylimmode','auto')
    zpud.respylim = get(zpud.ht.respAxes,'ylim');
    set(zpud.ht.respAxes,'ylim',zpud.respylim)
    set(fig,'userdata',zpud)

case 'zoominx'
    xlim = get(zpud.ht.zpAxes,'xlim');
    newxlim = 0.5*xlim;                         %.25*[3 1]*xlim' + [0 diff(xlim)/2];
    %if diff(newxlim) > zpud.specs.Fs / (4*zpud.prefs.nfft)
    set(zpud.ht.zpAxes,'xlim',newxlim)
    %end

case 'zoomoutx'
    xlim = get(zpud.ht.zpAxes,'xlim');
    xlim = 2*xlim;%.5*[3 -1]*xlim' + [0 diff(xlim)*2];
    %xlim = [max(xlim(1),zpud.limits.xlim(1)) min(xlim(2),zpud.limits.xlim(2))];
    set(zpud.ht.zpAxes,'xlim',xlim)

case 'zoominy'
    ylim = get(zpud.ht.zpAxes,'ylim');
    newylim = 0.5*ylim; .25*[3 1]*ylim' + [0 diff(ylim)/2];
   % if diff(newylim) > 0
    set(zpud.ht.zpAxes,'ylim',newylim)
   % end

case 'zoomouty'
    ylim = get(zpud.ht.zpAxes,'ylim');
    ylim = 2*ylim; %.5*[3 -1]*ylim' + [0 diff(ylim)*2];
   % ylim = [max(ylim(1),zpud.limits.ylim(1)) min(ylim(2),zpud.limits.ylim(2))];
    set(zpud.ht.zpAxes,'ylim',ylim)


%-------------- these are self callbacks:
case 'mousedown'
    zpud.justzoom = get(fig,'currentpoint'); 
    set(fig,'userdata',zpud)

    pstart = get(fig,'currentpoint');

    % don't do anything if click is outside mainaxes_port
    fp = get(fig,'position');   % in pixels already
    sz = zpud.sz;
    toolbar_ht = sz.ih;
    left_width = sz.rw;
    mp = [left_width 0 fp(3)-left_width fp(4)-toolbar_ht];

    %click is outside of main panel:
    if ~Localpinrect(pstart,[mp(1) mp(1)+mp(3) mp(2) mp(2)+mp(4)])
        %if ~zpud.prefs.tool.zoompersist
            % if click was on Mouse Zoom button, don't turn off button because
            % it will get turned off by its own callback  
            zg = findobj(fig,'type','axes','tag','zoomgroup');
            zgPos = get(zg,'position');
            if ~Localpinrect(pstart,[zgPos(1)+5*zgPos(3)/6 zgPos(1)+zgPos(3) ...
                                zgPos(2) zgPos(2)+zgPos(4)])
                btnup(fig,'zoomgroup','mousezoom');
                yhzzpzoom('mousezoom')
            end
        %end
        return
    end

    r=rbbox([pstart 0 0],pstart);

    if all(r([3 4])==0)
        % just a click - zoom about that point
        p1 = get(zpud.ht.respAxes,'currentpoint');

        xlim = get(zpud.ht.respAxes,'xlim');
        ylim = get(zpud.ht.respAxes,'ylim');

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
        p1 = get(zpud.ht.respAxes,'currentpoint');
        set(fig,'currentpoint',[r(1)+r(3) r(2)+r(4)])
        p2 = get(zpud.ht.respAxes,'currentpoint');
        
        xlim = [p1(1,1) p2(1,1)];
        ylim = [p1(1,2) p2(1,2)];
    end

    newxlim = xlim;%yhzinbounds(xlim,zpud.limits.xlim);
    newylim = ylim;%yhzinbounds(ylim,zpud.limits.ylim);
    %if diff(newxlim) > zpud.specs.Fs/(4*zpud.prefs.nfft)
       set(zpud.ht.respAxes,'xlim',newxlim)
    %end
    %if diff(newylim) > 0
       set(zpud.ht.respAxes,'ylim',newylim)
    %end
    %if ~zpud.prefs.tool.zoompersist
        setptr(fig,'arrow')
        set(fig,'windowbuttondownfcn','')
        btnup(fig,'zoomgroup','mousezoom');
        zpud.pointer = 0;  
        set(zpud.ht.respline,'buttondownfcn','yhzzpact(''mdown'',3)');
    %end
    set(fig,'currentpoint',zpud.justzoom)
    set(fig,'userdata',zpud)
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
    
%function windowBtnStr(fig)
%
%
%
% 
%zpud = get(fig,'UserData');
