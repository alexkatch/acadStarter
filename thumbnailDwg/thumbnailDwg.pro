/*****************************************************************************

                        Copyright (c) 2012 A&K

******************************************************************************/

implement thumbnailDwg
    open core

constants
    className = "com/visual-prolog/thumbnailDwg/thumbnailDwg".
    classVersion = "$JustDate: $666$Revision: $777".

clauses
    classInfo(className, classVersion).


clauses
    
%getBitmap(FileDWG)=DwgPreview :-
%  file::existFile(FileDwg),!.
%    ResultPicture = vpi::pictFromBin(

getBitmap(FileDWG)=ResultPicture :-
%FileStream^ fs = gcnew FileStream(fileName, FileMode::Open, FileAccess::Read, FileShare::ReadWrite);
 file::existFile(FileDwg),
Input= inputStream_file::openFile(FileDWG,stream::binary),
% BinaryReader^ br = gcnew BinaryReader(fs);
	%fs->Seek(0xD, SeekOrigin::Begin);
	_XX=Input:setPosition  (0xD),
	
	Input:Read
  	
	 ResultPicture = vpi::pictFromBin(XX),
	!.
	
getBitmap(_FileDWG)= uncheckedConvert(vpiDomains::picture, 0).% vpiDomains::picture(nu
	
	/*
	            %mixing colors of selected potions to get color potion in retort
            alchemistHelper::potion(_Label, Red, Green, Blue) =
                alchemistHelper:mixPotions(getPotionsIndexes(SelectedPotionsBindingList)),
            PotionColor =  vpi::composeRGB(convert(integer,Red), convert(integer,Green), convert(integer,Blue)),
            %begin drawing to offscreen surface
            ViewRect = vpi::winGetOuterRect(vpi::winGetCtlHandle(thisWin, idc_retort_rect_box)),
            Surface = vpi::pictOpen(ViewRect),
            %background picture drawing
            rct(ViewLeft, ViewTop, ViewRight, ViewBottom) = ViewRect,
            vpi::pictDraw(Surface,
                                pictBackground,
                                rct(1, 1, ViewRight - ViewLeft - 1, ViewBottom - ViewTop - 1),
                                rct(1, 1, ViewRight - ViewLeft - 1, ViewBottom - ViewTop - 1),
                                rop_SrcCopy),
            %transparent blending potion color to retort bitmap
            ResultPicture = vpi::pictFromBin(
                                                pictureBlendColoring( binPictRetort,
                                                                                binPictPotionMask,
                                                                                PotionColor)),
            %output result bitmap
            LeftUpperCornerX = (ViewRight - ViewLeft ) div 2 - 108 div 2,
            LeftUpperCornerY = (ViewBottom - ViewTop) div 2 - 172 div 2,
            vpi::pictDraw(Surface, pictRetortMask, pnt(LeftUpperCornerX, LeftUpperCornerY), rop_SrcPaint),
            vpi::pictDraw(Surface, ResultPicture, pnt(LeftUpperCornerX, LeftUpperCornerY), rop_SrcAnd),
            %end drawing to offscreen surface and draw out them to dialog surface
            vpi::pictDraw(thisWin, vpi::pictClose(Surface), pnt(ViewLeft, ViewTop), rop_SrcCopy).


	*/
	
	
	
/*
	fs->Seek(0x14 + br->ReadInt32(), SeekOrigin::Begin);
    byte bytCnt = br->ReadByte();
if (bytCnt <= 1)     return  nullptr; 
  int imageHeaderStart;
  int imageHeaderSize;
  byte imageCode;
  for (short i = 1; i <= bytCnt; i++) {
      imageCode = br->ReadByte(); 
	  imageHeaderStart = br->ReadInt32(); 
	  imageHeaderSize = br->ReadInt32();
	  if (imageCode == 2){  fs->Seek(imageHeaderStart, SeekOrigin::Begin);     // BITMAPINFOHEADER (40 bytes)
                            br->ReadBytes(0xE); //biSize, biWidth, biHeight, biPlanes
                            USHORT biBitCount = br->ReadUInt16();
                            br->ReadBytes(4); //biCompression
                            UINT biSizeImage = br->ReadUInt32(); //br.ReadBytes(0x10); //biXPelsPerMeter, biYPelsPerMeter, biClrUsed, biClrImportant                            
							fs->Seek(imageHeaderStart, SeekOrigin::Begin);                             
	 					    array<Byte>  ^bitmapBuffer = br->ReadBytes(imageHeaderSize);							  
							UINT colorTableSize =(UINT)((biBitCount < 9) ? 4 * Math::Pow(2, biBitCount) : 0);
                            MemoryStream^ ms = gcnew MemoryStream();
							BinaryWriter^ bw = gcnew BinaryWriter(ms);  //bw.Write(new byte[] { 0x42, 0x4D });
							bw->Write((unsigned short)0x4D42);
							bw->Write(54U + colorTableSize + biSizeImage);
							bw->Write((unsigned short)0x0);										
							bw->Write((unsigned short)0x0);
							bw->Write(54U + colorTableSize);
							bw->Write(bitmapBuffer);
							Bitmap^ ret= gcnew Bitmap(ms);							
                                     return  ret; }
	  //PNG Preview (2013 file format);           	  
	  else if (imageCode == 6) {
		  fs->Seek(imageHeaderStart, SeekOrigin::Begin);
		  MemoryStream^  ms = gcnew  MemoryStream();		 
		  //fs->CopyTo(fs,ms,imageHeaderStart); in
		  CopyStream(fs,ms);		  		  
			  Bitmap^ ret= gcnew Bitmap(ms); 
                                    return  ret; 			  
			  
	  }	
	  else if (imageCode == 3)   return nullptr;
					} //for	
             return nullptr;



*/


/*
    ViewRect = vpi::winGetOuterRect(vpi::winGetCtlHandle(thisWin, idc_retort_rect_box)),
    Surface = vpi::pictOpen(ViewRect),
     %background picture drawing
      rct(ViewLeft, ViewTop, ViewRight, ViewBottom) = ViewRect,
       vpi::pictDraw(Surface,
                                pictBackground,
                                rct(1, 1, ViewRight - ViewLeft - 1, ViewBottom - ViewTop - 1),
                                rct(1, 1, ViewRight - ViewLeft - 1, ViewBottom - ViewTop - 1),
                                rop_SrcCopy),

    DwgPreview =vpi::pictClose(Surface)    .
    */


end implement thumbnailDwg
