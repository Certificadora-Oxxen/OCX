unit uImportacao;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TImportacao = class(TASPMTSObject, IImportacao)
  private
    FCodPessoaProdutor: Integer;
    FDtaUltimoProcessamento: TDateTime;
    FCodArquivoImportacao: Integer;
    FNomArquivoImportacao: WideString;
    FDtaImportacao: TDateTime;
    FNomPessoaProdutor: WideString;
    FNumCNPJCPFFormatadoProdutor: WideString;
    FQtdAnimaisAlteracaoProcessados: Integer;
    FQtdAnimaisAlteracaoTotal: Integer;
    FQtdAnimaisEventosProcessados: Integer;
    FQtdAnimaisEventosTotal: Integer;
    FQtdAnimaisInsercaoProcessados: Integer;
    FQtdAnimaisInsercaoTotal: Integer;
    FQtdEventosProcessados: Integer;
    FQtdEventosTotal: Integer;
    FQtdRMProcessados: Integer;
    FQtdRMTotal: Integer;
    FQtdTourosRMProcessados: Integer;
    FQtdTourosRMTotal: Integer;
    FQtdInventariosAnimaisTotal: Integer;
    FQtdInventariosAnimaisProcessados: Integer;
    FQtdInventariosAnimaisErro: Integer;
    FQtdVezesProcessamento: Integer;
    FSglProdutor: WideString;
    FNomArquivoUpload: WideString;
    FNomUsuarioUpload: WideString;
    FQtdOcorrencias: Integer;
    FQtdLinhas: Integer;
    FQtdRMErro: Integer;
    FQtdAnimaisInsercaoErro: Integer;
    FQtdAnimaisAlteracaoErro: Integer;
    FQtdTourosRMErro: Integer;
    FQtdEventosErro: Integer;
    FQtdAnimaisEventosErro: Integer;
    FQtdCRacialTotal: Integer;
    FQtdCRacialProcessados: Integer;
    FQtdCRacialErro: Integer;
    FCodTipoOrigemArqImport: Integer;
    FSglTipoOrigemArqImport: WideString;
    FDesTipoOrigemArqImport: WideString;
    FCodSituacaoArqImport: WideString;
    FDesSituacaoArqImport: WideString;
    FCodUsuarioUpload: Integer;
    FCodUltimaTarefa: Integer;
    FCodSituacaoUltimaTarefa: WideString;
    FDesSituacaoUltimaTarefa: WideString;
    FDtaInicioPrevistoUltimaTarefa: TDateTime;
    FDtaInicioRealUltimaTarefa: TDateTime;
    FDtaFimRealUltimaTarefa: TDateTime;
  protected
    function Get_CodPessoaProdutor: Integer; safecall;
    function Get_DtaUltimoProcessamento: TDateTime; safecall;
    function Get_NomArquivoImportacao: WideString; safecall;
    function Get_NomPessoaProdutor: WideString; safecall;
    function Get_NumCNPJCPFFormatadoProdutor: WideString; safecall;
    function Get_QtdAnimaisAlteracaoProcessados: Integer; safecall;
    function Get_QtdAnimaisAlteracaoTotal: Integer; safecall;
    function Get_QtdAnimaisEventosProcessados: Integer; safecall;
    function Get_QtdAnimaisEventosTotal: Integer; safecall;
    function Get_QtdAnimaisInsercaoProcessados: Integer; safecall;
    function Get_QtdAnimaisInsercaoTotal: Integer; safecall;
    function Get_QtdEventosProcessados: Integer; safecall;
    function Get_QtdEventosTotal: Integer; safecall;
    function Get_QtdRMProcessados: Integer; safecall;
    function Get_QtdRMTotal: Integer; safecall;
    function Get_QtdTourosRMProcessados: Integer; safecall;
    function Get_QtdTourosRMTotal: Integer; safecall;
    function Get_QtdVezesProcessamento: Integer; safecall;
    function Get_SglProdutor: WideString; safecall;
    function Get_CodArquivoImportacao: Integer; safecall;
    function Get_DtaImportacao: TDateTime; safecall;
    procedure Set_CodPessoaProdutor(Value: Integer); safecall;
    procedure Set_DtaUltimoProcessamento(Value: TDateTime); safecall;
    procedure Set_NomArquivoImportacao(const Value: WideString); safecall;
    procedure Set_NomPessoaProdutor(const Value: WideString); safecall;
    procedure Set_NumCNPJCPFFormatadoProdutor(const Value: WideString);
      safecall;
    procedure Set_QtdAnimaisAlteracaoProcessados(Value: Integer); safecall;
    procedure Set_QtdAnimaisAlteracaoTotal(Value: Integer); safecall;
    procedure Set_QtdAnimaisEventosProcessados(Value: Integer); safecall;
    procedure Set_QtdAnimaisEventosTotal(Value: Integer); safecall;
    procedure Set_QtdAnimaisInsercaoProcessados(Value: Integer); safecall;
    procedure Set_QtdAnimaisInsercaoTotal(Value: Integer); safecall;
    procedure Set_QtdEventosProcessados(Value: Integer); safecall;
    procedure Set_QtdEventosTotal(Value: Integer); safecall;
    procedure Set_QtdRMProcessados(Value: Integer); safecall;
    procedure Set_QtdRMTotal(Value: Integer); safecall;
    procedure Set_QtdTourosRMProcessados(Value: Integer); safecall;
    procedure Set_QtdTourosRMTotal(Value: Integer); safecall;
    procedure Set_QtdVezesProcessamento(Value: Integer); safecall;
    procedure Set_SglProdutor(const Value: WideString); safecall;
    procedure Set_CodArquivoImportacao(Value: Integer); safecall;
    procedure Set_DtaImportacao(Value: TDateTime); safecall;
    function Get_NomUsuarioUpload: WideString; safecall;
    function Get_NomArquivoUpload: WideString; safecall;
    procedure Set_NomUsuarioUpload(const Value: WideString); safecall;
    procedure Set_NomArquivoUpload(const Value: WideString); safecall;
    function Get_QtdOcorrencias: Integer; safecall;
    procedure Set_QtdOcorrencias(Value: Integer); safecall;
    function Get_QtdLinhas: Integer; safecall;
    procedure Set_QtdLinhas(Value: Integer); safecall;
    function Get_QtdAnimaisAlteracaoErro: Integer; safecall;
    function Get_QtdAnimaisEventosErro: Integer; safecall;
    function Get_QtdAnimaisInsercaoErro: Integer; safecall;
    function Get_QtdEventosErro: Integer; safecall;
    function Get_QtdRMErro: Integer; safecall;
    function Get_QtdTourosRMErro: Integer; safecall;
    procedure Set_QtdAnimaisAlteracaoErro(Value: Integer); safecall;
    procedure Set_QtdAnimaisEventosErro(Value: Integer); safecall;
    procedure Set_QtdAnimaisInsercaoErro(Value: Integer); safecall;
    procedure Set_QtdEventosErro(Value: Integer); safecall;
    procedure Set_QtdRMErro(Value: Integer); safecall;
    procedure Set_QtdTourosRMErro(Value: Integer); safecall;
    function Get_QtdCRacialErro: Integer; safecall;
    function Get_QtdCRacialProcessados: Integer; safecall;
    function Get_QtdCRacialTotal: Integer; safecall;
    procedure Set_QtdCRacialErro(Value: Integer); safecall;
    procedure Set_QtdCRacialProcessados(Value: Integer); safecall;
    procedure Set_QtdCRacialTotal(Value: Integer); safecall;
    function Get_CodSituacaoArqImport: WideString; safecall;
    function Get_CodSituacaoUltimaTarefa: WideString; safecall;
    function Get_CodTipoOrigemArqImport: Integer; safecall;
    function Get_CodUltimaTarefa: Integer; safecall;
    function Get_CodUsuarioUpload: Integer; safecall;
    function Get_DesSituacaoArqImport: WideString; safecall;
    function Get_DesSituacaoUltimaTarefa: WideString; safecall;
    function Get_DesTipoOrigemArqImport: WideString; safecall;
    function Get_DtaFimRealUltimaTarefa: TDateTime; safecall;
    function Get_DtaInicioPrevistoUltimaTarefa: TDateTime; safecall;
    function Get_DtaInicioRealUltimaTarefa: TDateTime; safecall;
    function Get_SglTipoOrigemArqImport: WideString; safecall;
    procedure Set_CodSituacaoArqImport(const Value: WideString); safecall;
    procedure Set_CodSituacaoUltimaTarefa(const Value: WideString); safecall;
    procedure Set_CodTipoOrigemArqImport(Value: Integer); safecall;
    procedure Set_CodUltimaTarefa(Value: Integer); safecall;
    procedure Set_CodUsuarioUpload(Value: Integer); safecall;
    procedure Set_DesSituacaoArqImport(const Value: WideString); safecall;
    procedure Set_DesSituacaoUltimaTarefa(const Value: WideString); safecall;
    procedure Set_DesTipoOrigemArqImport(const Value: WideString); safecall;
    procedure Set_DtaFimRealUltimaTarefa(Value: TDateTime); safecall;
    procedure Set_DtaInicioPrevistoUltimaTarefa(Value: TDateTime); safecall;
    procedure Set_DtaInicioRealUltimaTarefa(Value: TDateTime); safecall;
    procedure Set_SglTipoOrigemArqImport(const Value: WideString); safecall;
    function Get_QtdInventariosAnimaisErro: Integer; safecall;
    function Get_QtdInventariosAnimaisProcessados: Integer; safecall;
    function Get_QtdInventariosAnimaisTotal: Integer; safecall;
    procedure Set_QtdInventariosAnimaisErro(Value: Integer); safecall;
    procedure Set_QtdInventariosAnimaisProcessados(Value: Integer); safecall;
    procedure Set_QtdInventariosAnimaisTotal(Value: Integer); safecall;
  public
    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property DtaUltimoProcessamento: TDateTime read FDtaUltimoProcessamento write FDtaUltimoProcessamento;
    property CodArquivoImportacao: Integer read FCodArquivoImportacao write FCodArquivoImportacao;
    property NomArquivoImportacao: WideString read FNomArquivoImportacao write FNomArquivoImportacao;
    property DtaImportacao: TDateTime read FDtaImportacao write FDtaImportacao;
    property NomPessoaProdutor: WideString read FNomPessoaProdutor write FNomPessoaProdutor;
    property NumCNPJCPFFormatadoProdutor: WideString read FNumCNPJCPFFormatadoProdutor write FNumCNPJCPFFormatadoProdutor;
    property QtdAnimaisAlteracaoProcessados: Integer read FQtdAnimaisAlteracaoProcessados write FQtdAnimaisAlteracaoProcessados;
    property QtdAnimaisAlteracaoTotal: Integer read FQtdAnimaisAlteracaoTotal write FQtdAnimaisAlteracaoTotal;
    property QtdAnimaisEventosProcessados: Integer read FQtdAnimaisEventosProcessados write FQtdAnimaisEventosProcessados;
    property QtdAnimaisEventosTotal: Integer read FQtdAnimaisEventosTotal write FQtdAnimaisEventosTotal;
    property QtdAnimaisInsercaoProcessados: Integer read FQtdAnimaisInsercaoProcessados write FQtdAnimaisInsercaoProcessados;
    property QtdAnimaisInsercaoTotal: Integer read FQtdAnimaisInsercaoTotal write FQtdAnimaisInsercaoTotal;
    property QtdEventosProcessados: Integer read FQtdEventosProcessados write FQtdEventosProcessados;
    property QtdEventosTotal: Integer read FQtdEventosTotal write FQtdEventosTotal;
    property QtdRMProcessados: Integer read FQtdRMProcessados write FQtdRMProcessados;
    property QtdRMTotal: Integer read FQtdRMTotal write FQtdRMTotal;
    property QtdTourosRMProcessados: Integer read FQtdTourosRMProcessados write FQtdTourosRMProcessados;
    property QtdTourosRMTotal: Integer read FQtdTourosRMTotal write FQtdTourosRMTotal;
    property QtdInventariosAnimaisTotal: Integer read FQtdInventariosAnimaisTotal write FQtdInventariosAnimaisTotal;
    property QtdInventariosAnimaisProcessados: Integer read FQtdInventariosAnimaisProcessados write FQtdInventariosAnimaisProcessados;
    property QtdInventariosAnimaisErro: Integer read FQtdInventariosAnimaisErro write FQtdInventariosAnimaisErro;
    property QtdVezesProcessamento: Integer read FQtdVezesProcessamento write FQtdVezesProcessamento;
    property SglProdutor: WideString read FSglProdutor write FSglProdutor;
    property NomArquivoUpload: WideString read FNomArquivoUpload write FNomArquivoUpload;
    property NomUsuarioUpload: WideString read FNomUsuarioUpload write FNomUsuarioUpload;
    property QtdOcorrencias: Integer read FQtdOcorrencias write FQtdOcorrencias;
    property QtdLinhas: Integer read FQtdLinhas write FQtdLinhas;
    property QtdRMErro: Integer read FQtdRMErro write FQtdRMErro;
    property QtdAnimaisInsercaoErro: Integer read FQtdAnimaisInsercaoErro write FQtdAnimaisInsercaoErro;
    property QtdAnimaisAlteracaoErro: Integer read FQtdAnimaisAlteracaoErro write FQtdAnimaisAlteracaoErro;
    property QtdTourosRMErro: Integer read FQtdTourosRMErro write FQtdTourosRMErro;
    property QtdEventosErro: Integer read FQtdEventosErro write FQtdEventosErro;
    property QtdAnimaisEventosErro: Integer read FQtdAnimaisEventosErro write FQtdAnimaisEventosErro;
    property QtdCRacialTotal: Integer read FQtdCRacialTotal write FQtdCRacialTotal;
    property QtdCRacialProcessados: Integer read FQtdCRacialProcessados write FQtdCRacialProcessados;
    property QtdCRacialErro: Integer read FQtdCRacialErro write FQtdCRacialErro;
    property CodTipoOrigemArqImport: Integer read FCodTipoOrigemArqImport write FCodTipoOrigemArqImport;
    property SglTipoOrigemArqImport: WideString read FSglTipoOrigemArqImport write FSglTipoOrigemArqImport;
    property DesTipoOrigemArqImport: WideString read FDesTipoOrigemArqImport write FDesTipoOrigemArqImport;
    property CodSituacaoArqImport: WideString read FCodSituacaoArqImport write FCodSituacaoArqImport;
    property DesSituacaoArqImport: WideString read FDesSituacaoArqImport write FDesSituacaoArqImport;
    property CodUsuarioUpload: Integer read FCodUsuarioUpload write FCodUsuarioUpload;
    property CodUltimaTarefa: Integer read FCodUltimaTarefa write FCodUltimaTarefa;
    property CodSituacaoUltimaTarefa: WideString read FCodSituacaoUltimaTarefa write FCodSituacaoUltimaTarefa;
    property DesSituacaoUltimaTarefa: WideString read FDesSituacaoUltimaTarefa write FDesSituacaoUltimaTarefa;
    property DtaInicioPrevistoUltimaTarefa: TDateTime read FDtaInicioPrevistoUltimaTarefa write FDtaInicioPrevistoUltimaTarefa;
    property DtaInicioRealUltimaTarefa: TDateTime read FDtaInicioRealUltimaTarefa write FDtaInicioRealUltimaTarefa;
    property DtaFimRealUltimaTarefa: TDateTime read FDtaFimRealUltimaTarefa write FDtaFimRealUltimaTarefa;
  end;

