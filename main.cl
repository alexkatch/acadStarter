/*****************************************************************************

                        Copyright (c) 2012 A&K

******************************************************************************/
class main
    open core

%predicates
    %classInfo : core::classInfo.
    % @short Class information  predicate.
    % @detail This predicate represents information predicate of this class.
    % @end
predicates
    run : core::runnable.

/*
domains
acad_db=acad_db(string VER,string  ACAD_A001_409  ,string ProductName ,string Location ,string Language ).
acadVerKey=acadVerKey(string Ver,string  ACAD_A001_409).
*/
predicates
getACAD_1:()-> infoTaskTxt::acad_db .
setACAD_1:(infoTaskTxt::acad_db ACAD) procedure(i).

end class main