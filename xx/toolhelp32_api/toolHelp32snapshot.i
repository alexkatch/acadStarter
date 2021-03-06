/*****************************************************************************

                        Copyright © Prolog Development Center A/S

******************************************************************************/

interface toolHelp32snapshot
    open core

domains
    moduleInfo =
        moduleInfo(unsigned ProcessID, pointer ModBaseAddr, unsigned ModBaseSize, hModule HModule, string ModuleName, string ExePath).
    % @short Information about a module.
    % @end

domains
    processInfo =
        processInfo(multiThread_native::processID ProcessID, unsigned Threads, multiThread_native::processID ParentProcessID, multiThread_native::threadPriority PriClassBase, string ExeFileName).
    % @short Information about a process.
    % @end

predicates
    getModule_nd : () -> moduleInfo Info nondeterm.
    % @short Get module information, #Info, from a snapshot, #Snapshot.
    % @end

predicates
    getProcess_nd : () -> processInfo Info nondeterm.
    % @short Get process information, #Info, from a snapshot, #Snapshot.
    % @end

end interface toolHelp32snapshot