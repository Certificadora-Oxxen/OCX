unit uTiposOrigemArqImport;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uTipoOrigemArqImport, uIntTiposOrigemArqImport,
  Classes, DBTables, SysUtils, DB, uIntClassesBasicas,
  uFerramentas, uConexao, uIntMensagens;

type
  TTiposOrigemArqImport = class(TASPMTSObject, ITiposOrigemArqImport)
  private
     FTipoOrigemArqImport: TTipoOrigemArqImport;
     FIntTiposOrigemArqImport: TIntTiposOrigemArqImport;
     FInicializado: Boolean;
  protected
    function Pesquisar: Integer; safecall;
    function BOF: WordBool; safecall;
    function EOF: WordBool; safecall;
    function NumeroRegistros: Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    function Get_TipoOrigemArqImport: ITipoOrigemArqImport; safecall;

  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

function TTiposOrigemArqImport.Inicializar(ConexaoBD: TConexao;
  Mensagens: TIntMensagens): Integer;
begin
  FIntTiposOrigemArqImport := TIntTiposOrigemArqImport.Create;
  Result := FIntTiposOrigemArqImport.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TTiposOrigemArqImport.Pesquisar: Integer;
begin
   Result := FIntTiposOrigemArqImport.Pesquisar;
end;

function TTiposOrigemArqImport.BOF: WordBool;
begin
   Result := FIntTiposOrigemArqImport.BOF;
end;

function TTiposOrigemArqImport.EOF: WordBool;
begin
   Result := FIntTiposOrigemArqImport.EOF;
end;

function TTiposOrigemArqImport.NumeroRegistros: Integer;
begin
   Result := FIntTiposOrigemArqImport.NumeroRegistros;
end;

function TTiposOrigemArqImport.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
   Result := FIntTiposOrigemArqImport.ValorCampo(NomCampo);
end;

procedure TTiposOrigemArqImport.IrAoAnterior;
begin
   FIntTiposOrigemArqImport.IrAoAnterior;
end;

procedure TTiposOrigemArqImport.IrAoPrimeiro;
begin
   FIntTiposOrigemArqImport.IrAoPrimeiro;
end;

procedure TTiposOrigemArqImport.IrAoProximo;
begin
   FIntTiposOrigemArqImport.IrAoProximo;
end;

procedure TTiposOrigemArqImport.IrAoUltimo;
begin
   FIntTiposOrigemArqImport.IrAoUltimo;
end;

procedure TTiposOrigemArqImport.AfterConstruction;
begin
  inherited;
end;

procedure TTiposOrigemArqImport.BeforeDestruction;
begin
  If FIntTiposOrigemArqImport <> nil Then Begin
    FIntTiposOrigemArqImport.Free;
  End;
  inherited;
end;

function TTiposOrigemArqImport.Get_TipoOrigemArqImport: ITipoOrigemArqImport;
begin
   FTipoOrigemArqImport.CodTipoOrigemArqImport := FIntTiposOrigemArqImport.IntTipoOrigemArqImport.CodTipoOrigemArqImport;
   FTipoOrigemArqImport.SglTipoOrigemArqImport := FIntTiposOrigemArqImport.IntTipoOrigemArqImport.SglTipoOrigemArqImport;
   FTipoOrigemArqImport.DesTipoOrigemArqImport := FIntTiposOrigemArqImport.IntTipoOrigemArqImport.DesTipoOrigemArqImport;
   Result := FTipoOrigemArqImport;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTiposOrigemArqImport, Class_TiposOrigemArqImport,
    ciMultiInstance, tmApartment);
end.
