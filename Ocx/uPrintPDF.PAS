{******************************************************************************

Nishita's PDF Creation VCL (TNPDF)
Version 2.0

Filename:             tnpdf.pas
Author:               K. Nishita
Compiler:           Delphi 1.0, 2.0, 3.0, 4.0, 5.0

Description:       Create PDF Files

NOTE:
If you want to use FlateDecode/Zlib compression, copy paszlib files (paszlib.zip)
included with this distribution to your Delphi librally path.

Copyright (c) 2002, K. Nishita.  All Rights Reserved.
Last Revised Date:    3/3/2002

******************************************************************************}

Unit uPrintPDF;

Interface

{$IFDEF VER150}
{$DEFINE DFS_DELPHI_3_UP}
{$ENDIF}

{$IFDEF VER130}
{$DEFINE DFS_DELPHI_3_UP}
{$ENDIF}

{$IFDEF VER125}
{$DEFINE DFS_DELPHI_3_UP}
{$ENDIF}

{$IFDEF VER120}
{$DEFINE DFS_DELPHI_3_UP}
{$ENDIF}

{$IFDEF VER100}
{$DEFINE DFS_DELPHI_3_UP}
{$ENDIF}

{$DEFINE USE_ZLIB} {Remove this if you do not want to use ZLIB Compression }

Uses
  SysUtils, WinProcs, WinTypes, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs{$IFDEF USE_ZLIB}, ZLib{$ENDIF};
{
NOTE:
If you want to use FlateDecode/Zlib compression, copy paszlib files (paszlib.zip)
included with this distribution to your Delphi librally path.
}

Type
  TPDFOrientation = (poPortrait, poLandscape);
Type
  TPDFLineStyle = (lsSolid, lsDashed, lsBeveled, lsInset, lsUnderline);
Type
  TPDFFontName = (poHelvetica, poHelveticaBold, poHelveticaOblique,
    poHelveticaBoldOblique, poCourier, poCourierBold, poCourierOblique,
    poCourierBoldOblique, poTimesRoman, poTimesBold, poTimesItalic,
    poTimesBoldItalic, poSymbol, poZapfDingbats);

Type
  TPDFFont = Class
  Public
    Name: TPDFFontName;
    Size: Integer;
  End;

Type
  AtributoBitmap = Record
    NumBitmap: Integer;
    Width: Integer;
    Height: Integer;
  End;

Type
  TPrintPDF = Class(TComponent)
  Private
    { Private declarations }
    PDF: TMemoryStream;
    FCanvasWidth: Integer;
    FCanvasHeight: Integer;
    FTmpFile: String;
    FFileName: String;
    FTITLE: String;
    FPageNumber: Integer;
    (*FFont:TFont;*)
    FPDFFont: TPDFFont;
    FLineWidth: Integer;
    FLineStyle: TPDFLineStyle;
    FLineDashedOn: Integer;
    FLineDashedOff: Integer;
    FOrientation: TPDFOrientation;
    FAuthor: String;
    FCreator: String;
    FKeywords: String;
    FSubject: String;
    FProducer: String;
    FFileCompress: boolean;

    FAtributoBitmap: Array Of AtributoBitmap;

    ParentNum, ContentNum, ResourceNum, (*FontNum,*) OutLinesNum, CatalogNum,
    FontNumber, CurrentSetPageObject, NumberofImages: Integer;
    CurrentObjectNum: Integer;
    ObjectOffset: LongInt;
    ObjectOffsetList: TStringList;
    PageNumberList: TStringList;
    FontNumberList: TStringList;
    CRCounter: LongInt;

    (*BitsPerComponent: Byte;*)
    (*ColorSpace: String;*)
    (*ColorCount: Byte;*)
    ImageStream: TMemoryStream;
    TempStream: TMemoryStream;
    pTempStream: TMemoryStream;
    sTempStream: TMemoryStream;
    cTempStream: TMemoryStream;

    StreamSize1, StreamSize2: LongInt;
    {$IFDEF USE_ZLIB}
    CompressionStream: TCompressionStream;
    {$ENDIF}
    Procedure AddToOffset(offset: LongInt);
    Procedure StreamWriteStr(Var ms: TMemoryStream; s: String);
    Procedure SetPDFHeader;
    Procedure SetCatalog;
    Procedure SetOutLine;
    Procedure SetDocInfo;
    Procedure SetPages;
    Procedure SetPageObject;
    Procedure StartStream;
    Procedure EndStream;
    Procedure SetArray;
    Procedure SetFontType;
    Procedure CreateFont(Subtype, BaseFont, Encoding: String);
    Procedure SetXref;
    Procedure SetBitmap(ABitmap: TBitmap);
    Procedure WriteBitmap(a: Integer);
    Function GetOffsetNumber(offset: String): String;

  Protected
    { Protected declarations }
  Public
    { Public declarations }
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
    Procedure BeginDoc;
    Procedure EndDoc;
    Procedure NewPage;
    Procedure DrawLine(x1, y1, x2, y2: Integer);
    Procedure DrawRectangle(x1, y1, x2, y2: Integer);
    Procedure TextOut(X, Y: Integer; Text: String); virtual;
    Procedure MemoOut(X, Y: Integer; Memo: TMemo);
    Procedure ImageOut(X, Y: Integer; ABitmap: TImage);
    Procedure DrawBitmap(X, Y: Integer; ABitmap: TBitmap);
    Procedure Draw(X, Y: Integer; ABitmap: TImage);

    Function EscreverBitmap(ABitmap: TBitmap): Integer;
    Procedure ReferenciarBitmap(X, Y, NumBitmap, Zoom: Integer);

  Published
    { Published declarations }
    Property FileName: String Read FFileName Write FFileName;
    Property TITLE: String Read FTITLE Write FTITLE;
    Property PageNumber: Integer Read FPageNumber;
    Property PageWidth: Integer Read FCanvasWidth Write FCanvasWidth;
    Property PageHeight: Integer Read FCanvasHeight Write FCanvasHeight;
    Property Orientation: TPDFOrientation Read FOrientation Write FOrientation;
    Property LineWidth: Integer Read FLineWidth Write FLineWidth;
    Property LineStyle: TPDFLineStyle Read FLineStyle Write FLineStyle;
    Property LineDashedOn: Integer Read FLineDashedOn Write FLineDashedOn;
    Property LineDashedOff: Integer Read FLineDashedOff Write FLineDashedOff;
    Property Author: String Read FAuthor Write FAuthor;
    Property Creator: String Read FCreator Write FCreator;
    Property Keywords: String Read FKeywords Write FKeywords;
    Property Subject: String Read FSubject Write FSubject;
    Property Producer: String Read FProducer Write FProducer;
    Property Font: TPDFFont Read FPDFFont Write FPDFFont;
    Property Compress: boolean Read FFileCompress Write FFileCompress;
  End;

