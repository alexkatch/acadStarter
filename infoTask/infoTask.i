/*****************************************************************************

                        Copyright (c) 2012 A&K

******************************************************************************/

interface infoTask supports   formWindow
    open core


%domains
%acad_db=acad_db(string VER,string ProductName ,string Location ,string Language ).
%acadVerKey=acadVerKey(string Ver,string  ACAD_A001_409).


predicates
    getACAD:()-> infoTaskTxt::acad_db.




end interface infoTask