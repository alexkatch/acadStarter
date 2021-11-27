/*****************************************************************************

                        Copyright (c) 2012 A&K

******************************************************************************/
class infoTask : infoTask
    open core

predicates
    %classInfo : core::classInfo.
    % @short Class information  predicate.
    % @detail This predicate represents information predicate of this class.
    % @end
/*
 domains
acad_db=acad_db(string VER,string  ACAD_A001_409  ,string ProductName ,string Location ,string Language ).
acadVerKey=acadVerKey(string Ver,string  ACAD_A001_409).
*/


predicates
    display : (window Parent) -> infoTask InfoTask.

constructors
    new : (window Parent).

end class infoTask