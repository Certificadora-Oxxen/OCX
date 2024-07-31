unit uCriptografia;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uFerramentas;

type
  TCriptografia = class(TASPMTSObject, ICriptografia)
  function Criptografar(const Texto: WideString): WideString; safecall;
  function Descriptografar(const Texto: WideString): WideString; safecall;
  end;

implementation

uses ComServ;

// Implementação da função Criptografar
function TCriptografia.Criptografar(const Texto: WideString): WideString;
begin
  Result := uFerramentas.Criptografar(Texto);
end;

// Implementação da função Descriptografar
function TCriptografia.Descriptografar(const Texto: WideString): WideString;
begin
  Result := uFerramentas.Descriptografar(Texto);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TCriptografia, Class_Criptografia,
    ciMultiInstance, tmApartment);
end.