Procedure Register;

Const
  aLineStyle: Array [TPDFLineStyle] of String = ('S', '', 'B', 'I', 'U');

Implementation

{$IFDEF VER80}

Function LTrim(Const Str: String): String;
Var
  len: Byte Absolute Str;
  i: Integer;
Begin
  i := 1;
  While (i <= len) And (Str[i] = ' ') Do
    Inc(i);
  LTrim := Copy(Str, i, len)
End;

Function RTrim(Str: String): String;
Var
  len: Byte Absolute Str;
Begin
  While (Str[len] = ' ') Do
    Dec(len);
  RTrim := Str
End;

Function Trim(Str: String): String;
Begin
  Trim := LTrim(RTrim(Str))
End;
{$ENDIF}

Procedure Register;
Begin
  RegisterComponents('TQI Custom', [TPrintPDF]);
End;

Function TPrintPDF.GetOffsetNumber(offset: String): String;
Var
  x, y: LongInt;
Begin
  x := Length(offset);
  result := '';
  For y := 1 To 10 - x Do
    result := result + '0';
  result := result + offset;
End;

Procedure TPrintPDF.StreamWriteStr(Var ms: TMemoryStream; s: String);
Begin
  CRCounter := CRCounter + 2;
  s := s + #13#10;
  ms.Write(s[1], Length(s));
End;

Constructor TPrintPDF.Create(AOwner: TComponent);
Begin
  Inherited Create(AOwner);
  ObjectOffsetList := TStringList.Create;
  PageNumberList := TStringList.Create;
  FontNumberList := TStringList.Create;
  PDF := TMemoryStream.Create;
  TempStream := TMemoryStream.Create;
  ImageStream := TMemoryStream.Create;
  pTempStream := TMemoryStream.Create;
  sTempStream := TMemoryStream.Create;
  cTempStream := TMemoryStream.Create;

  Font := TPDFFont.Create;
  Font.Name := poCourier;
  Font.Size := 12;
  FLineWidth := 1;
  FLineStyle := lsSolid;
  FLineDashedOn := 3;
  FLineDashedOff := 3;
  PageWidth := 595;  // A4
  PageHeight := 842; // A4

  {$IFDEF USE_ZLIB}
  Compress := True;
  {$ENDIF}

  Producer := 'TQI Tecnologia e Qual. em Informática Ltda';
  Author := 'TQI Tecnologia e Qual. em Informática Ltda';
  Creator := 'TQI Tecnologia e Qual. em Informática Ltda';
  Keywords := '';
  Subject := '';

End;

