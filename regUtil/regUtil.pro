/*****************************************************************************

                        Copyright (c) 2012 A&K

******************************************************************************/
implement regUtil
    open core,infoTaskTxt



%class predicates
   % prologWinExec : (string CMD, integer SHOW) determ.
clauses
    acadWinExec(CMD,_SHOW) :-
        try
           USEEXE = useEXE::new(CMD),
%           USEEXE:setCurrentDirectory(CURDIR),
            USEEXE:run(),
            USEEXE:close()
        catch _ do
            messageBox::displayError(string::format("Can't execute:\n%s",CMD)),
            fail()
%        finally
        %
        %winexec_succes(CMD,RES),!,
        % vfile::txt("system_call",SC),
        % vedlg::remarkmsg(SC)
        end try.

   clauses
      makeAcadRunCommandLine(AcadExe,_Ver, DwgFile)=RET  :-
          file::existExactFile(DwgFile),
      RET= string::concat(AcadExe," \"",DwgFile,"\"  /nologo"),!.

      makeAcadRunCommandLine(AcadExe,_Ver, _DwgFile)=RET :-
      Template= "C:\\Documents and Settings\\Admin\\Local Settings\\Application Data\\Autodesk\\AutoCAD 2012 - English\\R18.2\\enu\\Template\\acad.dwt",
      RET= string::concat(AcadExe,"  /t ",Template," /nologo").


clauses
 normalizeLinux(FileName) = FileNameOut :-
        NewFileName = string::replaceAll(FileName, "\\", "/"),
        FileNameOut =
            if FileName = NewFileName then
                FileName
            else
                normalizeLinux(NewFileName)
            end if.


clauses
 %HKEY_LOCAL_MACHINE\SOFTWARE\Autodesk\AutoCAD\R18.2\ACAD-A001:409
 %L=  registry::getAllValues( registry::localMachine(),  "SOFTWARE\\Autodesk\\AutoCAD"),!.%\\ProductName").

getAllAcadReleaseList () =L :-   % ->["R18.1","R18.2"]
  try % попытка
       %L=registry::getSubkeys(registry::localMachine(),"SOFTWARE\\Autodesk\\AutoCAD")
       L=registry::getSubkeys(registry::currentUser(),"SOFTWARE\\Autodesk\\AutoCAD")
  catch _ do % улавливаем ошибку
   L=[]
   % finally
   end try.

clauses
% "ACAD_A001:409" -> "A001"  "409"
getProductCodeAndLocalizationCode(ACAD_A001_409,Product,LocalCode) :-
    Len=string::length(ACAD_A001_409),
    P=string::search(ACAD_A001_409,":") ,
    Product=string::subString(ACAD_A001_409,0,P),
    LocalCode=string::subString(ACAD_A001_409,P+1,Len-P-1).
%getProductCodeAndLocalizationCode(_ACAD_A001_409,"","").




clauses
getAcad(VER) =L :- % -> ["ACAD-A001:409","ACAD-A004:409"]  PRODUCTCODE:LOCALIZATIONCODE
  try
    %L =registry::getSubkeys(registry::localMachine(),string::concat( "SOFTWARE\\Autodesk\\AutoCAD\\",VER))
    L1 =registry::getSubkeys(registry::currentUser(),string::concat( "SOFTWARE\\Autodesk\\AutoCAD\\",VER)),
    %f N=string::search(VER,":") then
L=[X||X in L1 ,   _=string::search(X,":")  ] % list::map(L1,{ (A):- _=string::search(A,":") })
    %end if

  catch _ do
  L=[]
%finally
end try.



getAllInfoAcad(VER,ACAD_A000, ProductName , Location , Language) :-
  %KEY=string::concat( "SOFTWARE\\Autodesk\\AutoCAD\\",VER,"\\",ACAD_A000),
%string( ProductName)=registry::tryGetValue(registry::localMachine(),KEY,"ProductName"),
%string(Location)=registry::tryGetValue(registry::localMachine(),KEY,"Location"),
%string(Language)=registry::tryGetValue(registry::localMachine(),KEY,"Language"),!.
getProductCodeAndLocalizationCode(ACAD_A000,Product,_LocalCode),
KEY_LANG=string::concat( "SOFTWARE\\Autodesk\\AutoCAD\\",VER), %запущенный-выпускаемый
KEY_Location=string::concat( "SOFTWARE\\Autodesk\\AutoCAD\\",VER,"\\",Product,"\\Install"),
%string( ProductName)=registry::tryGetValue(registry::currentUser(),KEY,"ProductName"),
string(Location)=registry::tryGetValue(registry::currentUser(),KEY_Location,"INSTALLDIR"),      % " "Location"), ->C:\Program Files\Autodesk\AutoCAD 2013\
string(Language)=registry::tryGetValue(registry::currentUser(),KEY_LANG, "LastLaunchedLanguage"), %"Language"),
%directory::getSubDirectories_nd
% удаляем последний флеш
 %ProductName = fileName::getName(Location),
 ProductName=fileName::getLastDirectory(Location,_Start),
!.

