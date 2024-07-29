unit uMensagem;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TMensagem = class(TASPMTSObject, IMensagem)
  private
    FCodigo : Integer;
    FTexto : String;
    FClasse: String;
    FMetodo: String;
    FTipo: Integer;
  protected
    function Get_Classe: WideString; safecall;
    function Get_Codigo: Integer; safecall;
    function Get_Metodo: WideString; safecall;
    function Get_Texto: WideString; safecall;
    procedure Set_Classe(const Value: WideString); safecall;
    procedure Set_Codigo(Value: Integer); safecall;
    procedure Set_Metodo(const Value: WideString); safecall;
    procedure Set_Texto(const Value: WideString); safecall;
    function Get_Tipo: Integer; safecall;
    procedure Set_Tipo(Value: Integer); safecall;
  public
    property Codigo : Integer read FCodigo write FCodigo;
    property Texto  : String  read FTexto  write FTexto;
    property Classe : String  read FClasse write FClasse;
    property Metodo : String  read FMetodo write FMetodo;
    property Tipo   : Integer read FTipo   write FTipo;
  end;

implementation

uses ComServ;

function TMensagem.Get_Classe: WideString;
begin
  Result := FClasse;
end;

function TMensagem.Get_Codigo: Integer;
begin
  Result := FCodigo;
end;

function TMensagem.Get_Metodo: WideString;
begin
  Result := FMetodo;
end;

function TMensagem.Get_Texto: WideString;
begin
  Result := FTexto;
end;

procedure TMensagem.Set_Classe(const Value: WideString);
begin
  FClasse := Value;
end;

procedure TMensagem.Set_Codigo(Value: Integer);
begin
  FCodigo := Value;
end;

procedure TMensagem.Set_Metodo(const Value: WideString);
begin
  FMetodo := Value;
end;

procedure TMensagem.Set_Texto(const Value: WideString);
begin
  FTexto := Value;
end;

function TMensagem.Get_Tipo: Integer;
begin
  Result := FTipo;
end;

procedure TMensagem.Set_Tipo(Value: Integer);
begin
  FTipo := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TMensagem, Class_Mensagem,
    ciMultiInstance, tmApartment);
end.
