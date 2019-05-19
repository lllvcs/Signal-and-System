function den_array = uf_setbutden(order);

if nargin<1,
   order=10;
end;

den_array=zeros(order,order+1);
for n=1:order,
   [z,p,k] = buttap(n);          % Butterworth analog lowpass filter prototype.
   den_array(n,1:(n+1))=poly(p); % Convert roots to polynomial
end;

if nargout<1,
   save anflt_butter_den_tbl den_array;
end;
