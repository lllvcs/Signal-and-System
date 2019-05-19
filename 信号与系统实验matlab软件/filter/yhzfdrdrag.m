function yhzfdrdrag(whichline,upflag)
%yhzfdrdrag  Ripple line drag (mouse motion and up) function for Filter Design tool
%   Motion and up function for dragging 'ripple' line up and down
%      whichline == 1 --> passband 
%      whichline == 2 --> stopband
% A second argument present calls the buttonup callback:
%    yhzfdrdrag(whichline) --> motion
%    yhzfdrdrag(whichline,0) --> up
%
 
%   Copyright (c) 1988-97 by The MathWorks, Inc.
% $Revision: 1.4 $

    ud = get(gcf,'userdata');

    if nargin == 2
    % reset these callbacks immediately in case of interrupts
        set(gcf,'windowbuttonmotionfcn','sbswitch(''yhzfdmotion'',''1'')')
        set(gcf,'windowbuttonupfcn','')
    end
   
    spec = ud.specs;
    type = spec.FType;      % filter type: 1=lp,2=hp,3=bp,4=bs
    firmethod = spec.firmethod;  % filter design method 
    iirmethod1 = spec.iirmethod(1);
    iirmethod2 = spec.iirmethod(2);
    specline1 = ud.ht.specline1;             % line: ax1; passband specs
    specline2 = ud.ht.specline2;             % line: ax1; stopband specs
    pt = get(ud.ht.ax1,'currentpoint');   % in data units, top axes
    pt = pt(1,1:2);

    pt_y = pt(2);
    if ud.prefs.gridding   % snap to grid if enabled
        grids = ud.prefs.gridsize;
        ygridsize = grids(2);
    end

    if whichline == 1   % passband drag
        if ud.specs.ir(1)    % FIR case
            if pt_y > 6.02, pt_y = 6.02; end
            if pt_y >= 0
                dev = 10^(pt_y/20)-1;
            else
                dev = 1-10^(pt_y/20);
            end
            above = 20*log10(1+dev); below = 20*log10(1-dev);
            Rp = above - below;
            % Snap Rp to grid
            if ud.prefs.gridding
                Rp = round(Rp/ygridsize)*ygridsize; 
                dev = (10^(Rp/20)-1)/(10^(Rp/20)+1);
                above = 20*log10(1+dev); below = 20*log10(1-dev);
            end
        else   % IIR case
            if ud.prefs.gridding, pt_y = round(pt_y/ygridsize)*ygridsize;  end
            if pt_y > 0, pt_y = 0; end
            above = 0; below = pt_y;
        end
        %if type == 4   % band stop - special case with TWO pass bands
        %    set(specline1,'ydata',[above above NaN below below NaN ...
        %                           above above NaN below below])
        %else   % lowpass, highpass, bandpass - one passband only
            set(specline1,'ydata',[above above NaN below below])
        %end
        spec.Rp = above-below;

        if (above - below == 0) & nargin==2
            spec = ud.specs;  % restore old spec if Rp == 0
            yhzfiltdes('drawspeclines')
        end

    else   % whichline == 2, stopband drag
        if ud.prefs.gridding, pt_y = round(pt_y/ygridsize)*ygridsize;  end
        if pt_y > 0, pt_y = 0; end
        if type == 3   % band pass - special case with TWO stop bands
            set(specline2,'ydata',[pt_y pt_y NaN pt_y pt_y])
        else   % lowpass, highpass, bandstop - one stopband only
            set(specline2,'ydata',[pt_y pt_y])
        end
        spec.Rs = -pt_y;
    end

    set(ud.ht.specHndl,'String',Localfdspecstr(spec))

    if nargin==2  % mouse up
        set(specline1,'erasemode','normal')
        set(specline2,'erasemode','normal')
        if ~isequal(spec,ud.specs)  % update only if changed
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

