function str = yhzfvhelpstr(tag,fig)
%yhzfvhelpstr  Help for Filter Viewer

%   Copyright (c) 1988-97 by The MathWorks, Inc.
% $Revision: 1.3 $

    str{1,1} = 'Filter Viewer';
    str{1,2} = {['No help for this object (' tag ')']};

% ****                       WARNING!                       ****
% ****                                                      ****
% ****  All help text between the SWITCH TAG and OTHERWISE  ****
% ****  statements is automatically generated.  To change   ****
% ****  the help text, edit FVHELP.H and use HWHELPER to    ****
% ****  insert the changes into this file.                  ****

switch tag

case 'help'
str{1,1} = 'FILTER VIEWER';
str{1,2} = {
' '
'This window is a Filter Viewer.  It allows you to view several'
'characteristics of a filter which can be loaded or designed via the'
'SPTool.  You can view any combination of the magnitude and phase'
'responses, the group delay, the pole-zero plot, and the impulse and'
'step responses of the filter. Through the Preferences menu item,'
'accessible from the File menu in SPTool, you can customize the layout'
'of the 6 subplots in the Filter Viewer.'
' '
'The Toolbar provides some information about the filter, such as the'
'variable name where the filter is stored (Filter) and the sampling'
'frequency (Fs).  The Toolbar has two zoom buttons that allows you to'
'zoom in to and out of each subplot.  It also contains a help button'
'which enables you to obtain help on the rest of the Filter Viewer.'
' '
'To get help at any time, click once on the Help button.  The mouse'
'pointer becomes an arrow with a question mark symbol.  You can then'
'click on anything in the Filter Viewer, including the options under'
'the menu items, to find out what it is and how to use it.'
};

case 'closemenu'
str{1,1} = 'CLOSE MENU OPTION';
str{1,2} = {
' '
'Select this menu option to close the Filter Viewer.'
};

case 'mainframe'
str{1,1} = 'MAIN FRAME';
str{1,2} = {
' '
'In this region of the Filter Viewer, you can select which subplots to'
'display in the main window, set the scaling of various subplot axes,'
'and set the sampling frequency.'
};

case {'plotframe','plottext'}
str{1,1} = 'PLOTS FRAME';
str{1,2} = {
' '
'This frame indicates which subplots are currently displayed in the'
'main window to the right.  You can enable some or all of the plots. '
'Simply check the corresponding box to enable a plot.  You can choose'
'from: magnitude response, phase response, group delay, pole-zero'
'plot, impulse response, and step response.'
};

case 'magcheck'
str{1,1} = 'MAGNITUDE';
str{1,2} = {
' '
'Check this box to enable the magnitude response subplot.  '
};

case {'maglist','magframe'}
str{1,1} = 'MAG SCALING';
str{1,2} = {
' '
'You can choose a scaling for the magnitude plot (linear, log, or'
'decibels) by choosing from the Magnitude popup menu.'
};

case 'phasecheck'
str{1,1} = 'PHASE';
str{1,2} = {
' '
'Check this box to enable the phase response subplot.'
};

case {'phaselist','phaseframe'}
str{1,1} = 'PHASE UNITS';
str{1,2} = {
' '
'You can choose the units for the phase (degrees or radians) by'
'choosing from the Phase popup menu.'
};

case 'groupdelay'
str{1,1} = 'GROUP DELAY';
str{1,2} = {
' '
'Check this box to enable the group delay subplot.  The group delay is'
'defined as the derivative of the phase response.'
};

case 'polezero'
str{1,1} = 'POLE-ZERO';
str{1,2} = {
' '
'Check this box to enable the pole-zero subplot.  This displays the'
'poles and zeros of the transfer function and their proximity to the'
'unit circle.'
};

case 'impresp'
str{1,1} = 'IMPULSE RESP.';
str{1,2} = {
' '
'Check this box to enable the impulse response subplot.  This displays'
'the result of applying the filter to a discrete-time unit-height'
'impulse at 0.'
};

case 'stepresp'
str{1,1} = 'STEP RESPONSE';
str{1,2} = {
' '
'Check this box to enable the step response subplot.  This displays'
'the result of applying the filter to a discrete-time unit-height step'
'at 0.'
};

case {'freqframe','freqtext'}
str{1,1} = 'FREQUENCY AXIS';
str{1,2} = {
' '
'In this frame, you can set the scaling and range of the frequency'
'axis.'
};

case {'freqsframe','freqscale','freqstext'}
str{1,1} = 'FREQ. SCALING';
str{1,2} = {
' '
'You can choose the scaling for the frequency axis (linear or log) by'
'selecting the appropriate option from this popup menu.'
};

case {'freqrframe','freqrange','freqrtext'}
str{1,1} = 'FREQ. RANGE';
str{1,2} = {
' '
'You can choose the range for the frequency axis by selecting an'
'option from this popup menu.  The options are [0, Fs/2], [0, Fs], and'
'[-Fs/2, Fs/2], where Fs in the sampling frequency displayed in the'
'editable text box up above in the Toolbar.'
};

