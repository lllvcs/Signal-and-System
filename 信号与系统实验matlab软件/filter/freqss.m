function [h,ww] = freqss(b,a,w)

if nargin == 2,
    w = 200;
end
if length(w) == 1,
    wlen = w;
    w_long = freqint(b,a,wlen);
    % need to interpolate long frequency vector:
    xi = linspace(1,length(w_long),wlen).';
    w = 10.^interp1(1:length(w_long),log10(w_long),xi,'linear');
end

s = j*w;
hh = polyval(b,s) ./ polyval(a,s);

if nargout == 0,
    mag = abs(hh);   phase = angle(hh)*180/pi;
    loglog(w./(2*pi),mag),set(gca,'xgrid','on','ygrid','on') 
    set(gca,'xlim',[w(1) w(length(w))]./(2*pi))
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
elseif nargout == 1,
    h = hh;
elseif nargout == 2,
    h = hh;
    ww = w;
end
% end freqss

function w=freqint(a,b,c,d,npts)
%FREQINT Auto-ranging algorithm for Bode frequency response
%   W=FREQINT(A,B,C,D,Npts)
%   W=FREQINT(NUM,DEN,Npts)

%   Andy Grace  7-6-90
%   Was Revision: 1.9,  Date: 1996/07/25 16:43:37

% Generate more points where graph is changing rapidly.
% Calculate points based on eigenvalues and transmission zeros. 

[na,ma] = size(a);

if (nargin==3)&(na==1),		% Transfer function form.
  npts=c;
  ep=roots(b);
  tz=roots(a);
else				% State space form
  if nargin==3, npts=c; [a,b,c,d] = tf2ss(a,b); end
  ep=[eig(a)];
  tz=tzero(a,b,c,d);
end

if isempty(ep), ep=-1000; end

% Note: this algorithm does not handle zeros greater than 1e5
ez=[ep(find(imag(ep)>=0));tz(find(abs(tz)<1e5&imag(tz)>=0))];

% Round first and last frequencies to nearest decade
integ = abs(ez)<1e-10; % Cater for systems with pure integrators
highfreq=round(log10(max(3*abs(real(ez)+integ)+1.5*imag(ez)))+0.5);
lowfreq=round(log10(0.1*min(abs(real(ez+integ))+2*imag(ez)))-0.5);

% Define a base range of frequencies
diffzp=length(ep)-length(tz);
w=logspace(lowfreq,highfreq,npts+diffzp+10*(sum(abs(imag(tz))<abs(real(tz)))>0));
ez=ez(find(imag(ez)>abs(real(ez))));

% Oscillatory poles and zeros
if ~isempty(ez)
  f=w;
  npts2=2+8/ceil((diffzp+eps)/10);
  [dum,ind]=sort(-abs(real(ez)));
  z=[];
  for i=ind'
    r1=max([0.8*imag(ez(i))-3*abs(real(ez(i))),10^lowfreq]);
    r2=1.2*imag(ez(i))+4*abs(real(ez(i)));
    z=z(find(z>r2|z<r1));
    indr=find(w<=r2&w>=r1);
    f=f(find(f>r2|f<r1));
    z=[z,logspace(log10(r1),log10(r2),sum(w<=r2&w>=r1)+npts2)];
  end
  w=sort([f,z]);
end
w = w(:);

% end freqint
