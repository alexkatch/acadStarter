/*****************************************************************************

                        Copyright (c) 2012 A&K

******************************************************************************/

implement infoTask
    inherits formWindow
    open core

constants
    %className = "com/visual-prolog/infoTask/infoTask".
    %classVersion = "$JustDate: $666$Revision: $777".

clauses
    %classInfo(className, classVersion).
/*
domains
acad_db=acad_db(string VER,string  ACAD_A001_409  ,string ProductName ,string Location ,string Language ).
acadVerKey=acadVerKey(string Ver,string  ACAD_A001_409).
*/
facts
curAcad:integer :=0.
list_acad:acad_db* := [].


clauses
    display(Parent) = Form :-
        Form = new(Parent),
        Form:show().

clauses
    new(Parent):-
        formWindow::new(Parent),
        generatedInitialize(),
my_ini().

predicates
    my_ini:().
    ini_acads:().
    allAcadInDb:().


    clauses
    allAcadInDb() :-
   ListVerAcad=  regUtil::getAllAcadReleaseList(), % 12.5 12.6 ETC

        %ListVerAcad2=   acadInfo::getAllAutoCADInf (), % infoAcad=infAcad(unsigned Major,unsigned Minor,platform X,string Location,string ProductName,string Language);nil.
        /*
        LV1=list::map(ListVerAcad2,{(infAcad(Major,Minor,Platform,Location,ProductName,Language)) =RET :-
                     Ver=string::format("r%.%",Major,Minor),
                     RET=  acad_db(Ver,ProductName,Location,Language ) }),
*/
        LA=list::map(ListVerAcad,{(VER)=RET  :-     LACAD_A001_409 =regUtil::getAcad(VER),
                                                 RET=   [acadVerKey(VER,KEY)  || KEY=list::getMember_nd(LACAD_A001_409) ]   } ), % СПИСОК kEYS

       R=list::appendList(LA),%        N=list::length(R),
        LV=  list::map(R,{ (acadVerKey(VER,K))=  RET  :-
                              regUtil::getAllInfoAcad(VER, K  ,ProductName ,Location ,Language ),

                               RET=  acad_db(VER,ProductName,Location,Language ) }),






                               list_acad:=LV.



clauses
     getACAD() = list::nth(curAcad,list_acad).


clauses
   ini_acads() :-
         L=list::map(list_acad,{(acad_db(_VER,ProductName ,_Location ,_Language ))=ProductName}),
         %%
       listButVerAcad_ctl:addList(L),
      listButVerAcad_ctl:selectAt(0,true).

    my_ini() :-
      allAcadInDb(),
      ini_acads().

predicates
    onListVerSelectionChanged : listControl::selectionChangedListener.
    isRunAcad:(string Location) determ (i).
clauses
    onListVerSelectionChanged(Source) :-
     Index = Source:tryGetSelectedIndex(),
        !,
        curAcad :=Index,
        acad_db(_VER,_ProductName ,Location ,_Language )=list::nth(curAcad,list_acad),
        editPatchAcad_ctl:setText(Location),
        if  isRunAcad(string::concat(Location,"acad.exe"))  then
         staticTextStatusRun_ctl:setText("RUN")
        else
          staticTextStatusRun_ctl:setText("NO RUN")
        end if ,
        Source:selectAt(Index, true).  %  false
          onListVerSelectionChanged(_Source).

clauses
   isRunAcad(Location) :-
   CR=cToolhelp::new(toolhelp32_native::snapProcess),
   CR:isRunProc("acad.exe",Location).

predicates
    onOkClick : button::clickResponder.
clauses
 onOkClick(_Source) = button::defaultAction  :-
        acad_db(_VER,ProductName ,Location ,Language )=list::nth(curAcad,list_acad),
       stdio::writef("\n ProductNAme= %s \n Location: %  ,\n Language: %  ",ProductName , Location , Language),
      AcadExeName = string::concat(Location,"acad.exe"),

    if  isRunAcad(string::concat(Location,"acad.exe"))  then

        else
         %makeAcadRunCommandLine(AcadExe, DwgFile)
      regUtil::acadWinExec( AcadExeName,1)
        end if ,!.




  onOkClick(_Source) =button::defaultAction.








predicates
    onLoseFocus : window::loseFocusListener.
clauses
    onLoseFocus(_Source) :-
%      App= editPatchAcad_ctl:getText(),
      AcApp = list::nth(curAcad,list_acad),
     main::setACAD(AcApp).





% This code is maintained automatically, do not update it manually. 18:53:45-28.3.2016
facts
    ok_ctl : button.
    cancel_ctl : button.
    help_ctl : button.
    listButVerAcad_ctl : listButton.
    editPatchAcad_ctl : editControl.
    staticTextStatusRun_ctl : textControl.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize():-
        setFont(vpi::fontCreateByName("Tahoma", 8)),
        setText("infoTask"),
        setRect(rct(50,40,382,204)),
        setDecoration(titlebar([closeButton,maximizeButton,minimizeButton])),
        setBorder(sizeBorder()),
        setState([wsf_ClipSiblings,wsf_ClipChildren]),
        menuSet(noMenu),
        addLoseFocusListener(onLoseFocus),
        StaticText_ctl = textControl::new(This),
        StaticText_ctl:setText("AutoCAD"),
        StaticText_ctl:setPosition(8, 6),
        StaticText_ctl:setSize(52, 12),
        staticTextStatusRun_ctl := textControl::new(This),
        staticTextStatusRun_ctl:setText("run"),
        staticTextStatusRun_ctl:setPosition(276, 26),
        staticTextStatusRun_ctl:setSize(40, 12),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK_Run"),
        ok_ctl:setPosition(8, 142),
        ok_ctl:setSize(32, 12),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::right,control::bottom]),
        ok_ctl:setClickResponder(onOkClick),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Cancel"),
        cancel_ctl:setPosition(48, 142),
        cancel_ctl:setSize(24, 12),
        cancel_ctl:defaultHeight := false,
        cancel_ctl:setAnchors([control::right,control::bottom]),
        help_ctl := button::newOk(This),
        help_ctl:setText("&Help"),
        help_ctl:setPosition(80, 142),
        help_ctl:setSize(32, 10),
        help_ctl:defaultHeight := false,
        help_ctl:setAnchors([control::right,control::bottom]),
        listButVerAcad_ctl := listButton::new(This),
        listButVerAcad_ctl:setPosition(72, 6),
        listButVerAcad_ctl:setWidth(184),
        listButVerAcad_ctl:setMaxDropDownRows(3),
        listButVerAcad_ctl:addSelectionChangedListener(onListVerSelectionChanged),
        editPatchAcad_ctl := editControl::new(This),
        editPatchAcad_ctl:setText(""),
        editPatchAcad_ctl:setPosition(4, 24),
        editPatchAcad_ctl:setWidth(264),
        editPatchAcad_ctl:setHeight(14),
        editPatchAcad_ctl:setMultiLine(),
        editPatchAcad_ctl:setReadOnly().
% end of automatic code
end implement infoTask
