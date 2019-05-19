function a = freadu8(name,offset,numbytes)
%FREADU8 Read bytes from a file into a uint8 array.
%   A = FREADU8(FNAME, OFFSET, NUMBYTES) reads NUMBYTES from the
%   file FNAME starting at OFFSET.  A is returned as a uint8
%   column array.  Note that the length of A is the number of
%   bytes successfully read, which may be less than NUMBYTES.
%
%   OFFSET defaults to 0.  If NUMBYTES is not specified, FREADU8
%   reads from OFFSET to the end of the file.

%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 1.4 $  $Date: 1997/11/21 23:35:58 $

error('Missing MEX-file FREADU8');
