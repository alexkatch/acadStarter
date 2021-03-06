/*****************************************************************************

                        Copyright © Prolog Development Center A/S

@short Contains domains and predicates for direct binding to some native Windows32 API Tool Help Functions.

@author PDC
@end

******************************************************************************/
class toolhelp32_native
    open core

predicates
    classInfo : classInfo.
    % @short Class information predicate.
    % @end

domains
    snapshotHandle = handle.

domains
    snapFlags = unsigned.
    % @short Domain for flags for API CreateToolhelp32Snapshot function.
    % @end

constants
    snapHeaplist : snapFlags = 0x00000001.
    snapProcess : snapFlags = 0x00000002.
    snapThread : snapFlags = 0x00000004.
    snapModule : snapFlags = 0x00000008.
    snapModule32 : snapFlags = 0x00000010.
    snapAll : snapFlags = snapHeaplist + snapProcess + snapThread + snapModule.
    inherit : snapFlags = 0x80000000.
    % @short Flags for API CreateToolhelp32Snapshot function.
    % See in MSDN (cf. TH32CS_SNAPHEAPLIST, etc).
    % @end

constants
    max_module_name32 = 255+1.

domains
    moduleEntry32 = moduleEntry32(
        unsigned Size,
        unsigned ModuleID,
        unsigned ProcessID,
        unsigned GlblcntUsage,
        unsigned ProccntUsage,
        pointer ModBaseAddr,
        unsigned ModBaseSize,
        hModule HModule,
        string ModuleName[inline(max_module_name32)],
        string ExePath[inline(fileSystem_native::maxPath)]).
    % @short The first part of a MODULEENTRY32. The real struct contains two additional embedded strings (see details).
    % @detail The first part of a MODULEENTRY32. The struct has this C declaration: <br>
    % typedef struct tagMODULEENTRY32 { <br>
    % DWORD dwSize; <br>
    % DWORD th32ModuleID; <br>
    % DWORD th32ProcessID; <br>
    % DWORD GlblcntUsage; <br>
    % DWORD ProccntUsage; <br>
    % BYTE* modBaseAddr; <br>
    % DWORD modBaseSize; <br>
    % HMODULE hModule; <br>
    % TCHAR szModule[MAX_MODULE_NAME32 + 1]; <br>
    % TCHAR szExePath[MAX_PATH]; <br>
    % } MODULEENTRY32 <br>
    % See MODULEENTRY32 in MSDN.
    % @end

domains
    processEntry32 = processEntry32(
        unsigned Size,
        unsigned Usage_unused,
        multiThread_native::processID ProcessID,
        pointer DefaultHeapID_unused,
        unsigned ModuleID_unused,
        unsigned Threads,
        multiThread_native::processID
        ParentProcessID,
        multiThread_native::threadPriority PriClassBase,
        unsigned Flags_unused,
        string ExeFile [inline(fileSystem_native::maxPath)]).
    % @short The first part of a PROCESSENTRY32. The real struct contains an additional embedded string (see details).
    % @detail The first part of a PROCESSENTRY32. The struct has this C declaration: <br>
    % typedef struct tagPROCESSENTRY32 { <br>
    % DWORD dwSize; <br>
    % DWORD cntUsage; <br>
    % DWORD th32ProcessID; <br>
    % ULONG_PTR th32DefaultHeapID; <br>
    % DWORD th32ModuleID; <br>
    % DWORD cntThreads; <br>
    % DWORD th32ParentProcessID; <br>
    % LONG pcPriClassBase; <br>
    % DWORD dwFlags; <br>
    % TCHAR szExeFile[MAX_PATH]; <br>
    % } PROCESSENTRY32 <br>
    % See PROCESSENTRY32 in MSDN.
    % @end

constants
    currentProcessId : multiThread_native::processID = 0.
    % @short An ProcessID representing the current process.
    % @end

predicates
    createToolhelp32Snapshot : (snapFlags Flags, multiThread_native::processID ProcessId) -> snapshotHandle Handle language apicall.
    % @short The CreateToolhelp32Snapshot function takes a snapshot of the specified processes,
    % as well as the heaps, modules, and threads used by these processes.
    % See CreateToolhelp32Snapshot in MSDN.
    % @end

predicates
    module32First : (snapshotHandle HandleSnapshot, moduleEntry32 Data) -> integer Result language stdcall as decoratedW.
    % @short The Module32First function retrieves information about the first module associated with a process.
    % See Module32First in MSDN.
    % @end

predicates
    module32Next : (snapshotHandle HandleSnapshot, moduleEntry32 Data) -> integer Result language stdcall as decoratedW.
    % @short The Module32Next function retrieves information about the next module associated with a process or thread.
    % See Module32Next in MSDN.
    % @end

predicates
    process32First : (snapshotHandle HandleSnapshot, processEntry32 Data) -> integer Result language stdcall as decoratedW.
    % @short This function retrieves information about the first process encountered in a system snapshot.
    % See Process32First in MSDN.
    % @end

predicates
    process32Next : (snapshotHandle HandleSnapshot, processEntry32 Data) -> integer Result language stdcall as decoratedW.
    % @short This function retrieves information about the next process recorded in a system snapshot.
    % See Process32Next in MSDN.
    % @end

end class toolhelp32_native