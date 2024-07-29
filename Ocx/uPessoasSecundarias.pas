// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 31/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Código Classe      : 41
// *  Descrição Resumida : Cadastro de Pessoas Secundárias
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    31/07/2002    Criação
// *   Arley     06/08/2002    Adição no cadastro de alguns atributos
// ********************************************************************
unit uPessoasSecundarias;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao, uIntMensagens,
  uPessoaSecundaria, uIntPessoasSecundarias;

type
  TPessoasSecundarias = class(TASPMTSObject, IPessoasSecundarias)
  private
    FIntPessoasSecundarias : TIntPessoasSecundarias;
    FInicializado : Boolean;
    FPessoaSecundaria : TPessoaSecundaria;
  protected
    function Pesquisar(CodPapelSecundario: Integer;
      const CodOrdenacao: WideString): Integer; safecall;
    function Inserir(const NomPessoaSecundaria, NomReduzidoPessoaSecundaria,
      CodNaturezaPessoa, NumCNPJCPF: WideString; CodTipoContato1: Integer;
      const TxtContato1: WideString; CodTipoContato2: Integer;
      const TxtContato2: WideString; CodTipoContato3: Integer;
      const TxtContato3: WideString; CodTipoEndereco: Integer;
      const NomLogradouro, NomBairro, NumCEP, NomPais, SglEstado,
      NomMunicipio, NumMunicipioIBGE, NomDistrito,
      TxtObservacao: WideString): Integer; safecall;
    function Alterar(CodPessoaSecundaria: Integer; const NomPessoaSecundaria,
      NomReduzidoPessoaSecundaria, CodNaturezaPessoa,
      NumCNPJCPF: WideString; CodTipoContato1: Integer;
      const TxtContato1: WideString; CodTipoContato2: Integer;
      const TxtContato2: WideString; CodTipoContato3: Integer;
      const TxtContato3: WideString; CodTipoEndereco: Integer;
      const NomLogradouro, NomBairro, NumCEP, NomPais, SglEstado,
      NomMunicipio, NumMunicipioIBGE, NomDistrito,
      TxtObservacao: WideString): Integer; safecall;
    function Excluir(CodPessoaSecundaria: Integer): Integer; safecall;
    function BOF: WordBool; safecall;
    function EOF: WordBool; safecall;
    function NumeroRegistros: Integer; safecall;
    function AdicionarPapelSecundario(CodPessoaSecundaria,
      CodPapelSecundario: Integer): Integer; safecall;
    function PossuiPapelSecundario(CodPessoaSecundaria,
      CodPapelSecundario: Integer): Integer; safecall;
    function RetirarPapelSecundario(CodPessoaSecundaria,
      CodPapelSecundario: Integer): Integer; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoUltimo; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoProximo; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure Deslocar(NumDeslocamento: Integer); safecall;
    procedure FecharPesquisa; safecall;
    function Buscar(CodPessoaSecundaria: Integer): Integer; safecall;
    function Get_PessoaSecundaria: IPessoaSecundaria; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TPessoasSecundarias.AfterConstruction;
begin
  inherited;
  FPessoaSecundaria := TPessoaSecundaria.Create;
  FPessoaSecundaria.ObjAddRef;
  FInicializado := False;
end;

procedure TPessoasSecundarias.BeforeDestruction;
begin
  If FIntPessoasSecundarias <> nil Then Begin
    FIntPessoasSecundarias.Free;
  End;
  If FPessoaSecundaria <> nil Then Begin
    FPessoaSecundaria.ObjRelease;
    FPessoaSecundaria := nil;
  End;
  inherited;
end;

function TPessoasSecundarias.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntPessoasSecundarias := TIntPessoasSecundarias.Create;
  Result := FIntPessoasSecundarias.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
End;

function TPessoasSecundarias.Pesquisar(CodPapelSecundario: Integer;
  const CodOrdenacao: WideString): Integer;
begin
  result := FIntPessoasSecundarias.Pesquisar(CodPapelSecundario,CodOrdenacao);
end;

function TPessoasSecundarias.Inserir(const NomPessoaSecundaria,
  NomReduzidoPessoaSecundaria, CodNaturezaPessoa, NumCNPJCPF: WideString;
  CodTipoContato1: Integer; const TxtContato1: WideString;
  CodTipoContato2: Integer; const TxtContato2: WideString;
  CodTipoContato3: Integer; const TxtContato3: WideString;
  CodTipoEndereco: Integer; const NomLogradouro, NomBairro, NumCEP,
  NomPais, SglEstado, NomMunicipio, NumMunicipioIBGE, NomDistrito,
  TxtObservacao: WideString): Integer;
