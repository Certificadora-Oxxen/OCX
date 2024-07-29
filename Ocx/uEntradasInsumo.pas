// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Carlos Augusto
// *  Versão             : 1
// *  Data               : 10/09/2002
// *  Documentação       : Controle de Insumos - Definição das Classes
// *  Código Classe      : 64
// *  Descrição Resumida : Cadastro de Entradas de Insumo
// ************************************************************************
// *  Últimas Alterações
// *  Hitalo   01/10/2002  adiconar NumCNPJCPFRevendedor, TxtObservacao
// *
// ********************************************************************
unit uEntradasInsumo;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntMensagens,uConexao,
  uIntEntradasInsumo,uEntradaInsumo;

type
  TEntradasInsumo = class(TASPMTSObject, IEntradasInsumo)
  private
    FIntEntradasInsumo : TIntEntradasInsumo;
    FInicializado   : Boolean;
    FEntradaInsumo     : TEntradaInsumo;
  protected
    function BOF: WordBool; safecall;
    function Deslocar(NumDeslocamento: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function Inserir(CodFazenda, CodTipoInsumo, CodSubTipoInsumo,
      CodInsumo: Integer; const DesInsumo, NomFabricanteInsumo: WideString;
      NumRegistroFabricante, CodPessoaSecundaria: Integer;
      const NomRevendedor, NumCNPJCPFRevendedor: WideString;
      DtaCompra: TDateTime; NumNotaFiscal: Integer;
      const NumPartidaLote: WideString; DtaValidade: TDateTime;
      QtdInsumo: Double; CodUnidadeMedida: Integer;
      const TxtObservacao: WideString; Custo: Double): Integer; safecall;
    function NumeroRegistros: Integer; safecall;
    function ValorCampo(const NomColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    function Alterar(CodEntradaInsumo, CodInsumo: Integer; const DesInsumo,
      NomFabricanteInsumo: WideString; NumRegistroFabricante,
      CodPessoaSecundaria: Integer; const NomRevendedor,
      NumCNPJCPFRevendedor: WideString; DtaCompra: TDateTime;
      NumNotaFiscal: Integer; const NumPartidaLote: WideString;
      DtaValidade: TDateTime; QtdInsumo: Double; CodUnidadeMedida: Integer;
      const TxtObservacao: WideString; Custo: Double): Integer; safecall;
    function Buscar(CodEntradaInsumo: Integer): Integer; safecall;
    function Excluir(CodEntradaEvendo: Integer): Integer; safecall;
    function Pesquisar(CodEntradaInsumoInicio, CodEntradaInsumoFim,
      CodTipoInsumo, CodSubTipoInsumo: Integer; const DesInsumo,
      NomFabricanteInsumo: WideString; NumRegistroFabricante: Integer;
      const NomRevendedor, NumCNPJCPFRevendedor: WideString;
      DtaCompraInicio, DtaCompraFim, DtaValidade: TDateTime;
      const CodOrdenacao, OrdenacaoCrescente: WideString;
      CodFazenda: Integer; const IndEntradasemFazenda,
      IndSubEventoSanitario: WideString): Integer; safecall;
    function Get_EntradaInsumo: IEntradaInsumo; safecall;
    function RelatorioConsolidado(const SglProdutor,
      NomPessoaProdutor: WideString; CodTipoInsumo,
      CodSubTipoInsumo: Integer; const DesInsumo,
      NomFabricanteInsumo: WideString; NumRegistroFabricante: Integer;
      const NomRevendedor, NumCNPJCPFRevendedor: WideString;
      DtaCompraInicio, DtaCompraFim: TDateTime;
      const IndDataOrdemCrescente: WideString; Tipo,
      QtdQuebraRelatorio: Integer): WideString; safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TEntradasInsumo.AfterConstruction;
begin
  inherited;
  FEntradaInsumo := TEntradaInsumo.Create;
  FEntradaInsumo.ObjAddRef;
  FInicializado := False;
end;

procedure TEntradasInsumo.BeforeDestruction;
begin
  If FIntEntradasInsumo <> nil Then Begin
    FIntEntradasInsumo.Free;
  End;
  If FEntradaInsumo <> nil Then Begin
    FEntradaInsumo.ObjRelease;
    FEntradaInsumo := nil;
  End;
  inherited;
end;

function TEntradasInsumo.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntEntradasInsumo := TIntEntradasInsumo.Create;
  Result := FIntEntradasInsumo.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TEntradasInsumo.BOF: WordBool;
begin
   result := FIntEntradasInsumo.BOF;
end;

function TEntradasInsumo.Deslocar(NumDeslocamento: Integer): Integer;
begin
   result := FIntEntradasInsumo.Deslocar(NumDeslocamento);
end;

function TEntradasInsumo.EOF: WordBool;
begin
   result := FIntEntradasInsumo.Eof;
end;

function TEntradasInsumo.Inserir(CodFazenda, CodTipoInsumo,
  CodSubTipoInsumo, CodInsumo: Integer; const DesInsumo,
  NomFabricanteInsumo: WideString; NumRegistroFabricante,
  CodPessoaSecundaria: Integer; const NomRevendedor,
  NumCNPJCPFRevendedor: WideString; DtaCompra: TDateTime;
  NumNotaFiscal: Integer; const NumPartidaLote: WideString;
  DtaValidade: TDateTime; QtdInsumo: Double; CodUnidadeMedida: Integer;
  const TxtObservacao: WideString; Custo: Double): Integer;
begin
  result := FIntEntradasInsumo.Inserir(CodFazenda, CodTipoInsumo,
  CodSubTipoInsumo, CodInsumo, DesInsumo, NomFabricanteInsumo,
  NumRegistroFabricante, CodPessoaSecundaria, NomRevendedor,
  NumCNPJCPFRevendedor, DtaCompra, NumNotaFiscal, NumPartidaLote,
  DtaValidade, QtdInsumo, CodUnidadeMedida, TxtObservacao,Custo);
end;

function TEntradasInsumo.NumeroRegistros: Integer;
begin
   result := FIntEntradasInsumo.NumeroRegistros;
end;

function TEntradasInsumo.ValorCampo(
  const NomColuna: WideString): OleVariant;
begin
   result := FIntEntradasInsumo.ValorCampo(NomColuna);
end;

procedure TEntradasInsumo.FecharPesquisa;
begin
  FIntEntradasInsumo.FecharPesquisa;
end;

procedure TEntradasInsumo.IrAoAnterior;
begin
   FIntEntradasInsumo.IrAoAnterior;
end;

procedure TEntradasInsumo.IrAoPrimeiro;
begin
   FIntEntradasInsumo.IrAoPrimeiro;
end;

procedure TEntradasInsumo.IrAoProximo;
begin
   FIntEntradasInsumo.IrAoProximo;
end;

procedure TEntradasInsumo.IrAoUltimo;
begin
   FIntEntradasInsumo.IrAoUltimo;
end;

procedure TEntradasInsumo.Posicionar(NumPosicao: Integer);
begin
   FIntEntradasInsumo.Posicionar(NumPosicao);
end;

function TEntradasInsumo.Alterar(CodEntradaInsumo, CodInsumo: Integer;
  const DesInsumo, NomFabricanteInsumo: WideString; NumRegistroFabricante,
  CodPessoaSecundaria: Integer; const NomRevendedor,
  NumCNPJCPFRevendedor: WideString; DtaCompra: TDateTime;
  NumNotaFiscal: Integer; const NumPartidaLote: WideString;
  DtaValidade: TDateTime; QtdInsumo: Double; CodUnidadeMedida: Integer;
  const TxtObservacao: WideString; Custo: Double): Integer;
begin
  result :=  FIntEntradasInsumo.Alterar(CodEntradaInsumo, CodInsumo,
  DesInsumo, NomFabricanteInsumo, NumRegistroFabricante,
  CodPessoaSecundaria, NomRevendedor, NumCNPJCPFRevendedor,
  DtaCompra, NumNotaFiscal, NumPartidaLote, DtaValidade, QtdInsumo,
  CodUnidadeMedida, TxtObservacao,Custo);
end;

function TEntradasInsumo.Buscar(CodEntradaInsumo: Integer): Integer;
begin
  result :=  FIntEntradasInsumo.Buscar(CodEntradaInsumo);
end;

function TEntradasInsumo.Excluir(CodEntradaEvendo: Integer): Integer;
begin
  result :=  FIntEntradasInsumo.Excluir(CodEntradaEvendo);
end;

function TEntradasInsumo.Pesquisar(CodEntradaInsumoInicio,
  CodEntradaInsumoFim, CodTipoInsumo, CodSubTipoInsumo: Integer;
  const DesInsumo, NomFabricanteInsumo: WideString;
  NumRegistroFabricante: Integer; const NomRevendedor,
  NumCNPJCPFRevendedor: WideString; DtaCompraInicio, DtaCompraFim,
  DtaValidade: TDateTime; const CodOrdenacao,
  OrdenacaoCrescente: WideString; CodFazenda: Integer;
  const IndEntradasemFazenda, IndSubEventoSanitario: WideString): Integer;
begin
  result :=  FIntEntradasInsumo.Pesquisar(CodEntradaInsumoInicio,
  CodEntradaInsumoFim, CodTipoInsumo, CodSubTipoInsumo, DesInsumo,
  NomFabricanteInsumo, NumRegistroFabricante, NomRevendedor,
  NumCNPJCPFRevendedor, DtaCompraInicio, DtaCompraFim, DtaValidade,
  CodOrdenacao, OrdenacaoCrescente, CodFazenda, IndEntradasemFazenda,
  IndSubEventoSanitario);
end;

function TEntradasInsumo.Get_EntradaInsumo: IEntradaInsumo;
begin
  FEntradaInsumo.CodPessoaProdutor              := FIntEntradasInsumo.IntEntradaInsumo.CodPessoaProdutor;
  FEntradaInsumo.CodEntradaInsumo               := FIntEntradasInsumo.IntEntradaInsumo.CodEntradaInsumo;
  FEntradaInsumo.CodFazenda                     := FIntEntradasInsumo.IntEntradaInsumo.CodFazenda;
  FEntradaInsumo.SglFazenda                     := FIntEntradasInsumo.IntEntradaInsumo.SglFazenda;
  FEntradaInsumo.NomFazenda                     := FIntEntradasInsumo.IntEntradaInsumo.NomFazenda;
  FEntradaInsumo.CodTipoInsumo                  := FIntEntradasInsumo.IntEntradaInsumo.CodTipoInsumo;
  FEntradaInsumo.SglTipoInsumo                  := FIntEntradasInsumo.IntEntradaInsumo.SglTipoInsumo;
  FEntradaInsumo.DesTipoInsumo                  := FIntEntradasInsumo.IntEntradaInsumo.DesTipoInsumo;
  FEntradaInsumo.IndAdmitePartidaLote           := FIntEntradasInsumo.IntEntradaInsumo.IndAdmitePartidaLote;
  FEntradaInsumo.CodSubTipoInsumo               := FIntEntradasInsumo.IntEntradaInsumo.CodSubTipoInsumo;
  FEntradaInsumo.SglSubTipoInsumo               := FIntEntradasInsumo.IntEntradaInsumo.SglSubTipoInsumo;
  FEntradaInsumo.DesSubTipoInsumo               := FIntEntradasInsumo.IntEntradaInsumo.DesSubTipoInsumo;
  FEntradaInsumo.CodInsumo                      := FIntEntradasInsumo.IntEntradaInsumo.CodInsumo;
  FEntradaInsumo.DesInsumo                      := FIntEntradasInsumo.IntEntradaInsumo.DesInsumo;
  FEntradaInsumo.CodFabricanteInsumo            := FIntEntradasInsumo.IntEntradaInsumo.CodFabricanteInsumo;
  FEntradaInsumo.NomFabricanteInsumo            := FIntEntradasInsumo.IntEntradaInsumo.NomFabricanteInsumo;
  FEntradaInsumo.NumRegistroFabricante          := FIntEntradasInsumo.IntEntradaInsumo.NumRegistroFabricante;
  FEntradaInsumo.CodPessoaSecundaria            := FIntEntradasInsumo.IntEntradaInsumo.CodPessoaSecundaria;
  FEntradaInsumo.NomRevendedor                  := FIntEntradasInsumo.IntEntradaInsumo.NomRevendedor;
  FEntradaInsumo.NumCNPJCPFRevendedorFormatado  := FIntEntradasInsumo.IntEntradaInsumo.NumCNPJCPFRevendedorFormatado;
  FEntradaInsumo.DtaCompra                      := FIntEntradasInsumo.IntEntradaInsumo.DtaCompra;
  FEntradaInsumo.NumNotaFiscal                  := FIntEntradasInsumo.IntEntradaInsumo.NumNotaFiscal;
  FEntradaInsumo.NumPartidaLote                 := FIntEntradasInsumo.IntEntradaInsumo.NumPartidaLote;
  FEntradaInsumo.DtaValidade                    := FIntEntradasInsumo.IntEntradaInsumo.DtaValidade;
  FEntradaInsumo.QtdInsumo                      := FIntEntradasInsumo.IntEntradaInsumo.QtdInsumo;
  FEntradaInsumo.CodUnidadeMedida               := FIntEntradasInsumo.IntEntradaInsumo.CodUnidadeMedida;
  FEntradaInsumo.SglUnidadeMedida               := FIntEntradasInsumo.IntEntradaInsumo.SglUnidadeMedida;
  FEntradaInsumo.NumCNPJCPFRevendedor           := FIntEntradasInsumo.IntEntradaInsumo.NumCNPJCPFRevendedor;
  FEntradaInsumo.TxtObservacao                  := FIntEntradasInsumo.IntEntradaInsumo.TxtObservacao;
  FEntradaInsumo.Custo                          := FIntEntradasInsumo.IntEntradaInsumo.Custo;

  result := FEntradaInsumo;
end;

function TEntradasInsumo.RelatorioConsolidado(const SglProdutor,
  NomPessoaProdutor: WideString; CodTipoInsumo, CodSubTipoInsumo: Integer;
  const DesInsumo, NomFabricanteInsumo: WideString;
  NumRegistroFabricante: Integer; const NomRevendedor,
  NumCNPJCPFRevendedor: WideString; DtaCompraInicio,
  DtaCompraFim: TDateTime; const IndDataOrdemCrescente: WideString; Tipo,
  QtdQuebraRelatorio: Integer): WideString;
begin
  result := FIntEntradasInsumo.RelatorioConsolidado(SglProdutor,NomPessoaProdutor,CodTipoInsumo,
  CodSubTipoInsumo,DesInsumo, NomFabricanteInsumo, NumRegistroFabricante, NomRevendedor,
  NumCnpjCpfRevendedor,DtaCompraInicio, DtaCompraFim,IndDataOrdemCrescente,Tipo,QtdQuebraRelatorio);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TEntradasInsumo, Class_EntradasInsumo,
    ciMultiInstance, tmApartment);
end.