Destructor TPrintPDF.Destroy;
(*var i:Integer;*)
Begin
  ObjectOffsetList.Free;
  PageNumberList.Free;
  FontNumberList.Free;
  PDF.Free;
  TempStream.Free;
  ImageStream.Free;
  Font.Free;
  pTempStream.Free;
  sTempStream.Free;
  cTempStream.Free;
  Inherited Destroy;
End;

Procedure TPrintPDF.AddToOffset(offset: LongInt);
Begin
  ObjectOffset := ObjectOffset + offset;
  ObjectOffsetList.Add(IntToStr(ObjectOffset));
  CRCounter := 0;
End;

Procedure TPrintPDF.BeginDoc;
(*var i:Integer;*)
Begin
  FTmpFile := ExtractFilePath(FileName) + '~' + ExtractFileName(FileName);
  FPageNumber := 1;
  NumberofImages := 0;
  CurrentObjectNum := 0;
  ObjectOffset := 0;
  CurrentSetPageObject := 0;
  CRCounter := 0;
  FontNumber := 0;

  ObjectOffsetList.Clear;
  PageNumberList.Clear;
  FontNumberList.Clear;
  PDF.Clear;
  TempStream.Clear;
  ImageStream.Clear;

  SetPDFHeader;
  SetDocInfo;
  StartStream;
End;

Procedure TPrintPDF.EndDoc;
Var
  i: Integer;
Begin
  EndStream;
  SetOutLine;
  SetFontType;
  SetPages;
  SetArray;
  For i := 1 To NumberofImages Do
    WriteBitmap(i);
  For i := 1 To PageNumber Do Begin
    SetPageObject;
  End;
  SetCatalog;
  SetXref;
  StreamWriteStr(PDF, '%%EOF');
  PDF.SaveToFile(FileName);

  If (NumberofImages > 0) Then Begin
    For i := 1 To NumberofImages Do Begin
      {$IFDEF WIN32}
      DeleteFile(pchar(FTmpFile + IntToStr(i)));
      {$ELSE}
      DeleteFile((FTmpFile + IntToStr(i)));
      {$ENDIF}
    End;
  End;

End;

Procedure TPrintPDF.SetPDFHeader;
Begin
  CurrentObjectNum := 0;
  StreamWriteStr(PDF, '%PDF-1.4');
  AddToOffset(PDF.Size);
End;

Procedure TPrintPDF.SetDocInfo;
Begin
  CurrentObjectNum := CurrentObjectNum + 1;
  TempStream.Clear;
  StreamWriteStr(TempStream, IntToStr(CurrentObjectNum) + ' 0 obj');
  StreamWriteStr(TempStream, '<<');
  StreamWriteStr(TempStream, '/Producer (' + Producer + ')');
  StreamWriteStr(TempStream, '/Author (' + Author + ')');
  StreamWriteStr(TempStream, '/CreationDate (D:' + FormatDateTime('YYYYMMDDHHmmSS', now) + ')');
  StreamWriteStr(TempStream, '/Creator (' + Creator + ')');
  StreamWriteStr(TempStream, '/Keywords (' + Keywords + ')');
  StreamWriteStr(TempStream, '/Subject (' + Subject + ')');
  StreamWriteStr(TempStream, '/Title (' + Title + ')');
  StreamWriteStr(TempStream, '/ModDate ()');
  StreamWriteStr(TempStream, '>>');
  StreamWriteStr(TempStream, 'endobj');
  AddToOffset(TempStream.Size);
  PDF.Seek(0, soFromEnd);
  TempStream.SaveToStream(PDF);
End;

Procedure TPrintPDF.SetArray;
Var
  i: Integer;
Begin
  CurrentObjectNum := CurrentObjectNum + 1;
  ResourceNum := CurrentObjectNum;
  TempStream.Clear;
  StreamWriteStr(TempStream, IntToStr(CurrentObjectNum) + ' 0 obj');
  StreamWriteStr(TempStream, '<< /ProcSet [ /PDF /Text /ImageC]');
  StreamWriteStr(TempStream, '/XObject << ');
  For i := 1 To NumberofImages Do
    StreamWriteStr(TempStream, '/Im' + IntToStr(i) + ' ' + IntToStr(CurrentObjectNum + i) + ' 0 R');
  StreamWriteStr(TempStream, '>>');
  StreamWriteStr(TempStream, '/Font << ');

  For i := 1 To FontNumber Do
    StreamWriteStr(TempStream, '/F' + IntToStr(i) + ' ' + FontNumberList.Strings[i - 1] + ' 0 R ');

  StreamWriteStr(TempStream, '>>');
  StreamWriteStr(TempStream, '>>');
  StreamWriteStr(TempStream, 'endobj');
  AddToOffset(TempStream.Size);
  PDF.Seek(0, soFromEnd);
  TempStream.SaveToStream(PDF);