getAllInfoAcad(VER,ACAD_A000, ProductName , Location , Language) :-
getProductCodeAndLocalizationCode(ACAD_A000,_Product,_LocalCode),
KEY_LANG=string::concat( "SOFTWARE\\Autodesk\\AutoCAD\\",VER,"\\",ACAD_A000), %запущенный-выпускаемый
KEY_Location=string::concat( "SOFTWARE\\Autodesk\\AutoCAD\\",VER,"\\",ACAD_A000,"\\Applications\\AcMr"),
%string( ProductName)=registry::tryGetValue(registry::currentUser(),KEY,"ProductName"),
string(Location1)=registry::tryGetValue(registry::currentUser(),KEY_Location,"LOADER"),      % " "Location"), ->C:\Program Files\Autodesk\AutoCAD 2013\
%%->D:\Program Files\Autodesk\AutoCAD 2012 - English\AcMr.dll
Location=filename::getPath(Location1),
ProductName=fileName::getLastDirectory(Location,_Start),
string(Language2)=registry::tryGetValue(registry::currentUser(),KEY_LANG, "AllUsersFolder"), %"Language"),
Language=fileName::getLastDirectory(Language2,_Start2),

%directory::getSubDirectories_nd
% удаляем последний флеш
 %ProductName = fileName::getName(Location),
!.





getAllInfoAcad(_VER,_ACAD_A000, "" , "" , "") .