begin
  Result := FIntPessoasSecundarias.Inserir(
    NomPessoaSecundaria
    , NomReduzidoPessoaSecundaria
    , CodNaturezaPessoa
    , NumCNPJCPF
    , CodTipoContato1
    , TxtContato1
    , CodTipoContato2
    , TxtContato2
    , CodTipoContato3
    , TxtContato3
    , CodTipoEndereco
    , NomLogradouro
    , NomBairro
    , NumCep
    , NomPais
    , SglEstado
    , NomMunicipio
    , NumMunicipioIBGE
    , NomDistrito
    , TxtObservacao);
end;

function TPessoasSecundarias.Alterar(CodPessoaSecundaria: Integer;
  const NomPessoaSecundaria, NomReduzidoPessoaSecundaria,
  CodNaturezaPessoa, NumCNPJCPF: WideString; CodTipoContato1: Integer;
  const TxtContato1: WideString; CodTipoContato2: Integer;
  const TxtContato2: WideString; CodTipoContato3: Integer;
  const TxtContato3: WideString; CodTipoEndereco: Integer;
  const NomLogradouro, NomBairro, NumCEP, NomPais, SglEstado, NomMunicipio,
  NumMunicipioIBGE, NomDistrito, TxtObservacao: WideString): Integer;
begin
  Result := FIntPessoasSecundarias.Alterar(
    CodPessoaSecundaria
    , NomPessoaSecundaria
    , NomReduzidoPessoaSecundaria
    , CodNaturezaPessoa
    , NumCNPJCPF
    , CodTipoContato1
    , TxtContato1
    , CodTipoContato2
    , TxtContato2
    , CodTipoContato3
    , TxtContato3
    , CodTipoEndereco
    , NomLogradouro
    , NomBairro
    , NumCep
    , NomPais
    , SglEstado
    , NomMunicipio
    , NumMunicipioIBGE
    , NomDistrito
    , TxtObservacao)
end;

function TPessoasSecundarias.Excluir(
  CodPessoaSecundaria: Integer): Integer;
begin
  result := FIntPessoasSecundarias.Excluir(CodPessoaSecundaria);
end;

function TPessoasSecundarias.BOF: WordBool;
begin
  result := FIntPessoasSecundarias.BOF;
end;

function TPessoasSecundarias.EOF: WordBool;
begin
  result := FIntPessoasSecundarias.EOF;
end;

function TPessoasSecundarias.NumeroRegistros: Integer;
begin
  result := FIntPessoasSecundarias.NumeroRegistros;
end;

function TPessoasSecundarias.AdicionarPapelSecundario(CodPessoaSecundaria,
  CodPapelSecundario: Integer): Integer;
begin
  result := FIntPessoasSecundarias.AdicionarPapelSecundario(CodPessoaSecundaria,CodPapelSecundario);
end;

function TPessoasSecundarias.PossuiPapelSecundario(CodPessoaSecundaria,
  CodPapelSecundario: Integer): Integer;
begin
  result := FIntPessoasSecundarias.PossuiPapelSecundario(CodPessoaSecundaria,CodPapelSecundario);
end;

function TPessoasSecundarias.RetirarPapelSecundario(CodPessoaSecundaria,
  CodPapelSecundario: Integer): Integer;
begin
  result := FIntPessoasSecundarias.RetirarPapelSecundario(CodPessoaSecundaria,CodPapelSecundario);
end;

procedure TPessoasSecundarias.IrAoPrimeiro;
begin
  FIntPessoasSecundarias.IrAoPrimeiro;
end;

procedure TPessoasSecundarias.IrAoUltimo;
begin
  FIntPessoasSecundarias.IrAoUltimo;
end;

procedure TPessoasSecundarias.IrAoAnterior;
begin
  FIntPessoasSecundarias.IrAoAnterior;
end;

procedure TPessoasSecundarias.IrAoProximo;
begin
  FIntPessoasSecundarias.IrAoProximo;
end;

procedure TPessoasSecundarias.Posicionar(NumPosicao: Integer);
begin
  FIntPessoasSecundarias.Posicionar(NumPosicao);
end;

function TPessoasSecundarias.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
 result := FIntPessoasSecundarias.ValorCampo(NomCampo);
end;

procedure TPessoasSecundarias.Deslocar(NumDeslocamento: Integer);
begin
  FIntPessoasSecundarias.Deslocar(NumDeslocamento);
