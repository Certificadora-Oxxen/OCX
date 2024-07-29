// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 15/08/2002
// *  Documentação       : Propriedades Rurais, Fazendas, etc - Definição das
// *                       classes.doc
// *  Código Classe      : 32
// *  Descrição Resumida : Cadastro de Locais
// ************************************************************************
// *  Últimas Alterações
// *   Jerry    15/08/2002    Criação
// *   Hitalo   15/08/2002    Retirar os Campos NumIncra, NumPropriedadeRural
// *                          do metodo buscar e propriedade Buscar
// *
// ***************************************************************************
unit uLocais;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntLocais, uLocal, uConexao, uIntMensagens;

type
  TLocais = class(TASPMTSObject, ILocais)
  private
    FIntLocais : TIntLocais;
    FInicializado : Boolean;
    FLocal: TLocal;
  protected
    function BOF: WordBool; safecall;
    function EOF: WordBool; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumRegistro: Integer); safecall;
    function Deslocar(QtdRegistros: Integer): Integer; safecall;
    function NumeroRegistros: Integer; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    function Pesquisar(CodFazenda: Integer;
      const CodOrdenacao: WideString): Integer; safecall;
    function Inserir(CodFazenda: Integer; const SglLocal, DesLocal,
      CodTiposFonteAgua, IndPrincipal: WideString): Integer; safecall;
    function Alterar(CodFazenda, CodLocal: Integer; const SglLocal, DesLocal,
      IndPrincipal: WideString): Integer; safecall;
    function Buscar(CodFazenda, CodLocal: Integer): Integer; safecall;
    function Excluir(CodFazenda, CodLocal: Integer): Integer; safecall;
    function AdicionarRegimeAlimentar(CodFazenda, CodLocal,
      CodRegimeAlimentar: Integer): Integer; safecall;
    function RetirarRegimeAlimentar(CodFazenda, CodLocal,
      CodRegimeAlimentar: Integer): Integer; safecall;
    function AdicionarTipoFonteAgua(CodFazenda, CodLocal,
      CodTipoFonteAgua: Integer; DtaInicioValidade: TDateTime): Integer;
      safecall;
    function RetirarTipoFonteAgua(CodFazenda, CodLocal,
      CodTipoFonteAgua: Integer; DtaInicioValidade,
      DtaFimValidade: TDateTime): Integer; safecall;
    function ExcluirTipoFonteAgua(CodFazenda, CodLocal,
      CodTipoFonteAgua: Integer; DtaInicioValidade,
      DtaFimValidade: TDateTime): Integer; safecall;
    function Get_Local: ILocal; safecall;
    function PesquisarTiposFonteAgua(CodFazenda, CodLocal: Integer): Integer;
      safecall;
    function PossuiRegimeAlimentar(CodFazenda, CodLocal,
      CodRegimeAlimentar: Integer): Integer; safecall;
    function PesquisarRelacionamento(CodFazenda: Integer): Integer; safecall;
    function InserirDadoGeral(const NumCNPJCPFProdutor,
      CodNaturezaProdutor: WideString; CodFazenda: Integer; const SglLocal,
      DesLocal, CodTiposFonteAgua,
      CodRegimeAlimentar: WideString): Integer; safecall;
    function AdicionarRegimeAlimentarDadoGeral(CodFazenda, CodLocal,
      CodRegimeAlimentar, CodProdutor: Integer): Integer; safecall;
    function AdicionarTipoFonteAguaDadoGeral(CodFazenda, CodLocal,
      CodTipoFonteAgua: Integer; DtaInicioValidade: TDateTime;
      CodProdutor: Integer): Integer; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TLocais.AfterConstruction;
begin
  inherited;
  FLocal := TLocal.Create;
  FLocal.ObjAddRef;
  FInicializado := False;
end;

procedure TLocais.BeforeDestruction;
begin
  If FIntLocais <> nil Then Begin
    FIntLocais.Free;
  End;
  If FLocal <> nil Then Begin
    FLocal.ObjRelease;
    FLocal := nil;
  End;
  inherited;
end;

function TLocais.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntLocais := TIntLocais.Create;
  Result := FIntLocais.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TLocais.BOF: WordBool;
begin
  Result := FIntLocais.BOF;
end;

function TLocais.EOF: WordBool;
begin
  Result := FIntLocais.EOF;
end;

procedure TLocais.IrAoPrimeiro;
begin
  FIntLocais.IrAoPrimeiro;
end;

procedure TLocais.IrAoProximo;
begin
  FIntLocais.IrAoProximo;
end;

procedure TLocais.IrAoAnterior;
begin
  FIntLocais.IrAoAnterior;
end;

procedure TLocais.IrAoUltimo;
begin
  FIntLocais.IrAoUltimo;
end;

procedure TLocais.Posicionar(NumRegistro: Integer);
begin
  FIntLocais.Posicionar(NumRegistro);
end;

function TLocais.Deslocar(QtdRegistros: Integer): Integer;
begin
  Result := FIntLocais.Deslocar(QtdRegistros);
end;

function TLocais.NumeroRegistros: Integer;
begin
  Result := FIntLocais.NumeroRegistros;
end;

function TLocais.ValorCampo(const NomeColuna: WideString): OleVariant;
begin
  Result := FIntLocais.ValorCampo(NomeColuna);
end;

procedure TLocais.FecharPesquisa;
begin
  FIntLocais.FecharPesquisa;
end;

function TLocais.Pesquisar(CodFazenda: Integer;
  const CodOrdenacao: WideString): Integer;
begin
  Result := FIntLocais.Pesquisar(CodFazenda, CodOrdenacao);
end;

function TLocais.Inserir(CodFazenda: Integer; const SglLocal, DesLocal,
  CodTiposFonteAgua, IndPrincipal: WideString): Integer;
