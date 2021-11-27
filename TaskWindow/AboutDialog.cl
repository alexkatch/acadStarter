/*****************************************************************************

                        Copyright (c) 2012 A&K

******************************************************************************/
class aboutDialog : aboutDialog
    open core

predicates
    %classInfo : core::classInfo.
    % @short Class information  predicate.
    % @detail This predicate represents information predicate of this class.
    % @end

predicates
    display : (window Parent) -> aboutDialog AboutDialog.

constructors
    new : (window Parent).

end class aboutDialog