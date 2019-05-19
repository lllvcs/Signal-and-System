function yhzfvzoom(action,varargin)
%yhzfvzoom  Filter Viewer zoom function.
%  Contains callbacks for Zoom button group of Filter Viewer.
%    mousezoom
%    zoomout
%   Copyright (c) 1988-97 by The MathWorks, Inc.
%       $Revision: 1.12 $

if nargin < 3
    fig = gcf;
else
    fig = varargin{2};
end
ud = get(fig,'userdata');

if ud.pointer==2   % help mode
    if strcmp(action,'mousezoom')
        state = btnstate(fig,'zoomgroup',1);
        if state
              btnup(fig,'zoomgroup',1)  % toggle button state back to
                                        % the way it was
        else
              btndown(fig,'zoomgroup',1) 
        end
    end
    spthelp('exit','yhzfvzoom',action)
    return
end

switch action

case 'mousezoom'
    state = btnstate(fig,'zoomgroup','mousezoom');
    if state == 1   % button is currently down
        set(fig,'windowbuttondownfcn','sbswitch(''yhzfvzoom'',''mousedown'')')
        ud.pointer = 1;  
        setptr(fig,'cross');
        set(fig,'userdata',ud)
        %setptr(fig,'arrow')
    else   % button is currently up - turn off zoom mode
        set(fig,'windowbuttondownfcn','')
        ud.pointer = 0;
        set(fig,'userdata',ud)
        setptr(fig,'arrow')
    end

%--------
%  call will be either
%     yhzfvzoom('zoomout')   - "Full View" button callback - zooms out all axes
%     yhzfvzoom('zoomout',plots) - plots is a 6 element binary vector, containing
%                               a '1' in each location for which to zoom out
%           1 - magnitude
%           2 - phase
%           3 - group delay
%           4 - zeros & poles
%           5 - impulse response
%           6 - step response
%     yhzfvzoom('zoomout',plots,fig) - same as above except with input figure

case 'zoomout'
    if nargin > 1
        plots = varargin{1};
    else
        plots = ones(6,1);
    end
    if nargin > 2
        fig = varargin{2};
    end
    %Fs = evalin('base',ud.prefs.Fs,'1');
    Fs=1;
    if strcmp(ud.prefs.freqscale,'log')
        xlim1 = Fs/4096;
    else
        xlim1 = 0;
    end
    switch ud.prefs.freqrange
    case 1
       xlim = [xlim1 Fs/2];
    case 2
       xlim = [xlim1 Fs];
    case 3
       xlim = [-Fs/2 Fs/2];
    end
    for i=1:3
        if plots(i)
            set(ud.ht.a(i),'ylimmode','auto','xlim',xlim);
         end
         if plots(3)
            newylim=max(length(ud.filt.den),length(ud.filt.num));
            set(ud.ht.a(3),'ylim',[-newylim,newylim]);
         end
    end
    if plots(4)
        
        set(ud.ht.a(4),'ylimmode','auto','xlimmode','auto');
        apos = get(ud.ht.a(4),'Position');
        set(ud.ht.a(4),'DataAspectRatio',[1 1 1],...
            'PlotBoxAspectRatio',apos([3 4 4]))
        if ~isempty(ud.filt.zpk)
            xlim1 = min(real([ud.filt.zpk.z(:); ud.filt.zpk.p(:)]));
            xlim2 = max(real([ud.filt.zpk.z(:); ud.filt.zpk.p(:)]));
            ylim1 = min(imag([ud.filt.zpk.z(:); ud.filt.zpk.p(:)]));
            ylim2 = max(imag([ud.filt.zpk.z(:); ud.filt.zpk.p(:)]));
            if isempty(xlim1)
                xlim1 = -1.5;
            end
            if isempty(xlim2)
                xlim2 = 1.5;
            end
            if isempty(ylim1)
                ylim1 = -1.5;
            end
            if isempty(ylim2)
                ylim2 = 1.5;
            end
            if xlim1 == xlim2
                xlim1 = xlim1-1;
                xlim2 = xlim2+1;
            end
            if ylim1 == ylim2
                ylim1 = ylim1-1;
                ylim2 = ylim2+1;
            end
            set(get(ud.ht.a(4),'xlabel'),'userdata',[xlim1 xlim2 ylim1 ylim2]);
        else
            set(get(ud.ht.a(4),'xlabel'),'userdata',[-1 1 -1 1]);
        end
    end
    if ~isempty(ud.filt.t)
        xlim1 = [ud.filt.t(1)-1/Fs  ud.filt.t(end)+1/Fs];
    else
        xlim1 = [0 1/Fs];
    end
    for i=5:6
        if plots(i)
            set(ud.ht.a(i),'ylimmode','auto','xlim',xlim1);
        end
    end

