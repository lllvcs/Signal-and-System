function [num, den, z, p] = cheby1Imp(n, r, Wn, varargin)
%cheby1Imp Chebyshev type I digital and analog filter design.
%   [B,A] = cheby1Imp(N,R,Wn) designs an N'th order lowpass digital
%   Chebyshev filter with R decibels of ripple in the passband.
%   cheby1Imp returns the filter coefficients in length N+1 vectors B
%   and A.  The cut-off frequency Wn must be 0.0 < Wn < 1.0, 
%   with 1.0 corresponding to half the sample rate.  Use R=0.5 as
%   a starting point, if you are unsure about choosing R.
%
%   If Wn is a two-element vector, Wn = [W1 W2], cheby1Imp returns an 
%   order 2N bandpass filter with passband  W1 < W < W2.
%   [B,A] = cheby1Imp(N,R,Wn,'high') designs a highpass filter.
%   [B,A] = cheby1Imp(N,R,Wn,'stop') is a bandstop filter if Wn = [W1 W2].
%
%   When used with three left-hand arguments, as in
%   [Z,P,K] = cheby1Imp(...), the zeros and poles are returned in
%   length N column vectors Z and P, and the gain in scalar K. 
%
%   When used with four left-hand arguments, as in
%   [A,B,C,D] = cheby1Imp(...), state-space matrices are returned. 
%
%   cheby1Imp(N,R,Wn,'s'), cheby1Imp(N,R,Wn,'high','s') and 
%   cheby1Imp(N,R,Wn,'stop','s') design analog Chebysev Type I filters.  
%   In this case, Wn can be bigger than 1.0.
%
%   See also CHEB1ORD, CHEBY2, BUTTER, ELLIP, FREQZ, FILTER.

%   Author(s): J.N. Little, 1-14-87
%   	   J.N. Little, 1-13-88, revised
%   	   L. Shure, 4-29-88, revised
%   	   T. Krauss, 3-25-93, revised
%   Copyright (c) 1988-97 by The MathWorks, Inc.
%   $Revision: 1.19 $  $Date: 1997/02/06 21:52:16 $

%   References:
%     [1] T. W. Parks and C. S. Burrus, Digital Filter Design,
%         John Wiley & Sons, 1987, chapter 7, section 7.3.3.

[btype,analog,errStr] = yhziirchk(Wn,varargin{:});
error(errStr)

if n>500
	error('Filter order too large.')
end

% step 1: get analog, pre-warped frequencies
if ~analog,
	fs = 2;
	u = 2*fs*tan(pi*Wn/fs);
else
	u = Wn;
end

Bw = [];
% step 2: convert to low-pass prototype estimate
if btype == 1	% lowpass
	Wn = u;
elseif btype == 2	% bandpass
	Bw = u(2) - u(1);
	Wn = sqrt(u(1)*u(2));	% center frequency
elseif btype == 3	% highpass
	Wn = u;
elseif btype == 4	% bandstop
	Bw = u(2) - u(1);
	Wn = sqrt(u(1)*u(2));	% center frequency
end

% step 3: Get N-th order Chebyshev type-I lowpass analog prototype
[z,p,k] = cheb1ap(n, r);

% Transform to state-space
[a,b,c,d] = zp2ss(z,p,k);

% step 4: Transform to lowpass, bandpass, highpass, or bandstop of desired Wn
if btype == 1		% Lowpass
	[a,b,c,d] = lp2lp(a,b,c,d,Wn);

elseif btype == 2	% Bandpass
	[a,b,c,d] = lp2bp(a,b,c,d,Wn,Bw);

elseif btype == 3	% Highpass
	[a,b,c,d] = lp2hp(a,b,c,d,Wn);

elseif btype == 4	% Bandstop
	[a,b,c,d] = lp2bs(a,b,c,d,Wn,Bw);
end

% step5: Use Bilinear transformation to find discrete equivalent:
if ~analog,
	[yhzB,yhzA] = ss2tf(a,b,c,d,1);
   [yhzB,yhzA] = impinvar(yhzB,yhzA,fs);
   [a,b,c,d] = tf2ss(yhzB,yhzA);
    %[a,b,c,d] = bilinear(a,b,c,d,fs);
end

if nargout == 4
	num = a;
	den = b;
	z = c;
	p = d;
else	% nargout <= 3
% Transform to zero-pole-gain and polynomial forms:
	if nargout == 3
		[z,p,k] = ss2zp(a,b,c,d,1);
		z = cheb1zeros(btype,n,Wn,Bw,analog);
		num = z;
		den = p;
		z = k;
	else % nargout <= 2
		den = poly(a);
		num = cheb1num(btype,n,Wn,Bw,analog,den,r);
		% num = poly(a-b*c)+(d-1)*den;
	end
end

%---------------------------------
function b = cheb1num(btype,n,Wn,Bw,analog,den,Rp)
% This internal function returns more exact numerator vectors
% for the num/den case.
% normalize so |H(w)| == 0 or -Rp decibels:
if ~rem(n,2)
    g = 10^(-Rp/20);
else
    g = 1;
end
if analog
    switch btype
    case 1  % lowpass
        b = [zeros(1,n) n^(-n)];
        b = real( g*b*polyval(den,-j*0)/polyval(b,-j*0) );
    case 2  % bandpass
        b = [zeros(1,n) Bw^n zeros(1,n)];
        b = real( g*b*polyval(den,-j*Wn)/polyval(b,-j*Wn) );
    case 3  % highpass
        b = [1 zeros(1,n)];
        b = real( g*b*den(1)/b(1) );
    case 4  % bandstop
        r = j*Wn*((-1).^(0:2*n-1)');
        b = poly(r);
        b = real( g*b*polyval(den,-j*0)/polyval(b,-j*0) );
    end
else
    Wn = 2*atan2(Wn,4);
    switch btype
    case 1  % lowpass
        r = -ones(n,1);
        w = 0;
    case 2  % bandpass
        r = [ones(n,1); -ones(n,1)];
        w = Wn;
    case 3  % highpass
        r = ones(n,1);
        w = pi;
    case 4  % bandstop
        r = exp(j*Wn*( (-1).^(0:2*n-1)' ));
        w = 0;
    end
    b = poly(r);
    kern = exp(-j*w*(0:length(b)-1));
    b = real(g*b*(kern*den(:))/(kern*b(:)));
end

function z = cheb1zeros(btype,n,Wn,Bw,analog)
% This internal function returns more exact zeros.
if analog
    switch btype
    case 1  % lowpass
        z = [zeros(1,n) n^(-n)]';
    case 2  % bandpass
        z = [zeros(1,n) Bw^n zeros(1,n)]';
    case 3  % highpass
        z = [1 zeros(1,n)]';
    case 4  % bandstop
        z = j*Wn*((-1).^(0:2*n-1)');
    end
else
    Wn = 2*atan2(Wn,4);
    switch btype
    case 1  % lowpass
        z = -ones(n,1);
    case 2  % bandpass
        z = [ones(n,1); -ones(n,1)];
    case 3  % highpass
        z = ones(n,1);
    case 4  % bandstop
        z = exp(j*Wn*( (-1).^(0:2*n-1)' ));
    end
end