begin
  Result := FIntLocais.Inserir(CodFazenda, SglLocal, DesLocal, CodTiposFonteAgua,
    IndPrincipal);
end;

function TLocais.Alterar(CodFazenda, CodLocal: Integer; const SglLocal,
  DesLocal, IndPrincipal: WideString): Integer;
begin
  Result := FIntLocais.Alterar(CodFazenda, CodLocal, SglLocal, DesLocal,
    IndPrincipal);
end;

function TLocais.Buscar(CodFazenda, CodLocal: Integer): Integer;
begin
  Result := FIntLocais.Buscar(CodFazenda, CodLocal);

  FLocal.CodPessoaProdutor := FIntLocais.IntLocal.CodPessoaProdutor;
  FLocal.CodFazenda := FIntLocais.IntLocal.CodFazenda;
  FLocal.CodLocal := FIntLocais.IntLocal.CodLocal;
  FLocal.SglLocal := FIntLocais.IntLocal.SglLocal;
  FLocal.DesLocal := FIntLocais.IntLocal.DesLocal;
  FLocal.SglFazenda := FIntLocais.IntLocal.SglFazenda;
  FLocal.NomFazenda := FIntLocais.IntLocal.NomFazenda;
  FLocal.CodEstado := FIntLocais.IntLocal.CodEstado;
  FLocal.SglEstado := FIntLocais.IntLocal.SglEstado;
  FLocal.DtaCadastramento := FIntLocais.IntLocal.DtaCadastramento;
  FLocal.IndPrincipal := FIntLocais.IntLocal.IndPrincipal;
end;

function TLocais.Excluir(CodFazenda, CodLocal: Integer): Integer;
begin
  Result := FIntLocais.Excluir(CodFazenda, CodLocal);
end;

function TLocais.AdicionarRegimeAlimentar(CodFazenda, CodLocal,
  CodRegimeAlimentar: Integer): Integer;
begin
  Result := FIntLocais.AdicionarRegimeAlimentar(CodFazenda, CodLocal, CodRegimeAlimentar);
end;

function TLocais.RetirarRegimeAlimentar(CodFazenda, CodLocal,
  CodRegimeAlimentar: Integer): Integer;
begin
  Result := FIntLocais.RetirarRegimeAlimentar(CodFazenda, CodLocal, CodRegimeAlimentar);
end;

function TLocais.AdicionarTipoFonteAgua(CodFazenda, CodLocal,
  CodTipoFonteAgua: Integer; DtaInicioValidade: TDateTime): Integer;
begin
  Result := FIntLocais.AdicionarTipoFonteAgua(CodFazenda, CodLocal, CodTipoFonteAgua, DtaInicioValidade);
end;

function TLocais.RetirarTipoFonteAgua(CodFazenda, CodLocal,
  CodTipoFonteAgua: Integer; DtaInicioValidade,
  DtaFimValidade: TDateTime): Integer;
begin
  Result := FIntLocais.RetirarTipoFonteAgua(CodFazenda, CodLocal, CodTipoFonteAgua,
                                            DtaInicioValidade, DtaFimValidade);
end;

function TLocais.ExcluirTipoFonteAgua(CodFazenda, CodLocal,
  CodTipoFonteAgua: Integer; DtaInicioValidade,
  DtaFimValidade: TDateTime): Integer;
begin
  Result := FIntLocais.ExcluirTipoFonteAgua(CodFazenda, CodLocal, CodTipoFonteAgua,
                                            DtaInicioValidade, DtaFimValidade);
end;

function TLocais.Get_Local: ILocal;
begin
  Result := FLocal;
end;

function TLocais.PesquisarTiposFonteAgua(CodFazenda,
  CodLocal: Integer): Integer;
begin
  Result := FIntLocais.PesquisarTiposFonteAgua(CodFazenda, CodLocal);
end;

function TLocais.PossuiRegimeAlimentar(CodFazenda, CodLocal,
  CodRegimeAlimentar: Integer): Integer;
begin
  Result := FIntLocais.PossuiRegimeAlimentar(CodFazenda, CodLocal, CodRegimeAlimentar);
end;

function TLocais.PesquisarRelacionamento(CodFazenda: Integer): Integer;
begin
  Result := FIntLocais.PesquisarRelacionamento(CodFazenda);
end;

function TLocais.InserirDadoGeral(const NumCNPJCPFProdutor,
  CodNaturezaProdutor: WideString; CodFazenda: Integer; const SglLocal,
  DesLocal, CodTiposFonteAgua, CodRegimeAlimentar: WideString): Integer;
begin
  Result := FIntLocais.InserirDadoGeral(NumCNPJCPFProdutor,
  CodNaturezaProdutor, CodFazenda, SglLocal,
  DesLocal, CodTiposFonteAgua, CodRegimeAlimentar);
end;

function TLocais.AdicionarRegimeAlimentarDadoGeral(CodFazenda, CodLocal,
  CodRegimeAlimentar, CodProdutor: Integer): Integer;
begin
  Result := FIntLocais.AdicionarRegimeAlimentarDadoGeral(CodFazenda, CodLocal, CodRegimeAlimentar, CodProdutor);
end;

function TLocais.AdicionarTipoFonteAguaDadoGeral(CodFazenda, CodLocal,
  CodTipoFonteAgua: Integer; DtaInicioValidade: TDateTime;
  CodProdutor: Integer): Integer;
begin
  Result := FIntLocais.AdicionarTipoFonteAguaDadoGeral(CodFazenda, CodLocal, CodTipoFonteAgua, DtaInicioValidade, CodProdutor);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TLocais, Class_Locais,
    ciMultiInstance, tmApartment);
end.
