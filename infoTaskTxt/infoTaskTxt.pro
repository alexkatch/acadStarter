% Copyright (c) 2012
implement infoTaskTxt
    open core

facts
curAcad:integer :=0.
list_acad:acad_db* := [].

clauses
 new():-
    allAcadInDb().

predicates
  allAcadInDb:().

clauses
 allAcadInDb() :-
           ListVerAcad=   acadInfo::getAllAutoCADInf (), % infoAcad=infAcad(unsigned Major,unsigned Minor,platform X,string Location,string ProductName,string Language);nil.
            LV=list::map(ListVerAcad,{(A) =RET :-
              if (A=acadInfo::infAcad(Major,Minor,_Platform,Location,ProductName,Language)) then
                     %Ver=string::format("r%.%",Major,Minor),
                     RET=  acad_db(/*Ver */ r(Major,Minor),ProductName,Location,Language )
                     else
                     RET=  acad_db(/*"" */ r(0,0) ,"","","" )
                     end if
                     }),
               list_acad:=LV.

clauses
     getCurACAD() = list::nth(curAcad,list_acad).
     getAllACAD() = list_acad.
     setCurACAD(I) :-  curAcad := I.

clauses
   isRunCurAcad() :-
   acad_db(_VER,_ProductName ,Location ,_Language )=list::nth(curAcad,list_acad),
   CR=cToolhelp::new(toolhelp32_native::snapProcess),
    LocationAll=string::concat(Location,"\\acad.exe"),
   _=CR:isRunAcad(LocationAll).

clauses
getAllRunACAD () = RET :-
  CR=cToolhelp::new(toolhelp32_native::snapProcess),
  L=list_acad,
 RET=[H || H=list::getMember_nd(L),
                 H =  acad_db(_VER,_ProductName ,Location ,_Language ),
                        _=CR:isRunAcad(string::concat(Location,"\\acad.exe")) ].

end implement infoTaskTxt