function [omega,Array]=uf_lp_curve(ftype,Ap);

if nargin<2,
   Ap = 0;
end;

ftype=lower(ftype);

Slen=100;
Modr=10;

Array=zeros(Modr,Slen*3);
omega=[linspace(0.01,1,Slen) linspace(1.01,Modr,Slen*2)];

if strcmp(ftype(1:6),'butter'),     % 1 to Modr order Butterworth analog lowpass prototype
   for n=1:Modr,
      Array(n,:) = - 10 .* log10( 1 + omega.^(2*n) );
   end;
   

elseif strcmp(ftype(1:6),'cheby1'), % 1 to Modr order Chebyshev type I analog lowpass prototype
   epsilon = sqrt(10^(.1*Ap)-1);
   Tn=zeros(size(omega));
   n1=max(find(omega<=1));
   for n=1:Modr,
      Tn = [ cos(n.*acos(omega(1:n1))) cosh(n.*acosh(omega((n1+1):(Slen*3)))) ];
      Array(n,:) = - 10 .* log10( 1 + epsilon^2 .* Tn.^2 );
   end;
   
elseif strcmp(ftype(1:6),'cheby2'), % 1 to Modr order Chebyshev type II analog lowpass prototype
%  epsilon = sqrt(10^(.1*Ap)-1);
%   Tn=zeros(size(omega));
%   n1=max(find(omega<=1));
%   for n=1:Modr,
%      Tn = [ cos(n.*acos(omega(1:n1))) cosh(n.*acosh(omega((n1+1):Slen))) ];
%      Array(n,:) = - 10 .* log10( 1 + epsilon^2 .* Tn.^2 );
%   end;
   
end;

