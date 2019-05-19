function makeshow(action);
% MAKESHOW  Make slideshow demo.
%
%    This tool allows you to create your own interactive
%    slideshows without building your own graphic interface.
%
%    To use, type your MATLAB commands in the command window.
%    Use ctrl+return to execute the commands and to view 
%    the result for the current page.  Type your explanatory
%    text in the text window. To create a new slide, click "New".
%    MAKESHOW will take care of the rest.
%
%    When you finish your demo, you can save it to a file with
%    the "Save" button. Next time, you can open the file using
%    "Open" to view or edit the demo.  To play the slideshow,
%    call playshow('filename').
%    
%    MAKESHOW('filename') opens the file filename. 
%
%    See also PLAYSHOW. 

%   Kelly Liu, Feb. 96
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 1.24 $  $Date: 1997/11/21 23:26:27 $

filename='';
if nargin<1,
    action='initialize';
else
   if ~strcmp(action(1), '#') 
    filename=action;
    action='initialize';
   else
    action=action(2:end);
   end;
end;

if strcmp(action,'initialize'),
    figNumber=figure( ...
        'Name','Slideshow Maker', ...
        'Units', 'pixels', ...
        'Position', [232 118 560 600],...
        'NumberTitle','off', ...
        'Visible','off');
    axes( ...
        'Units','normalized', ...
        'Position',[0.10 0.63 0.65 0.315]);

    %===================================    
    left=0.05;
    right=0.75;
    bottom=0.05;
    labelHt=0.03;
    spacing=0.005;
    frmBorder=0.012;

    %======Set up the text Window==========
    top=0.6;    
    % First, the Text Window frame 
    frmPos=[left-frmBorder bottom-frmBorder-.008 ...
        (right-left)+2*frmBorder (top-bottom-spacing)];
    frmHandle=LocalBuildFrmTxt(frmPos, '', 'frame', ''); 
    % Then the text label
    labelPos=[left top-labelHt-2*(frmBorder+spacing) (right-left) labelHt];    
    lableHndl=LocalBuildFrmTxt(labelPos, 'Text Window', 'text', 'lable2');
    % Then the editable text field
    mcwPos=[left bottom+(top-bottom-labelHt)/2 (right-left) ((top-bottom)/2-2*labelHt+spacing)]; 
    textHndl=LocalBuildUi(mcwPos, 'edit', 'makeshow #changetext', '', 'Comments');
 
    %========Set up the Command Window ==================     
    top=0.3;    
    % The text label
    labelPos=[left top-labelHt (right-left) labelHt];  
    lableHandle=LocalBuildFrmTxt(labelPos, 'Command Window', 'text', 'lable1');
    % Then the editable text field
    mcwPos=[left bottom (right-left) top-bottom-labelHt-spacing];  
    mcwHndl=LocalBuildUi(mcwPos, 'edit', 'makeshow #change', '', 'cmds');
 
    %====================================
    % Information for all buttons    
    left=0.80;
    btnWid=0.15;
    top=.5;

    %=========The Panel frame============
    frmBorder=0.02;
    yPos=0.05-frmBorder;
    frmPos=[left-frmBorder yPos btnWid+2*frmBorder 0.9+2*frmBorder];
    frmHandle=LocalBuildFrmTxt(frmPos, '', 'frame', '');

    %=========The Slide frame=============
    frmBorder=0.02;
    btnHt=0.05;
    yPos=top+.4;
    btnPos=[left yPos btnWid btnHt];
    slideHandle=LocalBuildFrmTxt(btnPos, 'Slide 1', 'text', 'slide');

    %=========The Next button============
    btnNumber=1;
    labelStr='Next>>';
    callbackStr='makeshow #next';  
    nextHndl=LocalBuildBtns(btnNumber, labelStr, callbackStr, 'next');

    %======Back button===================
    backHndl=LocalBuildBtns(2, 'Prev<<', 'makeshow #back', 'back');

    %======The Reset button==============
    resetHndl=LocalBuildBtns(3, 'Reset', 'makeshow #reset', 'reset');

    %======The New button================
    newHndl=LocalBuildBtns(4, 'New Slide', 'makeshow #new', 'new');
    
    %======The Delete button=============
    delHndl=LocalBuildBtns(5, 'Delete Slide', 'makeshow #delete', 'del');
    set(delHndl, 'Enable', 'off');

    %=======The Open button==============
    addHndl=LocalBuildBtns(6, 'Open...', 'makeshow #open', 'open');

    %=======The Save button==============
    saveHndl=LocalBuildBtns(7, 'Save...', 'makeshow #save', 'save');
        
    %=======The Info button==============
    infoHndl=LocalBuildBtns(0, 'Info', 'makeshow #info', 'info');

    %=======The Close button=============
    closeHndl=LocalBuildBtns(0, 'Close', 'close(gcf)', 'close');

    % Now uncover the figure
    LocalInitUserData(mcwHndl, nextHndl, backHndl, textHndl, lableHndl, delHndl); 
    set(figNumber,'Visible','on');
    if ~isempty(filename)
     slide=eval(filename);
     slideData=get(gcf, 'UserData');
     slideData.slide=slide;
     slideData.index=1; 
     set(gcf, 'UserData', slideData);   
     LocalDoCmd(0);   
    end
