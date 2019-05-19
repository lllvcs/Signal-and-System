function str = yhzfdhelpstr(tag,fig)
%yhzfdhelpstr  Help for Filter Designer

% Copyright (c) 1988-97 by The MathWorks, Inc.
% $Revision: 1.5 $

    str{1,1} = 'Filter Designer';
    str{1,2} = {['No help for this object (' tag ')']};

% ****                       WARNING!                       ****
% ****                                                      ****
% ****  All help text between the SWITCH TAG and OTHERWISE  ****
% ****  statements is automatically generated.  To change   ****
% ****  the help text, edit FDHELP.H and use HWHELPER to    ****
% ****  insert the changes into this file.                  ****

switch tag

case {'help','consoleframe'}
str{1,1} = 'FILTER DESIGNER';
str{1,2} = {
'This window is a Filter Designer.  It allows you to create FIR and'
'IIR digital filters of various lengths and types using design'
'functions in the Signal Processing Toolbox.'
' '
'To create a new filter, click the "New Design" button in the SPTool. '
'To edit an existing filter, click on it in the SPTool and click the'
'"Edit Design" button.'
' '
'The main axes displays the frequency response of the current filter. '
'Pull-dowm menus to the left of the main axes allow you to change the'
'optimization criterion used to design the filter as well as the type'
'of desired frequency response.  An editable text box allows the entry'
'of the edges and amount of ripple desired in the passband and'
'stopband.  You can either specify the length of the filter or let it'
'be determined automatically by the Filter Designer.'
' '
'The toolbar above the main axes allows you to zoom into and out of'
'the frequency response, and obtain help on any of the tool''s'
'components.'
' '
'Continued under Topics: MORE HELP'
};

str{2,1} = 'MORE HELP';
str{2,2} = {
'To get help at any time, click once on the ''Help'' button.  The'
'mouse pointer becomes an arrow with a Question Mark symbol.  You can'
'then click on anything in the Filter Designer (or select a menu) to'
'find out what it is and how to use it.'
};

case 'toolbar'
str{1,1} = 'TOOLBAR';
str{1,2} = {
'You have clicked in the "Toolbar" of the Filter Designer.'
' '
'The Toolbar contains two "Button Groups": the "Zoom Group" consisting'
'of the seven buttons on the left, and the "Help Group" consisting of'
'the two buttons on the right.'
' '
'To get help on any of the buttons, click once on the "Help" button,'
'then click on the button for which you want help.'
};

case 'fdzoom:mousezoom'
str{1,1} = 'MOUSE ZOOM';
str{1,2} = {
'Clicking this button puts you in "Mouse Zoom" mode. In this mode, the'
'mouse pointer becomes a cross when it is inside the main axes area. '
'You can click and drag a rectangle in the main axes, and the main'
'axes display will zoom in to that region.  If you click with the left'
'button at a point in the main axes, the main axes display will zoom'
'in to that point for a more detailed look at the response there. '
'Similarly, you can click with the right mouse button at a point in'
'the main axes to zoom out from that point for a wider view of the'
'response.'
' '
'To get out of mouse zoom mode without zooming in or out, click on the'
'Mouse Zoom button again.'
' '
'ZOOM PERSISTENCE'
' '
'Normally you leave zoom mode as soon as you zoom in or out once.  In'
'order to zoom in or out again, the Mouse Zoom button must be clicked'
'again. However, the mouse zoom mode will remain enabled after a zoom'
'if the box labeled ''Stay in Zoom-Mode after Zoom'' is checked in the'
'Preferences for SPTool window in the Filter Designer category.  The'
'Preferences for SPTool window can be opened by selecting Preferences'
'under the File menu in SPTool.'
};

case 'fdzoom:zoomout'
str{1,1} = 'FULL VIEW';
str{1,2} = {
'Clicking this button restores the data limits of the main axes to'
'show all of the filter''s response.'
};

case 'fdzoom:zoominy'
str{1,1} = 'ZOOM IN Y';
str{1,2} = {
'Clicking this button zooms in on the response, cutting the vertical'
'range of the main axes in half.  The x-limits (horizontal scaling) of'
'the main axes are not changed.'
};

case 'fdzoom:zoomouty'
str{1,1} = 'ZOOM OUT Y';
str{1,2} = {
'Clicking this button zooms out from the response, expanding the'
'vertical range of the main axes by a factor of two.  The x-limits'
'(horizontal scaling) of the main axes are not changed.'
};

case 'fdzoom:zoominx'
str{1,1} = 'ZOOM IN X';
str{1,2} = {
'Clicking this button zooms in on the response, cutting the horizontal'
'range of the main axes in half.  The y-limits (vertical scaling) of'
'the main axes are not changed.'
};

