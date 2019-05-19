function yhzzpresize(create_flag,fig)
%yhzzpresize Resize function for Filter Design Tool.
%   yhzzpresize will resize only those objects which need resizing.
%   yhzzpresize(1) will resize every object.  Use this syntax at creation
%   of the figure.
%
%   yhzzpresize(create_flag,fig) resizes the designer with figure handle fig.
%   Copyright (c) 1988-97 by The MathWorks, Inc.
%       $Revision: 1.9 $

    if nargin == 0
        create_flag = 0;
    end

    if nargin <= 1
        fig = gcbo;
    end
    
    zpud = get(fig,'userdata');
    sz = zpud.sz;

    %zpud.sz.ih= 47;
    %zpud.sz.iw= 42;
    %zpud.sz.lw= 130;
    %zpud.sz.fus= 5;
    %zpud.sz.ffs= 5;
    %zpud.sz.lfs= 3;
    %zpud.sz.lh= 18;
    %zpud.sz.uh= 20;
    %zpud.sz.rw= 150;  %130
    %zpud.sz.rih= 40;
    %zpud.sz.riw= 55;
    %zpud.sz.pmw= 14;
    %zpud.sz.lbs= 3;
    %zpud.sz.as= [57.7350 46.1880 23.0940 34.6410];
    %zpud.sz.ph= 60;
    %zpud.sz.bw= 110;
    
    fp = get(fig,'position');   % in pixels already

    toolbar_ht = sz.ih;
    left_width = sz.rw;  % arbitrary

    mainaxes_port = [left_width 0 fp(3)-left_width fp(4)-toolbar_ht];
    mainaxes_pos = mainaxes_port + ...
               [sz.as(1) sz.as(2) -(sz.as(1)+sz.as(3)) -(sz.as(2)+sz.as(4))];

     if mainaxes_pos(3)<zpud.prefs.minsize(1)  ...
          | mainaxes_pos(4)<zpud.prefs.minsize(2)
       disp('figure too small - resizing')
       
       % minsize(1)   - minimum width of main axes in pixels
       % minsize(2)   - minimum height of main axes in pixels

       w = left_width+sz.as(1)+sz.as(3)+zpud.prefs.minsize(1);
       w = max(w,fp(3));
       h = toolbar_ht+sz.as(2)+sz.as(4)+zpud.prefs.minsize(2);
       h = max(h,fp(4));
       fp = [fp(1) fp(2)+fp(4)-h w h];
       set(fig,'position',fp)
       %return
    end
    % recompute with new fp:
    mainaxes_port = [left_width 0 fp(3)-left_width fp(4)-toolbar_ht];
    mainaxes_pos = mainaxes_port + ...
               [sz.as(1) sz.as(2) -(sz.as(1)+sz.as(3)) -(sz.as(2)+sz.as(4))];

    ht = zpud.ht;
    % console position:
    lf = [0 0 left_width fp(4)-toolbar_ht];
    cf = [lf(1)+sz.fus lf(2)+sz.lbs lf(3)-sz.fus-sz.lfs ...
                                               7*sz.fus+6*sz.uh];
                                         
    zpaxes_pos = [sz.lfs+10, cf(2)+cf(4)+60,...       
                   left_width-2*sz.lfs-10, left_width-2*sz.lfs-20];              

    %lw1 = sz.bw/4;  % width of f, Rs, Rp, and Fs labels
    %lw2 = sz.bw/2;  % width of Auto: and Set: radio buttons
    
    recess=15;
    % 1-by-4 position vectors
    pos = {
    %ht.lftframe      lf
    ht.chsframe      cf
    ht.respAxes      mainaxes_pos
    ht.zpAxes        zpaxes_pos   
    ht.modepop       [cf(1)+sz.fus cf(2)+6*sz.fus+5*sz.uh cf(3)-2*sz.fus sz.uh]
    ht.zerosBtn      [cf(1)+sz.fus cf(2)+5*sz.fus+4*sz.uh ...
                                               40 sz.uh]
    ht.zerosEdit     [cf(1)+2*sz.fus+40 cf(2)+5*sz.fus+4*sz.uh ...
                                 (cf(3)-3*sz.fus-40) sz.uh]
    ht.polesBtn      [cf(1)+sz.fus cf(2)+4*sz.fus+3*sz.uh ...
                                               40 sz.uh]
    ht.polesEdit     [cf(1)+2*sz.fus+40 cf(2)+4*sz.fus+3*sz.uh ...
                                 (cf(3)-3*sz.fus-40) sz.uh]
    ht.backFD        [cf(1)+sz.fus cf(2)+sz.fus ...
                                  cf(3)-2*sz.fus  sz.uh]
    ht.clearAll      [cf(1)+sz.fus  cf(2)+2*sz.fus+sz.uh ...
                                  cf(3)-2*sz.fus  sz.uh]
    ht.clearLast       [cf(1)+sz.fus cf(2)+3*sz.fus+2*sz.uh ...
                                  cf(3)-2*sz.fus sz.uh]
};
                                         

    if create_flag
        pos = [pos;
        {

        } ];
    end

    set([pos{:,1}],{'position'},pos(:,2))
    
   
