/*****************************************************************************

                        Copyright (c) 2012 A&K

******************************************************************************/

implement taskWindow
    inherits applicationWindow
    open core, vpiDomains


constants
    mdiProperty : boolean = true.
clauses
    new():-
        applicationWindow::new(),
        generatedInitialize(),

     %%%
      makeAcadDocLsp::makeAcadDocLisp().

   facts
    infoAcad: infoTask := erroneous.
    acadDocLsp : string := erroneous.


predicates
    onShow : window::showListener.
clauses
    onShow(_S, _CreationData):-
 InfoTask=    infoTask::display(This),

 infoAcad := InfoTask,

 _MessageForm = messageForm::display(This).

predicates
    onDestroy : window::destroyListener.
clauses
    onDestroy(_) :-
   acadDocLsp := makeAcadDocLsp::getAcadDocLisp() ,
    if not(isErroneous(acadDocLsp ) ) then
             if file::existExactFile(acadDocLsp) then
                       file::delete(acadDocLsp)
    end if
    end if.
%estroy(_).

predicates
    onHelpAbout : window::menuItemListener.
clauses
    onHelpAbout(TaskWin, _MenuTag):-
        _AboutDialog = aboutDialog::display(TaskWin).

predicates
    onFileExit : window::menuItemListener.
clauses
    onFileExit(_, _MenuTag):-
        close().

predicates
    onSizeChanged : window::sizeListener.
clauses
    onSizeChanged(_):-
        vpiToolbar::resize(getVPIWindow()).

predicates
    onFileNew : window::menuItemListener.
clauses
    onFileNew(_Source, _MenuTag)  :- % дописать
     File="",
%     CurDir="",
   %File=   vpiCommonDialogs::getFileName("*.dwg",["Dwg file","*.dwg","All files","*.*"],"XX",[],CurDir,_),
   %stdio::writef(File),
%               Ret=infAcad(Major,Minor,Platform ,Location,ProductName,MAME_EN),!.
%infoTaskTxt::acad_db(AcadVersion, _ProductName ,Location ,_Language )= infoAcad:getACAD(),
%infoAcad=infAcad(unsigned Major,unsigned Minor,platform X,string Location,string ProductName,string Language);nil.
%acad_db=acad_db( rel VER ,string ProductName ,string Location ,string Language ).
%acadInfo::infAcad(Major,Minor,_Platform ,Location,_ProductName,_MAME_EN)
infoTaskTxt::acad_db(VER ,_ProductName ,Location ,_Language )= infoAcad:getACAD(),
TSKexeACAD= string::concat(Location,"\\acad.exe"),
CTOOLHELP=cToolhelp::new(),
%%%%
if  _=CTOOLHELP:isRunAcad(TSKexeACAD)  then
regUtil::newDwgInRunningAcad(TSKexeACAD, VER , File, "AcadDocLsp")
        else
 Command=  regUtil::makeAcadRunCommandLine(TSKexeACAD,VER,File),
 regUtil::acadWinExec( Command,1)
 end if,
 !.


     onFileNew(_Source, _MenuTag).


predicates
    onFileProcifo : window::menuItemListener.
clauses
    onFileProcifo(_Source, _MenuTag) :-
    /*
     ThProcesses=cToolHelp::new(toolhelp32_native::snapProcess),
 foreach  cToolHelp::processInfo(ProcessID, Threads, ParentProcessID,  PriClassBase,  ExeFileName)=ThProcesses:getAllProcess()   do
     stdio::writef("\n ----Start----"),
     stdio::writef("\n Process ID= 0x%08X", ProcessID) ,
     stdio::writef("\n Tread count = %d", Threads) ,
     stdio::writef("\n ParentProcessID = 0x%08X", ParentProcessID) ,
     stdio::writef("\n  PriClassBase =%d",PriClassBase),
     stdio::writef("\n  ExeFileName =%s", ExeFileName),

     ThModules=cToolHelp::new(toolhelp32_native::snapModule,ProcessID),
foreach   cToolHelp::moduleInfo(ProcessID2,_ModBaseAddr,_ModBaseSize,_HModule,ModuleName,ExePath)=ThModules:getModules()  do
    stdio::writef("\n ID=0x%08X  ModuleName %s   Path %s", ProcessID2, ModuleName, ExePath)
end foreach   ,
      stdio::writef("\n ----End---- \n \n")
end foreach    . */

     ThProcesses=cToolHelp::new(toolhelp32_native::snapProcess),
 foreach  cToolHelp::processInfo(ProcessID, Threads, ParentProcessID,  PriClassBase,  ExeFileName )=ThProcesses:getAllProcess()   do
 if (ExeFileName = "acad.exe" ) then
     stdio::writef("\n ----Start----"),
     stdio::writef("\n Process ID= 0x%08X", ProcessID) ,
     stdio::writef("\n Tread count = %d", Threads) ,
     stdio::writef("\n ParentProcessID = 0x%08X", ParentProcessID) ,
     stdio::writef("\n  PriClassBase =%d",PriClassBase),
     stdio::writef("\n  ExeFileName =%s", ExeFileName),

     ThModules=cToolHelp::new(toolhelp32_native::snapModule,ProcessID),