case 'fdzoom:zoomoutx'
str{1,1} = 'ZOOM OUT X';
str{1,2} = {
'Clicking this button zooms out from the response, expanding the'
'horizontal range of the main axes by a factor of two.  The y-limits'
'(vertical scaling) of the main axes are not changed.'
};

case 'fdzoom:passband'
str{1,1} = 'PASSBAND ZOOM';
str{1,2} = {
'Clicking this button zooms in on the passband of the response.  Both'
'the x- and y-limits of the main axes are changed so that the passband'
'fills the main axes.  There is only one level of detail in the'
'passband zoom; that is, you cannot zoom in to the passband further by'
'clicking the Passband Zoom button multiple times.'
' '
'There is no stopband zoom button because by hitting Full View you are'
'only one mouse zoom away from viewing the stopband.'
};

case 'Fs'
str{1,1} = 'SAMPLING FREQ.';
str{1,2} = {
' '
'This displays the sampling frequency.  To change this filter''s'
'sampling frequency, use the Edit/Sampling Frequency menu of the'
'SPTool.  '
' '
'Measurements corresponding to the edges and widths of the passband'
'and stopband change accordingly when you change Fs.'
};

case 'close'
str{1,1} = 'CLOSE';
str{1,2} = {
' '
'Select this menu option to close the Filter Designer.  All unsaved'
'filter information will be lost.  Any settings you changed and saved'
'with the Settings window will be retained the next time you open a'
'Filter Designer.'
};

case 'paramdialog'
str{1,1} = 'SPECIAL PARAMETERS';
str{1,2} = {
'This menu option brings up a window from which you can specify'
'special parameters which are specific to each of the filter design'
'methods.'
' '
'AUTO SPECIAL PARAMETERS'
'When this radio button is clicked, the special parameters are'
'determined automatically by the Filter Designer.  '
' '
'SET SPECIAL PARAMETERS'
'When you click this radio button, the special parameters are given by'
'the values you enter in the editable text field.'
' '
'AUTO -> SET SPECIAL PARAMETERS'
'When this button is clicked, the special parameters automatically'
'determined by the Filter Designer are written into the editable text'
'field for setting these special parameters.  This makes it easier to'
'restore the "default" weights.'
};

case 'filtdespop'
str{1,1} = 'DESIGN METHOD';
str{1,2} = {
'The basic filter design process involves four steps:'
' '
'1.  Choose a desired frequency response.'
' '
'2.  Choose an allowed class of filters (for example Nth order FIR or'
'IIR filters).'
' '
'3.  Establish a measure of distance between the desired response and'
'the actual response of a member of the allowed class.  This measure'
'of distance is also called the optimization or error criterion.'
' '
'4.  Develop a method to find the "best" allowed filter as measured by'
'closeness to the desired response.'
' '
'This popup menu allows you to choose the allowed class of filters and'
'an optimization criterion (steps 2 and 3) used to design a digital'
'filter.  The seven choices in the popup menu are discussed on the'
'following pages.'
' '
'Page 2: FIR filter design'
'Page 3: IIR filter design'
};

str{2,1} = 'FIR FILTERS';
str{2,2} = {
'Equiripple'
'------------------'
'FIR filter design using the Chebyshev error criterion and the Remez'
'exchange algorithm.   Uses REMEZ.M.'
' '
'Least Square'
'------------------'
'FIR filter design using the weighted least squares (L_2) error'
'criterion. Uses FIRLS.M.'
' '
'Kaiser Window'
'------------------'
'FIR filter design using a least squares error criterion along with a'
'Kaiser Window to provide a smoother truncation of the ideal impulse'
'response.  Uses FIRLS.M and KAISER.M.'
' '
'Page 1: Introduction to filter design'
'Page 3: IIR filter design'
};

str{3,1} = 'IIR FILTERS';
str{3,2} = {
'Butterworth'
'------------------'
'IIR filter design using a maximally flat (Taylor series)'
'approximation to the desired frequency response at 0 and Fs/2, where'
'Fs is the sampling frequency.  Uses BUTTER.M.'
' '
'Chebyshev I'
'------------------'
'IIR filter design using a Chebyshev (equiripple) approximation to the'
'desired frequency response in the passband and a maximally flat'
'approximation at Fs/2.  Uses CHEBY1.M.'
' '
'Chebyshev II (inverse Chebyshev)'
'-----------------------------------------'
'IIR filter design using a maximally flat approximation to the desired'
'frequency response at 0 and a Chebyshev (equiripple) approximation in'
'the stopband.  Uses CHEBY2.M.'
' '
'Elliptic'
'------------------'
'IIR filter design using a Chebyshev error criterion in both the'
'passband and stopband.  Uses ELLIP.M.'
' '
' '
'Page 1: Introduction to filter design'
'Page 2: FIR filter design'
};