clauses
%insertDwgInRunningAcad:(string AcadAppString, /* string AcadVersion */ infoTaskTxt::rel  Release, string DwgName) procedure (i,i,i).
insertDwgInRunningAcad(  _AcadAppString,/*AcadVersion  */ r(Major,_Minor), DwgName) :-
AcadVersMajor=string::format("r%",Major),
ACAD=string::concat("AutoCAD.",AcadVersMajor,".DDE"),
	vpiDde::init([vpidde::f_clientonly]),
    try  Conv = vpiDde::setConnect(ACAD, "System"),
       %if trap(Conv = vpiDde::setConnect(ACAD, "System"), _, fail) then
        %Requests(прошение a value from a server.
%        Command = string::format( "(setvar \"cmdecho\"  0)\n_.LINE 100.0,100 0,0 \n(setq x 100.0)\n"),
DwgNameNorm=filename::normalize(DwgName),
DwgNameLinux=normalizeLinux(DwgNameNorm),
        Command = string::format("(command) (command) (command  \"_.insert\"  \"%\"  pause)\n",DwgNameLinux),
           %Command = string::format( "(setvar \"cmdecho\"  0)\n-INSERT  % \n", DwgNameLinux),
            _ = vpiDde::execute(Conv, Command, 0),
            vpiDde::disConnect(Conv)
        %else
         catch  Error  do
            exceptionDump::dumpToStdOutput(Error),
            %succeed()
            stdio::writef( "Acad not running\n")
        end try.

            %
           %stdio::writef( "Acad not running\n")
%        end if.


clauses
 openDwgInRunningAcad(ModuleInfo,_AcadAppString,r(Major,_Minor) , DwgName, _AcadDocLsp) :-
 AcadVersMajor=string::format("r%",Major),
 ACAD=string::concat("AutoCAD.",AcadVersMajor,".DDE"),
	vpiDde::init([vpidde::f_clientonly]),

       try  Conv = vpiDde::setConnect(ACAD, "System"),
DwgNameNorm=filename::normalize(DwgName),
DwgNameLinux=normalizeLinux(DwgNameNorm),
    Command = string::format("(command)(command)(vla-activate (vla-open (vla-get-documents (vla-get-application (vlax-get-acad-object))) \"%\"))\n",DwgNameLinux),
                       %(command)(command)(vla-activate (vla-open (vla-get-documents (vla-get-application (vlax-get-acad-object)))  \"%\"))\n",DwgNameLinux),
            _ = vpiDde::execute(Conv, Command, 0),
            %vpiDde::disConnect(Conv)
        %catch  Error do
       % exceptionDump::dumpToStdOutput(Error),
          % stdio::writef( "Acad not running\n")
        %end try,
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% подождать пока загрузиться файл
cToolhelp::moduleInfo(ProcessID,_ModBaseAddr, _ModBaseSize,_HModule, _ModuleName, _ExePath)=ModuleInfo,
H=multiThread_native::openProcess(2097151,1 /* core::booleanInt */,ProcessID),
if(gui_native::waitForInputIdle(H,10000)=winErrors::wait_timeout) then
   %_=gui_api::messageBox(null,"Timed out waiting for Acad.exe", null, 0) % MB_OK);
  _=vpiCommonDialogs::messageBox("Ok", "Timed out waiting for Acad.exe?",
                vpiDomains::mesbox_iconQuestion, vpiDomains::mesbox_buttonsYesNo, vpiDomains::mesbox_defaultFirst,
              vpiDomains::mesbox_suspendApplication)
end if,
_=fileSystem_native::closeHandle(H),
  %gui_native::waitForInputIdle(    winErrors::wait_timeout
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %vpiDde::init([vpidde::f_clientonly]),
        %%%%%% Загружаем файл acadDoc.lsp
        %vpiDde::init([vpidde::f_clientonly]),
        AcadLsp=  makeAcadDocLsp::getAcadDocLisp(),

    %try  Conv2 = vpiDde::setConnect(ACAD, "System"),
     %       if not(isErroneous(AcadLsp)) then
                CommandLoadLisp = string::format("(load   \"%\")\n",AcadLsp),
               _ = vpiDde::execute(Conv, CommandLoadLisp, 0),
    %end if,

      vpiDde::disConnect(Conv)

     catch  Error do
        exceptionDump::dumpToStdOutput(Error),
           stdio::writef( "Acad not running\n")
        end try.


clauses

openDwgInRunningAcad_0(_AcadAppString,_W/*r(Major,Minor)*/ , DwgName, _AcadDocLsp) :-

DwgNameNorm=filename::normalize(DwgName),
DwgNameLinux=normalizeLinux(DwgNameNorm).







clauses
newDwgInRunningAcad(_AcadAppString, r(Major,_Minor), DwgName, _AcadDocLsp) :-
AcadVersMajor=string::format("r%",Major),
 ACAD=string::concat("AutoCAD.",AcadVersMajor,".DDE"),
	vpiDde::init([vpidde::f_clientonly]),
        try Conv = vpiDde::setConnect(ACAD, "System"),
DwgNameNorm=filename::normalize(DwgName),
DwgNameLinux=normalizeLinux(DwgNameNorm),
        Command = string::format("(command)(command)(vla-activate (vla-open (vla-get-documents (vla-get-application (vlax-get-acad-object)))  \"%\"))\n",DwgNameLinux),
            _ = vpiDde::execute(Conv, Command, 0),
            vpiDde::disConnect(Conv)
        catch  Error do
            exceptionDump::dumpToStdOutput(Error),
           stdio::writef( "Acad not running\n")
        end try.






  /*
  getActiveAcadOleObject(AcadApp)=AcdAppVariant :-

      CLSID = guid::toNativeGuid("{000209FF-0000-0000-C000-000000000046}"),
        IUnknown = comCreation::createInstance(CLSID, iDispatch::iid),
        IDispatchWord = uncheckedConvert(iDispatch,IUnknown),
        ComDispInterfaceWord = comDispInterface::new(IDispatchWord),
           ComDispInterfaceWord:setProperty("Visible", comDomains::byte(1)),
           ComDispInterfaceWord:getProperty("Documents", comDomains::iDispatch(IDispatchDocuments)),
       ComDispInterfaceDocuments = comDispInterface::new(IDispatchDocuments),
       ComDispInterfaceDocuments:invokeMethod("Add",[]).
*/

  /*
  AfxGetApp()->m_pszExeName; // Get the "MyExe" portion of "MyExe.exe". Or, "MyDll" if RunDll32 is used.

dllName.Append( ".exe" ); // Now has "MyExe.exe" (or "MyDll.dll").

HMODULE hmod = GetModuleHandle(dllName);

CString fullPath;
DWORD pathLen = ::GetModuleFileName( hmod, fullPath.GetBufferSetLength(MAX_PATH+1), MAX_PATH); // hmod of zero gets the main EXE
fullPath.ReleaseBuffer( pathLen ); // Note that ReleaseBuffer doesn't need a +1 for the null byte.
  */







    /*
      procedure GetAcadReleaseList(const Rel: string);
  var
    r: TRegistry;
    s,
      rList: TStringList;
    i,
      c: integer;
  begin
    r := TRegistry.Create;
    r.RootKey := HKEY_LOCAL_MACHINE;
    s := TStringList.Create;
    rList := TStringList.Create;
    if r.OpenKey(keyAcadRegRoot, false)
      then begin
      r.GetKeyNames(s);
      r.CloseKey;
      for i := 0 to s.Count - 1 do
        if (AnsiStrLIComp(pchar(Rel), pchar(s[i]), length(Rel)) = 0)
          then rList.Add(keyAcadRegRoot + '\' + s[i]);
      for i := 0 to rList.Count - 1 do begin
        r.CloseKey;
        r.OpenKey(rList[i], false);
        s.Clear;
        r.GetKeyNames(s);
        for c := 0 to s.Count - 1 do begin
          if (AnsiStrLIComp('ACAD', pchar(s[c]), 4) = 0)
            then begin
            r.CloseKey;
            if r.OpenKey(rList[i] + '\' + s[c], false)
              then begin
                    {
                    lst.Add(r.ReadString('ProductName')+' '+
                               r.ReadString('Language')+'='+
                               NormalDir(r.ReadString('AcadLocation'))+
                               'acad.exe')+';'+s[c];
                    }
              lst.Add(copy(rList[i], (LastDelimiter('\', rList[i]) + 1), maxInt) + '\' +
                s[c] + '=' +
                r.ReadString('ProductName') + ' ' +
                r.ReadString('Language') + ', ' + Rel);
            end;
          end;
        end;
      end;
    end;
    s.Free;
    rList.Free;
    r.CloseKey;
    r.Free;
  end;

    */




end implement regUtil
