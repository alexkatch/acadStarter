/*****************************************************************************

                        Copyright © Prolog Development Center A/S

******************************************************************************/
class toolHelp32snapshot : toolHelp32snapshot
    open core

constructors
    new : ().
    % @short Create a snapshot with info about modules and processes
    % @end

constructors
    newModuleInfo : ().
    % @short Create a snapshot with info about modules
    % @end

constructors
    newProcessInfo : ().
    % @short Create a snapshot with info about processes
    % @end

predicates
    classInfo : core::classInfo.
    % @short Class information predicate.
    % @end

end class toolHelp32snapshot