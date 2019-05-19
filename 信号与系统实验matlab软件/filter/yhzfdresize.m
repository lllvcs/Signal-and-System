function yhzfdresize(create_flag,fig)
%yhzfdresize Resize function for Filter Design Tool.
%   yhzfdresize will resize only those objects which need resizing.
%   yhzfdresize(1) will resize every object.  Use this syntax at creation
%   of the figure.
%
%   yhzfdresize(create_flag,fig) resizes the designer with figure handle fig.
%   Copyright (c) 1988-97 by The MathWorks, Inc.
%       $Revision: 1.9 $

    if nargin == 0
        create_flag = 0;
    end

    if nargin <= 1
        fig = gcbo;
    end
    
    ud = get(fig,'userdata');
    sz = ud.sz;

    fp = get(fig,'position');   % in pixels already

    toolbar_ht = sz.ih;
    left_width = sz.rw;  % arbitrary

    mainaxes_port = [left_width 0 fp(3)-left_width fp(4)-toolbar_ht];
    mainaxes_pos = mainaxes_port + ...
               [sz.as(1) sz.as(2) -(sz.as(1)+sz.as(3)) -(sz.as(2)+sz.as(4))];

    if mainaxes_pos(3)<ud.prefs.minsize(1)  ...
         | mainaxes_pos(4)<ud.prefs.minsize(2)
       % disp('figure too small - resizing')
       
       % minsize(1)   - minimum width of main axes in pixels
       % minsize(2)   - minimum height of main axes in pixels

       w = left_width+sz.as(1)+sz.as(3)+ud.prefs.minsize(1);
       w = max(w,fp(3));
       h = toolbar_ht+sz.as(2)+sz.as(4)+ud.prefs.minsize(2);
       h = max(h,fp(4));
       fp = [fp(1) fp(2)+fp(4)-h w h];
       set(fig,'position',fp)
       %return
    end
    % recompute with new fp:
    mainaxes_port = [left_width 0 fp(3)-left_width fp(4)-toolbar_ht];
    mainaxes_pos = mainaxes_port + ...
               [sz.as(1) sz.as(2) -(sz.as(1)+sz.as(3)) -(sz.as(2)+sz.as(4))];

    ht = ud.ht;
    % console position:
    cp = [0 0 left_width fp(4)-toolbar_ht];

    lw1 = sz.bw/4;  % width of f, Rs, Rp, and Fs labels
    lw2 = sz.bw/2;  % width of Auto: and Set: radio buttons
    
    recess=15;
    % 1-by-4 position vectors
    pos = {
    ht.ax1           mainaxes_pos
    ht.consoleframe  cp
    ht.FType         [cp(1)+sz.fus cp(2)+cp(4)-(sz.fus+sz.uh) cp(3)-2*sz.fus sz.uh]
    ht.labelHndl     [cp(1)+sz.fus cp(2)+cp(4)-4*(sz.fus+sz.uh) ...
                                               lw1 3*sz.uh+2*sz.fus]
    ht.specHndl      [cp(1)+2*sz.fus+lw1 cp(2)+cp(4)-4*(sz.fus+sz.uh) ...
                                 (cp(3)-3*sz.fus-lw1) 3*sz.uh+2*sz.fus]
    ht.labelHndl1    [cp(1)+sz.fus cp(2)+cp(4)-5*(sz.fus+sz.uh)...
                                               lw1 sz.uh]   
    ht.FsHndl        [cp(1)+2*sz.fus+lw1 cp(2)+cp(4)-5*(sz.fus+sz.uh)...
                              (cp(3)-3*sz.fus-lw1) sz.uh]
    ht.changeiir     [cp(1)+sz.fus cp(2)+cp(4)-6*(sz.fus+sz.uh) ...
                                               cp(3)-2*sz.fus sz.uh]
    ht.iirmethod1    [cp(1)+sz.fus+recess cp(2)+cp(4)-7*(sz.fus+sz.uh)...
                                               cp(3)-2*sz.fus-recess sz.uh]
    ht.iirmethod2    [cp(1)+sz.fus+recess cp(2)+cp(4)-8*(sz.fus+sz.uh)...
                                               cp(3)-2*sz.fus-recess sz.uh]
    ht.iirlabelHndl  [cp(1)+sz.fus cp(2)+cp(4)-9*(sz.fus+sz.uh)...
                                               lw1 sz.uh]   
    ht.iirorderHndl  [cp(1)+2*sz.fus+lw1 cp(2)+cp(4)-9*(sz.fus+sz.uh)...
                                               (cp(3)-3*sz.fus-lw1) sz.uh]
    ht.changefir     [cp(1)+sz.fus cp(2)+cp(4)-10*(sz.fus+sz.uh) ...
                                               cp(3)-2*sz.fus sz.uh]
    ht.firmethod     [cp(1)+sz.fus+recess cp(2)+cp(4)-11*(sz.fus+sz.uh)...
                                               cp(3)-2*sz.fus-recess sz.uh]
    ht.firlabelHndl  [cp(1)+sz.fus cp(2)+cp(4)-13*(sz.fus+sz.uh)...
                                               lw1 2*sz.uh]   
    ht.firNHndl      [cp(1)+2*sz.fus+lw1 cp(2)+cp(4)-13*(sz.fus+sz.uh)...
                                              (cp(3)-3*sz.fus-lw1) 2*sz.uh]
};
                                         
   % ht.labelHndl1    [cp(1)+sz.fus cp(2)+cp(4)-8*(sz.fus+sz.uh) ...
   %                                            lw1 sz.uh]
   % ht.FsHndl        [cp(1)+2*sz.fus+lw1 cp(2)+cp(4)-8*(sz.fus+sz.uh)-1 ...
   %                   (cp(3)-3*sz.fus-lw1) sz.uh+2]
   % ht.orderLabel    [cp(1)+sz.fus cp(2)+cp(4)-9*(sz.fus+sz.uh) ...
   %                                            cp(3)-2*sz.fus sz.uh]
   % ht.btn1Hndl      [cp(1)+sz.fus cp(2)+cp(4)-10*(sz.fus+sz.uh) ...
   %                                            lw2 sz.uh]
   % ht.ord1Hndl      [cp(1)+2*sz.fus+lw2 cp(2)+cp(4)-10*(sz.fus+sz.uh)-1 ...
   %                                            cp(3)-3*sz.fus-lw2 sz.uh+2]
   % ht.btn2Hndl      [cp(1)+sz.fus cp(2)+cp(4)-11*(sz.fus+sz.uh) ...
   %                                            lw2 sz.uh]
   % ht.ord2Hndl      [cp(1)+2*sz.fus+lw2 cp(2)+cp(4)-11*(sz.fus+sz.uh)-1 ...
   %                                            cp(3)-3*sz.fus-lw2 sz.uh+2]
   % };

    if create_flag
        pos = [pos;
        {

        } ];
    end

    set([pos{:,1}],{'position'},pos(:,2))
    
   
