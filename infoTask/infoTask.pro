/*****************************************************************************

                        Copyright (c) 2012 A&K

******************************************************************************/

implement infoTask
    inherits formWindow
    open core, vpiDomains ,infoTaskTxt

facts
curAcad:integer :=0.
list_acad:      acad_db* := [].
%acad_db=acad_db( rel VER ,string ProductName ,string Location ,string Language ).

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
           ListVerAcad=   acadInfo::getAllAutoCADInf (), % infoAcad=infAcad(unsigned Major,unsigned Minor,platform X,string Location,string ProductName,string Language);nil.
            LV=list::map(ListVerAcad,{(A) =RET :-
              if (A=acadInfo::infAcad(Major,Minor,_Platform,Location,ProductName,Language)) then
                     %Ver=string::format("r%.%",Major,Minor),
                     RET=  acad_db(r(Major,Minor),/* Ver,*/ProductName,Location,Language )
                     else
                     RET=  acad_db(r(0,0),"","","" )
                     end if
                     }),
               list_acad:=LV.

clauses
     getACAD() = list::nth(curAcad,list_acad).


clauses
   ini_acads() :-
        % L=list::map(list_acad,{(acad_db(_VER,ProductName ,_Location ,_Language ))=ProductName}),
         L=list::map(list_acad,{(acad_db( _VER ,ProductName ,_Location ,_Language ))=ProductName}),
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
        acad_db(VER,_ProductName ,Location ,_Language )=list::nth(curAcad,list_acad),
        if(r(VER1,VER2) =VER) then
        VerTxt =string::format("R(%.%)",Ver1,Ver2)
        else
        VerTxt =""
        end if,
        ver_ctl:setText(VerTxt),
        LocationAcadExe=string::concat(Location,"\\acad.exe"),
        editPatchAcad_ctl:setText(LocationAcadExe),
        if  isRunAcad(string::concat(Location,"\\acad.exe"))  then  %%% ??
         staticTextStatusRun_ctl:setText("RUN")
        else
          staticTextStatusRun_ctl:setText("NO RUN")
        end if ,
        Source:selectAt(Index, true).  %  false

          onListVerSelectionChanged(_Source).

clauses
   isRunAcad(Location) :-
   CR=cToolhelp::new(toolhelp32_native::snapProcess),
   _=CR:isRunProc("acad.exe",Location).

predicates
    onOkClick : button::clickResponder.
clauses
 onOkClick(_Source) = button::defaultAction  :-
        acad_db(_VER,ProductName ,Location ,Language )=list::nth(curAcad,list_acad),
       stdio::writef("\n ProductNAme= %s \n Location: %  ,\n Language: %  ",ProductName , Location , Language),
      AcadExeName = string::concat(Location,"\\acad.exe"),

    if  isRunAcad(string::concat(Location,"\\acad.exe"))  then  %%???

    %%% load lisp etc

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
     main::setACAD_1(AcApp).





% This code is maintained automatically, do not update it manually.
%  13:02:15-23.1.2018

facts
    ok_ctl : button.
    cancel_ctl : button.
    help_ctl : button.
    listButVerAcad_ctl : listButton.
    editPatchAcad_ctl : editControl.
    staticTextStatusRun_ctl : textControl.
    ver_ctl : textControl.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setFont(vpi::fontCreateByName("Tahoma", 8)),
        setText("infoTask"),
        setRect(rct(50, 40, 382, 204)),
        setDecoration(titlebar([closeButton, maximizeButton, minimizeButton])),
        setBorder(sizeBorder()),
        setState([wsf_ClipSiblings, wsf_ClipChildren]),
        menuSet(noMenu),
        addLoseFocusListener(onLoseFocus),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK_Run"),
        ok_ctl:setPosition(8, 142),
        ok_ctl:setSize(32, 12),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::right, control::bottom]),
        ok_ctl:setClickResponder(onOkClick),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Cancel"),
        cancel_ctl:setPosition(48, 142),
        cancel_ctl:setSize(24, 12),
        cancel_ctl:defaultHeight := false,
        cancel_ctl:setAnchors([control::right, control::bottom]),
        help_ctl := button::newOk(This),
        help_ctl:setText("&Help"),
        help_ctl:setPosition(80, 142),
        help_ctl:setSize(32, 10),
        help_ctl:defaultHeight := false,
        help_ctl:setAnchors([control::right, control::bottom]),
        listButVerAcad_ctl := listButton::new(This),
        listButVerAcad_ctl:setPosition(80, 4),
        listButVerAcad_ctl:setWidth(184),
        listButVerAcad_ctl:setMaxDropDownRows(3),
        listButVerAcad_ctl:setAnchors([control::top, control::right]),
        listButVerAcad_ctl:addSelectionChangedListener(onListVerSelectionChanged),
        editPatchAcad_ctl := editControl::new(This),
        editPatchAcad_ctl:setText(""),
        editPatchAcad_ctl:setPosition(4, 48),
        editPatchAcad_ctl:setWidth(264),
        editPatchAcad_ctl:setHeight(14),
        editPatchAcad_ctl:setAnchors([control::left, control::top, control::right]),
        editPatchAcad_ctl:setMultiLine(),
        editPatchAcad_ctl:setReadOnly(),
        StaticText1_ctl = textControl::new(This),
        StaticText1_ctl:setText("STATUS ="),
        StaticText1_ctl:setPosition(4, 70),
        StaticText1_ctl:setSize(40, 10),
        StaticText_ctl = textControl::new(This),
        StaticText_ctl:setText("Product autoCAD"),
        StaticText_ctl:setPosition(4, 6),
        StaticText_ctl:setSize(60, 12),
        StaticText_ctl:setAnchors([control::top]),
        staticTextStatusRun_ctl := textControl::new(This),
        staticTextStatusRun_ctl:setText("run"),
        staticTextStatusRun_ctl:setPosition(52, 70),
        staticTextStatusRun_ctl:setSize(32, 10),
        StaticText2_ctl = textControl::new(This),
        StaticText2_ctl:setText("Location"),
        StaticText2_ctl:setPosition(12, 26),
        StaticText2_ctl:setSize(56, 10),
        StaticText2_ctl:setAnchors([control::top]),
        ver_ctl := textControl::new(This),
        ver_ctl:setText("00.00"),
        ver_ctl:setPosition(150, 68),
        ver_ctl:setSize(40, 10),
        VerTxt_ctl = textControl::new(This),
        VerTxt_ctl:setText("Ver="),
        VerTxt_ctl:setPosition(124, 68),
        VerTxt_ctl:setSize(20, 10).
% end of automatic code
end implement infoTask
