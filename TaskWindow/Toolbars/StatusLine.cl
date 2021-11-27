/*****************************************************************************

                        Copyright (c) 2012 A&K

******************************************************************************/
class statusLine
    open core

predicates
    %classInfo : core::classInfo.
    % @short Class information  predicate.
    % @detail This predicate represents information predicate of this class.
    % @end

predicates
    create : (vpiDomains::windowHandle Parent).

end class statusLine