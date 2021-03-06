/*****************************************************************************

                        Copyright © Prolog Development Center A/S

******************************************************************************/

implement toolhelp32_native
resolve
    module32First/2-> externally,
    module32Next/2-> externally,
    process32First/2-> externally,
    process32Next/2-> externally

constants
    className = "pfc/windowsApi/toolhelp32_api/toolhelp32_native".
    classVersion = "$JustDate: 2010-03-11 $$Revision: 5 $".

clauses
    classInfo(className, classVersion).

end implement toolhelp32_native
