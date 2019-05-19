function [cmp, Rl] = uf_chebycmp(Ap,order,Rl);

if nargin < 3, Rl = 1; end;

epsilon = sqrt(10^(.1*Ap)-1);

cmp = zeros(1,order);

if mod(order,2),
   a = 4*Rl/((Rl+1)^2);
   mm = (order-1)/2;
else,
   %a = 4*Rl/((Rl+1)^2);
   a = 4*Rl*(1+epsilon^2)/((Rl+1)^2);
   if a > 1,
      a = 1;
      Rl = (4*(0.5+epsilon^2)-sqrt((4*(0.5+epsilon^2))^2-4))/2;
   end;
   mm = order/2;
end;

n = 1:order*2;

alpha = 2*sin(n.*pi./(2*order));
beta  = 2*cos(n.*pi./(2*order));
gamma = (1/epsilon+sqrt(1/epsilon^2+1))^(1/order);
delta = (sqrt((1-a)/epsilon^2)+sqrt((1-a)/epsilon^2+1))^(1/order);

x = gamma - 1/gamma;
y = delta - 1/delta;

cmp(1) = 2*alpha(1)/(x-y);

for m = 1:mm,
   b = x^2 - beta(2*(2*m-1))*x*y + y^2 + alpha(2*(2*m-1))^2;
   cmp(2*m) = 4*alpha(4*m-3)*alpha(4*m-1)/(cmp(2*m-1)*b);
   if 2*m+1 <= order,
      b = x^2 - beta(2*(2*m))*x*y + y^2 + alpha(2*(2*m))^2;
      cmp(2*m+1) = 4*alpha(4*m-1)*alpha(4*m+1)/(cmp(2*m)*b);
   end;
end;
   