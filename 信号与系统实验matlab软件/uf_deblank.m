function s1 = uf_deblank(s)
% UF_DEBLANK Remove all blanks in the string.
%   UF_DEBLANK(S) removes blanks from string S.
%
%   UF_DEBLANK(C), when C is a cell array of strings, removes the 
%   blanks from each element of C.
%
%   DEBLANK was modified by axz

if ~isempty(s) & ~isstr(s)
    warning('Input must be a string.')
end

if isempty(s)
    s1 = s([]);
else
  % remove ALL blanks
  [r,c] = find ( s >= char(33) & s <= char(126) ) ;
  s1 = s(:,c);
end
