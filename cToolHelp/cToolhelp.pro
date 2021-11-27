/*****************************************************************************

                        Copyright (c) 2012 A&K

******************************************************************************/

implement cToolhelp
    open core, toolHelp32_native %,toolHelp32snapshot

 facts
  m_hSnaphot:handle :=   invalidHandle.%  uncheckedConvert(handle,0xffffffff).  %INVALID_HANDLE_VALUE erroneous.

clauses
    new(DwFlags,DwProcessID) :-
      m_hSnaphot :=  invalidHandle,%  uncheckedConvert(handle,0xffffffff),  %INVALID_HANDLE_VALUE
      _=createSnapShot(DwFlags,DwProcessID).

   clauses
          new() :-
             m_hSnaphot :=  invalidHandle,
              _=createSnapShot(0, currentProcessId).


    clauses
      new(DwFlags) :-
             m_hSnaphot :=  invalidHandle,
              _=createSnapShot(DwFlags,0).



clauses
  isRunProc(ExeFileName,ExePath)=RET :-
        ThProcesses=cToolHelp::new(toolhelp32_native::snapProcess),
  cToolHelp::processInfo(ProcessID, _Threads, _ParentProcessID,  _PriClassBase,  ExeFileName )=  ThProcesses:  getAllProcess() ,
  ThModules=cToolHelp::new(toolhelp32_native::snapModule,ProcessID),
  RET=ThModules:getModules(),
  cToolHelp::moduleInfo(ProcessID,_ModBaseAddr,_ModBaseSize,_HModule,ExeFileName,ExePath)=RET,
  !.



   isRunAcad(ExePath) =  isRunProc("acad.exe",ExePath).




%%%%%%%%%%%%%%%%%%%%%%%%
  %% destrucor
 clauses
  finalize() :-
  if  (m_hSnaphot <> invalidHandle)    then
  _=fileSystem_native::closeHandle(m_hSnaphot)
  end if.
%     stdio::writef("\nDelete %", className).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clauses
createSnapShot (DwFlags,DwProcessID) =Return  :-
 if  (m_hSnaphot <> invalidHandle)    then % 0xffffffff
_=fileSystem_native::closeHandle(m_hSnaphot)
    end if   ,
 if(DwFlags = 0) then
 m_hSnaphot :=  invalidHandle
  else
  m_hSnaphot := toolhelp32_native::createToolhelp32Snapshot  (DwFlags,DwProcessID) % determ
  end if,
  if(m_hSnaphot <> invalidHandle) then
  Return=b_true
  else
  Return=b_false
  end if
  ,!.
%createSnapShot (_DwFlags,_DwProcessID)=0.
%%%%%%%%%%%%%%%%%%%%%%%%%

% Begin ProcessEntry
clauses
    getAllProcess() = iterate_nd(tryProcess32First, tryProcess32Next).

predicates
    tryProcess32First : () -> processInfo ProcessInfo determ.
clauses
    tryProcess32First() = getProcessInfo(Buffer) :-
        Buffer = allocProcessEntry32(),
        b_false <> process32First(/*snapshot*/   m_hSnaphot, Buffer).

predicates
    tryProcess32Next : () -> processInfo ProcessInfo determ.
clauses
    tryProcess32Next() = getProcessInfo(Buffer) :-
        Buffer = allocProcessEntry32(),
        b_false <> process32Next(/* snapshot */   m_hSnaphot, Buffer).

class predicates
allocModuleEntry32 : () -> moduleEntry32 Buffer.
    %allocProcessEntry32 : () -> pointer Buffer.
clauses
   % allocProcessEntry32() =  allocWithSize( sizeOfDomain(processEntry32)).
   allocModuleEntry32() = uncheckedConvert(moduleEntry32, allocWithSize(sizeOfDomain(moduleEntry32))).

class predicates
    %getProcessInfo : (pointer Buffer) -> processInfo ProcessInfo.
     getProcessInfo : (processEntry32 ProcessEntry32) -> processInfo ProcessInfo.
clauses
 getProcessInfo(processEntry32(_Size, _Usage, ProcessID, _DefaultHeapID, _ModuleID, Threads, ParentProcessID, PriClassBase, _Flags, ExeFileNameNoSafe))
        = processInfo(ProcessID, Threads, ParentProcessID, PriClassBase, string::createCopy(ExeFileNameNoSafe)).


% End ProcessEntry



% <<<<<<<<<<<<<<<<<<<<<Begin ModuleEntry>>>>>>>>>>>>>>>>>>
clauses
    getModules()= iterate_nd(tryModule32First, tryModule32Next).


predicates
    tryModule32First : () -> moduleInfo ModuleInfo determ.
clauses
    tryModule32First() = getModuleInfo(Buffer) :-
        Buffer = allocModuleEntry32(),
        b_false <> module32First(/*snapshot*/  m_hSnaphot, Buffer).

predicates
    tryModule32Next : () -> moduleInfo ModuleInfo determ.
clauses
    tryModule32Next() = getModuleInfo(Buffer) :-
        Buffer = allocModuleEntry32(),
        b_false <> module32Next(/* snapshot */ m_hSnaphot, Buffer).

class predicates
    allocProcessEntry32 : () -> processEntry32 Buffer.
clauses
    allocProcessEntry32() = uncheckedConvert(processEntry32, allocWithSize(sizeOfDomain(processEntry32))).

class predicates

        getModuleInfo : (moduleEntry32 ModuleEntry32) -> moduleInfo ModuleInfo.
clauses
    getModuleInfo(moduleEntry32(_Size, _ModuleID, ProcessID, _GlblcntUsage, _ProccntUsage, ModBaseAddr, ModBaseSize, HModule, ModuleNameNoSafe, ExePathNoSafe))
        = moduleInfo(ProcessID, ModBaseAddr, ModBaseSize, HModule, ModuleName, ExePath) :-
        ModuleName = string::createCopy(ModuleNameNoSafe),
        ExePath = string::createCopy(ExePathNoSafe).

% <<<<<<<<<<<<<End ModuleEntry>>>>>>>>>>>>>>>>>>>>>>

class predicates
    allocWithSize : (byteCount Size) -> pointer Buffer.
clauses
    allocWithSize(Size) = Buffer :-
        Buffer = memory::allocAtomicHeap(Size, memory::contextType_pfc),
        memory::setByteCount(Buffer, Size).
        %memory::setInteger32(Buffer, convert(core::integer32, Size)).

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

end implement cToolhelp
