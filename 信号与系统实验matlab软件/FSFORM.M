function [a,b,ao]=fsform(c,d,co)
%FSFORM	Fourier Series Format Conversion.
%	KN=FSFORM(An,Bn,Ao) converts the trigonometric FS with
%	An being the COSINE and Bn being the SINE coefficients to
%	the complex exponential FS with coefficients Kn.
%	Ao is the DC component and An, Bn and Ao are assumed to be real.
%
%	[Kn,i]=FSFORM(An,Bn,Ao) returns the index vector i that
%	identifies the harmonic number of each element of Kn.
%
%	[An,Bn,Ao]=FSFORM(Kn) does the reverse format conversion.
nc=length(c);
if nargin==1			% complex -> trig form
	if rem(nc-1,2)|(nc==1)
		error('Number of elements in K must be odd and greater than 1.')
	end
	nn=(nc+3)/2;
	a=2*real(c(nn:nc));
	b=-2*imag(c(nn:nc));
	ao=real(c(nn-1));
elseif nargin==3		% trig -> complex exp form
	nd=length(d);
	if nc~=nd
		error('A and B must be the same length.')
	end
	a=0.5*(c-sqrt(-1)*d);
	a=[conj(a(nc:-1:1)) co(1) a];
	b=-nc:nc;
else
	error('Improper number of input arguments.')
end
