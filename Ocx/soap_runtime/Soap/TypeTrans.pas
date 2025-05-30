{*******************************************************}
{                                                       }
{ Borland Delphi Visual Component Library               }
{                SOAP Support                           }
{                                                       }
{ Copyright (c) 2001 Borland Software Corporation       }
{                                                       }
{*******************************************************}

unit TypeTrans;

interface

uses TypInfo, IntfInfo, SysUtils, InvokeRegistry;

type

  TTypeTranslator = class
  public
    constructor Create;
    destructor Destroy; override;

    function   CastSoapToNative(Info: PTypeInfo; const SoapData: WideString;
                                NatData: Pointer; IsNull: Boolean): Boolean;
    procedure  CastNativeToSoap(Info: PTypeInfo; var SoapData: WideString;
                                NatData: Pointer; var IsNull: Boolean);
    procedure  CastSoapToVariant(SoapInfo: PTypeInfo; const SoapData: WideString; NatData: Pointer); overload;
    function   CastSoapToVariant(SoapInfo: PTypeInfo; const SoapData: WideString): Variant; overload;
    procedure  Base64ToVar(NatData: Pointer; const SoapData: WideString); overload;
    procedure  Base64ToVar(var V: Variant; const SoapData: WideString); overload;
  end;

  ETypeTransException = class(Exception);

function  FloatToStrEx(Value: Extended): string;
function  StrToFloatEx(const S: string): Extended;
function  GetEnumValueEx(TypInfo: PTypeInfo; const Name: string): Integer;
procedure SetEnumPropEx(Instance: TObject; PropInfo: PPropInfo;
                        const Value: string);

var
  TypeTranslator: TTypeTranslator;

implementation

uses Variants, SOAPConst, EncdDecd, Types, Math, XSBuiltIns;


constructor TTypeTranslator.Create;
begin
  inherited Create;
end;

destructor TTypeTranslator.Destroy;
begin
  inherited;
end;

type
  PWideChar = ^WideChar;

function TTypeTranslator.CastSoapToVariant(SoapInfo: PTypeInfo; const SoapData: WideString): Variant;
var
  I64: Int64;
begin
  case SoapInfo.Kind of
    tkString,
    tkLString,
    tkChar:
     Result  := SoapData;
    tkInt64:
      Result := StrToInt64(Trim(SoapData));
    tkInteger:
      begin
        if GetTypeData(SoapInfo).OrdType = otULong then
        begin
          I64 := StrToInt64(Trim(SoapData));
          Result := Cardinal(I64);
        end else
          Result := StrToInt(Trim(SoapData));
      end;
    tkFloat:
      Result:= StrToFloatEx(Trim(SoapData));
    tkWChar,
    tkWString:
      Result := WideString(Trim(SoapData));
    tkClass:
      ;
    tkSet,
    tkMethod,

    tkArray,
    tkRecord,
    tkInterface,
    tkEnumeration:
      raise ETypeTransException.Create(SVariantCastNotSupported);
    tkDynArray:
    begin
      if SameTypeInfo(TypeInfo(Types.TByteDynArray), SoapInfo) then
        Base64ToVar(Result, SoapData)
      else
       raise ETypeTransException.Create(SVariantCastNotSupported);
    end;
  end;
end;


procedure TTypeTranslator.CastSoapToVariant(SoapInfo: PTypeInfo; const SoapData: WideString; NatData: Pointer);
begin
  case SoapInfo.Kind of
    tkString,
    tkLString,
    tkChar:
      Variant(PVarData(NatData)^) := SoapData;
    tkInt64:
      Variant(PVarData(NatData)^) := StrToInt64(Trim(SoapData));
    tkInteger:
      Variant(PVarData(NatData)^) := StrToInt(Trim(SoapData));
    tkFloat:
      Variant(PVarData(NatData)^) := StrToFloatEx(Trim(SoapData));
    tkWChar,
    tkWString:
      Variant(PVarData(NatData)^) := WideString(SoapData);
    tkDynArray:
      begin
        if SameTypeInfo(TypeInfo(Types.TByteDynArray), SoapInfo) then
          Base64ToVar(NatData, SoapData)
        else
         raise ETypeTransException.Create(SVariantCastNotSupported);
       end;
    tkClass:
      ;
    tkSet,
    tkMethod,

    tkArray,
    tkRecord,
    tkInterface,
    tkEnumeration:
      raise ETypeTransException.Create(SVariantCastNotSupported);
  end;
