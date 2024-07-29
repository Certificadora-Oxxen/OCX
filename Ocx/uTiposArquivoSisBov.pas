// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 31/10/2002
// *  Documentação       :
// *  Código Classe      : 70
// *  Descrição Resumida : Pesquisa de arquivos SISBOV
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    31/10/2002    Criação
// *
// ********************************************************************
unit uTiposArquivoSisBov;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao,uIntMensagens,
  uIntTiposArquivoSISBOV;

type
  TTiposArquivoSisBov = class(TASPMTSObject, ITiposArquivoSisBov)
  private
    FIntTiposArquivoSisBov : TIntTiposArquivoSisBov;
    FInicializado : Boolean;
  protected
    function EOF: WordBool; safecall;
    function ValorCampo(const NomColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    function Pesquisar: Integer; safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TTiposArquivoSisBov.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TTiposArquivoSisBov.BeforeDestruction;
begin
  If FIntTiposArquivoSisBov <> nil Then Begin
    FIntTiposArquivoSisBov.Free;
  End;
  inherited;
end;

function TTiposArquivoSisBov.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntTiposArquivoSisBov := TIntTiposArquivoSisBov.Create;
  Result := FIntTiposArquivoSisBov.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TTiposArquivoSisBov.EOF: WordBool;
begin
  result := FIntTiposArquivoSisBov.EOF;
end;

function TTiposArquivoSisBov.ValorCampo(
  const NomColuna: WideString): OleVariant;
begin
  result := FIntTiposArquivoSisBov.ValorCampo(NomColuna);
end;

procedure TTiposArquivoSisBov.FecharPesquisa;
begin
  FIntTiposArquivoSisBov.FecharPesquisa;
end;

procedure TTiposArquivoSisBov.IrAoPrimeiro;
begin
  FIntTiposArquivoSisBov.IrAoPrimeiro;
end;

procedure TTiposArquivoSisBov.IrAoProximo;
begin
  FIntTiposArquivoSisBov.IrAoProximo;
end;

function TTiposArquivoSisBov.Pesquisar: Integer;
begin
  result := FIntTiposArquivoSisBov.Pesquisar;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTiposArquivoSisBov, Class_TiposArquivoSisBov,
    ciMultiInstance, tmApartment);
end.