elseif strcmp(action,'next'),
    LocalDoCmd(1);

elseif strcmp(action,'back'),
    LocalDoCmd(-1);

elseif strcmp(action,'reset'),
% reset to the first page
    slideData=get(gcf,'UserData');
    slideData.index=1;
    set(gcf, 'UserData', slideData);   
    LocalDoCmd(0);

elseif strcmp(action,'new'),
% generate a new slide
    cla;
    slideData=get(gcf,'UserData');
    curindx=slideData.index;
    numSlides=size(slideData.slide);
    if curindx~=numSlides
     disp('Please go to the end of the slide first, then, add new slide');
     break;
    end
    idx=numSlides(2)+1;
    slideData.index=idx;
    slideData.slide(idx).code={''};
    slideData.slide(idx).text={''};
    set(gcf, 'UserData', slideData);   
    LocalDoCmd(0);   

elseif strcmp(action,'open'),
% open an existing file
    slideData=get(gcf,'UserData'); 
    [fname, fpath]=uigetfile; 
     
    if isstr(fname)&isstr(fpath)
     cd(fpath(1:(length(fpath)-1)));
     filename=fname(1:(length(fname)-2));   
     slide=eval(filename);
     slideData.slide=slide;
     slideData.index=1; 
     set(gcf, 'UserData', slideData);   
     LocalDoCmd(0);   
    end

elseif strcmp(action,'save'),
    LocalSaveCallBack;

elseif strcmp(action,'change'),
% command window changes
    slideData=get(gcf,'UserData');
    idx=slideData.index; 
    LocalCmdChange(idx, slideData);
    LocalDoCmd(0);

elseif strcmp(action,'changetext'),
% text window changes
    slideData=get(gcf,'UserData');
    idx=slideData.index; 
    LocalTxtChange(idx, slideData);

elseif strcmp(action,'delete'),
% delete a slide
    slideData=get(gcf,'UserData');
    idx=slideData.index;  
    slideData.slide(idx)=[];
    slideData.param(idx)=[];
    slideData.index=idx-1;
    set(gcf, 'UserData', slideData);   
    LocalDoCmd(0);    

elseif strcmp(action,'info'),
    helpwin(mfilename);

