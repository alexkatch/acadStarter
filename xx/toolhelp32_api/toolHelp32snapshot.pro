/*****************************************************************************

                        Copyright © Prolog Development Center A/S

******************************************************************************/

implement toolHelp32snapshot
    open core, toolhelp32_native

constants
    className = "com/visual-prolog/pfc/windowsapi/toolhelp32_api/toolHelp32snapshot".
    classVersion = "$JustDate: 2010-03-09 $$Revision: 9 $".

facts
    snapshot : snapshotHandle.

clauses
    new() :-
        newInner(snapModule + snapProcess, currentProcessId).

clauses
    newModuleInfo() :-
        newInner(snapModule, currentProcessId).

clauses
    newProcessInfo() :-
        newInner(snapProcess, currentProcessId).

constructors
    newInner : (snapFlags Flags, multiThread_native::processID ProcessId).
clauses
    newInner(Flags, ProcessId) :-
        snapshot := toolhelp32_native::createToolhelp32Snapshot(Flags, ProcessId).
        % ###### TODO: must check for <> invalidHandleValue

% Begin ModuleEntry
clauses
    getModule_nd() = iterate_nd(tryModule32First, tryModule32Next).

predicates
    tryModule32First : () -> moduleInfo ModuleInfo determ.
clauses
    tryModule32First() = getModuleInfo(Buffer) :-
        Buffer = allocModuleEntry32(),
        b_false <> module32First(snapshot, Buffer).

predicates
    tryModule32Next : () -> moduleInfo ModuleInfo determ.
clauses
    tryModule32Next() = getModuleInfo(ModuleInfo32) :-
        ModuleInfo32 = allocModuleEntry32(),
        b_false <> module32Next(snapshot, ModuleInfo32).

class predicates
    allocModuleEntry32 : () -> moduleEntry32 Buffer.
clauses
    allocModuleEntry32() = uncheckedConvert(moduleEntry32, allocWithSize(sizeOfDomain(moduleEntry32))).

class predicates
    getModuleInfo : (moduleEntry32 ModuleEntry32) -> moduleInfo ModuleInfo.
clauses
    getModuleInfo(moduleEntry32(_Size, _ModuleID, ProcessID, _GlblcntUsage, _ProccntUsage, ModBaseAddr, ModBaseSize, HModule, ModuleNameNoSafe, ExePathNoSafe))
        = moduleInfo(ProcessID, ModBaseAddr, ModBaseSize, HModule, ModuleName, ExePath) :-
        ModuleName = string::createCopy(ModuleNameNoSafe),
        ExePath = string::createCopy(ExePathNoSafe).
% End ModuleEntry

% Begin ProcessEntry
clauses
    getProcess_nd() = iterate_nd(tryProcess32First, tryProcess32Next).

predicates
    tryProcess32First : () -> processInfo ProcessInfo determ.
clauses
    tryProcess32First() = getProcessInfo(Buffer) :-
        Buffer = allocProcessEntry32(),
        b_false <> process32First(snapshot, Buffer).

predicates
    tryProcess32Next : () -> processInfo ProcessInfo determ.
clauses
    tryProcess32Next() = getProcessInfo(Buffer) :-
        Buffer = allocProcessEntry32(),
        b_false <> process32Next(snapshot, Buffer).

class predicates
    allocProcessEntry32 : () -> processEntry32 Buffer.
clauses
    allocProcessEntry32() = uncheckedConvert(processEntry32, allocWithSize(sizeOfDomain(processEntry32))).

class predicates
    getProcessInfo : (processEntry32 ProcessEntry32) -> processInfo ProcessInfo.
clauses
    getProcessInfo(processEntry32(_Size, _Usage, ProcessID, _DefaultHeapID, _ModuleID, Threads, ParentProcessID, PriClassBase, _Flags, ExeFileNameNoSafe))
        = processInfo(ProcessID, Threads, ParentProcessID, PriClassBase, string::createCopy(ExeFileNameNoSafe)).
% End ProcessEntry

class predicates
    allocWithSize : (byteCount Size) -> pointer Buffer.
clauses
    allocWithSize(Size) = Buffer :-
        Buffer = memory::allocAtomicHeapProfile(Size, memory::contextType_pfc),
        memory::setInteger32(Buffer, convert(integer32, Size)).

% iteration support
domains
    tryGetOne{Elem} = () -> Elem determ.

class predicates
    iterate_nd : (tryGetOne{Elem} TryGetFirst, tryGetOne{Elem} TryGetNext) -> Elem Value nondeterm.
clauses
    iterate_nd(TryGetFirst, TryGetNext) = iterate_rest(TryGetFirst(), TryGetNext).

class predicates
    iterate_rest : (Elem Found, tryGetOne{Elem} TryGetNext) -> Elem Value multi.
clauses
    iterate_rest(Found, _TryGetNext) = Found.
    iterate_rest(_Found, TryGetNext) = iterate_rest(TryGetNext(), TryGetNext).

clauses
    finalize() :-
        _BOOL = fileSystem_native::closeHandle(snapshot).

clauses
    classInfo(className, classVersion).

end implement toolHelp32snapshot
