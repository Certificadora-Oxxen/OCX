unit uImportacoesSISBOV;

interface

uses
  Classes, DBTables, SysUtils, DB, FileCtrl, uIntClassesBasicas,
  uFerramentas, uArquivo, ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens,
  uImportacaoSISBOV, uIntImportacoesSISBOV, uLibZipM;


type
  TImportacoesSISBOV = class(TASPMTSObject, IImportacoesSISBOV)
  private
     FImportacaoSISBOV: TImportacaoSISBOV;
     FIntImportacoesSISBOV: TIntImportacoesSISBOV;
     FInicializado: Boolean;
  protected
    function BOF: WordBool; safecall;
    function EOF: WordBool; safecall;
    function Excluir(CodArquivoImportacao: Integer): Integer; safecall;
    function NumeroRegistros: Integer; safecall;
    function Pesquisar(DtaImportacaoInicio, DtaImportacaoFim,
      DtaUltimoProcessamentoInicio, DtaUltimoProcessamentoFim: TDateTime;
      const LoginUsuario, IndErrosNoProcessamento,
      IndArquivoProcessado: WideString; CodTipoArquivoImportacao,
      NumSolicitacao: Integer; const NomeProdutor, CNPJ_CPF,
      NomePropriedade, Nirf: WideString;
      CodLocalizacaoSisbov: Integer): Integer; safecall;
    function PesquisarTipoArquivo: Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    function ArmazenarArqUpload(const NomArquivoUpload: WideString;
      TipoArquivoImportacao, CodOrigemArquivoUsuario: Integer): Integer;
      safecall;
    function Buscar(CodArquivoImportacao: Integer): Integer; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    function Processar(CodArquivoImportacao: Integer): Integer; safecall;
    function Get_ImportacaoSISBOV: IImportacaoSISBOV; safecall;
    procedure Posicionar(NumRegistro: Integer); safecall;
    function PesquisarOcorrencia(CodArquivoImportacao, CodTipoLinhaImportacao,
      CodTipoMensagem: Integer): Integer; safecall;
    function GerarRelatorioAutenticacao(const NumCNPJCPFProdutor,
      NomPessoaProdutor, SglProdutor, NumImovelReceitaFederal: WideString;
      CodLocalizacaoSisbov: Integer; const NomPropriedadeRural: WideString;
      CodEstado: Integer; const NomArqUpload: WideString;
      DtaImportacaoInicio, DtaImportacaoFim: TDateTime; CodPaisSisBov,
      CodEstadoSISBOV, CodMicroRegiaoSISBOV, CodAnimalSisbov,
      Tipo: Integer): WideString; safecall;

    public
       procedure AfterConstruction; override;
       procedure BeforeDestruction; override;
       function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TImportacoesSISBOV.AfterConstruction;
begin
  inherited;
  FImportacaoSISBOV := TImportacaoSISBOV.Create;
  FImportacaoSISBOV.ObjAddRef;
  FInicializado := False;
end;

procedure TImportacoesSISBOV.BeforeDestruction;
begin
  If FIntImportacoesSISBOV <> nil Then Begin
    FIntImportacoesSISBOV.Free;
  End;
  If FImportacaoSISBOV <> nil Then Begin
    FImportacaoSISBOV.ObjRelease;
    FImportacaoSISBOV := nil;
  End;
  inherited;
end;

function TImportacoesSISBOV.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntImportacoesSISBOV := TIntImportacoesSISBOV.Create;
  Result := FIntImportacoesSISBOV.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TImportacoesSISBOV.BOF: WordBool;
begin
   Result := FIntImportacoesSISBOV.BOF;
end;

function TImportacoesSISBOV.EOF: WordBool;
begin
   Result := FIntImportacoesSISBOV.EOF;
end;

function TImportacoesSISBOV.Excluir(
  CodArquivoImportacao: Integer): Integer;
begin
   Result := FIntImportacoesSISBOV.Excluir(CodArquivoImportacao);
end;

