/*****************************************************************************

                        Copyright (c) 2012 A&K

******************************************************************************/

implement mainTaskDilalog
    inherits dialog
    open core, vpiDomains

constants
    className = "com/visual-prolog/mainTaskDilalog/mainTaskDilalog".
    classVersion = "$JustDate: $666$Revision: $777".

clauses
    classInfo(className, classVersion).

clauses
    display(Parent) = Dialog :-
        Dialog = new(Parent),
        Dialog:show().

clauses
    new(Parent) :-
        dialog::new(Parent),
        generatedInitialize().

% This code is maintained automatically, do not update it manually. 09:11:38-4.10.2012
facts
    ok_ctl : button.
    cancel_ctl : button.
    help_ctl : button.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize():-
        setFont(vpi::fontCreateByName("Tahoma", 8)),
        setText("mainTaskDilalog"),
        setRect(rct(50,40,290,160)),
        setModal(true),
        setDecoration(titlebar([closebutton()])),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK"),
        ok_ctl:setPosition(48, 98),
        ok_ctl:setAnchors([control::right,control::bottom]),
        cancel_ctl := button::newCancel(This),
        cancel_ctl:setText("Cancel"),
        cancel_ctl:setPosition(112, 98),
        cancel_ctl:setAnchors([control::right,control::bottom]),
        help_ctl := button::new(This),
        help_ctl:setText("&Help"),
        help_ctl:setPosition(176, 98),
        help_ctl:setAnchors([control::right,control::bottom]).
% end of automatic code
end implement mainTaskDilalog