End;

Procedure TPrintPDF.SetFontType;
Begin
  CreateFont('Type1', 'Helvetica', 'WinAnsiEncoding');
  CreateFont('Type1', 'Helvetica-Bold', 'WinAnsiEncoding');
  CreateFont('Type1', 'Helvetica-Oblique', 'WinAnsiEncoding');
  CreateFont('Type1', 'Helvetica-BoldOblique', 'WinAnsiEncoding');
  CreateFont('Type1', 'Courier', 'WinAnsiEncoding');
  CreateFont('Type1', 'Courier-Bold', 'WinAnsiEncoding');
  CreateFont('Type1', 'Courier-Oblique', 'WinAnsiEncoding');
  CreateFont('Type1', 'Courier-BoldOblique', 'WinAnsiEncoding');
  CreateFont('Type1', 'Times-Roman', 'WinAnsiEncoding');
  CreateFont('Type1', 'Times-Bold', 'WinAnsiEncoding');
  CreateFont('Type1', 'Times-Italic', 'WinAnsiEncoding');
  CreateFont('Type1', 'Times-BoldItalic', 'WinAnsiEncoding');
  CreateFont('Type1', 'Symbol', 'WinAnsiEncoding');
  CreateFont('Type1', 'ZapfDingbats', 'WinAnsiEncoding');
End;

{************************}

Procedure TPrintPDF.SetOutLine;
Begin
  CurrentObjectNum := CurrentObjectNum + 1;
  OutLinesNum := CurrentObjectNum;
  TempStream.Clear;
  StreamWriteStr(TempStream, IntToStr(CurrentObjectNum) + ' 0 obj');
  StreamWriteStr(TempStream, '<< /Type /Outlines');
  StreamWriteStr(TempStream, '/Count 0');
  StreamWriteStr(TempStream, '>>');
  StreamWriteStr(TempStream, 'endobj');
  AddToOffset(TempStream.Size);
  PDF.Seek(0, soFromEnd);
  TempStream.SaveToStream(PDF);
End;

Procedure TPrintPDF.SetPages;
Var
  i, PageObjNum: Integer;
Begin

  CurrentObjectNum := CurrentObjectNum + 1;
  ParentNum := CurrentObjectNum;
  TempStream.Clear;
  StreamWriteStr(TempStream, IntToStr(CurrentObjectNum) + ' 0 obj');
  StreamWriteStr(TempStream, '<< /Type /Pages');
  StreamWriteStr(TempStream, '/Kids [');

  PageObjNum := 2;
  For i := 1 To PageNumber Do Begin
    StreamWriteStr(TempStream, IntToStr(CurrentObjectNum + i + 1 + NumberofImages) + ' 0 R');
    PageNumberList.Add(IntToStr(PageObjNum));
    PageObjNum := PageObjNum + 2;
  End;
  StreamWriteStr(TempStream, ']');
  StreamWriteStr(TempStream, '/Count ' + IntToStr(PageNumber));
  StreamWriteStr(TempStream, '>>');
  StreamWriteStr(TempStream, 'endobj');
  AddToOffset(TempStream.Size);
  PDF.Seek(0, soFromEnd);
  TempStream.SaveToStream(PDF);
End;

Procedure TPrintPDF.SetPageObject;
(*var i:Integer;*)
Begin
  ContentNum := ContentNum + 1;
  CurrentObjectNum := CurrentObjectNum + 1;
  TempStream.Clear;
  StreamWriteStr(TempStream, IntToStr(CurrentObjectNum) + ' 0 obj');
  StreamWriteStr(TempStream, '<< /Type /Page');
  StreamWriteStr(TempStream, '/Parent ' + IntToStr(ParentNum) + ' 0 R');
  StreamWriteStr(TempStream, '/MediaBox [ 0 0 ' + IntToStr(PageWidth) + ' ' + IntToStr(PageHEight) + ']');
  StreamWriteStr(TempStream, '/Contents ' + PageNumberList.Strings[CurrentSetPageObject] + ' 0 R');
  StreamWriteStr(TempStream, '/Resources ' + IntToStr(ResourceNum) + ' 0 R');
  StreamWriteStr(TempStream, '>>');
  StreamWriteStr(TempStream, 'endobj');
  AddToOffset(TempStream.Size);
  PDF.Seek(0, soFromEnd);
  TempStream.SaveToStream(PDF);
  CurrentSetPageObject := CurrentSetPageObject + 1;
End;