implementation

uses ComServ;

function TImportacao.Get_CodPessoaProdutor: Integer;
begin
  Result := FCodPessoaProdutor;
end;

function TImportacao.Get_DtaUltimoProcessamento: TDateTime;
begin
  Result := FDtaUltimoProcessamento;
end;

function TImportacao.Get_NomArquivoImportacao: WideString;
begin
  Result := FNomArquivoImportacao;
end;

function TImportacao.Get_NomPessoaProdutor: WideString;
begin
  Result := FNomPessoaProdutor;
end;

function TImportacao.Get_NumCNPJCPFFormatadoProdutor: WideString;
begin
  Result := FNumCNPJCPFFormatadoProdutor;
end;

function TImportacao.Get_QtdAnimaisAlteracaoProcessados: Integer;
begin
  Result := FQtdAnimaisAlteracaoProcessados;
end;

function TImportacao.Get_QtdAnimaisAlteracaoTotal: Integer;
begin
  Result := FQtdAnimaisAlteracaoTotal;
end;

function TImportacao.Get_QtdAnimaisEventosProcessados: Integer;
begin
  Result := FQtdAnimaisEventosProcessados;
end;

function TImportacao.Get_QtdAnimaisEventosTotal: Integer;
begin
  Result := FQtdAnimaisEventosTotal;