end;

procedure TPessoasSecundarias.FecharPesquisa;
begin
  FIntPessoasSecundarias.FecharPesquisa;
end;

function TPessoasSecundarias.Buscar(CodPessoaSecundaria: Integer): Integer;
begin
  result:= FIntPessoasSecundarias.Buscar(CodPessoaSecundaria);
end;

function TPessoasSecundarias.Get_PessoaSecundaria: IPessoaSecundaria;
begin
  FPessoaSecundaria.CodPessoaProdutor             := FIntPessoasSecundarias.IntPessoaSecundaria.CodPessoaProdutor;
  FPessoaSecundaria.CodPessoaSecundaria           := FIntPessoasSecundarias.IntPessoaSecundaria.CodPessoaSecundaria;
  FPessoaSecundaria.NomPessoaSecundaria           := FIntPessoasSecundarias.IntPessoaSecundaria.NomPessoaSecundaria;
  FPessoaSecundaria.NomReduzidoPessoaSecundaria   := FIntPessoasSecundarias.IntPessoaSecundaria.NomReduzidoPessoaSecundaria;
  FPessoaSecundaria.CodNaturezaPessoa             := FIntPessoasSecundarias.IntPessoaSecundaria.CodNaturezaPessoa;
  FPessoaSecundaria.DtaCadastramento              := FIntPessoasSecundarias.IntPessoaSecundaria.DtaCadastramento;
  FPessoaSecundaria.NumCNPJCPF                    := FIntPessoasSecundarias.IntPessoaSecundaria.NumCNPJCPF;
  FPessoaSecundaria.NumCNPJCPFFormatado           := FIntPessoasSecundarias.IntPessoaSecundaria.NumCNPJCPFFormatado;
  FPessoaSecundaria.CodTipoContato1               := FIntPessoasSecundarias.IntPessoaSecundaria.CodTipoContato1;
  FPessoaSecundaria.DesTipoContato1               := FIntPessoasSecundarias.IntPessoaSecundaria.DesTipoContato1;
  FPessoaSecundaria.TxtContato1                   := FIntPessoasSecundarias.IntPessoaSecundaria.TxtContato1;
  FPessoaSecundaria.CodTipoContato2               := FIntPessoasSecundarias.IntPessoaSecundaria.CodTipoContato2;
  FPessoaSecundaria.DesTipoContato2               := FIntPessoasSecundarias.IntPessoaSecundaria.DesTipoContato2;
  FPessoaSecundaria.TxtContato2                   := FIntPessoasSecundarias.IntPessoaSecundaria.TxtContato2;
  FPessoaSecundaria.CodTipoContato3               := FIntPessoasSecundarias.IntPessoaSecundaria.CodTipoContato3;
  FPessoaSecundaria.DesTipoContato3               := FIntPessoasSecundarias.IntPessoaSecundaria.DesTipoContato3;
  FPessoaSecundaria.TxtContato3                   := FIntPessoasSecundarias.IntPessoaSecundaria.TxtContato3;
  FPessoaSecundaria.CodTipoEndereco               := FIntPessoasSecundarias.IntPessoaSecundaria.CodTipoEndereco;
  FPessoaSecundaria.NomLogradouro                 := FIntPessoasSecundarias.IntPessoaSecundaria.NomLogradouro;
  FPessoaSecundaria.NomBairro                     := FIntPessoasSecundarias.IntPessoaSecundaria.NomBairro;
  FPessoaSecundaria.NumCep                        := FIntPessoasSecundarias.IntPessoaSecundaria.NumCep;
  FPessoaSecundaria.NomPais                       := FIntPessoasSecundarias.IntPessoaSecundaria.NomPais;
  FPessoaSecundaria.SglEstado                     := FIntPessoasSecundarias.IntPessoaSecundaria.SglEstado;
  FPessoaSecundaria.NomMunicipio                  := FIntPessoasSecundarias.IntPessoaSecundaria.NomMunicipio;
  FPessoaSecundaria.NumMunicipioIBGE              := FIntPessoasSecundarias.IntPessoaSecundaria.NumMunicipioIBGE;
  FPessoaSecundaria.NomDistrito                   := FIntPessoasSecundarias.IntPessoaSecundaria.NomDistrito;
  FPessoaSecundaria.txtObservacao                 := FIntPessoasSecundarias.IntPessoaSecundaria.txtObservacao;
  Result := FPessoaSecundaria;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TPessoasSecundarias, Class_PessoasSecundarias,
    ciMultiInstance, tmApartment);
end.
