function y=df2(x,m)

global i j signmark dis;

x=x(:);

temp=sqrt((x+1)./2);

if nargin==1, m=100; end
if isempty(i), i=0; end
if isempty(j), j=0; end
if isempty(signmark), signmark=1; end
if isempty(dis), dis=0; end

if (x+1)<0.05 & abs(dis-i)>m
	j=j+1;
	if j>=10000, j=0; end
	if round(j/2)*2==j
		signmark=-1;
		dis=i;
	else
		signmark=1;
		dis=i;
	end
end

if i<=1e+6, i=i+1; else, i=0; end

y=signmark.*temp;