case 'toolbar'
str{1,1} = 'TOOLBAR';
str{1,2} = {
' '
'The Toolbar has three sections.  On the left it has two variables,'
'Filter and Fs, which provide filter information.  Following the two'
'variables are two zooming buttons.  On the right side of the Toolbar'
'there is a help button.'
' '
'To get help on any of the buttons, click once on the "Help" button,'
'then click on the button for which you want help.'
' '
'The two variables, Filter and Fs, contain the variable name and the'
'sampling frequency of the filter design, respectively. You can change'
'these using the edit menu of the SPTool.'
};

case 'fvzoom:mousezoom'
str{1,1} = 'MOUSE ZOOM';
str{1,2} = {
' '
'Clicking this button puts you in "Mouse Zoom" mode. In this mode, the'
'mouse pointer becomes a cross when it is inside any of the six'
'subplot areas.  You can click and drag a rectangle in a subplot, and'
'the axes display will zoom in to that region.  If you click with the'
'left button at a point in a subplot, the axes display will zoom in to'
'that point for a more detailed look at the data at that point. '
'Similarly, you can click with the right mouse button (shift click on'
'a Mac) at a point in a subplot to zoom out from that point for a'
'wider view of the data.'
' '
'To get out of the mouse zoom mode without zooming in or out, click on'
'the Mouse Zoom button again.'
' '
'ZOOM PERSISTENCE'
' '
'Normally you leave zoom mode as soon as you zoom in or out once.  In'
'order to zoom in or out again, the Mouse Zoom button must be clicked'
'again.  However, the mouse zoom mode will remain enabled after a zoom'
'if the box labeled ''Stay in Zoom Mode after Zoom'' is checked in the'
'Preferences for SPTool window.  The Preferences for SPTool window can'
'be opened by selecting Preferences under the File menu in SPTool.'
};

case 'fvzoom:zoomout'
str{1,1} = 'FULL VIEW';
str{1,2} = {
' '
'Clicking this button restores the axes limits of all the subplots.'
};

case 'magaxes'
str{1,1} = 'MAGNITUDE';
str{1,2} = {
' '
'This axes displays the magnitude of the frequency response of the'
'current filter.'
};

case 'phaseaxes'
str{1,1} = 'PHASE';
str{1,2} = {
' '
'This axes displays the phase of the frequency response of the current'
'filter.'
};

case 'delayaxes'
str{1,1} = 'GROUP DELAY';
str{1,2} = {
' '
'This axes displays the group delay (defined as the derivative of the'
'phase of the frequency response) of the current filter.'
};

case 'pzaxes'
str{1,1} = 'POLE-ZERO';
str{1,2} = {
' '
'This axes displays the poles and zeros of the transfer function of'
'the current filter in relationship to the unit circle.'
};

case 'impaxes'
str{1,1} = 'IMPULSE RESPONSE';
str{1,2} = {
' '
'This axes displays the response of the current filter to a'
'discrete-time unit-height impulse at 0.'
};

case 'stepaxes'
str{1,1} = 'STEP RESPONSE';
str{1,2} = {
' '
'This axes displays the response of the current filter to a'
'discrete-time unit-height step function.'
};

case 'magline'
str{1,1} = 'MAGNITUDE RESP.';
str{1,2} = {
' '
'This line is the magnitude of the frequency response of the current'
'filter.  When not in mouse zoom mode, you can click and drag on the'
'response to move it around this subplot.'
};

case 'phaseline'
str{1,1} = 'PHASE RESPONSE';
str{1,2} = {
' '
'This line is the phase of the frequency response of the current'
'filter.  When not in mouse zoom mode, you can click and drag on the'
'response to move it around this subplot.'
};

case 'delayline'
str{1,1} = 'GROUP DELAY';
str{1,2} = {
' '
'This line is the group delay (defined as the derivative of the phase'
'of the frequency response) of the current filter.  When not in mouse'
'zoom mode, you can click and drag on the line to move it around this'
'subplot.'
};

case {'implinedots','implinestem'}
str{1,1} = 'IMPULSE RESP.';
str{1,2} = {
' '
'This stem plot is the response of the current filter to a'
'discrete-time unit-height impulse at 0.  When not in mouse zoom mode,'
'you can click and drag on the response to move it around this subplot.'
};

case {'steplinedots','steplinestem'}
str{1,1} = 'STEP RESPONSE';
str{1,2} = {
' '
'This stem plot is the response of the current filter to a'
'discrete-time unit-height step function.  When not in mouse zoom'
'mode, you can click and drag on the response to move it around this'
'subplot.'
};

case 'polesline'
str{1,1} = 'POLE';
str{1,2} = {
' '
'This ''x'' represents a pole of the transfer function of the current'
'filter.'
};

case 'zerosline'
str{1,1} = 'ZERO';
str{1,2} = {
' '
'This ''o'' represents a zero of the transfer function of the current'
'filter.'
};

case 'unitcircle'
str{1,1} = 'UNIT CIRCLE';
str{1,2} = {
' '
};


otherwise

str{1} = {
    'HELP for FILTVIEW'
    ' '
    'You have clicked on an object with tag'
    ['   ''' tag ''''] 
};

end

