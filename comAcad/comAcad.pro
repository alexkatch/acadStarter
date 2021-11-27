% Copyright (c) 2012

implement comAcad
    open core

clauses
runAcad(ExePAtch,PROGID) :-!.

/*
typedef struct _STARTUPINFOW {
    DWORD   cb; <-  1
    LPWSTR  lpReserved; 2
    LPWSTR  lpDesktop; 3
    LPWSTR  lpTitle; 4
    DWORD   dwX; 5
    DWORD   dwY;  6
    DWORD   dwXSize; 7
    DWORD   dwYSize; 8
    DWORD   dwXCountChars; 9
    DWORD   dwYCountChars; 10
    DWORD   dwFillAttribute; 11
    DWORD   dwFlags; <- 12
    WORD    wShowWindow; <- 13
    WORD    cbReserved2; 14
    LPBYTE  lpReserved2; 15
    HANDLE  hStdInput; 16
    HANDLE  hStdOutput; 17
    HANDLE  hStdError; 18
} STARTUPINFOW, *LPSTARTUPINFOW;

STARTUPINFO Start;
PROCESS_INFORMATION ProcInfo;
ZeroMemory(&Start,sizeof(STARTUPINFO));
Start.cb=sizeof(Start);
Start.dwFlags = STARTF_USESHOWWINDOW;
Start.wShowWindow = SW_MAXIMIZE;
//Change the path to ACAD as needed...
TCHAR pszExcelPath[] = _T("c:/Program Files/Autodesk/AutoCAD 2013/acad.exe");
//#define DEBUG_PROCESS                     0x00000001
BOOL fSuccess= ::CreateProcess(NULL, pszExcelPath, NULL, NULL,FALSE,NORMAL_PRIORITY_CLASS, NULL, NULL, &Start, &ProcInfo);

if((::WaitForInputIdle(ProcInfo.hProcess, 10000))==WAIT_TIMEOUT)
{
    ::MessageBox(NULL, L"Timed out waiting for Acad.", NULL,MB_OK);
}
*/
%                                          1          2         3       4    5            6                                  7      8        9          10
%FSuccess= createProcess(NULL, pszExcelPath, NULL, NULL,FALSE,NORMAL_PRIORITY_CLASS, NULL, NULL, &Start, &ProcInfo);
 %ensureNotStarted(),
   %     F01 = completeStdHandles(),
    %    getShowWindow(F02, ShowWindow),
    %getCoordinates(F03, X, Y, XSize, YSize),
    %    getFillColorAttribute(F04, FillColorAttribute),
      %  Flags = bit::bitOr(F01, F02, F03, F04),
      /*
        ProcInfo = memory::alloc_atomic(memory::contextType_application),
        Start =
    multiThread_native::startupinfo(sizeofdomain(multiThread_native::startupinfo), null, nullString, nullString, X, Y, XSize, YSize, 0, 0,
          FillColorAttribute, Flags, ShowWindow, 0, null, processStdIn, processStdOut, processStdErr),
      getEnvironmentBlock(Flag, Environment),
    Result =
    multiThread_native::createProcess(/*applicationName */, ExePath, null, null,boolean::toBooleanInt(false), getCreationFlags(Flag),
        null, null, Start, ProcessInfo),
        % get error immediately (in case we need it)
        Error = exception::getLastError(),
        closeHandle(processStdIn),
        closeHandle(processStdOut),
        closeHandle(processStdErr),
        if b_false = Result then
            close(),
            exception::raise_nativeCallException("CreateProcess", Error,
                [namedValue(useExe_exception::filename_parameter, string(applicationName)), namedValue("commandLine", string(commandLine))])
        end if,
        multiThread_native::processInformation(ProcessHandle, ThreadHandle, ProcessId, ThreadId) = ProcessInformation,
        threadHandle := ThreadHandle,
        processId := ProcessId,
        threadId := ThreadId,
        delegateSyncObject_fact := syncObject::new(ProcessHandle, true).






*/





end implement comAcad