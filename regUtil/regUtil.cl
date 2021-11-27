/*****************************************************************************

                        Copyright (c) 2012 A&K

******************************************************************************/
class regUtil : regUtil
    open core, infoTaskTxt,cToolHelp

predicates

    acadWinExec : (string CMD, integer SHOW) determ.
    getAllAcadReleaseList:()-> string*.%   ->  core::namedValue_list.
    getAcad:(string)    ->string*. %string*.
    getProductCodeAndLocalizationCode:(string ACAD_A001_409,string Product,string LocalCode) determ (i,o,o).

    getAllInfoAcad:(string VER,string  ACAD_A001_409  ,string ProductName ,string Location ,string Language ) procedure (i,i,o,o,o).
   %getActiveAcadOleObject:(string AcadApp)-> comDomains::variant Variant.
   openDwgInRunningAcad:(cToolHelp::moduleInfo Inf, string AcadAppString, rel Release, string DwgName,string AcadDocLsp) procedure (i,i,i,i,i).
      openDwgInRunningAcad_0:(string AcadAppString, rel Release, string DwgName,string AcadDocLsp) procedure (i,i,i,i).

    newDwgInRunningAcad:(string AcadAppString, rel Release, string DwgName,string AcadDocLsp) procedure (i,i,i,i).

    insertDwgInRunningAcad:(string AcadAppString, /* string AcadVersion */ rel  Release, string DwgName) procedure (i,i,i).

     makeAcadRunCommandLine:(string AcadExe, rel  AcadVer ,string DwgFile)->string  procedure.

 normalizeLinux : (string FileName) -> string NormalizedFileName.

end class regUtil