end;

function TImportacao.Get_QtdAnimaisInsercaoProcessados: Integer;
begin
  Result := FQtdAnimaisInsercaoProcessados;
end;

function TImportacao.Get_QtdAnimaisInsercaoTotal: Integer;
begin
  Result := FQtdAnimaisInsercaoTotal;
end;

function TImportacao.Get_QtdEventosProcessados: Integer;
begin
  Result := FQtdEventosProcessados;
end;

function TImportacao.Get_QtdEventosTotal: Integer;
begin
  Result := FQtdEventosTotal;
end;

function TImportacao.Get_QtdRMProcessados: Integer;
begin
  Result := FQtdRMProcessados;
end;

function TImportacao.Get_QtdRMTotal: Integer;
begin
  Result := FQtdRMTotal;
end;

function TImportacao.Get_QtdTourosRMProcessados: Integer;
begin
  Result := FQtdTourosRMProcessados;
end;

function TImportacao.Get_QtdTourosRMTotal: Integer;
begin
  Result := FQtdTourosRMTotal;
end;

function TImportacao.Get_QtdVezesProcessamento: Integer;
begin
  Result := FQtdVezesProcessamento;
end;

function TImportacao.Get_SglProdutor: WideString;
begin
  Result := FSglProdutor;
end;

function TImportacao.Get_CodArquivoImportacao: Integer;
begin
  Result := FCodArquivoImportacao;
