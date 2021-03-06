/*****************************************************************************

                        Copyright (c) 2012 A&K

******************************************************************************/

implement aboutDialog
    inherits dialog
    open core, vpiDomains
/*
constants
    className = "com/visual-prolog/TaskWindow/aboutDialog".
    classVersion = "$JustDate: $666$Revision: $777".
*/
%clauses
   % classInfo(className, classVersion).

clauses
    display(Parent) = Dialog :-
        Dialog = new(Parent),
        Dialog:show().

clauses
    new(Parent) :-
        dialog::new(Parent),
        generatedInitialize().

% This code is maintained automatically, do not update it manually. 22:02:39-2.9.2012
facts
    version1_ctl : versioncontrol.
    version3_ctl : versioncontrol.
    version2_ctl : versioncontrol.
    version_ctl : versioncontrol.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize():-
        setFont(vpi::fontCreateByName("Tahoma", 8)),
        setText("About"),
        setRect(rct(122,26,322,130)),
        setModal(true),
        setDecoration(titlebar([closebutton()])),
        ButtonOk = button::newOk(This),
        ButtonOk:setText("&OK"),
        ButtonOk:setPosition(72, 86),
        GroupBox = groupBox::new(This),
        GroupBox:setText(""),
        GroupBox:setPosition(4, 22),
        GroupBox:setSize(192, 60),
        version1_ctl := versioncontrol::new(GroupBox),
        version1_ctl:setPosition(4, 12),
        version1_ctl:setSize(184, 10),
        version1_ctl:setText("File Version: {FileVersionA}.{FileVersionB}.{FileVersionC}.{FileVersionD}"),
        version3_ctl := versioncontrol::new(GroupBox),
        version3_ctl:setPosition(4, 36),
        version3_ctl:setSize(184, 10),
        version3_ctl:setText("Company Name: {CompanyName}"),
        version2_ctl := versioncontrol::new(GroupBox),
        version2_ctl:setPosition(4, 24),
        version2_ctl:setSize(184, 10),
        version2_ctl:setText("Copyright: {LegalCopyright}"),
        version_ctl := versioncontrol::new(GroupBox),
        version_ctl:setPosition(4, 0),
        version_ctl:setSize(184, 10),
        version_ctl:setText("File Description: {FileDescription}"),
        IconProject = iconControl::new(This),
        IconProject:setIcon(application_icon),
        IconProject:setPosition(12, 4).
% end of automatic code
end implement aboutDialog