Procedure TPrintPDF.SetCatalog;
Begin
  CurrentObjectNum := CurrentObjectNum + 1;
  CatalogNum := CurrentObjectNum;
  TempStream.Clear;
  StreamWriteStr(TempStream, IntToStr(CurrentObjectNum) + ' 0 obj');
  StreamWriteStr(TempStream, '<< /Type /Catalog');
  StreamWriteStr(TempStream, '/Pages ' + IntToStr(ParentNum) + ' 0 R');
  StreamWriteStr(TempStream, '/Outlines ' + IntToStr(OutlinesNum) + ' 0 R');
  StreamWriteStr(TempStream, '>>');
  StreamWriteStr(TempStream, 'endobj');
  AddToOffset(TempStream.Size);
  PDF.Seek(0, soFromEnd);
  TempStream.SaveToStream(PDF);
End;

Procedure TPrintPDF.NewPage;
Var
  TempSize: LongInt;
Begin
  FPageNumber := FPageNumber + 1;

  {$IFDEF USE_ZLIB}
  If Compress Then Begin
    CompressionStream := TCompressionStream.Create(clDefault, TempStream);
    CompressionStream.CopyFrom(sTempStream, 0);
    CompressionStream.Free;
  End
  Else
    {$ENDIF}
    sTempStream.SaveToStream(TempStream);

  sTempStream.Clear;

  StreamWriteStr(TempStream, 'endstream');
  StreamWriteStr(TempStream, 'endobj');
  StreamSize2 := 6;
  AddToOffset(TempStream.Size);
  PDF.Seek(0, soFromEnd);
  TempStream.SaveToStream(PDF);

  TempSize := TempStream.Size - StreamSize1 - StreamSize2 - Length('Stream') - Length('endstream') - 6;
  ContentNum := CurrentObjectNum;
  CurrentObjectNum := CurrentObjectNum + 1;
  TempStream.Clear;
  StreamWriteStr(TempStream, IntToStr(CurrentObjectNum) + ' 0 obj');
  StreamWriteStr(TempStream, IntToStr(TempSize));
  StreamWriteStr(TempStream, 'endobj');
  AddToOffset(TempStream.Size);
  PDF.Seek(0, soFromEnd);
  TempStream.SaveToStream(PDF);

  ContentNum := CurrentObjectNum;
  CurrentObjectNum := CurrentObjectNum + 1;
  TempStream.Clear;
  StreamWriteStr(TempStream, IntToStr(CurrentObjectNum) + ' 0 obj');
  StreamWriteStr(TempStream, '<< /Length ' + IntToStr(CurrentObjectNum + 1) + ' 0 R');

  {$IFDEF USE_ZLIB}
  If Compress Then
    StreamWriteStr(TempStream, '/Filter [/FlateDecode]');
  {$ENDIF}

  StreamWriteStr(TempStream, ' >>');

  StreamSize1 := TempStream.Size;
  StreamWriteStr(TempStream, 'stream');
End;

Procedure TPrintPDF.StartStream;
Begin
  ContentNum := CurrentObjectNum;
  CurrentObjectNum := CurrentObjectNum + 1;
  TempStream.Clear;
  StreamWriteStr(TempStream, IntToStr(CurrentObjectNum) + ' 0 obj');
  StreamWriteStr(TempStream, '<< /Length ' + IntToStr(CurrentObjectNum + 1) + ' 0 R');

  {$IFDEF USE_ZLIB}
  If Compress Then
    StreamWriteStr(TempStream, '/Filter [/FlateDecode]');
  {$ENDIF}

  StreamWriteStr(TempStream, ' >>');
  StreamSize1 := TempStream.Size;
  StreamWriteStr(TempStream, 'stream');
  sTempStream.Clear;
End;

Procedure TPrintPDF.EndStream;
Var
  TempSize: LongInt;
Begin

  {$IFDEF USE_ZLIB}
  If Compress Then Begin
    CompressionStream := TCompressionStream.Create(clDefault, TempStream);
    CompressionStream.CopyFrom(sTempStream, 0);
    CompressionStream.Free;
  End
  Else
    {$ENDIF}
    sTempStream.SaveToStream(TempStream);

  sTempStream.Clear;

  StreamWriteStr(TempStream, 'endstream');
  StreamWriteStr(TempStream, 'endobj');
  StreamSize2 := 6;
  AddToOffset(TempStream.Size);
  PDF.Seek(0, soFromEnd);
  TempStream.SaveToStream(PDF);

  TempSize := TempStream.Size - StreamSize1 - StreamSize2 - Length('Stream') - Length('endstream') - 6;
  ContentNum := CurrentObjectNum;
  CurrentObjectNum := CurrentObjectNum + 1;
  TempStream.Clear;
  StreamWriteStr(TempStream, IntToStr(CurrentObjectNum) + ' 0 obj');
  StreamWriteStr(TempStream, IntToStr(TempSize));
  StreamWriteStr(TempStream, 'endobj');
  AddToOffset(TempStream.Size);
  PDF.Seek(0, soFromEnd);
  TempStream.SaveToStream(PDF);
