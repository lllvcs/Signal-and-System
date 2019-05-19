function s1 = deblank(s)
%DEBLANK Remove trailing blanks.
%   DEBLANK(S) removes trailing blanks from string S.
%
%   DEBLANK(C), when C is a cell array of strings, removes the trailing
%   blanks from each element of C.

%   L. Shure, 6-17-92.
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.15 $  $Date: 1998/04/02 18:01:45 $

% The cell array implementation is in @cell/deblank.m

if ~isempty(s) & ~isstr(s)
    warning('Input must be a string.')
end

if isempty(s)
    s1 = s([]);
else
  % remove trailing blanks
  [r,c] = find(s ~= ' ' & s ~= 0);
  if isempty(c)
    s1 = s([]);
  else
    s1 = s(:,1:max(c));
  end
end