end;

function TImportacao.Get_DtaImportacao: TDateTime;
begin
  Result := FDtaImportacao;
end;

function TImportacao.Get_NomUsuarioUpload: WideString;
begin
  Result := FNomUsuarioUpload;
end;

function TImportacao.Get_NomArquivoUpload: WideString;
begin
  Result := FNomArquivoUpload;
end;

function TImportacao.Get_QtdOcorrencias: Integer;
begin
  Result := FQtdOcorrencias;
end;

procedure TImportacao.Set_CodPessoaProdutor(Value: Integer);
begin
  FCodPessoaProdutor := Value;
end;

procedure TImportacao.Set_DtaUltimoProcessamento(Value: TDateTime);
begin
  FDtaUltimoProcessamento := Value;
end;

procedure TImportacao.Set_NomArquivoImportacao(const Value: WideString);
begin
  FNomArquivoImportacao := Value;
end;

procedure TImportacao.Set_NomPessoaProdutor(const Value: WideString);
begin
  FNomPessoaProdutor := Value;
end;

procedure TImportacao.Set_NumCNPJCPFFormatadoProdutor(
  const Value: WideString);
begin
  FNumCNPJCPFFormatadoProdutor := Value;
end;

procedure TImportacao.Set_QtdAnimaisAlteracaoProcessados(Value: Integer);
begin
  FQtdAnimaisAlteracaoProcessados := Value;
