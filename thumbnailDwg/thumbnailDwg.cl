/*****************************************************************************

                        Copyright (c) 2012 A&K

******************************************************************************/
class thumbnailDwg : thumbnailDwg
    open core

predicates
    classInfo : core::classInfo.
    % @short Class information  predicate. 
    % @detail This predicate represents information predicate of this class.
    % @end


predicates    
getBitmap:(string FileDWG)-> vpiDomains::picture DwgPreview.

end class thumbnailDwg