%-------------- these are self callbacks:
case 'mousedown'

    ud.justzoom = get(fig,'currentpoint'); 
    set(fig,'userdata',ud)
    Fs = 1;

    pstart = get(fig,'currentpoint');

    % don't do anything if click is outside mainaxes_port
    fp = get(fig,'position');   % in pixels already
    sz = ud.sz;
    toolbar_ht = ud.resize.topheight;
    left_width = ud.resize.leftwidth;
    mp = [left_width 0 fp(3)-left_width fp(4)-toolbar_ht];

    %click is outside of main panel:
    if ~Localpinrect(pstart,[mp(1) mp(1)+mp(3) mp(2) mp(2)+mp(4)])
        %if ~ud.prefs.tool.zoompersist
         %   % if click was on Mouse Zoom button, don't turn off button because
         %   % it will get turned off by its own callback  
         %   zg = findobj(fig,'type','axes','tag','zoomgroup');
         %   zgPos = get(zg,'position');
         %   if ~Localpinrect(pstart,[zgPos(1) zgPos(1)+zgPos(3)/2 ...
         %                       zgPos(2) zgPos(2)+zgPos(4)])
         %       btnup(fig,'zoomgroup','mousezoom');
         %       yhzfvzoom('mousezoom')
         %   end
        %end
        return
    end

    r=rbbox([pstart 0 0],pstart);

    % Find out which axes was clicked in according to rules:
    % rule 1: click inside an axes - zoom in that axes
    % rule 2: current point is not in any axes - zoom in on axes most overlapping
    %         dragged rectangle
    open_axes = ud.ht.a(find(ud.prefs.plots));
    rects = [];
    target_axes = [];
    for i=1:length(open_axes)
        rects = [rects; get(open_axes(i),'position')];
        if Localpinrect(pstart,rects(i,[1 1 2 2])+[0 rects(i,3) 0 rects(i,4)])
            target_axes = open_axes(i);
        end
    end    
    if isempty(target_axes)
        overlap = rectint(r,rects);
        overlap = overlap(:)...
              ./ (rects(:,3).*rects(:,4));
            % what percentage of the area of the axis is 
            %  covered by the dragged out rectangle?
        [maxoverlap,k] = max(overlap);
        if maxoverlap > 0
            target_axes = open_axes(k);
        end
    end
    if isempty(target_axes)
        return   % stay in zoom mode and return
    end
    
    if all(r([3 4])==0)
        % just a click - zoom about that point
        p1 = get(target_axes,'currentpoint');

        xlim = get(target_axes,'xlim');
        ylim = get(target_axes,'ylim');

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
        p1 = get(target_axes,'currentpoint');
        set(fig,'currentpoint',[r(1)+r(3) r(2)+r(4)])
        p2 = get(target_axes,'currentpoint');
        
        xlim = [p1(1,1) p2(1,1)];
        ylim = [p1(1,2) p2(1,2)];
    end

    switch target_axes
    
    case {ud.ht.a(1), ud.ht.a(2), ud.ht.a(3)}
        xdiff = Fs / (4*4096); %ud.prefs.nfft);
    case ud.ht.a(4)
        xdiff = 0;
    case {ud.ht.a(5), ud.ht.a(6)}
        xdiff = .1/Fs;
    end

    if target_axes ~= ud.ht.a(4)
        if diff(xlim) > xdiff
           set(target_axes,'xlim',xlim)
        end
        if diff(ylim) > 0
           set(target_axes,'ylim',ylim)
        end
    else					% Pole-zero
        apos = get(target_axes,'Position');
        set(get(ud.ht.a(4),'xlabel'),'userdata',[xlim ylim]);
        [newxlim,newylim] = newlims(apos,xlim,ylim);
          set(target_axes,'xlim',newxlim,'ylim',newylim)
    end

    %if ~ud.prefs.tool.zoompersist
    %    setptr(fig,'arrow')
    %    set(fig,'windowbuttondownfcn','')
    %    btnup(fig,'zoomgroup','mousezoom');
    %    ud.pointer = 0;  
    %end
    set(fig,'userdata',ud)
    set(fig,'currentpoint',ud.justzoom)

end


%================================================================

function [newxlim,newylim] = newlims(apos,xlim,ylim);

dx = diff(xlim);
dy = diff(ylim);

if dx * apos(4)/apos(3) >= dy   % Snap to the requested x limits, expand y to fit
   newxlim = xlim;
   newylen = apos(4)/apos(3) * dx;
   newylim = mean(ylim) + [-newylen/2 newylen/2];
else
   newylim = ylim;
   newxlen = apos(3)/apos(4) * dy;
   newxlim = mean(xlim) + [-newxlen/2 newxlen/2];
end

if diff(newxlim) <= 0
   newxlim = xlim;
end
if diff(newylim) <= 0
   newylim = ylim;
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
    
    % WORK NEEDED TO BE DONE:
    %      ARRANGE THE POINTER ACCORDING TO THE DIFFERENT POSITION OF THE CURSUR