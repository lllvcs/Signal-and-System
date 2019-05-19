function s1 = deblankall(s)
%DEBLANKALL Remove heading and trailing blanks in the string.
%   DEBLANKALL(S) removes blanks from string S.
%
%   DEBLANKALL(C), when C is a cell array of strings, removes the 
%   blanks from each element of C.
%
%   DEBLANK was modified by axz

if ~isempty(s) & ~isstr(s)
    warning('Input must be a string.')
end

if isempty(s)
    s1 = s([]);
else
  % remove heading and trailing blanks
  [r,c] = find(s ~= ' ' & s ~= 0 & s ~= '¡¡');
  if isempty(c)
    s1 = s([]);
  else
    s1 = s(:,min(c):max(c));
  end
end