end;

procedure TImportacao.Set_QtdAnimaisAlteracaoTotal(Value: Integer);
begin
  FQtdAnimaisAlteracaoTotal := Value;
end;

procedure TImportacao.Set_QtdAnimaisEventosProcessados(Value: Integer);
begin
  FQtdAnimaisEventosProcessados := Value;
end;

procedure TImportacao.Set_QtdAnimaisEventosTotal(Value: Integer);
begin
  FQtdAnimaisEventosTotal := Value;
end;

procedure TImportacao.Set_QtdAnimaisInsercaoProcessados(Value: Integer);
begin
  FQtdAnimaisInsercaoProcessados := Value;
end;

procedure TImportacao.Set_QtdAnimaisInsercaoTotal(Value: Integer);
begin
  FQtdAnimaisInsercaoTotal := Value;
end;

procedure TImportacao.Set_QtdEventosProcessados(Value: Integer);
begin
  FQtdEventosProcessados := Value;
end;

procedure TImportacao.Set_QtdEventosTotal(Value: Integer);
begin
  FQtdEventosTotal := Value;
end;

procedure TImportacao.Set_QtdRMProcessados(Value: Integer);
begin
  FQtdRMProcessados := Value;
end;

procedure TImportacao.Set_QtdRMTotal(Value: Integer);
begin
  FQtdRMTotal := Value;
