/*****************************************************************************

                        Copyright (c) 2012 A&K

******************************************************************************/
class cToolhelp : cToolhelp
    open core

predicates
    %classInfo : core::classInfo.
    % @short Class information  predicate.
    % @detail This predicate represents information predicate of this class.
    % @end



constructors
    new:(toolhelp32_native::snapFlags DwFlag, multiThread_native::processID DwProcessID )  .
    new:(toolhelp32_native::snapFlags DwFlag).
    new:().




end class cToolhelp