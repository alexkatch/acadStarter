% Copyright (c) 2012

class acadInfo : acadInfo
    open core


domains
platform=x86();x64();xany().
infoAcad=infAcad(unsigned Major,unsigned Minor,platform X,string Location,string ProductName,string Language);nil.
acKey_LocalizationKeys=acKey_LocalizationKeys(string AcadKeyName,string* RET).
infoAcad_list =infoAcad*.
infoAcad_list_list =infoAcad_list*.
%hkey_list=registry_native::hKey*.


predicates


getInstalledAcads:()->   acKey_LocalizationKeys*.   % string_list_list. %hkey_list.
%getAllAutoCAD:()->string_list.

getAllAutoCADInf:()->infoAcad_list.   %%%MAIN
getAcadInfo:( string  KoreKey)->infoAcad.




end class acadInfo