% Copyright (c) 2012

interface infoTaskTxt
    open core


domains
rel =r(unsigned Major,unsigned Minor).
acad_db=acad_db( rel VER ,string ProductName ,string Location ,string Language ).
acadVerKey=acadVerKey(string Ver,string  ACAD_A001_409).


predicates
    getAllACAD:()-> acad_db*.
    getAllRunACAD:()->acad_db*.

    getCurAcad:() -> acad_db.
    setCurAcad:(integer I [in]).
     %isRunAcad:(string Location) determ (i).
     isRunCurAcad:() determ().




end interface infoTaskTxt