end;

procedure TImportacao.Set_QtdTourosRMProcessados(Value: Integer);
begin
  FQtdTourosRMProcessados := Value;
end;

procedure TImportacao.Set_QtdTourosRMTotal(Value: Integer);
begin
  FQtdTourosRMTotal := Value;
end;

procedure TImportacao.Set_QtdVezesProcessamento(Value: Integer);
begin
  FQtdVezesProcessamento := Value;
end;

procedure TImportacao.Set_SglProdutor(const Value: WideString);
begin
  FSglProdutor := Value;
end;

procedure TImportacao.Set_CodArquivoImportacao(Value: Integer);
begin
  FCodArquivoImportacao := Value;
end;

procedure TImportacao.Set_DtaImportacao(Value: TDateTime);
begin
  FDtaImportacao := Value;
end;

procedure TImportacao.Set_NomUsuarioUpload(const Value: WideString);
begin
  FNomUsuarioUpload := Value;
end;

procedure TImportacao.Set_NomArquivoUpload(const Value: WideString);
begin
  FNomArquivoUpload := Value;
end;

procedure TImportacao.Set_QtdOcorrencias(Value: Integer);
begin
  FQtdOcorrencias := Value;
end;

function TImportacao.Get_QtdLinhas: Integer;
begin
  Result := FQtdLinhas;
end;

procedure TImportacao.Set_QtdLinhas(Value: Integer);
begin
  FQtdLinhas := Value;
end;

function TImportacao.Get_QtdAnimaisAlteracaoErro: Integer;
begin
  Result := FQtdAnimaisAlteracaoErro;
end;

function TImportacao.Get_QtdAnimaisEventosErro: Integer;
begin
  Result := FQtdAnimaisEventosErro;
end;

function TImportacao.Get_QtdAnimaisInsercaoErro: Integer;
begin
  Result := FQtdAnimaisInsercaoErro;
end;

function TImportacao.Get_QtdEventosErro: Integer;
begin
  Result := FQtdEventosErro;
end;

function TImportacao.Get_QtdRMErro: Integer;
begin
  Result := FQtdRMErro;
end;

function TImportacao.Get_QtdTourosRMErro: Integer;
begin
  Result := FQtdTourosRMErro;
end;

procedure TImportacao.Set_QtdAnimaisAlteracaoErro(Value: Integer);
begin
  FQtdAnimaisAlteracaoErro := Value;
end;

procedure TImportacao.Set_QtdAnimaisEventosErro(Value: Integer);
begin
  FQtdAnimaisEventosErro := Value;
end;

procedure TImportacao.Set_QtdAnimaisInsercaoErro(Value: Integer);
begin
  FQtdAnimaisInsercaoErro := Value;
end;

procedure TImportacao.Set_QtdEventosErro(Value: Integer);
begin
  FQtdEventosErro := Value;
end;

procedure TImportacao.Set_QtdRMErro(Value: Integer);
begin
  FQtdRMErro := Value;
end;

procedure TImportacao.Set_QtdTourosRMErro(Value: Integer);
begin
  FQtdTourosRMErro := Value;
end;

function TImportacao.Get_QtdCRacialErro: Integer;
begin
  Result := FQtdCRacialErro;
end;

function TImportacao.Get_QtdCRacialProcessados: Integer;
begin
  Result := FQtdCRacialProcessados;
end;

function TImportacao.Get_QtdCRacialTotal: Integer;
begin
  Result := FQtdCRacialTotal;
end;

procedure TImportacao.Set_QtdCRacialErro(Value: Integer);
begin
  FQtdCRacialErro := Value;
end;

procedure TImportacao.Set_QtdCRacialProcessados(Value: Integer);
begin
  FQtdCRacialProcessados := Value;
end;

procedure TImportacao.Set_QtdCRacialTotal(Value: Integer);
begin
  FQtdCRacialTotal := Value;
end;

function TImportacao.Get_CodSituacaoArqImport: WideString;
begin
        Result :=  FCodSituacaoArqImport;
end;

function TImportacao.Get_CodSituacaoUltimaTarefa: WideString;
begin
        Result :=  FCodSituacaoUltimaTarefa;
end;

function TImportacao.Get_CodTipoOrigemArqImport: Integer;
begin
        Result :=  FCodTipoOrigemArqImport;