case 'filttypepop'
str{1,1} = 'CONFIGURATION';
str{1,2} = {
' '
'This menu allows you to set the configuration of the filter: either'
'lowpass, highpass, bandpass or bandstop.  '
' '
'For the lowpass and highpass cases, there are four parameters in the'
'specifications box below this popup menu: f1, f2, Rp and Rs.  For'
'bandpass and bandstop, there are six parameters: f1, f2, f3, f4, Rp'
'and Rs.  The frequencies are in ascending order.'
};

case {'speclabels','spectextbox'}
str{1,1} = 'SPECIFICATIONS';
str{1,2} = {
' '
'This edit box shows you and lets you change the specifications for'
'the filter.  In lowpass and highpass modes, f1 and f2 are band edges'
'in ascending order.  In bandpass and bandstop modes, f1, f2, f3, and'
'f4 are the band edges in ascending order.'
' '
'Rp is the desired passband ripple, in dB.  Rs is the desired stopband'
'attenuation, in dB.'
};

case 'autoradio'
str{1,1} = 'AUTO ORDER';
str{1,2} = {
' '
'Click this button to use the order that the Filter Designer'
'automatically calculates which is minimum to meet the specifications'
'entered for this filter.  '
' '
'Note that for FIR filters, this order is only an approximation; you'
'might have to increase the order a bit to truly meet the'
'specifications that you desire.  Enter a value in the ''Set:'' area'
'to change the order.'
};

case 'setradio'
str{1,1} = 'SET ORDER';
str{1,2} = {
' '
'With this button clicked, you will always design a filter of the'
'order given in the edit box to the right of the button.  To use the'
'automatically generated order, click on the ''Auto:'' button.'
};

case 'mainaxes'
str{1,1} = 'MAIN AXES';
str{1,2} = {
' '
'This is the main axes of the Filter Designer.  It displays the'
'current response of the filter and specifications lines indicating'
'the desired ripple and band edges.'
};

case 'pbripline'
str{1,1} = 'PASSBAND RIPPLE';
str{1,2} = {
' '
'Drag this line up and down to change the amount of desired ripple in'
'the passband.  As you drag the line, the value for Rp changes in the'
'text box at the left; when you let go of the line, a new filter is'
'designed.'
' '
'You can also change Rp directly by entering a value for it in the'
'text box on the left.'
' '
'EDGE FREQUENCIES'
' '
'By clicking on the line near a band edge, you can change the value of'
'the band edge by dragging the line back and forth.  Again, the value'
'of the band edge changes in the edit box on the left, and when you'
'let go, a new filter is designed.  You can change the band edges'
'directly by typing in the text box on the left.'
};

case 'sbattenline'
str{1,1} = 'STOPBAND ATTENUATION';
str{1,2} = {
' '
'Drag this line up and down to change the amount of desired'
'attenuation in the stopband.  As you drag the line, the value for Rs'
'changes in the text box at the left; when you let go of the line, a'
'new filter is designed.'
' '
'You can also change Rs directly by entering a value for it in the'
'text box on the left.'
' '
'EDGE FREQUENCIES'
' '
'By clicking on the line near a band edge, you can change the value of'
'the band edge by dragging the line back and forth.  Again, the value'
'of the band edge changes in the edit box on the left, and when you'
'let go, a new filter is designed.  You can change the band edges'
'directly by typing in the text box on the left.'
' '
};

case 'magline'
str{1,1} = 'MAGNITUDE';
str{1,2} = {
' '
'This line is the magnitude response of the current filter design, in'
'dB.'
};

case 'title'
str{1,1} = 'TITLE';
str{1,2} = {
' '
'You have clicked on the title for the Filter Designer''s main axes'
'area.  This title displays the name of the currently selected filter'
'in the SPTool, and some information about how the filter was designed.'
};


otherwise

str{1,1} = 'HELP for FILTDES';
str{1,2} = {
'You have clicked on an object with tag'
['   ''' tag ''''] 
};

end

if strcmp(computer,'MAC2')
   crchar = 13;
else
   crchar = 10;
end

for i=1:size(str,1)
   str{i,2} = char(str{i,2});
   str{i,2} = [str{i,2},crchar*ones(size(str{i,2},1),1)]';
   str{i,2} = str{i,2}(:)';
end

helpwin(str,str{1,1},'Filter Design Tool Help')