end;

{ Convert string to Enum value }
function GetEnumValueEx(TypInfo: PTypeInfo; const Name: string): Integer;
var
  PName: string;
begin
  PName := Name;
  if SameTypeInfo(TypeInfo(System.Boolean), TypInfo) or
     SameTypeInfo(TypeInfo(System.ByteBool), TypInfo) or
     SameTypeInfo(TypeInfo(System.WordBool), TypInfo) or
     SameTypeInfo(TypeInfo(System.LongBool), TypInfo) then
  begin
    if SameText(Name, 'true') or SameText(Name, '1') then         { Do not localize }
      PName := 'True'                                             { Do not localize }
    else if SameText(Name, 'false') or SameText(Name, '0') then   { Do not localize }
      PName := 'False';                                           { Do not localize }
    Result := GetEnumValue(TypeInfo(System.Boolean), PName);
  end else
  begin
    { Here check whether this enumeration has been renamed }
    PName := RemTypeRegistry.GetInternalPropName(TypInfo, PName);
    Result := GetEnumValue(TypInfo, PName);
  end;
end;

procedure SetEnumPropEx(Instance: TObject; PropInfo: PPropInfo;
  const Value: string);
var
  Val: string;
  TypInfo: PTypeInfo;
begin
  TypInfo := PropInfo.PropType^;
  if SameTypeInfo(TypeInfo(System.Boolean), TypInfo) or
     SameTypeInfo(TypeInfo(System.ByteBool), TypInfo) or
     SameTypeInfo(TypeInfo(System.WordBool), TypInfo) or
     SameTypeInfo(TypeInfo(System.LongBool), TypInfo) then
  begin
    if SameText(Value, 'true') or SameText(Value, '1') then
      Val := 'True'
    else if SameText(Value, 'false') or SameText(Value, '0') then
      Val := 'False';
    SetEnumProp(Instance, PropInfo, Val);
  end else
  begin
    Val := RemClassRegistry.GetInternalPropName(TypInfo, Value);
    SetEnumProp(Instance, PropInfo, Val);
  end;
end;

{ Convert String to Float }
function StrToFloatEx(const S: string): Extended;
begin
  if SameText(S, 'NaN') then
    Result := Nan
  else if SameText(S, 'INF') then
    Result := Infinity
  else if SameText(S, '-INF') then
    Result := NegInfinity
  else
    Result := SoapStrToFloat(S);
end;

function IsNeg(const AValue: Double): Boolean;
begin
  Result := ((PInt64(@AValue)^ and $8000000000000000) = $8000000000000000);
end;

{ Convert float to String }
function FloatToStrEx(Value: Extended): string;
begin
  if IsNan(Value) then
    Result := 'NaN'
  else if IsInfinite(Value) then
  begin
    { +|- ve }
    if isNeg(Value) then
      Result := '-INF'
    else
      Result := 'INF';
  end
  else
    Result := SoapFloatToStr(Value);
end;

function  TTypeTranslator.CastSoapToNative(Info: PTypeInfo; const SoapData: WideString; NatData: Pointer; IsNull: Boolean): Boolean;
var
  ParamTypeData: PTypeData;
  DefaultSeparator: Char;
