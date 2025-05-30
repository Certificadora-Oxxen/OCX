{***************************************************************}
{                                                               }
{   Borland Delphi Visual Component Library                     }
{                                                               }
{   Copyright (c) 2000-2001 Borland Software Corporation        }
{                                                               }
{***************************************************************}
unit WSDLPub;

{$IFDEF CONDITIONALEXPRESSIONS}
  {$IF CompilerVersion >= 17.0)
    {$DEFINE DIAMONDBACK_UP}
  {$IFEND}
{$ENDIF}

interface

uses InvokeRegistry, Classes, HTTPApp, AutoDisp, Masks, Types,
     WebServExp;

type

  IWSDLPublish = interface(IInvokable)
  ['{ECD820DD-F242-11D4-928A-00C04F990435}']
    function  GetPortTypeList: TWideStringDynArray; stdcall;
    function  GetWSDLForPortType(const PortType: WideString): WideString; stdcall;
    function  GetTypeSystemsList: TWideStringDynArray; stdcall;
    function  GetXSDForTypeSystem(const TypeSystem: WideString): WideString; stdcall;
  end;

  TBeforePublishingWSDLEvent = procedure(const IntfName: WideString; var WSDL: WideString; var Handled: Boolean) of object;

  TWSDLPublish = class(TInvokableClass, IWSDLPublish)
  private
    Locations: array of WideString;
    PortNames: array of WideString;
    FTargetNamespace: WideString;

    FOnBeforePublishingWSDL: TBeforePublishingWSDLEvent;
    FOnBeforePublishingTypes: TBeforePublishingTypesEvent;
    FOnPublishingType: TPublishingTypeEvent;
    FOnAfterPublishingWSDL: TAfterPublishingWSDLEvent;
  public
    property  TargetNamespace: WideString read FTargetNamespace write FTargetNamespace;
    procedure GetPortTypeEntries(var Entries: TInvRegIntfEntryArray);

    { IWSDLPublish }
    function  GetPortTypeList: TWideStringDynArray; stdcall;
    function  GetWSDLForPortType(const PortType: WideString): WideString; stdcall;
    function  GetTypeSystemsList: TWideStringDynArray; stdcall;
    function  GetXSDForTypeSystem(const TypeSystem: WideString): WideString; stdcall;

    property OnBeforePublishingWSDL: TBeforePublishingWSDLEvent read FOnBeforePublishingWSDL write FOnBeforePublishingWSDL;
    property OnBeforePublishingTypes: TBeforePublishingTypesEvent read FOnBeforePublishingTypes write FOnBeforePublishingTypes;
    property OnPublishingType: TPublishingTypeEvent read FOnPublishingType write FOnPublishingType;
    property OnAfterPublishingWSDL: TAfterPublishingWSDLEvent read FOnAfterPublishingWSDL write FOnAfterPublishingWSDL;
  end;

  SOAPPublishOptions = (poDefault, poPublishLocationAsSecure);
  TSOAPPublishOptions= set of SOAPPublishOptions;

  TWSDLHTMLPublish =  class(TComponent, IWebDispatch)
  private
    Pub: TWSDLPublish;
    FWebDispatch: TWebDispatch;
    FAdminEnabled: Boolean;
    FTargetNamespace: WideString;
    FPublishOptions: TSOAPPublishOptions;
    FOnBeforePublishingWSDL: TBeforePublishingWSDLEvent;
    FOnBeforePublishingTypes: TBeforePublishingTypesEvent;
    FOnPublishingType: TPublishingTypeEvent;
    FOnAfterPublishingWSDL: TAfterPublishingWSDLEvent;
    procedure SetWebDispatch(const Value: TWebDispatch);
{$IFDEF DIAMONDBACK_UP}
    function GetNameSpaceIsStored:Boolean;
{$ENDIF}
  protected
    procedure AddInterfaceList(htmldoc: TStringList; const WSDLBaseURL: String);
    procedure AddPortList(htmldoc: TStringList; const PortType: String);
    procedure UpdatePortList(PortList: TStrings; const PortType, Command: String);
    function  GetHostScriptBaseURL(Request: TWebRequest): String;
    procedure WSILInfo(const HostScriptBaseURL: string; Request: TWebRequest;
                Response: TWebResponse; var Handled: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { IWebDispatch }
    function DispatchEnabled: Boolean;
    function DispatchMask: TMask;
    function DispatchMethodType: TMethodType;
    function DispatchRequest(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse): Boolean;
    procedure ServiceInfo(Sender: TObject; Request: TWebRequest;
                Response: TWebResponse; var Handled: Boolean);
    function HandleRequest(Resp: TStringList; const Path: String;
                           const HostScriptBaseURL: String;
                           var ContentType: String; Request: TWebRequest): integer;
    function GetTargetNamespace: WideString;
  published
    property WebDispatch: TWebDispatch read FWebDispatch write SetWebDispatch;
{$IFDEF DIAMONDBACK_UP}
    property AdminEnabled: Boolean read FAdminEnabled write FAdminEnabled default False;
    property TargetNamespace: WideString read GetTargetNamespace write FTargetNamespace stored GetNameSpaceIsStored;
    property PublishOptions: TSOAPPublishOptions read FPublishOptions write FPublishOptions default [];
{$ELSE}
    property AdminEnabled: Boolean read FAdminEnabled write FAdminEnabled;
    property TargetNamespace: WideString read GetTargetNamespace write FTargetNamespace;
    property PublishOptions: TSOAPPublishOptions read FPublishOptions write FPublishOptions;
{$ENDIF}
    property OnBeforePublishingWSDL: TBeforePublishingWSDLEvent read FOnBeforePublishingWSDL write FOnBeforePublishingWSDL;
    property OnBeforePublishingTypes: TBeforePublishingTypesEvent read FOnBeforePublishingTypes write FOnBeforePublishingTypes;
    property OnPublishingType: TPublishingTypeEvent read FOnPublishingType write FOnPublishingType;
    property OnAfterPublishingWSDL: TAfterPublishingWSDLEvent read FOnAfterPublishingWSDL write FOnAfterPublishingWSDL;
  end;

  procedure WSDLPubFactory(out obj: TObject);

implementation

uses {$IFDEF MSWINDOWS}Windows, ActiveX, {$ENDIF}
  SysUtils, IntfInfo, XMLSchema, WSDLIntf, WSDLBind, TypInfo,
  WSDLItems, WSDLSOAP, IniFiles, OPToSOAPDomConv, SOAPConst, WSILIntf;

resourcestring
  sPortNameHeader = 'PortName';
  sAddressHeader = 'address';
  sAdminButtonCation = 'Administrator';
  sAddButtonCaption = 'Add';
  sDeleteButtonCaption = 'Remove';

{ TWSDLPublish }

var
  AdminIniFile: string;
  ServicePath: string;
  ServiceName: string;
  ModuleName: array[0..MAX_PATH] of char;


procedure AddElem(htmldoc: TStringList; const Elem: string; const cls: string);
begin
  htmldoc.Add('<td class="'+cls+'">' + Elem + '</td>');   { Do not localize }
end;

procedure TWSDLHTMLPublish.AddInterfaceList(htmldoc: TStringList; const WSDLBaseURL: String);
var
  I: Integer;
  Entries: TInvRegIntfEntryArray;
  Entry: InvRegIntfEntry;
  Doc: string;
begin
  htmldoc.Add('<table ' + TableStyle + '>');        { Do not localize }
  htmldoc.Add('<tr>');                              { Do not localize }
  AddElem(htmldoc, sPortType, sTblHdrCls);
  AddElem(htmldoc, sNamespaceURI, sTblHdrCls);
  AddElem(htmldoc, sDocumentation, sTblHdrCls);
  AddElem(htmldoc, sWSDL, sTblHdrCls);
  htmldoc.Add('</tr>');
  Pub.GetPortTypeEntries(Entries);
  for I := 0 to Length(Entries) - 1 do
  begin
    Entry := Entries[I];
    htmldoc.Add('<tr>');                  { Do not localize }
    AddElem(htmldoc, Entry.Name, sTblRow);
    AddElem(htmldoc, Entry.Namespace, sTblRow);
    Doc := Entry.Documentation;
    if Doc = '' then
      Doc := sNBSP;
    AddElem(htmldoc, Doc, sTblRow);
    AddElem(htmldoc, '<a href="' + WSDLBaseURL + '/' + Entry.Name + '">' + sWSDLFor + Entry.Name + '</a>', sTblRow); { Do not localize }
    htmldoc.Add('</tr>');                 { Do not localize }
  end;
  htmldoc.Add('</table>');                { Do not localize }
end;

procedure TWSDLHTMLPublish.AddPortList(htmldoc: TStringList; const PortType: string);
var
  I: Integer;
  IniFile: TMemIniFile;
  PortList: TStringList;
begin
  IniFile := TMemIniFile.Create(AdminIniFile);
  try
    htmldoc.Add('<table ' + TableStyle + '>');  { Do not localize }
    htmldoc.Add('<tr>');                        { Do not localize }
    AddElem(htmldoc, sPortNameHeader, sTblHdrCls);
    AddElem(htmldoc, sAddressHeader, sTblHdrCls);
    htmldoc.Add('</tr>');                       { Do not localize }
    if IniFile.SectionExists(PortType) then
    begin
      PortList := TStringList.Create;
      try
        IniFile.ReadSectionValues(PortType, PortList);
        for I := 0 to PortList.Count - 1 do
        begin
          htmldoc.Add('<tr>');                  { Do not localize }
          AddElem(htmldoc, PortList.Names[I], sTblRow);
          AddElem(htmldoc, PortList.Values[PortList.Names[I]], sTblRow);
          htmldoc.Add('</tr>');                 { Do not localize }
        end;
      finally
        PortList.Free;
      end;
    end;
    htmldoc.Add('</table>');
  finally
    IniFile.Free;
  end;
end;

procedure TWSDLHTMLPublish.UpdatePortList(PortList: TStrings; const PortType, Command: String);
var
  IniFile: TMemIniFile;
begin
  if PortList.Count > 0 then
  begin
    IniFile := TMemIniFile.Create(AdminIniFile);
    try
      if PortList.Values['PortName'] <> '' then     { Do not localize }
        if UpperCase(Command) = 'ADD' then          { Do not localize }
          IniFile.WriteString(PortType, PortList.Values[sPortName], PortList.Values[sAddress])
        else if UpperCase(Command) = 'REMOVE' then  { Do not localize }
          IniFile.DeleteKey(PortType, PortList.Values[sPortName]);
      if AdminEnabled then
        IniFile.UpdateFile;
    finally
      IniFile.Free;
    end;
  end;
end;

function TWSDLHTMLPublish.GetHostScriptBaseURL(Request: TWebRequest): String;
begin
 { Here we set the proper url prefix and port [if nessecary] }
  if poPublishLocationAsSecure in PublishOptions then begin // SSL
    if (Request.ServerPort <> 443) and (Pos(':', Request.Host) = 0) then
      Result := 'https://' + Request.Host + ':' + IntToStr(Request.ServerPort) + Request.InternalScriptName         { do not localize }
    else
      Result := 'https://' + Request.Host + Request.InternalScriptName;    { do not localize }
  end else begin                                            // Normal
    if (Request.ServerPort <> 80) and (Pos(':', Request.Host) = 0) then
      Result := 'http://' + Request.Host + ':' + IntToStr(Request.ServerPort) + Request.InternalScriptName         { do not localize }
    else
      Result := 'http://' + Request.Host + Request.InternalScriptName;    { do not localize }
  end;

end;

function TWSDLPublish.GetPortTypeList: TWideStringDynArray;
var
  I, Count: Integer;
  IntfEntry: InvRegIntfEntry;
begin
  { Use invrg to list all the interfaces registered, add new method if necessary }
  Count := InvRegistry.GetInterfaceCount;
  SetLength(Result, Count);
  for I:= 0 to Count-1 do
  begin
    IntfEntry := InvRegistry.GetRegInterfaceEntry(I);
    Result[I] := IntfEntry.Name;
  end;
end;

function TWSDLPublish.GetTypeSystemsList: TWideStringDynArray;
var
  I, Count: Integer;
  URIMap: TRemRegEntry;
  TypeSystemList: TWideStrings;
begin
  TypeSystemList := TWideStrings.Create;
  try
    { Find Unique URIs registered }
    Count := RemClassRegistry.GetURICount;
    for I := 0 to Count-1 do
    begin
      URIMap := RemClassRegistry.GetURIMap(I);
      if TypeSystemList.IndexOf(URIMap.URI) = -1 then
        TypeSystemList.Add(URIMap.URI)
    end;
    SetLength(Result, TypeSystemList.Count);
    for I := 0 to TypeSystemList.Count-1 do
      Result[I] := TypeSystemList[I];
  finally
    TypeSystemList.Free;
  end;
end;

function TWSDLPublish.GetWSDLForPortType(const PortType: WideString): WideString;
var
  IID: TGUID;
  Info: PTypeInfo;
  WSDLDoc: IWSDLDocument;
  WebServExp: TWebServExp;
  WebServIntf: IWebServExp;
  SResult: string;
  Handled: Boolean;
begin
  { Allow user first crack }
  if Assigned(FOnBeforePublishingWSDL) then
  begin
    Handled := False;
    Result := '';
    FOnBeforePublishingWSDL(PortType, Result, Handled);
    if Handled then
      Exit;
  end;
  { Use invrg to get typeinfo for porttype name ( interface name ) }
  { Convert to WSDL fragement }
  InvRegistry.GetInterfaceInfoFromName ('', PortType, Info, IID);

  { TODO Should we throw an exception if interface is not registered?? }
  if Info <> nil then
  begin
    WSDLDoc := TWSDLDocument.Create(nil);
    WSDLDoc.Active := True;
    WebServIntf := TWebServExp.Create;
    WebServExp := (WebServIntf as IWebServExpAccess).GetWebServExp;

    WebServExp.TargetNameSpace := TargetNamespace;
    WSDLDoc.Encoding := 'utf-8';        { Do not localize }
    WebServExp.BindingType := btSoap;
    WebServExp.WSDLElements :=  WebServExp.WSDLElements + [weService];

    WebServExp.OnBeforePublishingTypes := FOnBeforePublishingTypes;
    WebServExp.OnPublishingType := FOnPublishingType;
    WebServExp.OnAfterPublishingWSDL := FOnAfterPublishingWSDL;

    WebServExp.GetWSDLForInterface(Info, WSDLDoc, PortNames, Locations);
    WSDLDoc.SaveToXML(SResult);
    Result := SResult;
  end;
end;

function TWSDLPublish.GetXSDForTypeSystem(const TypeSystem: WideString): WideString;
var
  I, Count: Integer;
  URIMap: TRemRegEntry;
  WebServExp: TWebServExp;
  XMLDoc: IXMLSchemaDoc;
  SResult: string;
begin
  { Use xsdclasses to get list of all classes registered with same URI and }
  { Create XML schema doc for this. }
  Count := RemClassRegistry.GetURICount;
  for I := 0 to Count -1 do
  begin
    URIMap := RemClassRegistry.GetURIMap(I);
    if TypeSystem = URIMap.URI then
    begin
      WebServExp := TWebServExp.Create;
      try
        XMLDoc := NewXMLSchema;
        WebServExp.GenerateXMLSchema(XMLDoc.SchemaDef, URIMap.Info, nil, '');
        XMLDoc.SaveToXML(SResult);
        Result := SResult;
      finally
        WebServExp.Free;
      end;
    end;
  end;
end;

procedure WSDLPubFactory(out obj: TObject);
begin
  obj := TWSDLPublish.Create;
end;

procedure TWSDLPublish.GetPortTypeEntries(var Entries: TInvRegIntfEntryArray);
var
  I, J, Count, AllIntf: Integer;
  Entry: InvRegIntfEntry;
begin
  AllIntf := InvRegistry.GetInterfaceCount;
  Count := 0;
  for I := 0 to AllIntf do
  begin
    if InvRegistry.HasRegInterfaceImpl(I) then
      Inc(Count);
  end;

  SetLength(Entries, Count);
  J := 0;
  for I:= 0 to AllIntf-1 do
  begin
    { Skip non-implemented classes }
    if not InvRegistry.HasRegInterfaceImpl(I) then
      continue;

    { Put the built-in publisher last }
    Entry := InvRegistry.GetRegInterfaceEntry(I);
    if Entry.Info = TypeInfo(IWSDLPublish) then
      Entries[Count-1] := Entry
    else
    begin
      Entries[J] := Entry;
      Inc(J);
    end;
  end;
end;

{ TWSDLHTMLPublish }

constructor TWSDLHTMLPublish.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWebDispatch := TWebDispatch.Create(Self);
  FWebDispatch.PathInfo := 'wsdl*';
  FWebDispatch.MethodType := mtAny;
  PublishOptions := [];
  AdminEnabled := False;
end;

destructor TWSDLHTMLPublish.Destroy;
begin
  inherited Destroy;
  FWebDispatch.Free;
end;


function TWSDLHTMLPublish.DispatchEnabled: Boolean;
begin
  Result := FWebDispatch.Enabled;
end;

function TWSDLHTMLPublish.DispatchMask: TMask;
begin
    Result := FWebDispatch.Mask;
end;

function TWSDLHTMLPublish.DispatchMethodType: TMethodType;
begin
   Result := FWebDispatch.MethodType;
end;


function TWSDLHTMLPublish.HandleRequest(Resp: TStringList; const Path: String;
                                        const HostScriptBaseURL: String;
                                        var ContentType: String;
                                        Request: TWebRequest): integer;
var
  Pub: TWSDLPublish;

  procedure AddAdmin(const URL: string);
  begin
    Resp.Add('<FORM NAME="admin" METHOD="GET" ACTION=' + '"' + URL + '"' + '>'); { do not localize }
    Resp.Add('<INPUT TYPE="SUBMIT" VALUE="' + sAdminButtonCation + '">');
    Resp.Add('</FORM>');                                     { do not localize }
  end;

  function getDefaultPortValue(Name: string): string;
  begin
    Result := HostScriptBaseURL + '/soap/' + Name;    { Do not localize }
  end;

  function getDefaultPortKey(Name: string): string;
  begin
    Result := Name + 'Port';                          { Do not localize }
  end;

  procedure CreateDefaultEntries;
  var
    I: Integer;
    Entries: TInvRegIntfEntryArray;
    IniFile: TMemIniFile;
  begin
    if not FileExists(AdminIniFile) then
    begin
      IniFile := TMemIniFile.Create(AdminIniFile);
      try
        Pub.GetPortTypeEntries(Entries);
        for I := 0 to Length(Entries) - 1 do
        with Entries[I] do
          IniFile.WriteString(Name, getDefaultPortKey(Name), getDefaultPortValue(Name));  { do not localize }
        if AdminEnabled then
          IniFile.UpdateFile;
      finally
        IniFile.Free;
      end;
    end;
  end;

  procedure NewServicePortForm;
  begin
    Resp.Add('<FORM NAME="admin" METHOD="GET" ACTION=' + '"' + { do not localize }
             HostScriptBaseURL + Path + '"' + '>');          { do not localize }
    Resp.Add('<table ' + TableStyle + '>');                  { do not localize }
    Resp.Add('<tr>');                                        { do not localize }
    AddElem(Resp, sPortNameHeader, sTblHdrCls);
    AddElem(Resp, sAddressHeader, sTblHdrCls);
    Resp.Add('</tr>');                                       { do not localize }
    Resp.Add('<tr>');                                        { do not localize }
    AddElem(Resp, '<INPUT TYPE="TEXT" NAME="' + sPortName + '" SIZE="20" VALUE="" MAXLENGTH="4096">', sTblRow); { do not localize }
    AddElem(Resp, '<INPUT TYPE="TEXT" NAME="' + sAddress + '" SIZE="40" VALUE="" MAXLENGTH="4096">', sTblRow); { do not localize }
    Resp.Add('</tr>');                                       { do not localize }
    Resp.Add('</table>');                                    { do not localize }
    Resp.Add('<p>');                                         { do not localize }
    Resp.Add('<INPUT TYPE="SUBMIT" VALUE="' + sAddButtonCaption + '" NAME="COMMAND_ADD">'); { do not localize }
    Resp.Add('<INPUT TYPE="SUBMIT" VALUE="' + sDeleteButtonCaption + '" NAME="COMMAND_REMOVE">'); { do not localize }
    Resp.Add('</FORM>');                                     { do not localize }
  end;

  procedure GetServicePorts(PortType: string);
  var
    I: Integer;
    IniFile: TMemIniFile;
    PortList: TStringList;
  begin
    IniFile := TMemIniFile.Create(AdminIniFile);
    try
      { If the section exists, use what's there}
      if IniFile.SectionExists(PortType) then
      begin
        PortList := TStringList.Create;
        try
          IniFile.ReadSectionValues(PortType, PortList);
          Pub.PortNames := nil;
          Pub.Locations := nil;
          SetLength(Pub.PortNames, PortList.Count);
          SetLength(Pub.Locations, PortList.Count);
          for I := 0 to PortList.Count - 1 do
          begin
            Pub.PortNames[I] := PortList.Names[I];
            Pub.Locations[I] := PortList.Values[PortList.Names[I]];
          end;
        finally
          PortList.Free;
        end;
      end
      else
      { Here there was nothing for this PortType in the .INI file...
        So we create at least one default so we have something for
        the address location }
      begin
        Pub.PortNames := nil;
        Pub.Locations := nil;
        SetLength(Pub.PortNames, 1);
        SetLength(Pub.Locations, 1);
        Pub.PortNames[0] := getDefaultPortKey(PortType);
        Pub.Locations[0] := getDefaultPortValue(PortType);
      end;
    finally
      IniFile.Free;
    end;
  end;

var
  LastName, PreName: string;
  WSDL: string;
  WSDLBaseURL: String;

begin
  Result   := 200;
  LastName := Copy(Path, LastDelimiter('/', Path) + 1, High(Integer));
  PreName  := Copy(Path, 1, LastDelimiter('/', Path) - 1);
  PreName  :=  Copy(PreName, LastDelimiter('/', PreName) + 1, High(Integer));
  WSDLBaseURL := HostScriptBaseURL + Path;
{$IFDEF MSWINDOWS}
  CoInitialize(nil);
{$ENDIF}
  try
    Pub :=  TWSDLPublish.Create;
    try
      Pub.TargetNamespace := TargetNamespace;
      Pub.OnBeforePublishingWSDL := FOnBeforePublishingWSDL;
      Pub.OnBeforePublishingTypes := FOnBeforePublishingTypes;
      Pub.OnPublishingType := FOnPublishingType;
      Pub.OnAfterPublishingWSDL := FOnAfterPublishingWSDL;

      CreateDefaultEntries;
      if LastName = 'wsdl' then                              { do not localize }
      begin
        Resp.Add(Format(HTMLTopTitleNoMargin, [ServiceName]) +
                        InfoTitle1 +
                        Format(InfoTitle2, [ServiceName, sWebServiceListing]));
        Resp.Add('<center><br>');                            { do not localize }
        AddInterfaceList(Resp, WSDLBaseURL);
        if AdminEnabled then
          AddAdmin(WSDLBaseURL + '/' + 'admin');             { do not localize }
        Resp.Add('</center>');                               { do not localize }
        Resp.Add(HTMLEnd);
        ContentType := sTextHtml;
      end
      else if LastName = 'admin' then                        { do not localize }
      begin
        if not AdminEnabled then
        begin
          Result := 403;
          Resp.Add(sForbiddenAccess);
          ContentType := sTextHtml;
          Exit;
        end;

        Resp.Add(Format(HTMLTopTitle, [sWebServiceListingAdmin]));
        Resp.Add('<h1>' + sWebServiceListingAdmin + '</h1><p>'); { do not localize }
        AddInterfaceList(Resp, WSDLBaseURL);
        Resp.Add(HTMLEnd);
        ContentType := sTextHtml;
      end
      else
      begin
        if PreName = 'wsdl' then                             { do not localize }
        begin
          GetServicePorts(LastName);
          WSDL := Pub.GetWSDLForPortType(LastName);
          if WSDL <> '' then
          begin
            Resp.Add(UTF8Encode(WSDL));
            ContentType := sTextXML;
          end
          else
          begin
            { interface not found... }
            Resp.Add(Format(sInterfaceNotFound, [LastName]));
            ContentType := sTextHtml;
          end;
        end
        else if PreName = 'admin' then                       { do not localize }
        begin
          if not AdminEnabled then
          begin
            Result := 403;
            Resp.Add(sForbiddenAccess);
            ContentType := sTextHtml;
            Exit;
          end;
          if Request.QueryFields.Values['COMMAND_ADD'] <> '' then
            UpdatePortList(Request.QueryFields, LastName, 'ADD')  { do not localize }
          else if Request.QueryFields.Values['COMMAND_REMOVE'] <> '' then
            UpdatePortList(Request.QueryFields, LastName, 'Remove');  { do not localize }
          Resp.Add(Format(HTMLTopTitle, [sWSDLPortsforPortType]));
          Resp.Add('<h1>' + sWSDLPortsforPortType + ' ' + LastName + '</h1><p>'); { do not localize }
          AddPortList(Resp, LastName);
          Resp.Add('<p>');                          { do not localize }
          NewServicePortForm;
          Resp.Add(HTMLEnd);                        { do not localize }
          ContentType := sTextHtml;
        end;
      end;
    finally
      Pub.Free;
    end;
  finally
{$IFDEF MSWINDOWS}
    CoUnInitialize;
{$ENDIF}
  end;
end;

function TWSDLHTMLPublish.DispatchRequest(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse): Boolean;
var
  Resp: TStringList;
  Path: string;
  HostScriptBaseURL: String;
  ContentType: String;
begin
  try
    HostScriptBaseURL := GetHostScriptBaseURL(Request);
    Path := Request.InternalPathInfo;
    { Strip ending '/' }
    if Path[Length(Path)] = '/' then
      Path := Copy(Path, 1, Length(Path)-1);
{$IFDEF MSWINDOWS}
    CoInitialize(nil);
{$ENDIF}
    try
      Resp := TStringList.Create;
      try
        Response.StatusCode := HandleRequest(Resp, Path, HostScriptBaseURL, ContentType, Request);
        Response.ContentType := ContentType;
        Response.Content := Resp.Text;
      finally
        Resp.Free;
      end;
    finally
{$IFDEF MSWINDOWS}
      CoUnInitialize;
{$ENDIF}
    end;
  except
    on E: Exception do
    begin
      Response.Content := HTMLTop+'<h1>' + sErrorColon + E.Message + '/'+ E.ClassName+'</h1>'+HTMLEnd; { do no localize }
      Response.ContentType := sTextHtml;
    end
    else
    begin
      Response.Content := HTMLTop+'<h1>'+sUnknownError +'</h1>'+HTMLEnd; { do not localize }
      Response.ContentType := sTextHtml;
    end;
  end;
  Result := True;
end;

procedure TWSDLHTMLPublish.ServiceInfo(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);

const
  IntfHdr     = '<br><table width="100%" border=0 cellpadding=1 cellspacing=0>'            + sLineBreak;
  IntfSectBig = '<tr><td width="1%" class="Info">&nbsp;</td><td width="99%" class="Info">' + sLineBreak;
  IntfSect    = '<tr><td width="1%">&nbsp;</td><td width="99%">'                           + sLineBreak;
  IntfSectEnd = '</td></tr>'                                                               + sLineBreak +
                '<tr><td>&nbsp;</td><td>&nbsp;</td></tr>'                                  + sLineBreak;

  IntfBeg = '<tr>' +
            '<td width="1%">&nbsp;</td>' +
            '<td width="99%">' +
            '<ul>';
  IntfEntL= '<li>'                                                                     + sLineBreak +
            '<a class="IntfName" href="%1:s?' + sQueryStringIntf + '=%0:s">%0:s</a>'   + sLineBreak;
  IntfEntP= '<li>'                                                                     + sLineBreak +
            '<span class="IntfName">%0:s</span>'                                       + sLineBreak;

  IntfWSDL= '<span class="WSDL">[</span>'                                              +
            '<a class="WSDL" href="%s">WSDL</a>'                                       +
            '<span class="WSDL">]</span>'                                              + sLineBreak;
  IntfNS =  '&nbsp;<span class="Namespace">(%0:s)</span>'                              + sLineBreak;
  IntDoc1=  '<table><tr><td width="2%">&nbsp;</td><td>'                                + sLineBreak;
  IntDoc2=  '<span class="Tip">%s</span></td></tr></table>'                            + sLineBreak;
  MethBeg=  '<ul>';
  MethEnt=  '<li><span class="MethName">%s</span></li>';
  MethEnd=  '</ul>';

  MethBeg2= '<table>'                                                                  + sLineBreak;
  MethEnt2= '<tr><td width="10%%" class="MethName">&nbsp;</td>' +
            '<td class="ParmName">%s</td><td>%s</td></tr>'                             + sLineBreak;
  MethEnt3= '<span class="MethName">%s(</span>%s<span class="MethName">)</span>';
  MethEnd2= '</table>'                                                                 + sLineBreak;

  IntfEnd=  '</li>' +
            '</ul>' +
            '</td>' +
            '</tr>';
  IntfFtr=  '</table>';

  RegHdr =  '<a name="types"></a><center><h3>Registered Types</h3>' +
            '<table cellpadding=2 cellspacing=1 border=0><tr>' +
            '<td class="TblHdr">Type</td>' +
            '<td class="TblHdr">XML Name</td>' +
            '<td class="TblHdr">Namespace</td>' +
            '<td class="TblHdr">Class</td>' +
            '<td class="TblHdr">Address</td>' +
            '<td class="TblHdr">ExtName</td></tr>';
  RegRow =  '%0:s<tr>' +
            '<td class="%1:s">%2:s</td>' +
            '<td class="%1:s">%3:s</td>' +
            '<td class="%1:s">%4:s</td>' +
            '<td class="%1:s">%5:s %6:s</td>' +
            '<td class="%1:s">%7:d</td>' +
            '<td class="%1:s">%8:s</td></tr>';
  RegFtr =  '</table></center>';
  TTypeKindStrings: array[TTypeKind] of string =  ('(tkUnknown)', '(tkInteger)', '(tkChar)',
                                                   '(tkEnumeration)', '(tkFloat)',
                                                   '(tkString)', '(tkSet)', '',
                                                   '(tkMethod)', '(tkWChar)', '(tkLString)',
                                                   '(tkWString)', '(tkVariant)', '(tkArray)',
                                                   '(tkRecord)', '(tkInterface)', '(tkInt64)',
                                                   '(tkDynArray)');
  sWSILPath = '/inspection.wsil';
var
  Path: string;
  HostScriptBaseURL: String;

  function ValidIntfName(const Entries: TInvRegIntfEntryArray;  const name: string): Boolean;
  var
    Entry: InvRegIntfEntry;
    I: Integer;
  begin
    Result := False;
    if Length(Entries) > 0 then
    begin
      for I := 0 to Length(Entries)-1 do
      begin
        Entry := Entries[I];
        if Entry.Name = name then
        begin
          Result := True;
          Exit;
        end;
      end;
    end;
  end;

  function GetReturnStr(const RInfo: PTypeInfo): string;
  var
    IsScalar: Boolean;
    URI, Name: WideString;
  begin
    Result := 'void ';          { Do not localize }
    if RInfo <> nil then
    begin
      if RemClassRegistry.InfoToURI(RInfo, URI, Name, IsScalar) then
        Result := Name + ' '
      else
        Name := '????';         { Do not localize }
    end;
  end;

  function GetParams(const Params: TIntfParamEntryArray): string;
  const
    Commas : array[Boolean] of string = ('', ', ');
  var
    I: Integer;
    Param: TIntfParamEntry;
    PName, TName: string;
    IsScalar: Boolean;
    URI, Name: WideString;
  begin
    Result := '';
    if Length(Params) > 0 then
    begin
      for I := 0 to Length(Params)-1 do
      begin
        Param := Params[I];
        if Param.Info = nil then
          continue;
        if RemClassRegistry.InfoToURI(Param.Info, URI, Name, IsScalar) then
          TName := Name
        else
          TName := '????';    { Do not localize }
        PName := Param.Name;
        Result:= Format('%s' +                                    { Do not localize }
                        '<span class="MethName">%s</span>'+       { Do not localize }
                        '<span class="ParmName">%s</span>'+       { Do not localize }
                        '<span class="MethName">&nbsp;%s</span>', { Do not localize }
                        [Result, Commas[Length(Result)>0], TName, PName]);
      end;
    end;
  end;

  function GetInterfaceInfo(const name: string): string;
  var
    Entries: TInvRegIntfEntryArray;
    Entry: InvRegIntfEntry;
    I, J: Integer;
    IntfInfo: PTypeInfo;
    IntfMD: TIntfMetaData;
    MethEntry: TIntfMethEntry;
    Namespace: string;
    IntfName : string;
    FuncSig, RetStr: string;
  begin;
    Result := '';
    Pub.GetPortTypeEntries(Entries);

    { Check if it's for a special interface }
    if name <> '' then
    begin
      if ValidIntfName(Entries, name) then
        IntfName := name
      else
        IntfName := '';
    end;

    if Length(Entries) > 0 then
    begin
      Result := IntfHdr;
      if IntfName = '' then
        Result := Result + IntfSectBig + Format(sServiceInfo, [ServiceName]) + IntfSectEnd
      else
      begin
        Result := Result + IntfSectBig + Format(sInterfaceInfo, [HostScriptBaseURL, ServiceName, IntfName]) + IntfSectEnd;
      end;

      for I := 0 to Length(Entries)-1 do
      begin
        Entry := Entries[I];
        if (IntfName <> '') and (Entry.Name <> IntfName) then
          continue;

        IntfInfo := InvRegistry.GetInterfaceTypeInfo(Entry.GUID);
        GetIntfMetaData(IntfInfo, IntfMD);
        Result := Result + IntfBeg;
        { Display linked or plain version of interface name }
        if (IntfName <> '') then
          Result := Result + Format(IntfEntP, [IntfMD.Name])
        else
          Result := Result + Format(IntfEntL, [IntfMD.Name, HostScriptBaseURL]);
        { Add link to WSDL }
        Result := Result + Format(IntfWSDL, [HostScriptBaseURL + '/wsdl/'+IntfMD.Name]);
        if IntfName <> '' then
        begin
          Namespace:= InvRegistry.GetNamespaceByGUID(Entry.GUID);
          Result := Result + Format(IntfNS, [Namespace]);
        end;
        if Entry.Documentation <> '' then
        begin
          Result := Result + IntDoc1;
          Result := Result + Format(IntDoc2, [Entry.Documentation]);
        end;
        if Length(IntfMD.MDA) > 0 then
        begin
          if IntfName <> '' then
            Result := Result + MethBeg2;
          for J := 0 to Length(IntfMD.MDA)-1 do
          begin
            MethEntry := IntfMD.MDA[J];
            if IntfName <> '' then
            begin
              FuncSig:= Format(MethEnt3, [IntfMD.MDA[J].Name, GetParams(MethEntry.Params)]);
              RetStr := GetReturnStr(MethEntry.ResultInfo);
              Result := Result + Format(MethEnt2, [RetStr, FuncSig]);
            end
            else
            begin
              Result := Result + MethBeg + Format(MethEnt, [IntfMD.MDA[J].Name]) + MethEnd;
            end;
          end;
          if IntfName <> '' then
            Result := Result + MethEnd2;
        end;
        Result := Result + IntfEnd;
      end;

      { WSIL Link }
      if IntfName = '' then
      begin
        Result := Result + IntfSectBig + sWSILInfo +
                  Format(sWSILLink, [HostScriptBaseUrl+sWSILPath]) + IntfSectEnd;
      end;

      Result := Result + IntfFtr;
    end;
  end;

  function GetRegisteredTypes: string;
  var
    I: Integer;
    Entry: TRemRegEntry;
    ObjName: string;
    InfoName: string;
    Style: string;
  begin
    Result := '';
    if RemClassRegistry.GetURICount > 0 then
    begin
      Result := RegHdr;
      for I := 0 to RemClassRegistry.GetURICount-1 do
      begin
        RemClassRegistry.GetURIMap(I, Entry);
        if Assigned(Entry.ClassType) then
          ObjName := Entry.ClassType.ClassName
        else
          ObjName := '';
        InfoName := Entry.Info.Name;
        Style := TblCls[I and 1 = 0];
        Result := Format(RegRow, [Result, Style, InfoName,
                                  Entry.Name, Entry.URI,
                                  ObjName, TTypeKindStrings[Entry.Info.Kind],
                                  Integer(Entry.Info), Entry.ExtName]);
      end;
      Result := Result + RegFtr;
    end;
  end;
var
  RegTypes: string;
  IntfInfo: string;
  IntfName: string;
begin
  HostScriptBaseURL := GetHostScriptBaseURL(Request);
  Path := Request.InternalPathInfo;

  { WSIL }
  if SameText(Path, sWSILPath) then
  begin
    WSILInfo(HostScriptBaseURL, Request, Response, Handled);
    Exit;
  end;

  try
    if (Request.QueryFields.Values[sQueryStringTypes] = '1' ) then
      RegTypes := GetRegisteredTypes;
  except
    { Don't let retrieval of bad types bring us down - IOW, since there's no way to enforce
      registration or registration of valid types, for that matter, let's be safe }
  end;

  { See if request was for a special interface }
  IntfName := Request.QueryFields.Values[sQueryStringIntf];
  IntfInfo := GetInterfaceInfo(IntfName);

  Response.Content := Format(HTMLTopTitleNoMarginWSIL, [ServiceName]) +
                      InfoTitle1 +
                      Format(InfoTitle2, [ServiceName, sServiceInfoPage]) +
                      IntfInfo + RegTypes +
                      HTMLEnd;
  Handled := True;
end;

procedure TWSDLHTMLPublish.WSILInfo(const HostScriptBaseURL: string; Request: TWebRequest;
            Response: TWebResponse; var Handled: Boolean);
var
  Entries: TInvRegIntfEntryArray;
  Entry: InvRegIntfEntry;
  I: Integer;
  Inspection: IXMLInspection;
  Service: IXMLServiceType;
  Abstrct: IXMLTypeOfAbstract;
  Name: IXMLNameType;
  Description: IXMLDescriptionType;
  ServiceName: WideString;
begin
  CoInitialize(nil);
  try
    Inspection := Newinspection;

    Pub.GetPortTypeEntries(Entries);
    if Length(Entries) > 0 then
    begin
      for I := 0 to Length(Entries)-1 do
      begin
        Entry := Entries[I];
        { Service Name }
        if Entry.ExtName <> '' then
          ServiceName := Entry.ExtName
        else
          ServiceName := Entry.Name;

        Service := Inspection.Service.Add;
        { Abstract }
        Abstrct := Service.Add;
        Abstrct.Text := Entry.Documentation;
        { Name }
        Name := Service.Name.Add;
        Name.Text := ServiceName;
        { WSDL Description }
        Description := Service.Description.Add;
        Description.ReferencedNamespace := Wsdlns;
        Description.Location := HostScriptBaseURL + '/wsdl/' + Entry.Name;
      end;
    end;

    Response.Content := Inspection.OwnerDocument.XML.Text;
    Response.ContentType := sTextXML;
    Handled := True;
  finally
    CoUninitialize;
  end;
end;

function TWSDLHTMLPublish.GetTargetNamespace: WideString;
begin
  if (FTargetNamespace <> '') then
    Result := FTargetNamespace
  else
    Result := WSDLIntf.tns;
end;

procedure TWSDLHTMLPublish.SetWebDispatch(const Value: TWebDispatch);
begin
 FWebDispatch.Assign(Value);
end;

{$IFDEF DIAMONDBACK_UP}
function TWSDLHTMLPublish.GetNameSpaceIsStored: Boolean;
begin
  Result := FTargetNameSpace <> 'http://tempuri.org/';
end;
{$ENDIF}

initialization
  { IWSDLPublish registration }
  InvRegistry.RegisterInterface(TypeInfo(IWSDLPublish), SBorlandTypeNamespace,
                                '', IWSDLPublishDoc);
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(IWSDLPublish),
                                        SBorlandTypeNamespace + '-IWSDLPublish');
  InvRegistry.RegisterInvokableClass(TWSDLPublish);

  { Admin Ini File }
  GetModuleFileName(HInstance, ModuleName, SizeOf(ModuleName));
  ServicePath := Copy(ModuleName, 1, StrLen(ModuleName) - Cardinal(Length(ExtractFileExt(ModuleName))));
  ServiceName := ExtractFileName(ServicePath);
  AdminIniFile:= ServicePath + '_WSDLADMIN.INI';  { do not localize } 
end.
