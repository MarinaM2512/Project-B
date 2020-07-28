function [start, len, k1] = PZeroOnesCount(v,p)
%
% Determine the position and length of each 1-string in v,
% where v is a vector of 1s and 0s
% Derek O'Connor 21 Sep 2011
%
 n = length(v);
 start = zeros(1,n);            % where each 1-string starts
 len = zeros(1,n);              % length of each 1-string
 k1= 0;                         % count of 1-strings
 cntZ = 1;
 inOnes = false;
 for k = 1:n
     if v(k) == 0             % not in 1-string
         cntZ = cntZ+1;
         if cntZ>=p
            inOnes = false; 
         end
     elseif ~inOnes             % start of new 1-string
         cntZ=0;
         inOnes = true;
         k1 = k1+1;
         start(k1) = k;
         len(k1) = 1;
     else                       % still in 1-string
         len(k1) = len(k1)+1;
     end
 end
 len =len(len~=0);
 start = start(len~=0);
end