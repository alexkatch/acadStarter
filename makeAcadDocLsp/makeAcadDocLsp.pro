% Copyright (c) 2012

implement makeAcadDocLsp
    open core


class facts
acadDocLsp :string :=erroneous.

clauses
getAcadDocLisp () = Ret :-
if isErroneous(acadDocLsp) then
Ret =acadDocLsp
else
Ret= string::replaceAll(acadDocLsp,@"\",@"/")
end if.




clauses
makeAcadDocLisp() :-
    % поиск шаблона
    mainExe::getFilename(Path,_File),
    FileAcadDocTemplate=string::concat(Path,@"template\acadDoc.lsp"),
    FileAcadDoc=string::concat(Path,@"acadDoc.lsp"),  % filename::setPath(
    Path_0= string::replaceAll(Path,@"\",@"/"),

    if file::existExactFile(FileAcadDocTemplate) then
    STR_acad_doc_template= file::readString(FileAcadDocTemplate),
    STR_acad_doc= string::replaceAll(STR_acad_doc_template,@"%AK_ROOT_DIR%",Path_0),

%     stdio::writef("% " ,FileAcadDocTemplate),
     file::writeString(FileAcadDoc,STR_acad_doc, false),
     acadDocLsp := FileAcadDoc
     end if.
    %stdio::writef("% %" ,Path,File).

end implement makeAcadDocLsp