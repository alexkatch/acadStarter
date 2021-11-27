/*****************************************************************************

                        Copyright (c) 2012 A&K

******************************************************************************/

implement main
    open core

  class facts - startup
  %cmd_line:string := "".
  acadApp: infoTaskTxt::acad_db := erroneous.

 clauses
     getACAD_1()=acadApp.

setACAD_1(ACAD) :-
      acadApp := ACAD.

clauses
    run():-

        TaskWindow = taskWindow::new(),
        TaskWindow:show().
end implement main

goal
    mainExe::run(main::run).