End;

Procedure TPrintPDF.SetXref;
Var
  i: Integer;
Begin
  CurrentObjectNum := CurrentObjectNum + 1;
  TempStream.Clear;
  StreamWriteStr(TempStream, 'xref');
  StreamWriteStr(TempStream, '0 ' + IntToStr(CurrentObjectNum));
  StreamWriteStr(TempStream, '0000000000 65535 f');

  For i := 0 To CurrentObjectNum - 2 Do
    StreamWriteStr(TempStream, GetOffsetNumber(trim(ObjectOffsetList.Strings[i])) + ' 00000 n');

  StreamWriteStr(TempStream, 'trailer');
  StreamWriteStr(TempStream, '<< /Size ' + IntToStr(CurrentObjectNum));
  StreamWriteStr(TempStream, '/Root ' + IntToStr(CatalogNum) + ' 0 R');
  StreamWriteStr(TempStream, '/Info 1 0 R');
  StreamWriteStr(TempStream, '>>');
  StreamWriteStr(TempStream, 'startxref');
  StreamWriteStr(TempStream, trim(ObjectOffsetList.Strings[CurrentObjectNum - 1]));
  PDF.Seek(0, soFromEnd);
  TempStream.SaveToStream(PDF);
End;

Procedure TPrintPDF.DrawLine(x1, y1, x2, y2: Integer);
Begin
  {Define a espessura de linha a ser traçada}
  StreamWriteStr(sTempStream, IntToStr(LineWidth) + ' w');
  {Caso o tipo da linha seja "Dashed" define a qtd de pontos a serem preenchidos e não preenchidos}
  If FLineStyle = lsDashed Then Begin
    If FLineDashedOn = FLineDashedOff Then Begin
      StreamWriteStr(sTempStream,Format('[%d] 0 d', [FLineDashedOn]));
    End Else Begin
      StreamWriteStr(sTempStream,Format('[%d %d] 0 d', [FLineDashedOn, FLineDashedOff]));
    End;
  End;
  {Traça a linha nas posições identificadas}
  StreamWriteStr(sTempStream, IntToStr(x1) + ' ' + IntToStr((PageHeight - y1)) + ' m');
  StreamWriteStr(sTempStream, IntToStr(x2) + ' ' + IntToStr((PageHeight - y2)) + ' l');
  StreamWriteStr(sTempStream, 'S '+aLineStyle[FLineStyle]); {S-Solid,  D-Dashed, B-Beveled, I-Inset, U-Underline}
  {Reseta os valores definidos para uma linha do tipo "Dashed", retornando a condição "Solid"}
  If FLineStyle = lsDashed Then Begin
    StreamWriteStr(sTempStream,'[] 0 d');
  End;
End;

Procedure TPrintPDF.DrawRectangle(x1, y1, x2, y2: Integer);
Begin
  DrawLine(x1, y1, x1, y2);
  DrawLine(x1, y2, x2, y2);
  DrawLine(x2, y2, x2, y1);
  DrawLine(x2, y1, x1, y1);
End;

Procedure TPrintPDF.TextOut(X, Y: Integer; Text: String);
Begin
  StreamWriteStr(sTempStream, 'BT');
  StreamWriteStr(sTempStream, '/F' + IntToStr((Integer(Font.Name) + 1)) + ' ' + IntToStr(Font.Size) + ' Tf');
  StreamWriteStr(sTempStream, IntToStr(X) + ' ' + IntToStr((PageHeight - Y)) + ' Td');
  StreamWriteStr(sTempStream, '(' + Text + ') Tj');
  StreamWriteStr(sTempStream, 'ET');
End;

Procedure TPrintPDF.MemoOut(X, Y: Integer; Memo: TMemo);
Var
  i: Integer;
Begin
  StreamWriteStr(sTempStream, 'BT');
  StreamWriteStr(sTempStream, '/F' + IntToStr((Integer(Font.Name) + 1)) + ' ' + IntToStr(Font.Size) + ' Tf');
  StreamWriteStr(sTempStream, IntToStr(X) + ' ' + IntToStr((PageHeight - Y)) + ' Td');

  For i := 0 To Memo.Lines.Count Do Begin
    StreamWriteStr(sTempStream, '(' + Memo.Lines[i] + ') Tj');
    StreamWriteStr(sTempStream, '0 -12.5 TD');
  End;

  StreamWriteStr(sTempStream, 'ET');
End;

Procedure TPrintPDF.Draw(X, Y: Integer; ABitmap: TImage);
Begin
  ImageOut(X, Y, ABitmap);
End;

Procedure TPrintPDF.ImageOut(X, Y: Integer; ABitmap: TImage);
Var
  tempsx, tempsy: double;
