/*****************************************************************************

                        Copyright (c) 2012 A&K

******************************************************************************/

interface cToolhelp
    open core


domains
    moduleInfo =
        moduleInfo(unsigned ProcessID, pointer ModBaseAddr, unsigned ModBaseSize, hModule HModule, string ModuleName, string ExePath).
    % @short Information about a module.
    % @end


    processInfo =
        processInfo(multiThread_native::processID ProcessID, unsigned Threads, multiThread_native::processID ParentProcessID, multiThread_native::threadPriority PriClassBase, string ExeFileName).
    % @short Information about a process.
    % @end


      predicates
    createSnapShot:(toolhelp32_native::snapFlags DwFlag, multiThread_native::processID DwProcessID )-> core::booleanInt   procedure (i,i).
    %processFirst:(/* toolhelp32_native::processEntry32_prefix PPE */) -> core::booleanInt nondeterm ().
    getModules:()-> moduleInfo Info nondeterm.
    getAllProcess:()-> processInfo  Info nondeterm.
     isRunProc:(string ExeModul,string Location)-> moduleInfo  determ (i,i).
     isRunAcad:(string Location)->moduleInfo  determ (i).






end interface cToolhelp