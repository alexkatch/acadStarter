/*****************************************************************************

                        Copyright (c) 2012 A&K

******************************************************************************/

implement statusLine
    open core, vpiDomains, vpiToolbar, resourceIdentifiers
/*
constants
    className = "com/visual-prolog/TaskWindow/Toolbars/statusLine".
    classVersion = "$JustDate: $666$Revision: $777".
*/
%clauses
   % classInfo(className, classVersion).

clauses
    create(Parent):-
        _ = vpiToolbar::create(style, Parent, controlList).

% This code is maintained automatically, do not update it manually. 22:02:39-2.9.2012
constants
    style : vpiToolbar::style = tb_bottom().
    controlList : vpiToolbar::control_list =
        [
        tb_text(idt_help_line,tb_context(),452,0,4,10,0x0,"")
        ].
% end of automatic code
end implement statusLine
