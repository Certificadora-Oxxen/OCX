// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 24/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 30
// *  Descrição Resumida : Cadastro de Categoria Animal
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    24/07/2002    Criação
// *   Hitalo    15/08/2002    Adicionar o Metodo PesquisarRelacionamento
// *
// *
// ********************************************************************
unit uCategoriasAnimal;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao,uIntMensagens,
  uIntCategoriasAnimal;

type
  TCategoriasAnimal = class(TASPMTSObject, ICategoriasAnimal)
  private
    FIntCategoriasAnimal : TIntCategoriasAnimal;
    FInicializado : Boolean;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar(CodAptidao: Integer; const IndAnimalAtivo,
      IndSexo: WideString; NumIdade: Integer; const IndAnimalCadastrado,
      CodOrdenacao, IndRestritoSistema: WideString): Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
    function PesquisarRelacionamento: Integer; safecall;
    procedure IrAoPrimeiro; safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TCategoriasAnimal.AfterConstruction;
begin
  inherited;
  FInicializado := False;
end;

procedure TCategoriasAnimal.BeforeDestruction;
begin
  If FIntCategoriasAnimal <> nil Then Begin
    FIntCategoriasAnimal.Free;
  End;
  inherited;
end;

function TCategoriasAnimal.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntCategoriasAnimal := TIntCategoriasAnimal.Create;
  Result := FIntCategoriasAnimal.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TCategoriasAnimal.EOF: WordBool;
begin
  result := FIntCategoriasAnimal.EOF;
end;

function TCategoriasAnimal.Pesquisar(CodAptidao: Integer;
  const IndAnimalAtivo, IndSexo: WideString; NumIdade: Integer;
  const IndAnimalCadastrado, CodOrdenacao,
  IndRestritoSistema: WideString): Integer;
begin
  result := FIntCategoriasAnimal.Pesquisar(CodAptidao,IndAnimalAtivo,
                     IndSexo,NumIdade,IndAnimalCadastrado,CodOrdenacao,IndRestritoSistema);
end;

function TCategoriasAnimal.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
  result := FIntCategoriasAnimal.ValorCampo(NomCampo);
end;

procedure TCategoriasAnimal.FecharPesquisa;
begin
  FIntCategoriasAnimal.FecharPesquisa;
end;

procedure TCategoriasAnimal.IrAoProximo;
begin
  FIntCategoriasAnimal.IrAoProximo;
end;

function TCategoriasAnimal.PesquisarRelacionamento: Integer;
begin
  result := FIntCategoriasAnimal.PesquisarRelacionamento;
end;

procedure TCategoriasAnimal.IrAoPrimeiro;
begin
  FIntCategoriasAnimal.IrAoPrimeiro;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TCategoriasAnimal, Class_CategoriasAnimal,
    ciMultiInstance, tmApartment);
end.
