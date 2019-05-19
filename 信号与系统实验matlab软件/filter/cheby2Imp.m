function [num, den, z, p] = cheby2Imp(n, r, Wn, varargin)
%cheby2Imp Chebyshev type II digital and analog filter design.
%   [B,A] = cheby2Imp(N,R,Wn) designs an N'th order lowpass digital
%   Chebyshev filter with the stopband ripple R decibels down and
%   stopband edge frequency Wn.  cheby2Imp returns the filter 
%   coefficients in length N+1 vectors B and A.  The cut-off frequency 
%   Wn must be 0.0 < Wn < 1.0, with 1.0 corresponding to half the 
%   sample rate.  Use R = 20 as a starting point, if you are unsure 
%   about choosing R.
%
%   If Wn is a two-element vector, Wn = [W1 W2], cheby2Imp returns an 
%   order 2N bandpass filter with passband  W1 < W < W2.
%   [B,A] = cheby2Imp(N,R,Wn,'high') designs a highpass filter.
%   [B,A] = cheby2Imp(N,R,Wn,'stop') is a bandstop filter if Wn = [W1 W2].
%
%   When used with three left-hand arguments, as in
%   [Z,P,K] = cheby2Imp(...), the zeros and poles are returned in
%   length N column vectors Z and P, and the gain in scalar K. 
%
%   When used with four left-hand arguments, as in
%   [A,B,C,D] = cheby2Imp(...), state-space matrices are returned.
%
%   cheby2Imp(N,R,Wn,'s'), cheby2Imp(N,R,Wn,'high','s') and 
%   cheby2Imp(N,R,Wn,'stop','s') design analog Chebysev Type II filters.  
%   In this case, Wn can be bigger than 1.0.
%
%   See also CHEB2ORD, CHEBY1, BUTTER, ELLIP, FREQZ, FILTER.

%   Author(s): J.N. Little, 1-14-87
%   	   J.N. Little, 1-13-88, revised
%   	   L. Shure, 4-29-88, revised
%   	   T. Krauss, 3-25-93, revised
%   Copyright (c) 1988-97 by The MathWorks, Inc.
%   $Revision: 1.16 $  $Date: 1997/02/06 21:52:18 $

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

% step 3: Get N-th order Chebyshev type-II lowpass analog prototype
[z,p,k] = cheb2ap(n, r);

% Transform to state-space
[a,b,c,d] = zp2ss(z,p,k);

% step 4: Transform to lowpass, bandpass, highpass, or bandstop of desired Wn
if btype == 1		% Lowpass
	[a,b,c,d] = lp2lp(a,b,c,d,Wn);

elseif btype == 2	% Bandpass
	[a,b,c,d] = lp2bp(a,b,c,d,Wn,Bw);

elseif btype == 3	% Highpass
	[a,b,c,d] = lp2hp(a,b,c,d, Wn);

elseif btype == 4	% Bandstop
	[a,b,c,d] = lp2bs(a,b,c,d,Wn,Bw);
end

% step5: Use Bilinear transformation to find discrete equivalent:
if ~analog,
	[yhzB,yhzA] = ss2tf(a,b,c,d,1);
   [yhzB,yhzA] = impinvar(yhzB,yhzA,fs);
   [a,b,c,d]=tf2ss(yhzB,yhzA);
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
		num = z;
		den = p;
		z = k;
	else % nargout <= 2
		den = poly(a);
		num = poly(a-b*c)+(d-1)*den;
	end
end

