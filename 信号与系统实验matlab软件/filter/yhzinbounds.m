function x = yhzinbounds(x,lim,logscale)
%yhzinbounds Returns value limited to interval.
%   yhzinbounds(x,lim), where x is a scalar and lim = [lower_bound
%              upper_bound], clips x to the interval lim.
%   yhzinbounds(interval,lim), where interval is an interval with
%          length less than or equal to lim, clips the interval
%          to lim, keeping its width constant.
%   yhzinbounds(interval,lim,1) clips the interval to lim, keeping the log of its 
%      width constant.

 
%   Copyright (c) 1988-97 by The MathWorks, Inc.
% $Revision: 1.6 $

if nargin < 3
    logscale = 0;
end

    if length(x)==1
        if x<lim(1)
            x = lim(1);
        elseif x>lim(2)
            x = lim(2);
        end
    else
        if x(1)<lim(1)
            if logscale 
                x = 10.^(log10(x) - log10(x(1)/lim(1)));
            else
                x = x - x(1) + lim(1);
            end
        elseif x(2)>lim(2)
            if logscale 
                x = 10.^(log10(x) - log10(x(2)/lim(2)));
            else
                x = x - x(2) + lim(2);
            end
        end
        if diff(x)>diff(lim)
            x = lim;
        end
    end