begin
  { NOTE: The following in not threadsafe, as reported in QC:30095}
  DefaultSeparator := DecimalSeparator;  
  DecimalSeparator := '.';
  try
    Result := True;
    if IsNull and (Info.Kind = tkVariant) then
    begin
      Variant(PVarData(NatData)^) := NULL;
      Exit;
    end;
    ParamTypeData := GetTypeData(Info);
    case Info^.Kind of
      tkInteger:
        case ParamTypeData^.OrdType of
          otSByte,
          otUByte:
            PByte(NatData)^ := StrToInt(Trim(SoapData));
          otSWord,
          otUWord:
          PSmallInt(NatData)^ := StrToInt(Trim(SoapData));
        otSLong,
        otULong:
          PInteger(NatData)^ := StrToInt(Trim(SoapData));
      end;
      tkFloat:
        case ParamTypeData^.FloatType of
          ftSingle:
            PSingle(NatData)^ := StrToFloatEx(Trim(SoapData));
          ftDouble:
          begin
            if Info = TypeInfo(TDateTime) then
              PDateTime(NatData)^ := XMLTimeToDateTime(Trim(SoapData))
            else
              PDouble(NatData)^ := StrToFloatEx(Trim(SoapData));
          end;
  
          ftComp:
            PComp(NatData)^ := StrToFloatEx(Trim(SoapData));
          ftCurr:
            PCurrency(NatData)^ := StrToFloatEx(Trim(SoapData));
          ftExtended:
            PExtended(NatData)^ := StrToFloatEx(Trim(SoapData));
        end;
      tkWString:
        PWideString(NatData)^ := SoapData;
      tkString:
        PShortString(NatData)^ := SoapData;
      tkLString:
        PString(NatData)^ := SoapData;
      tkChar:
        if SoapData <> '' then
          PChar(NatData)^ := Char(SoapData[1]);
      tkWChar:
        if SoapData <> '' then
          PWideChar(NatData)^ := WideChar(SoapData[1]);
      tkInt64:
        PInt64(NatData)^ := StrToInt64(Trim(SoapData));
  
      tkEnumeration:
        { NOTE: Here we assume enums to be byte-size; make sure (specially for C++)
                that enums have generated with the proper size }
        PByte(NatData)^ :=  GetEnumValueEx(Info, Trim(SoapData));
      tkClass:
        ;
      tkSet,
      tkMethod,
  
      tkArray,
      tkRecord,
      tkInterface,
  
      tkDynArray:
        raise ETypeTransException.CreateFmt(SUnexpectedDataType, [ KindNameArray[Info.Kind]] );
      tkVariant:
        CastSoapToVariant(Info, SoapData, NatData);
    end;
  finally
    DecimalSeparator := DefaultSeparator; 
  end;
end;

procedure TTypeTranslator.CastNativeToSoap(Info: PTypeInfo;
     var SoapData: WideString; NatData: Pointer; var IsNull: Boolean);
var
  TypeData: PTypeData;
begin
  TypeData := GetTypeData(Info);
  case Info.Kind of
    tkInteger:
      case TypeData.OrdType of
        otSByte,
        otUByte:
          SoapData := IntToStr(byte(NatData^) );
        otSWord:
          SoapData := IntToStr(SmallInt(NatData^));
        otUWord:
           SoapData := IntToStr(SmallInt(NatData^));
        otSLong,
        otULong:
          SoapData := IntToStr(Integer(NatData^));
      end;
    tkFloat:
      case TypeData.FloatType of
        ftSingle:
          SoapData := FloatToStrEx(Single(NatData^));
        ftDouble:
        begin
          if Info = TypeInfo(TDateTime) then
            SoapData := DateTimeToXMLTime(TDateTime(NatData^), True)
          else
            SoapData := FloatToStrEx(Double(NatData^));
        end;
        ftComp:
          SoapData := FloatToStrEx(Comp(NatData^));
        ftCurr:
          SoapData := FloatToStrEx(Currency(NatData^));
        ftExtended:
         SoapData := FloatToStrEx(Extended(NatData^));
      end;
    tkInt64:
      SoapData := IntToStr(Int64(NatData^));
    tkChar:
      SoapData := Char(NatData^);
    tkWChar:
      SoapData := WideChar(NatData^);
    tkWString:
      SoapData  := PWideString(NatData)^;
    tkString:
      SoapData := PShortString(NatData)^;
    tkLString:
      SoapData := PAnsiString(NatData)^;
  end;
end;

procedure TTypeTranslator.Base64ToVar(var V: Variant; const SoapData: WideString);
var
  Base64Dec: String;
  P: Pointer;
begin
  Base64Dec := DecodeString(SoapData);
  V :=  VarArrayCreate([0, Length(Base64Dec) - 1], varByte);
  P := VarArrayLock(V);
  try
    Move(Base64Dec[1], P^, Length(Base64Dec));
  finally
    VarArrayUnLock(V);
  end;
end;

procedure TTypeTranslator.Base64ToVar(NatData: Pointer; const SoapData: WideString);
begin
  Base64ToVar(PVariant(PVarData(NatData))^, SoapData);
end;


initialization
  TypeTranslator := TTypeTranslator.Create;

finalization
  TypeTranslator.Free;

end.
