/*****************************************************************************

                        Copyright (c) 2012 A&K

******************************************************************************/
class mainTaskDilalog : mainTaskDilalog
    open core

predicates
    classInfo : core::classInfo.
    % @short Class information  predicate. 
    % @detail This predicate represents information predicate of this class.
    % @end

predicates
    display : (window Parent) -> mainTaskDilalog MainTaskDilalog.

constructors
    new : (window Parent).

end class mainTaskDilalog