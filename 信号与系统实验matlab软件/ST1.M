   t=-10:10;
N1=20
       for i=1:N1+1
     %       f(0)=amp;
         if abs(i-N1/2-1)<=4
        % for t=-10:10
     %      if abs(t)<=N1 f=amp
      %      else 
         %      f=0.0
          %      j=i-N1;
         %   if abs(i-N1)<=freq/2
              f(i)=1;
          else
              f(i)=0;
   
      %   else 
       %     f(t)=0
           end
      end
   stem(t,f)