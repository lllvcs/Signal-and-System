function region = yhzfdregion(fig,pt)
%yhzfdregion - which region the mouse pointer points to for filter design tool.
%       Inputs: 
%         fig - the figure number of the tool (uses gcf if not present).
%         pt - 2 element point vector [x y] in data units.
%       Outputs:  this function returns a scalar integer value.
%         Returns 0 for no region
%         Returns 1 for pointer over a band edge
%         Returns 2 for pointer over a band
 
%   Copyright (c) 1988-97 by The MathWorks, Inc.
% $Revision: 1.5 $

    if nargin == 0
        fig = gcf;
    end

    ud = get(fig,'userdata');

    if isempty(ud.specs)
        region = 0;
        return
    end
    
    xlim = get(ud.ht.ax1,'xlim');
    ylim = get(ud.ht.ax1,'ylim');
 
    % set to ARROW if outside axes limits
    if pt(1)<xlim(1)|pt(1)>xlim(2)|pt(2)<ylim(1)|pt(2)>ylim(2)
       region = 0;
       return
    end

    type = ud.specs.FType;   % 1 = lp, 2 = hp, 3 = bp, 4 = bs
    firmethod = ud.specs.firmethod;
    % filter design method 
    iirmethod1= ud.specs.iirmethod(1);
    iirmethod2 = ud.specs.iirmethod(2);
    Rp = ud.specs.Rp;
    Rs = ud.specs.Rs;

    set(ud.ht.ax1,'units','pixels');
    pos = get(ud.ht.ax1,'position');
    n = 6;
    w = n*diff(xlim)/pos(3);   % width:  n pixels in x-units
    h = n*diff(ylim)/pos(4);   % height: n pixels in y-units

    if ud.specs.ir(1)   % FIR
        dev = [ (10^(Rp/20)-1)/(10^(Rp/20)+1)  10^(-Rs/20) ];
        above = 20*log10(1+dev(1)); below = 20*log10(1-dev(1));
    else   % IIR
        above = 0; below = -Rp;   
    end
    
    %f1 = ud.specs.f(1);  f2 = ud.specs.f(2);
    f=ud.specs.f;
    if type<=2
       f1=min(f); 
       f2=max(f);
    else%   if type >= 3   % bandpass or stop
       f1=f(2,1);
       f2=f(1,1);
       f3=f(1,2);
       f4=f(2,2);
       %f3 = ud.specs.f(3);  f4 = ud.specs.f(4);
    end

    switch type
    case 1   % lp
        if (((pt(1)-f1)/w)^2 + ((pt(2)-above)/h)^2)<1
            region = 1;
        elseif (((pt(1)-f1)/w)^2 + ((pt(2)-below)/h)^2)<1
            region = 1;
        elseif (((pt(1)-f2)/w)^2 + ((pt(2)+Rs)/h)^2)<1
            region = 1;
        elseif (pt(1)<f1)&(abs(pt(2)-above)<h)
            region = 2;
        elseif (pt(1)<f1)&(abs(pt(2)-below)<h)
            region = 2;
        elseif (pt(1)>f2)&(abs(pt(2)+Rs)<h)
            region = 2;
        else
            region = 0;
        end
    case 2   % hp
        if (((pt(1)-f2)/w)^2 + ((pt(2)-above)/h)^2)<1
            region = 1;
        elseif (((pt(1)-f2)/w)^2 + ((pt(2)-below)/h)^2)<1
            region = 1;
        elseif (((pt(1)-f1)/w)^2 + ((pt(2)+Rs)/h)^2)<1
            region = 1;
        elseif (pt(1)>f2)&(abs(pt(2)-above)<h)
            region = 2;
        elseif (pt(1)>f2)&(abs(pt(2)-below)<h)
            region = 2;
        elseif (pt(1)<f1)&(abs(pt(2)+Rs)<h)
            region = 2;
        else
            region = 0;
        end
    case 3   % bp
        if (((pt(1)-f1)/w)^2 + ((pt(2)+Rs)/h)^2)<1
            region = 1;
        elseif (((pt(1)-f2)/w)^2 + ((pt(2)-above)/h)^2)<1
            region = 1;
        elseif (((pt(1)-f2)/w)^2 + ((pt(2)-below)/h)^2)<1
            region = 1;
        elseif (((pt(1)-f3)/w)^2 + ((pt(2)-above)/h)^2)<1
            region = 1;
        elseif (((pt(1)-f3)/w)^2 + ((pt(2)-below)/h)^2)<1
            region = 1;
        elseif (((pt(1)-f4)/w)^2 + ((pt(2)+Rs)/h)^2)<1
            region = 1;
        elseif (pt(1)<f1)&(abs(pt(2)+Rs)<h)
            region = 2;
        elseif (pt(1)>f2)&(pt(1)<f3)&(abs(pt(2)-above)<h)
            region = 2;
        elseif (pt(1)>f2)&(pt(1)<f3)&(abs(pt(2)-below)<h)
            region = 2;
        elseif (pt(1)>f4)&(abs(pt(2)+Rs)<h)
            region = 2;
        else
            region = 0;
        end
    %case 4  % bs
    %    if (((pt(1)-f2)/w)^2 + ((pt(2)+Rs)/h)^2)<1
    %        region = 1;
    %    elseif (((pt(1)-f3)/w)^2 + ((pt(2)+Rs)/h)^2)<1
    %        region = 1;
    %    elseif (((pt(1)-f1)/w)^2 + ((pt(2)-above)/h)^2)<1
    %        region = 1;
    %    elseif (((pt(1)-f1)/w)^2 + ((pt(2)-below)/h)^2)<1
    %        region = 1;
    %    elseif (((pt(1)-f4)/w)^2 + ((pt(2)-above)/h)^2)<1
    %        region = 1;
    %    elseif (((pt(1)-f4)/w)^2 + ((pt(2)-below)/h)^2)<1
    %        region = 1;
    %    elseif (pt(1)>f2)&(pt(1)<f3)&(abs(pt(2)+Rs)<h)
    %        region = 2;
    %    elseif (pt(1)<f1)&(abs(pt(2)-above)<h)
    %        region = 2;
    %    elseif (pt(1)<f1)&(abs(pt(2)-below)<h)
    %        region = 2;
    %    elseif (pt(1)>f4)&(abs(pt(2)-above)<h)
    %        region = 2;
    %    elseif (pt(1)>f4)&(abs(pt(2)-below)<h)
    %        region = 2;
    %    else
    %        region = 0;
    %    end
    end