Begin

  tempsx := ((PageWidth) / (WinProcs.GetDeviceCaps(GetDC(0), LOGPIXELSX) * 8));
  tempsy := ((PageHeight) / (WinProcs.GetDeviceCaps(GetDC(0), LOGPIXELSY) * 10.625));

  NumberofImages := NumberofImages + 1;
  StreamWriteStr(sTempStream, 'q');
  StreamWriteStr(sTempStream, IntToStr(trunc(ABitmap.Picture.Bitmap.Width * tempsx)) +
    ' 0 0 ' + IntToStr(trunc(ABitmap.Picture.Bitmap.Height * tempsy)) +
    ' ' + IntToStr(X) + ' ' + IntToStr(PageHeight - Y - trunc(ABitmap.Picture.Bitmap.Height * tempsy))
    + ' cm');
  StreamWriteStr(sTempStream, '/Im' + IntToStr(NumberofImages) + ' Do');
  StreamWriteStr(sTempStream, 'Q');
  SetBitmap(ABitmap.Picture.Bitmap);
End;

Procedure TPrintPDF.DrawBitmap(X, Y: Integer; ABitmap: TBitmap);
Var
  tempsx, tempsy: double;
Begin

  tempsx := ((PageWidth) / (WinProcs.GetDeviceCaps(GetDC(0), LOGPIXELSX) * 8));
  tempsy := ((PageHeight) / (WinProcs.GetDeviceCaps(GetDC(0), LOGPIXELSY) * 10.625));

  NumberofImages := NumberofImages + 1;
  StreamWriteStr(sTempStream, 'q');
  StreamWriteStr(sTempStream, IntToStr(trunc(ABitmap.Width * tempsx)) +
    ' 0 0 ' + IntToStr(trunc(ABitmap.Height * tempsy)) +
    ' ' + IntToStr(X) + ' ' + IntToStr(PageHeight - Y - trunc(ABitmap.Height * tempsy))
    + ' cm');
  StreamWriteStr(sTempStream, '/Im' + IntToStr(NumberofImages) + ' Do');
  StreamWriteStr(sTempStream, 'Q');
  SetBitmap(ABitmap);
End;

Procedure TPrintPDF.SetBitmap(ABitmap: TBitmap);
Type
  pRGBArray = ^TRGBArray;
  TRGBArray = Array[0..0] Of TRGBTriple;
Var
  tmpBitmap: TBitmap;
  InfoSize: {$IFNDEF WIN32}Integer{$ELSE}DWORD{$ENDIF};
  ImageSize: {$IFNDEF WIN32}LongInt{$ELSE}DWORD{$ENDIF};
  (*x,*) y: integer;
  pb: PByteArray;
  (*b: TRGBTriple;*)

  (*bits :Pointer;*)
  (*Info: PBitmapInfo;*)
  BitmapInfo   :  TBitmapInfo;

  DeviceContext:  hDC;
  (*i            :  INTEGER;*)
  j            :  INTEGER;
  ScanLine     :  pRGBArray;
  (*iSize: LongInt;*)
Begin
  tmpBitmap := ABitmap;

  GetDIBSizes(tmpBitmap.Handle, InfoSize, ImageSize);

  ImageStream.Clear;

  {$IFDEF DFS_DELPHI_3_UP}
  tmpBitmap.PixelFormat := pf24Bit;
  For y := 0 To tmpBitmap.Height - 1 Do Begin
    pb := tmpBitmap.ScanLine[y];
    ImageStream.Write(pb^, tmpBitmap.Width * 3);
  End;
  {$ELSE}

  GetMem(ScanLine, 3 * tmpBitmap.Width);
  Try
    With BitmapInfo Do Begin
      bmiHeader.biSize := InfoSize;
      bmiHeader.biWidth := tmpBitmap.Width;
      bmiHeader.biHeight := tmpBitmap.Height;
      bmiHeader.biPlanes := 1;
      bmiHeader.biBitCount := 24;
      bmiHeader.biCompression := BI_RGB;
    End;
    DeviceContext := GetDC(0);
    Try
      For j := tmpBitmap.Height - 1 Downto 0 Do Begin
        GetDIBits(DeviceContext, tmpBitmap.Handle, j, 1, ScanLine, BitmapInfo, DIB_RGB_COLORS);
        ImageStream.Write(ScanLine^, 3 * tmpBitmap.Width);
      End;

    Finally
      ReleaseDC(0, DeviceContext);
    End;

  Finally
    FreeMem(ScanLine, 3 * tmpBitmap.Width);
  End;

  {$ENDIF}

  GetDIBSizes(tmpBitmap.Handle, InfoSize, ImageSize);
  pTempStream.Clear;
  StreamWriteStr(pTempStream, '<< /Type /XObject');
  StreamWriteStr(pTempStream, '/Subtype /Image');
  StreamWriteStr(pTempStream, '/Width ' + IntToStr(tmpBitmap.Width));
  StreamWriteStr(pTempStream, '/Height ' + IntToStr(tmpBitmap.Height));
  StreamWriteStr(pTempStream, '/ColorSpace /DeviceRGB');
  StreamWriteStr(pTempStream, '/BitsPerComponent 8');
  StreamWriteStr(pTempStream, '/Length ' + IntToStr(ImageSize));
  StreamWriteStr(pTempStream, '/Name /Im' + IntToStr(NumberofImages));
  {$IFDEF USE_ZLIB}
  If Compress Then
    StreamWriteStr(pTempStream, '/Filter [/FlateDecode]');
  {$ENDIF}
  StreamWriteStr(pTempStream, '>>');
  StreamWriteStr(pTempStream, 'stream');
  pTempStream.Seek(0, soFromEnd);

  {$IFDEF USE_ZLIB}
  If Compress Then Begin
    CompressionStream := TCompressionStream.Create(clDefault, pTempStream);
    CompressionStream.CopyFrom(ImageStream, 0);
    CompressionStream.Free;
  End
  Else
    {$ENDIF}
    ImageStream.SaveToStream(pTempStream);
  pTempStream.SaveToFile(FTmpFile + IntToStr(NumberofImages));