function TImportacoesSISBOV.NumeroRegistros: Integer;
begin
   Result := FIntImportacoesSISBOV.NumeroRegistros;
end;

function TImportacoesSISBOV.Pesquisar(DtaImportacaoInicio,
  DtaImportacaoFim, DtaUltimoProcessamentoInicio,
  DtaUltimoProcessamentoFim: TDateTime; const LoginUsuario,
  IndErrosNoProcessamento, IndArquivoProcessado: WideString;
  CodTipoArquivoImportacao, NumSolicitacao: Integer; const NomeProdutor,
  CNPJ_CPF, NomePropriedade, Nirf: WideString;
  CodLocalizacaoSisbov: Integer): Integer;
begin
   Result := FIntImportacoesSISBOV.Pesquisar( DtaImportacaoInicio,
                                              DtaImportacaoFim, DtaUltimoProcessamentoInicio,
                                              DtaUltimoProcessamentoFim, LoginUsuario,
                                              IndErrosNoProcessamento, IndArquivoProcessado,
                                              CodTipoArquivoImportacao,
                                              NumSolicitacao, NomeProdutor,
                                              CNPJ_CPF, NomePropriedade, NIRF, CodLocalizacaoSisbov);
end;

function TImportacoesSISBOV.PesquisarTipoArquivo: Integer;
begin
   Result := FIntImportacoesSISBOV.PesquisarTipo;
end;

function TImportacoesSISBOV.ValorCampo(
  const NomCampo: WideString): OleVariant;
begin
   Result := FIntImportacoesSISBOV.ValorCampo(NomCampo);
end;

function TImportacoesSISBOV.ArmazenarArqUpload(
  const NomArquivoUpload: WideString; TipoArquivoImportacao,
  CodOrigemArquivoUsuario: Integer): Integer;
begin
   Result := FIntImportacoesSISBOV.ArmazenarArquivoUpLoad(NomArquivoUpLoad, TipoArquivoImportacao, CodOrigemArquivoUsuario);
end;

function TImportacoesSISBOV.Buscar(CodArquivoImportacao: Integer): Integer;
begin
   Result := FIntImportacoesSISBOV.Buscar(CodArquivoImportacao);
end;

procedure TImportacoesSISBOV.IrAoAnterior;
begin
   FIntImportacoesSISBOV.IrAoAnterior;
end;

procedure TImportacoesSISBOV.IrAoPrimeiro;
begin
   FIntImportacoesSISBOV.IrAoPrimeiro;
end;

procedure TImportacoesSISBOV.IrAoProximo;
begin
   FIntImportacoesSISBOV.IrAoProximo;
end;

procedure TImportacoesSISBOV.IrAoUltimo;
begin
   FIntImportacoesSISBOV.IrAoUltimo;
end;

function TImportacoesSISBOV.Processar(
  CodArquivoImportacao: Integer): Integer;
begin
   FIntImportacoesSISBOV.Processar(CodArquivoImportacao);
end;

