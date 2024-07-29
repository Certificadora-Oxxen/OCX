// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 10/08/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 49
// *  Descrição Resumida : Cadastro de Causas Morte
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    10/08/2002    Criação
// *
// ********************************************************************
unit uCausasMorte;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao,uIntMensagens,
  uIntCausasMorte;

type
  TCausasMorte = class(TASPMTSObject, ICausasMorte)
  private
    FIntCausasMorte : TIntCausasMorte;
    FInicializado : Boolean;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar(const CorOrdenacao: WideString): Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
  end;

implementation

uses ComServ;

procedure TCausasMorte.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TCausasMorte.BeforeDestruction;
begin
  If FIntCausasMorte <> nil Then Begin
    FIntCausasMorte.Free;
  End;
  inherited;
end;

function TCausasMorte.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntCausasMorte := TIntCausasMorte.Create;
  Result := FIntCausasMorte.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TCausasMorte.EOF: WordBool;
begin
  result := FIntCausasMorte.EOF;
end;

function TCausasMorte.Pesquisar(const CorOrdenacao: WideString): Integer;
begin
  result := FIntCausasMorte.Pesquisar(CorOrdenacao); 
end;

function TCausasMorte.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  result := FIntCausasMorte.ValorCampo(NomCampo); 
end;

procedure TCausasMorte.FecharPesquisa;
begin
  FIntCausasMorte.FecharPesquisa;
end;

procedure TCausasMorte.IrAoProximo;
begin
  FIntCausasMorte.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TCausasMorte, Class_CausasMorte,
    ciMultiInstance, tmApartment);
end.