end;

function TImportacao.Get_CodUltimaTarefa: Integer;
begin
        Result :=  FCodUltimaTarefa;
end;

function TImportacao.Get_CodUsuarioUpload: Integer;
begin
        Result :=  FCodUsuarioUpload;
end;

function TImportacao.Get_DesSituacaoArqImport: WideString;
begin
        Result :=  FDesSituacaoArqImport;
end;

function TImportacao.Get_DesSituacaoUltimaTarefa: WideString;
begin
        Result :=  FDesSituacaoUltimaTarefa;
end;

function TImportacao.Get_DesTipoOrigemArqImport: WideString;
begin
        Result :=  FDesTipoOrigemArqImport;
end;

function TImportacao.Get_DtaFimRealUltimaTarefa: TDateTime;
begin
        Result :=  FDtaFimRealUltimaTarefa;
end;

function TImportacao.Get_DtaInicioPrevistoUltimaTarefa: TDateTime;
begin
        Result :=  FDtaInicioPrevistoUltimaTarefa;
end;

function TImportacao.Get_DtaInicioRealUltimaTarefa: TDateTime;
begin
        Result :=  FDtaInicioRealUltimaTarefa;
end;

function TImportacao.Get_SglTipoOrigemArqImport: WideString;
begin
        Result :=  FSglTipoOrigemArqImport;
end;

procedure TImportacao.Set_CodSituacaoArqImport(const Value: WideString);
begin
        FCodSituacaoArqImport := Value;
end;

procedure TImportacao.Set_CodSituacaoUltimaTarefa(const Value: WideString);
begin
        FCodSituacaoUltimaTarefa := Value;
end;

procedure TImportacao.Set_CodTipoOrigemArqImport(Value: Integer);
begin
        FCodTipoOrigemArqImport := Value;
end;

procedure TImportacao.Set_CodUltimaTarefa(Value: Integer);
begin
        FCodUltimaTarefa := Value;
end;

procedure TImportacao.Set_CodUsuarioUpload(Value: Integer);
begin
        FCodUsuarioUpload := Value;
end;

procedure TImportacao.Set_DesSituacaoArqImport(const Value: WideString);
begin
        FDesSituacaoArqImport := Value;
end;

procedure TImportacao.Set_DesSituacaoUltimaTarefa(const Value: WideString);
begin
        FDesSituacaoUltimaTarefa := Value;
end;

procedure TImportacao.Set_DesTipoOrigemArqImport(const Value: WideString);
begin
        FDesTipoOrigemArqImport := Value;
end;

procedure TImportacao.Set_DtaFimRealUltimaTarefa(Value: TDateTime);
begin
        FDtaFimRealUltimaTarefa := Value;
end;

procedure TImportacao.Set_DtaInicioPrevistoUltimaTarefa(Value: TDateTime);
begin
        FDtaInicioPrevistoUltimaTarefa := Value;
end;

procedure TImportacao.Set_DtaInicioRealUltimaTarefa(Value: TDateTime);
begin
        FDtaInicioRealUltimaTarefa := Value;
end;

procedure TImportacao.Set_SglTipoOrigemArqImport(const Value: WideString);
begin
        FSglTipoOrigemArqImport := Value;
end;

function TImportacao.Get_QtdInventariosAnimaisErro: Integer;
begin
  Result := FQtdInventariosAnimaisErro;
end;

function TImportacao.Get_QtdInventariosAnimaisProcessados: Integer;
begin
  Result := FQtdInventariosAnimaisProcessados;
end;

function TImportacao.Get_QtdInventariosAnimaisTotal: Integer;
begin
  Result := FQtdInventariosAnimaisTotal;
end;

procedure TImportacao.Set_QtdInventariosAnimaisErro(Value: Integer);
begin
  FQtdInventariosAnimaisErro := Value;
end;

procedure TImportacao.Set_QtdInventariosAnimaisProcessados(Value: Integer);
begin
  FQtdInventariosAnimaisProcessados := Value;
end;

procedure TImportacao.Set_QtdInventariosAnimaisTotal(Value: Integer);
begin
  FQtdInventariosAnimaisTotal := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TImportacao, Class_Importacao,
    ciMultiInstance, tmApartment);
end.