function TImportacoesSISBOV.Get_ImportacaoSISBOV: IImportacaoSISBOV;
begin
   FImportacaoSISBOV.NIRF                       := FIntImportacoesSISBOV.IntImportacao.NIRF;
   FImportacaoSISBOV.NumCpfCnpj                 := FIntImportacoesSISBOV.IntImportacao.NumCpfCnpj;
   FImportacaoSISBOV.CodProdutor                := FIntImportacoesSISBOV.IntImportacao.CodProdutor;
   FImportacaoSISBOV.CodPropriedade             := FIntImportacoesSISBOV.IntImportacao.CodPropriedade;
   FImportacaoSISBOV.CodSisBov                  := FIntImportacoesSISBOV.IntImportacao.CodSisBov;
   FImportacaoSISBOV.CodArqImportSisBov         := FIntImportacoesSISBOV.IntImportacao.CodArqImportSisBov;
   FImportacaoSISBOV.NomArqUpload               := FIntImportacoesSISBOV.IntImportacao.NomArqUpload;
   FImportacaoSISBOV.NomArqImportSisBov         := FIntImportacoesSISBOV.IntImportacao.NomArqImportSisBov;
   FImportacaoSISBOV.QtdLinhas                  := FIntImportacoesSISBOV.IntImportacao.QtdLinhas;
   FImportacaoSISBOV.QtdLinhasErroUltimoProc    := FIntImportacoesSISBOV.IntImportacao.QtdLinhasErroUltimoProc;
   FImportacaoSISBOV.QtdLinhasLogUltimoProc     := FIntImportacoesSISBOV.IntImportacao.QtdLinhasLogUltimoProc;
   FImportacaoSISBOV.QtdVezesProcessamento      := FIntImportacoesSISBOV.IntImportacao.QtdVezesProcessamento;
   FImportacaoSISBOV.NomUsuarioUpLoad           := FIntImportacoesSISBOV.IntImportacao.NomUsuarioUpLoad;
   FImportacaoSISBOV.DtaArqImportSisBov         := FIntImportacoesSISBOV.IntImportacao.DtaArqImportSisBov;
   FImportacaoSISBOV.DtaUltimoProcessamento     := FIntImportacoesSISBOV.IntImportacao.DtaUltimoProcessamento;
   FImportacaoSISBOV.QtdLinhasProcessadas       := FIntImportacoesSISBOV.IntImportacao.QtdLinhasProcessadas;
   FImportacaoSISBOV.TxtDados                   := FIntImportacoesSISBOV.IntImportacao.TxtDados;
   FImportacaoSISBOV.txtMensagem                := FIntImportacoesSISBOV.IntImportacao.txtMensagem;
   FImportacaoSISBOV.CodTipoOrigemArqImport     := FIntImportacoesSISBOV.IntImportacao.CodTipoOrigemArqImport;
   FImportacaoSISBOV.CodSituacaoArqImport       := FIntImportacoesSISBOV.IntImportacao.CodSituacaoArqImport;
   FImportacaoSISBOV.DesSituacaoArqImport       := FIntImportacoesSISBOV.IntImportacao.DesSituacaoArqImport;
   FImportacaoSISBOV.DesTipoOrigemArqImport     := FIntImportacoesSISBOV.IntImportacao.DesTipoOrigemArqImport;
   Result := FImportacaoSISBOV;
end;

procedure TImportacoesSISBOV.Posicionar(NumRegistro: Integer);
begin
   FIntImportacoesSISBOV.Posicionar(NumRegistro);
end;

function TImportacoesSISBOV.PesquisarOcorrencia(CodArquivoImportacao,
  CodTipoLinhaImportacao, CodTipoMensagem: Integer): Integer;
begin
   FIntImportacoesSISBOV.PesquisarOcorrencias( CodArquivoImportacao,
                                               CodTipoLinhaImportacao,
                                               CodTipoMensagem );
end;

function TImportacoesSISBOV.GerarRelatorioAutenticacao(
  const NumCNPJCPFProdutor, NomPessoaProdutor, SglProdutor,
  NumImovelReceitaFederal: WideString; CodLocalizacaoSisbov: Integer;
  const NomPropriedadeRural: WideString; CodEstado: Integer;
  const NomArqUpload: WideString; DtaImportacaoInicio,
  DtaImportacaoFim: TDateTime; CodPaisSisBov, CodEstadoSISBOV,
  CodMicroRegiaoSISBOV, CodAnimalSisbov, Tipo: Integer): WideString;
begin
  Result := FIntImportacoesSISBOV.GerarRelatorioAutenticacao(NumCNPJCPFProdutor,
    NomPessoaProdutor, SglProdutor, NumImovelReceitaFederal, CodLocalizacaoSisbov, 
    NomPropriedadeRural, CodEstado, NomArqUpload, DtaImportacaoInicio,
    DtaImportacaoFim, CodPaisSISBOV, CodEstadoSISBOV, CodMicroRegiaoSISBOV,
    CodAnimalSISBOV, Tipo);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TImportacoesSISBOV, Class_ImportacoesSISBOV,
    ciMultiInstance, tmApartment);
end.
