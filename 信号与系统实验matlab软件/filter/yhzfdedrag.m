function yhzfdedrag(whichline,upflag)
%yhzfdedrag Edge dragging (motion and up functions) for Filter Designer.
% filtdes('edrag',edge)
%   Motion and up function for dragging 'edge' of spec back and forth
%      edge == 1 --> f1
%      edge == 2 --> f2
%      edge == 3 --> f3
%      edge == 4 --> f4
% A second argument present calls the buttonup callback:
%    yhzfdedrag(edge) --> motion
%    yhzfdedrag(edge,0) --> up
%
 
%   Copyright (c) 1988-97 by The MathWorks, Inc.
% $Revision: 1.5 $
    ud = get(gcf,'userdata');

    if nargin == 2
    % reset these callbacks immediately in case of interrupts
        set(gcf,'windowbuttonmotionfcn','sbswitch(''yhzfdmotion'',''1'')')
        set(gcf,'windowbuttonupfcn','')
    end
   
    type = ud.specs.FType;   % filter type: 1=lp,2=hp,3=bp,4=bs
    Fs = ud.filt.Fs;     % sampling frequency
    firmethod = ud.specs.firmethod;
    iirmethod1 = ud.specs.iirmethod(1);
    iirmehtod2 = ud.specs.iirmethod(2);
    specline1 = ud.ht.specline1;             % line: ax1; passband specs
    specline2 = ud.ht.specline2;             % line: ax1; stopband specs
    pt = get(ud.ht.ax1,'currentpoint');   % in data units, top axes
    pt = pt(1,1:2);

    pt_x = pt(1);
    if ud.prefs.gridding   % snap to grid if enabled
        xgridsize = ud.prefs.gridsize(1);
        pt_x = round(pt_x/xgridsize)*xgridsize;
    end

    spec = ud.specs;
    if type<=2
       f=[min(spec.f);max(spec.f)];
    else
       f=[spec.f(2,1);spec.f(1,1);spec.f(1,2);spec.f(2,2)];
    end   
    %f = spec.f; 
    ff = [0; f(:); Fs/2];
    mx = ff(whichline+2);   % maximum value
    mn = ff(whichline);     % minimum value
    if pt_x>mx, pt_x = mx; end
    if pt_x<mn, pt_x = mn; end

    f(whichline) = pt_x;
    if (nargin == 2) & ( pt_x == mn | pt_x == mx)
    % if bands are touching, this isn't a legal spec
        spec = ud.specs;
    end

    set(ud.ht.specHndl,'String',Localfdspecstr(spec))

    if type == 1  % lowpass
        if whichline == 1
            set(specline1,'xdata',[0 f(1) NaN 0 f(1)])
        else
            set(specline2,'xdata',[f(2) Fs/2])
        end
    elseif type == 2  %highpass
        if whichline == 1
            set(specline2,'xdata',[0 f(1)])
        else
            set(specline1,'xdata',[f(2) Fs/2 NaN f(2) Fs/2])
        end
    else %type == 3  %bandpass
        if whichline == 1 | whichline == 4
            set(specline2,'xdata',[0 f(1) NaN f(4) Fs/2])
        elseif whichline == 2 | whichline == 3
            set(specline1,'xdata',[f(2) f(3) NaN f(2) f(3)])
        end
    %else  % type == 4, bandstop
    %    if whichline == 1 | whichline == 4
    %        set(specline1,'xdata',[0 spec.f(1) NaN 0 spec.f(1) NaN ...
    %                               spec.f(4) Fs/2 NaN spec.f(4) Fs/2 ])
    %    elseif whichline == 2 | whichline == 3
    %        set(specline2,'xdata',[spec.f(2) spec.f(3)])
    %    end
    end
    
    if nargin==2
        set(specline1,'erasemode','normal')
        set(specline2,'erasemode','normal')
        if ~isequal(ud.specs,spec)  % update only if changed
            ud.specs = spec;
            set(gcf,'userdata',ud)
            yhzfiltdes('specchange')
        end
     end
     
function str = Localfdspecstr(spec)
%Localfdspecstr  Returns string for multi-line editbox of Filter Design tool.
%       The edit box contains band edges and ripple
 
%   Copyright (c) 1988-97 by The MathWorks, Inc.
% $Revision: 1.3 $

%       Tom Krauss, 1/19/96
%       $Revision: 1.3 $

    if spec.FType <= 2
        str = sprintf('%4.3g\n%4.3g\n\n%4.3g\n%4.3g',spec.f(1),spec.f(2),...
          spec.Rp,spec.Rs);
    else
        str = sprintf('%4.3g%s%4.3g\n%4.3g%s%4.3g\n\n%4.3g\n%4.3g',spec.f(1,1),'   ',...
          spec.f(1,2),spec.f(2,1),'   ',spec.f(2,2),...
          spec.Rp,spec.Rs); 
        %str = sprintf('%g\n%g\n%g\n%g\n\n%g\n%g',spec.f(1),spec.f(2),...
        %  spec.f(3),spec.f(4),spec.Rp,spec.Rs);
     end

        