end;    % if strcmp(action, ...
% End of function makeshow

%==================================================
function LocalInitUserData(whandle, nextHndl, backHndl, thandle, lblhandle, delhandle)
% Initialize index, slide, param, ...

 slideData.index=1;
 slideData.cmdHandle=whandle;
 slideData.nextHandle=nextHndl;
 slideData.backHandle=backHndl;
 slideData.txthandle=thandle;
 slideData.lblhandle=lblhandle;
 slideData.delhandle=delhandle;
 slideData.slide(1).code={''};
 slideData.slide(1).text={''};
 slideData.param(1).vars={};
 set(gcf, 'Userdata', slideData);
 LocalDoCmd(0);

%==================================================
function LocalDoCmd(ichange)
% execute the command in the command window 
% when ichange = 1, go to the next slide;
% when ichange = -1, go to the previous slide;
% when ichange = 0; stay with the current slide;

    % retrieve variables from saved UserData workspace
    slideData=get(gcf,'UserData');
    SlideShowi=slideData.index+ichange;
    numSlides=length(slideData.slide);
    if SlideShowi>1
     SlideShowVars=slideData.param(SlideShowi-1).vars;
     for SlideShown=1:size(SlideShowVars,1); 
       eval([SlideShowVars{SlideShown,1} '=SlideShowVars{SlideShown,2};']);
     end;
    end;
        
    %  make sure the index, SlideShowi, is within the limits
    if SlideShowi<=0,
     SlideShowi=1;
    elseif SlideShowi>numSlides
     SlideShowi=numSlidescell;
    end   
    LocalEnableBtns(SlideShowi, slideData); 
   
    % get slides, consider the empty case
    SlideShowcmdS=slideData.slide(SlideShowi).code;
    if length(SlideShowcmdS)>0
      SlideShowcmdS = char(SlideShowcmdS);
    else
      SlideShowcmdS='';
    end
    SlideShowcmdNum=size(SlideShowcmdS);   
    SlideShowtextStr=slideData.slide(SlideShowi).text;


    if length(SlideShowtextStr)==0
      SlideShowtextStr='';
    end
    % set up comments for text window, command window and slide label
    LocalSetTexts(slideData, SlideShowcmdS, SlideShowtextStr,'Text Window');
    sHndl=findobj(gcf, 'Type', 'uicontrol', 'Tag', 'slide');
    set(sHndl, 'String', ['Slide ', num2str(SlideShowi)]);
    % take comments out of the commands before eval them
    SlideShowNoCmt=SlideShowcmdS;
    if ~isempty(SlideShowcmdS)
     SlideShowNoCmt=LocalNoComments(SlideShowcmdS);
    end
    SlideShowerrorFlag=0;
    % add ',' at the end of each command 
    SlideShowcmdStemp=[SlideShowNoCmt char(','*ones(size(SlideShowcmdS,1),1))];
    % make SlideShowcmdStemp in one line for eval (it has to be that way with 'for' or 'if')
    SlideShowcmdStemp=SlideShowcmdStemp';
    % evaluate the whole command window's code
    eval(SlideShowcmdStemp(:)', 'SlideShowerrorFlag=1;');
    if SlideShowerrorFlag,
     LocalErrorProc(slideData, SlideShowcmdS);
    end     
    slideData.index=SlideShowi;
    set(gcf, 'UserData', slideData);   
    % clear all makeshow specific variables  
    clear SlideShowVars SlideShowcmdS SlideShowNoCmt SlideShowcmdStemp numSlides SlideShowi ichange 
    clear SlideShown SlideShowtextStr slideData SlideShowcmdNum
    % put variables into UserData workspace
    vars=who;
    for SlideShown=1:size(vars,1),
       vars{SlideShown,2}=eval(vars{SlideShown,1});
    end
    slideData=get(gcf, 'UserData');
    
    slideData.param(slideData.index).vars=vars;
    set(gcf, 'UserData', slideData);   

%==================================================
function NoComments=LocalNoComments(SlideShowcmdS)
% take out comments from command window commands
  SlideShowNoCmt=SlideShowcmdS;
  for SlideShowj=1:size(SlideShowcmdS,1)
     SlideShowCmt=find(SlideShowcmdS(SlideShowj,:)=='%');
     if ~isempty(SlideShowCmt)
         if SlideShowCmt(1)==1
          SlideShowNoCmt(SlideShowj,:)=';';
         else
          % check whether '%' is inside quotes
          SlideShowQut=find(SlideShowcmdS(SlideShowj,:)=='''');
          if ~isempty(SlideShowQut)
             str=SlideShowcmdS(SlideShowj,:);  %to find out % inside '', 
             a=(str=='''');
             b=1-rem(cumsum(a),2);
             c=(str=='%');
             d=b.*c;
             SlideShowCmt=find(d==1); 
             if isempty(SlideShowCmt),
              SlideShowCmt(1)=length(SlideShowcmdS(SlideShowj,:))+1;
             end
          end
          SlideShowNoCmt(SlideShowj,1:(SlideShowCmt(1)-1))=SlideShowcmdS(SlideShowj, 1:(SlideShowCmt(1)-1));
          SlideShowNoCmt(SlideShowj,SlideShowCmt(1):end)=' ';
         end   
     else
         SlideShowNoCmt(SlideShowj,:)=SlideShowcmdS(SlideShowj, :);
     end
  end
NoComments=SlideShowNoCmt;
%==================================================
function LocalSaveCallBack
% Callback for save button
    slideData=get(gcf,'UserData');
    numSlides=size(slideData.slide);
    [fname, fpath]=uiputfile;
    if isstr(fpath)&isstr(fname)
     fid=fopen([fpath, fname],'w');
     if fid~=-1 
      fprintf(fid, 'function slide=%s\n', fname(1:end-2));
      fprintf(fid, '%% This is a slideshow file for use with playshow.m and makeshow.m\n');
      fprintf(fid, '%% To see it run, type ''playshow %s'', \n\n', fname(1:end-2));
      fprintf(fid, '%% Copyright (c) 1984-98 by The MathWorks, Inc.\n');    
      fprintf(fid, 'if nargout<1,\n  playshow %s\nelse', fname(1:end-2));
      for j=1:numSlides(2)
        str=char(slideData.slide(j).code);
        target='''';
        totalen=size(str);
        fprintf(fid, '\n  %%========== Slide %d ==========\n\n', j);
        fprintf(fid, '  slide(%d).code={\n', j);
        if totalen(1)>0 
         
         for k=1:totalen(1)-1
             tempstr=str(k,:);
             outstr=LocalDoubleQuote(tempstr, target);
             fprintf(fid, '   ''%s'',\n', deblank(outstr));
         end
         tempstr=str(totalen(1),:);
         outstr=LocalDoubleQuote(tempstr, target);
         fprintf(fid, '   ''%s'' ', deblank(outstr));
        
        end
        fprintf(fid, '};\n');
      
        str=char(slideData.slide(j).text);
        totalen=size(str);
        fprintf(fid, '  slide(%d).text={\n', j);
        if totalen(1)>0           
           for k=1:totalen(1)-1
              tempstr=str(k,:);
              fprintf(fid, '   ''%s'',\n', deblank(LocalDoubleQuote(tempstr, target))');
           end 
           tempstr=str(totalen(1),:);
           fprintf(fid, '   ''%s''', deblank(LocalDoubleQuote(tempstr, target))');
        end 
        fprintf(fid, '};\n');             
      end
      fprintf(fid, 'end');
      status=fclose(fid);
     else
       disp(['can not save file ' fname ' file was not saved']);
     end
    end

%==================================================
function outStr=LocalDoubleQuote(inStr, target)
% add double quote to quoted string
    outStr=inStr(sort([1:length(inStr) find(inStr==target)]));

%==================================================
function LocalCmdChange(idx, slideData)  
% Callback when command is changed
    cmdHndl=findobj('Type', 'uicontrol', 'Tag', 'cmds');
    cmdHndl=slideData.cmdHandle;
    newcmd=get(cmdHndl, 'String');
    slideData.slide(idx).code={newcmd};
    set(gcf, 'UserData', slideData);
    LocalEnableBtns(idx, slideData);

%==================================================
function LocalTxtChange(idx, slideData)  
% Callback when text is changed
    txtHndl=slideData.txthandle;
    newtext=get(txtHndl, 'String');
    slideData.slide(idx).text=newtext;
    set(gcf, 'UserData', slideData);
    LocalEnableBtns(idx, slideData);

%==================================================
function LocalEnableBtns(i, slideData)
% control the enable property for Next and Prev. buttons
    numSlides=length(slideData.slide);
    nextHndl=slideData.nextHandle;
    backHndl=slideData.backHandle;
    delHndl=slideData.delhandle;
    if numSlides>0,
      set(delHndl, 'Enable', 'on');
    else
      set(delHndl, 'Enable', 'off');
    end
    
    if i==numSlides,
      set(nextHndl, 'Enable', 'off');
      set(backHndl, 'Enable', 'on');
    elseif i==1,
      set(backHndl, 'Enable', 'off');
      set(nextHndl, 'Enable', 'on');
    else
      set(nextHndl, 'Enable', 'on');
      set(backHndl, 'Enable', 'on');
        
    end

%==================================================
function LocalSetTexts(slideData, str1, str2, str3) 
% set comments for text window, command window and label
    mcwHndl=slideData.cmdHandle;
    textHndl=slideData.txthandle;
    lableHndl=slideData.lblhandle;
    set(mcwHndl,'String',str1);
    set(textHndl, 'String', str2);
    set(lableHndl, 'String', str3);

%==================================================
function uiHandle=LocalBuildUi(uiPos, uiStyle, uiCallback, promptStr, uiTag)
% build editable text 
    uiHandle=uicontrol( ...
        'Style',uiStyle, ...
        'HorizontalAlignment','left', ...
        'Units','normalized', ...
        'Max',20, ...
        'BackgroundColor',[1 1 1], ...
        'Position',uiPos, ...
        'Callback',uiCallback, ... 
        'Tag', uiTag, ...
        'String',promptStr);

%==================================================
function frmHandle=LocalBuildFrmTxt(frmPos, txtStr, uiStyle, txtTag)
% build frame and label
      frmHandle=uicontrol( ...
        'Style', uiStyle, ...
        'Units','normalized', ...
        'Position',frmPos, ...
        'BackgroundColor',[0.50 0.50 0.50], ...
        'ForegroundColor',[1 1 1], ...                  %generates an edge
        'String', txtStr, ...
        'Tag', txtTag);

%==================================================
function btHandle=LocalBuildBtns(btnNumber, labelStr, callbackStr, uiTag)
% build buttons or check boxes on the right panel

    labelColor=[0.8 0.8 0.8];
    top=0.9;
    left=0.80;
    btnWid=0.15;
    btnHt=0.06;
    bottom=0.05;
    % Spacing between the button and the next command's label
    spacing=0.03;

    yPos=top-(btnNumber-1)*(btnHt+spacing);
    if strcmp(labelStr, 'Close')==1
      yPos= bottom;
    elseif strcmp(labelStr, 'Info')==1
      yPos= bottom+btnHt+spacing; 
    else
      yPos=top-(btnNumber-1)*(btnHt+spacing)-btnHt;
    end
    % Generic button information
    btnPos=[left yPos btnWid btnHt];
    btHandle=uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'Tag', uiTag, ...
        'Callback',callbackStr); 

%==================================================
function LocalErrorProc(slideData, oldCmds)
% error processing 
      editHndl=slideData.cmdHandle;
      set(editHndl,'ForegroundColor',[1 0 0]);
      % Pad "lasterr" with spaces for consistency
      lasterrStr=[32 lasterr];
      lasterrStr=strrep(lasterrStr,10,[13 10 32]);
      errorStr=str2mat(' Error Detected:',lasterrStr,' Resetting Input');
      set(editHndl,'String',errorStr);
      pause(3);
      set(editHndl,'String', oldCmds);
      set(editHndl,'ForegroundColor',[0 0 0]);

