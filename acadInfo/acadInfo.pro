% Copyright (c) 2012
implement acadInfo
    open core

constants
localeNameMaxLength = 85.

%class facts
%lCIDToLocaleNameFun:lCIDToLocaleNameKernel := erroneous.

domains
lCIDToLocaleNameKernel=(unsigned  ,string ,memory::pCharCount ,integer ) -> integer procedure language stdcall.

%facts - inform
%infoAcad:(unsigned Major,unsigned Minor,platform X,string Locatin,string ProductName,string Language).
class predicates
%LCIDToLocaleName(0x10407, strNameBuffer, LOCALE_NAME_MAX_LENGTH, 0)
lCIDToLocaleName:(unsigned Id) -> string.% , string StrNameBuffer,integer    LOCALE_NAME_MAX_LENGTH, 0)
clauses
lCIDToLocaleName(Id)  = STRNAME :-
  Dll=useDll::load ("Kernel32.dll"),
  %LOCALE_NAME_MAX_LENGTH]
        Buffer = string::create(localeNameMaxLength),
        Memory = memory::allocAtomicHeap(sizeOfDomain(unsigned), memory::contextType_pfc),
        memory::setCharCount(Memory, localeNameMaxLength),
        Count = uncheckedConvert(memory::pCharCount, Memory),
       LCIDToLocaleName=uncheckedConvert(lCIDToLocaleNameKernel,Dll:getPredicateHandle("LCIDToLocaleName")),
       %lCIDToLocaleNameFun :=LCIDToLocaleName,
       RC=LCIDToLocaleName  (ID,Buffer,Count,0),
    if b_false = RC then
            LastError = exception::getLastError(),
            exception::raise_nativeCallException(predicate_name(), LastError, [])
        end if,
  STRNAME=string::createCopy(Buffer),
  Dll:unload().

%base regKey = {HKEY_LOCAL_MACHINE\SOFTWARE\Autodesk\AutoCAD\R19.0\ACAD-B001:409}
%%  LAN= 18.2   ACAD-A001:409
% inp RegKey -> infAcad(Major,Minor,Platform ,Location,ProductName,Language)
%     0               1               2           3              4
%SOFTWARE\Autodesk\AutoCAD\R19.0\ACAD-B001:409}
getAcadInfo(RegKey)=REt :-
LRegKey=string::split(RegKey,"\\"),
MjMn=list::nth(3, LRegKey),
ParrentFullName= string::subString(MjMn,1,string::length(MjMn)-1),  %19.0
CoreVersion=string::split(ParrentFullName,"."),
Major=tryToTerm(unsigned, list::nth(0,CoreVersion)),
Minor=tryToTerm(unsigned,list::nth(1,CoreVersion)),
IndexOf=string::search(RegKey,":"),
Xs = string::fromPosition(RegKey,IndexOf + 1),
Xxs=string::concat("0x",Xs),
Xi=tryToTerm(unsigned,Xxs),%Int32 xi = Int32.Parse(xs, NumberStyles.HexNumber);
MAME_EN=lCIDToLocaleName(Xi),
%stdio::writef("\n Язык %s ",MAME_EN),
%V=systemInformation_api::majorOSversion,
%stdio::writef("\n V=%d",V),
% LL=registry::getAllValues(registry::localMachine(),RegKey),
if   systemInformation_api:: isWindows64() then
Platform=x64
else
Platform=x86
end if,
if string(Loc)=registry::tryGetValue(registry::localMachine(),RegKey, "Location", registry::normal) then
Location=Loc
else
Location=""
end if,
if string(Prod)=registry::tryGetValue(registry::localMachine(),RegKey, "ProductName", registry::normal)  then
ProductName=Prod
else
ProductName=""
end if,
Ret=infAcad(Major,Minor,Platform ,Location,ProductName,MAME_EN),!.
getAcadInfo(_RegKey)=nil.

%% для R18.2-> найти все  удовлетворяющие условию ACAD-????:
class predicates
findLokalizationKeysForCoreKeyNames:(string CoreKeyName) ->acKey_LocalizationKeys.
clauses
findLokalizationKeysForCoreKeyNames(AcadKeyName) = RET2 :-
  Key=string::concat(@"SOFTWARE\Autodesk\AutoCAD\",AcadKeyName),
 LocalizationKeys =  registry::getSubkeys(registry::localMachine(),Key),
%  RET=[X1||X1 in LocalizationKeys, regEx::match(@":[0-9]{1,3}$",X1,true,_FundPos,_FundLen,_LL)].
  RET=[X1||X1 in LocalizationKeys, regEx::match(@"^ACAD-[\w]{1,4}:[0-9]{1,3}$",X1,true,_FundPos,_FundLen,_LL)],
  RET2=acKey_LocalizationKeys(AcadKeyName,RET).


clauses
getInstalledAcads()=RET :-
СommonAcadKeyS =     registry::getSubkeys(registry::localMachine(),@"SOFTWARE\Autodesk\AutoCAD"),
CoreKeyNames=[X||X in СommonAcadKeyS, regEx::match(@"^R[0-9]{2}\.[0-9]{1}$",X,true,_FundPos,_FundLen,_LL)],
RET=list::map(CoreKeyNames,findLokalizationKeysForCoreKeyNames).

class predicates
getAcadSInfo:(acKey_LocalizationKeys A)->infoAcad_list.
%mAppen:(infoAcad_list_list)->infoAcad_list.

clauses
getAcadSInfo(acKey_LocalizationKeys(KEY,[LocalizationKey|T]))=[RET|TT] :-
  REGISTR=string::concat(@"SOFTWARE\Autodesk\AutoCAD\",KEY,"\\",LocalizationKey),
  RET=getAcadInfo(REGISTR),!,
  TT=getAcadSInfo(acKey_LocalizationKeys(KEY,T)).
  %RRET=[RET|TT].
  getAcadSInfo(_)=[].

clauses
getAllAutoCADinf()=Ret:-
%[ infAcad(unsigned Major,unsigned Minor,platform X,string Location,string ProductName,string Language) ... ;nil.]
%[acKey_LocalizationKeys(string AcadKeyName,string_list RET). ...]
L=getInstalledAcads(),
LL=  list::map(L,getAcadSInfo),
Ret=list::appendList(LL).

end implement acadInfo