End;

Procedure TPrintPDF.WriteBitmap(a: Integer);
Begin
  CurrentObjectNum := CurrentObjectNum + 1;
  TempStream.Clear;
  StreamWriteStr(TempStream, IntToStr(CurrentObjectNum) + ' 0 obj');
  ImageStream.Clear;
  ImageStream.LoadFromFile(FTmpFile + IntToStr(a));
  TempStream.Seek(0, soFromEnd);
  ImageStream.SaveToStream(TempStream);
  StreamWriteStr(TempStream, #13#10 + 'endstream');
  StreamWriteStr(TempStream, 'endobj');
  AddToOffset(TempStream.Size);
  PDF.Seek(0, soFromEnd);
  TempStream.SaveToStream(PDF);
End;

Procedure TPrintPDF.CreateFont(Subtype, BaseFont, Encoding: String);
Begin
  FontNumber := FontNumber + 1;
  CurrentObjectNum := CurrentObjectNum + 1;
  FontNumberList.Add(IntToStr(CurrentObjectNum));
  TempStream.Clear;
  StreamWriteStr(TempStream, IntToStr(CurrentObjectNum) + ' 0 obj');
  StreamWriteStr(TempStream, '<< /Type /Font');
  StreamWriteStr(TempStream, '/Subtype /' + Subtype);
  StreamWriteStr(TempStream, '/Name /F' + IntToStr(FontNumber));
  StreamWriteStr(TempStream, '/BaseFont /' + BaseFont);
  StreamWriteStr(TempStream, '/Encoding /' + Encoding);
  StreamWriteStr(TempStream, '>>');
  StreamWriteStr(TempStream, 'endobj');
  AddToOffset(TempStream.Size);
  PDF.Seek(0, soFromEnd);
  TempStream.SaveToStream(PDF);
End;

Function TPrintPDF.EscreverBitmap(ABitmap: TBitmap): Integer;
Begin
  NumberofImages := NumberofImages + 1;
  SetLength(FAtributoBitmap, Length(FAtributoBitmap) + 1);
  FAtributoBitmap[Length(FAtributoBitmap) - 1].NumBitmap := NumberofImages;
  FAtributoBitmap[Length(FAtributoBitmap) - 1].Width := ABitmap.Width;
  FAtributoBitmap[Length(FAtributoBitmap) - 1].Height := ABitmap.Height;

  Result := NumberofImages;
  SetBitmap(ABitmap);
End;

Procedure TPrintPDF.ReferenciarBitmap(X, Y, NumBitmap, Zoom: Integer);
Var
  I: Integer;
Begin
  For I := 0 To Length(FAtributoBitmap) - 1 Do Begin
    If FAtributoBitmap[I].NumBitmap = NumBitmap Then Begin
      StreamWriteStr(sTempStream, 'q');
      StreamWriteStr(sTempStream,
        IntToStr(Trunc(FAtributoBitmap[I].Width * Zoom /100)) +
        ' 0 0 ' + IntToStr(Trunc(FAtributoBitmap[I].Height * Zoom /100)) +
        ' ' + IntToStr(X) + ' '
        + IntToStr(PageHeight - Y - Trunc(FAtributoBitmap[I].Height * Zoom /100))
        + ' cm');
      StreamWriteStr(sTempStream, '/Im' + IntToStr(NumBitmap) + ' Do');
      StreamWriteStr(sTempStream, 'Q');
      Break;
    End;
  End;
End;

End.

