// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Adalberto Knychala Neto
// *  Versão             : 1
// *  Data               : 10/08/2004
// *  Documentação       : ????
// *  Código Classe      : ???
// *  Descrição Resumida : Pesquisa por enderecos
// ************************************************************************
// *  Últimas Alterações :
// *
// ************************************************************************
unit uEnderecos;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uIntEnderecos, uEndereco;

type
  TEnderecos = class(TASPMTSObject, IEnderecos)
  private
    FIntEnderecos: TIntEnderecos;
    FEndereco: TEndereco;
    FInicializado: boolean;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  protected
    function Buscar(CodEndereco: Integer): Integer; safecall;
    function Get_Endereco: IEndereco; safecall;
    function EOF: WordBool; safecall;
    function ValorCampo(const CodCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
  end;

implementation

uses ComServ;

procedure TEnderecos.AfterConstruction;
begin
  inherited;
  FEndereco := TEndereco.Create;
  FIntEnderecos := TIntEnderecos.Create;
  FEndereco.ObjAddRef;
  FInicializado := False;
end;

procedure TEnderecos.BeforeDestruction;
begin
  If FIntEnderecos <> nil Then Begin
    FIntEnderecos.Free;
  End;
  If FEndereco <> nil then begin
    FEndereco.ObjRelease;
    FEndereco := nil;
  end;
  inherited;
end;

function TEnderecos.Inicializar(ConexaoBD: TConexao;
  Mensagens: TIntMensagens): Integer;
begin
  Result := FIntEnderecos.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TEnderecos.Buscar(CodEndereco: Integer): Integer;
begin
  Result := FIntEnderecos.Buscar(CodEndereco);
end;

function TEnderecos.Get_Endereco: IEndereco;
begin
   FEndereco.CodEndereco       := FIntEnderecos.IntEndereco.CodEndereco;
   FEndereco.CodTipoEndereco   := FIntEnderecos.IntEndereco.CodTipoEndereco ;
   FEndereco.SglTipoEndereco   := FIntEnderecos.IntEndereco.SglTipoEndereco ;
   FEndereco.DesTipoEndereco   := FIntEnderecos.IntEndereco.DesTipoEndereco ;
   FEndereco.NomPessoaContato  := FIntEnderecos.IntEndereco.NomPessoaContato ;
   FEndereco.NumTelefone       := FIntEnderecos.IntEndereco.NumTelefone ;
   FEndereco.NumFax            := FIntEnderecos.IntEndereco.NumFax ;
   FEndereco.TxtEmail          := FIntEnderecos.IntEndereco.TxtEmail ;
   FEndereco.NomLogradouro     := FIntEnderecos.IntEndereco.NomLogradouro ;
   FEndereco.NomBairro         := FIntEnderecos.IntEndereco.NomBairro ;
   FEndereco.NumCEP            := FIntEnderecos.IntEndereco.NumCEP ;
   FEndereco.CodDistrito       := FIntEnderecos.IntEndereco.CodDistrito ;
   FEndereco.NomDistrito       := FIntEnderecos.IntEndereco.NomDistrito ;
   FEndereco.CodMunicipio      := FIntEnderecos.IntEndereco.CodMunicipio ;
   FEndereco.NumMunicipioIBGE  := FIntEnderecos.IntEndereco.NumMunicipioIBGE ;
   FEndereco.NomMunicipio      := FIntEnderecos.IntEndereco.NomMunicipio ;
   FEndereco.CodEstado         := FIntEnderecos.IntEndereco.CodEstado ;
   FEndereco.SglEstado         := FIntEnderecos.IntEndereco.SglEstado ;
   FEndereco.NomEstado         := FIntEnderecos.IntEndereco.NomEstado ;
   FEndereco.CodPais           := FIntEnderecos.IntEndereco.CodPais ;
   FEndereco.NomPais           := FIntEnderecos.IntEndereco.NomPais ;
   Result := FEndereco;
end;

function TEnderecos.EOF: WordBool;
begin
  Result := FIntEnderecos.EOF;
end;

function TEnderecos.ValorCampo(const CodCampo: WideString): OleVariant;
begin
  Result := FIntEnderecos.ValorCampo(CodCampo);
end;

procedure TEnderecos.FecharPesquisa;
begin
  FIntEnderecos.FecharPesquisa;
end;

procedure TEnderecos.IrAoPrimeiro;
begin
  FIntEnderecos.IrAoPrimeiro;
end;

procedure TEnderecos.IrAoProximo;
begin
  FIntEnderecos.IrAoProximo;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TEnderecos, Class_Enderecos,
    ciMultiInstance, tmApartment);
end.