foreach   cToolHelp::moduleInfo(ProcessID2,_ModBaseAddr,_ModBaseSize,_HModule,ModuleName,ExePath)=ThModules:getModules()  do

    stdio::writef("\n ID=0x%08X  ModuleName %s   Path %s", ProcessID2, ModuleName, ExePath)

end foreach   ,
      stdio::writef("\n ----End---- \n \n")
      end if
end foreach    .


%       foreach    cToolHelp::moduleInfo(ProcessID2,_ModBaseAddr,_ModBaseSize,_HModule,ModuleName,ExePath)=Y:getModules()       do
  %      stdio::writef("\n ID=%x  ModuleName %s   Path %s", ProcessID2, ModuleName, ExePath)
    % end foreach,

    % H=   toolhelp32_native::createToolhelp32Snapshot(toolhelp32_native::snapModule32,ProcessID),
    /*
    Y=toolHelp32snapshot::newModuleInfo (),
     foreach     toolHelp32snapshot::moduleInfo(ProcessID2,_ModBaseAddr,_ModBaseSize,_HModule,ModuleName,ExePath)=Y:getModule_nd()       do
        stdio::writef("\n ID=%x  ModuleName %s   Path %s", ProcessID2, ModuleName, ExePath)
     end foreach,
     */
   %stdio::writef("\n ----End---- \n \n")
   /*
_ = vpiCommonDialogs::messageBox("Ok button",
               "Continue ?",
               vpiDomains::mesbox_iconQuestion, vpiDomains::mesbox_buttonsYesNo,
               vpiDomains::mesbox_defaultFirst, vpiDomains::mesbox_suspendApplication)

   */
% end foreach
%       onFileProcifo(_Source, _MenuTag).



predicates
    onFileOpen : window::menuItemListener.
clauses
    onFileOpen(_Source, _MenuTag) :-
    CurDir="",
   File=   vpiCommonDialogs::getFileName("*.dwg",["Dwg file","*.dwg","All files","*.*"],"Выбери файл для работы",[],CurDir,_),
   stdio::writef(File),
infoTaskTxt::acad_db(VER ,_ProductName ,Location ,_Language )= infoAcad:getACAD(),
TSKexeACAD= string::concat(Location,"\\acad.exe"),
    CTOOLHELP=cToolhelp::new(),
if  ModuleInfo=CTOOLHELP:isRunAcad(TSKexeACAD)  then
regUtil::openDwgInRunningAcad(ModuleInfo,TSKexeACAD,  VER, File, "AcadDocLsp")
        else
 Command=  regUtil::makeAcadRunCommandLine(TSKexeACAD,VER,File),
 regUtil::acadWinExec( Command,1)
 end if,
 !.
   onFileOpen(_Source, _MenuTag).

predicates
    onActivate : documentWindow::activateListener.
clauses
    onActivate(_Source) .
    %       S=  getParent(),
         %MT=mainTaskDilalog::display(Source).% :new(S).



predicates
    onGetFocus : window::getFocusListener.
clauses
    onGetFocus(_Source).



predicates
    onAcadInfoacad : window::menuItemListener.
clauses
    onAcadInfoacad(_Source, _MenuTag) :-
       InfoTask=    infoTask::display(This),
 infoAcad := InfoTask,
 _MessageForm = messageForm::display(This).

% This code is maintained automatically, do not update it manually. 16:26:55-1.10.2017

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("acadStarter"),
        setDecoration(titlebar([closeButton, maximizeButton, minimizeButton])),
        setBorder(sizeBorder()),
        setState([wsf_ClipSiblings]),
        whenCreated(
            {  :-
                projectToolbar::create(getVpiWindow()),
                statusLine::create(getVpiWindow())
            }),
        addSizeListener({  :- vpiToolbar::resize(getVpiWindow()) }),
        setMdiProperty(mdiProperty),
        menuSet(resMenu(resourceIdentifiers::id_TaskMenu)),
        addShowListener(onShow),
        addSizeListener(onSizeChanged),
        addGetFocusListener(onGetFocus),
        addDestroyListener(onDestroy),
        addActivateListener(onActivate),
        addMenuItemListener(resourceIdentifiers::id_help_about, onHelpAbout),
        addMenuItemListener(resourceIdentifiers::id_file_exit, onFileExit),
        addMenuItemListener(resourceIdentifiers::id_file_new, onFileNew),
        addMenuItemListener(resourceIdentifiers::id_file_procifo, onFileProcifo),
        addMenuItemListener(resourceIdentifiers::id_file_open, onFileOpen),
        addMenuItemListener(resourceIdentifiers::id_acad_infoacad, onAcadInfoacad).
% end of automatic code
end implement taskWindow
