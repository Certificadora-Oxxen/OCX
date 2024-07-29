unit uMensagens;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntMensagens, Windows, uMensagem;

type
  TMensagens = class(TASPMTSObject, IMensagens, IEnumVARIANT)
  private
    FItems : TColMensagens;
    FIndex : Integer;
  protected
    function Clone(out ppenum: IEnumVARIANT): HResult; stdcall;
    function Get__NewEnum: IUnknown; safecall;
    function Get_NumItens: Integer; safecall;
    function Item(Index: Integer): IDispatch; safecall;
    function Next(celt: LongWord; var rgvar: OleVariant;
      out pceltFetched: LongWord): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Skip(celt: LongWord): HResult; stdcall;
    function BuscarMensagem(Codigo: Integer): WideString; safecall;
  public
    procedure Adicionar(Codigo: Integer; const Texto, Classe,
      Metodo: WideString; Tipo: Integer); safecall;
    procedure Limpar; safecall;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

implementation

uses ComServ;

procedure TMensagens.AfterConstruction;
begin
  inherited;
  FItems := TColMensagens.Create(TIntMensagem);
end;

procedure TMensagens.BeforeDestruction;
begin
  FItems.Free;
  inherited;
end;

function TMensagens.Clone(out ppenum: IEnumVARIANT): HResult;
var
  Items: TMensagens;
  X : Integer;
begin
  Items := TMensagens.Create;
  For X := 0 to FItems.Count - 1 do Begin
    Items.Adicionar(FItems[X].Codigo,
                    FItems[X].Texto,
                    FItems[X].Classe,
                    FItems[X].Metodo,
                    FItems[X].Tipo);
  End;
  ppEnum := Items as IEnumVARIANT;
  Result := S_OK;
end;

function TMensagens.Get__NewEnum: IUnknown;
begin
  Result := Self as IEnumVARIANT;
end;

function TMensagens.Get_NumItens: Integer;
begin
  Result := FItems.Count;
end;

function TMensagens.Item(Index: Integer): IDispatch;
var
  Mensagem : TMensagem;
begin
  Mensagem := TMensagem.Create;
  Try
    Mensagem.Codigo := FItems[Index - 1].Codigo;
    Mensagem.Texto  := FItems[Index - 1].Texto;
    Mensagem.Classe := FItems[Index - 1].Classe;
    Mensagem.Metodo := FItems[Index - 1].Metodo;
    Mensagem.Tipo   := FItems[Index - 1].Tipo;
    Result := Mensagem as IDispatch;
  Finally
//    Mensagem.Free;
  End;
end;

// Obtem próximo item da coleção
// Este código é escrito para atender as declarações do tipo
// For each Obj in Collectoin
//   '...
// Next
//
function TMensagens.Next(celt: LongWord; var rgvar: OleVariant;
  out pceltFetched: LongWord): HResult;
type
  TVariantList = array [0..0] of OleVariant;
var
  Mensagem : TMensagem;
  I : LongWord;
begin
  I := 0;
  While (I < celt) and (FIndex < FItems.Count) do Begin
    Mensagem := TMensagem.Create;
    Mensagem.Codigo := FItems[Integer(I)+FIndex].Codigo;
    Mensagem.Texto  := FItems[Integer(I)+FIndex].Texto;
    Mensagem.Classe := FItems[Integer(I)+FIndex].Classe;
    Mensagem.Metodo := FItems[Integer(I)+FIndex].Metodo;
    Mensagem.Tipo   := FItems[Integer(I)+FIndex].Tipo;
    TVariantList(rgVar)[I] := Mensagem as IDispatch;
    Inc(I);
    Inc(FIndex);
  End;
  If (@pCeltFetched<> nil) Then Begin
    pCeltFetched := I;
  End;
  If (I= celt) Then Begin
    Result := S_OK;
  End Else Begin
    Result := S_FALSE;
  End;
end;

function TMensagens.Reset: HResult;
begin
  FIndex := 0;
  Result := S_OK;
end;

function TMensagens.Skip(celt: LongWord): HResult;
begin
  If (FIndex + Integer(celt) <= FItems.Count) Then Begin
    Inc(FIndex, celt);
    Result := S_OK;
  End Else Begin
    FIndex := FItems.Count;
    Result := S_FALSE;
  End;
end;

procedure TMensagens.Adicionar(Codigo: Integer; const Texto, Classe,
  Metodo: WideString; Tipo: Integer);
begin
  FItems.Add(Codigo, Texto, Classe, Metodo, Tipo);
end;

procedure TMensagens.Limpar;
begin
  FItems.Clear;
  FIndex := 0;
end;

function TMensagens.BuscarMensagem(Codigo: Integer): WideString;
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TMensagens, Class_Mensagens,
    ciMultiInstance, tmApartment);
end.
