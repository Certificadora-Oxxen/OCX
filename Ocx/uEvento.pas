unit uEvento;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TEvento = class(TASPMTSObject, IEvento)
  private
    FCodArquivoSisbov: Integer;
    FCodEvento: Integer;
    FCodGrupoEvento: Integer;
    FCodPessoaProdutor: Integer;
    FCodTipoEvento: Integer;
    FDesGrupoEvento: WideString;
    FDesTipoEvento: WideString;
    FDtaCadastramento: TDateTime;
    FDtaEfetivacaoCadastro: TDateTime;
    FDtaFim: TDateTime;
    FDtaGravacaoSisbov: TDateTime;
    FDtaInicio: TDateTime;
    FNomArquivoSisbov: WideString;
    FQtdAnimais: Integer;
    FSglGrupoEvento: WideString;
    FSglTipoEvento: WideString;
    FTxtDados: WideString;
    FTxtObservacao: WideString;
    FCodSituacaoSisbov: WideString;
    FCodAptidao: Integer;
    FCodCategoria: Integer;
    FCodFazenda: Integer;
    FNIRF: WideString;
    FCodLocalizacaoSISBOV: Integer;
    FCNPJAglomeracao: WideString;
    FNomArquivoCertificado: WideString;
    FCodPropriedadeRural: Integer;
    FNomPropriedadeRural: WideString;
    FNumCNPJCPFPessoa: WideString;
    FCodPessoa: Integer;
    FNomPessoa: WideString;
    FNumCNPJCPFPessoaSecundaria: WideString;
    FCodPessoaSecundaria: Integer;
    FNomPessoaSecundaria: WideString;
    FNumGTA: WideString;
    FCodSerieGTA: WideString;
    FCodEstadoGTA: Integer;
    FDtaEmissaoGTA: TDateTime;
    FDtaValidadeGTA: TDateTime;
    FCodAnimalRMManejo: WideString;
    FCodFazendaManejo: Integer;
    FCodPessoaSecAvaliador: Integer;
    FCodTipoAvaliacao: Integer;
    FCodGrauDificuldade: Integer;
    FCodEventoCobertura: Integer;
    FDesSituacaoCria: WideString;
    FDtaEventoCobertura: TDateTime;
    FQtdDiasGestacao: Integer;
    FNumOrdemParto: Integer;
    FCodAnimalManejoCria: WideString;
    FCodAnimalManejoGemeo: WideString;
    FCodAnimalManejoTouro: WideString;
    FCodAnimalManejoFemea: WideString;
    FCodEstacaoMonta: Integer;
    FCodAnimalTouro: Integer;
    FCodAnimalFemea: Integer;
    FCodPessoaOrigem: Integer;
    FCodPessoaDestino: Integer;
    FCodEventoAssociado: Integer;
    FIndVendaCertifTerceira: WideString;
    FCodExportacaoPropriedade: WideString;
    FIndMovNErasEras: WideString;
    FIndMigrarAnimal: WideString;
  protected
    function Get_CodAnimalFemea: Integer; safecall;
    function Get_CodArquivoSisbov: Integer; safecall;
    function Get_CodEvento: Integer; safecall;
    function Get_CodGrupoEvento: Integer; safecall;
    function Get_CodPessoaProdutor: Integer; safecall;
    function Get_CodTipoEvento: Integer; safecall;
    function Get_DesGrupoEvento: WideString; safecall;
    function Get_DesTipoEvento: WideString; safecall;
    function Get_DtaCadastramento: TDateTime; safecall;
    function Get_DtaEfetivacaoCadastro: TDateTime; safecall;
    function Get_DtaFim: TDateTime; safecall;
    function Get_DtaGravacaoSisbov: TDateTime; safecall;
    function Get_DtaInicio: TDateTime; safecall;
    function Get_NomArquivoSisbov: WideString; safecall;
    function Get_QtdAnimais: Integer; safecall;
    function Get_SglGrupoEvento: WideString; safecall;
    function Get_SglTipoEvento: WideString; safecall;
    function Get_TxtDados: WideString; safecall;
    function Get_TxtObservacao: WideString; safecall;
    function Get_CodSituacaoSisbov: WideString; safecall;
    function Get_CodAptidao: Integer; safecall;
    function Get_Codcategoria: Integer; safecall;
    function Get_CodFazenda: Integer; safecall;
    function Get_CNPJAglomeracao: WideString; safecall;
    function Get_NIRF: WideString; safecall;
    function Get_NomArquivoCertificado: WideString; safecall;
    function Get_CodPessoa: Integer; safecall;
    function Get_CodPessoaSecundaria: Integer; safecall;
    function Get_CodPropriedadeRural: Integer; safecall;
    function Get_DtaEmissaoGTA: TDateTime; safecall;
    function Get_NomPessoa: WideString; safecall;
    function Get_NomPessoaSecundaria: WideString; safecall;
    function Get_NomPropriedadeRural: WideString; safecall;
    function Get_NumCNPJCPFPessoa: WideString; safecall;
    function Get_NumCNPJCPFPessoaSecundaria: WideString; safecall;
    function Get_NumGTA: WideString; safecall;
    function Get_CodAnimalRMManejo: WideString; safecall;
    function Get_CodFazendaManejo: Integer; safecall;
    function Get_CodPessoaSecAvaliador: Integer; safecall;
    function Get_CodTipoAvaliacao: Integer; safecall;
    function Get_CodAnimalManejoCria: WideString; safecall;
    function Get_CodAnimalManejoFemea: WideString; safecall;
    function Get_CodAnimalManejoGemeo: WideString; safecall;
    function Get_CodAnimalManejoTouro: WideString; safecall;
    function Get_CodEventoCobertura: Integer; safecall;
    function Get_CodGrauDificuldade: Integer; safecall;
    function Get_DesSituacaoCria: WideString; safecall;
    function Get_DtaEventoCobertura: TDateTime; safecall;
    function Get_NumOrdemParto: Integer; safecall;
    function Get_QtdDiasGestacao: Integer; safecall;
    function Get_CodEstacaoMonta: Integer; safecall;
    function Get_CodAnimalTouro: Integer; safecall;
    function Get_CodLocalizacaoSISBOV: Integer; safecall;
    function Get_CodPessoaDestino: Integer; safecall;
    function Get_CodPessoaOrigem: Integer; safecall;
    function Get_CodEventoAssociado: Integer; safecall;
    procedure Set_CodEventoAssociado(Value: Integer); safecall;
    function Get_CodExportacaoPropriedade: WideString; safecall;
    function Get_IndVendaCertifTerceira: WideString; safecall;
    procedure Set_CodExportacaoPropriedade(const Value: WideString); safecall;
    procedure Set_IndVendaCertifTerceira(const Value: WideString); safecall;
    function Get_CodEstadoGTA: Integer; safecall;
    function Get_CodSerieGTA: WideString; safecall;
    procedure Set_CodEstadoGTA(Value: Integer); safecall;
    procedure Set_CodSerieGTA(const Value: WideString); safecall;
    function Get_IndMovNErasEras: WideString; safecall;
    procedure Set_IndMovNErasEras(const Value: WideString); safecall;
    function Get_DtaValidadeGTA: TDateTime; safecall;
    procedure Set_DtaValidadeGTA(Value: TDateTime); safecall;
    function Get_IndMigrarAnimal: WideString; safecall;
    procedure Set_IndMigrarAnimal(const Value: WideString); safecall;
  public
    property CodArquivoSisbov: Integer read FCodArquivoSisbov write FCodArquivoSisbov;
    property CodEvento: Integer read FCodEvento write FCodEvento;
    property CodGrupoEvento: Integer read FCodGrupoEvento write FCodGrupoEvento;
    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property CodTipoEvento: Integer read FCodTipoEvento write FCodTipoEvento;
    property DesGrupoEvento: WideString read FDesGrupoEvento write FDesGrupoEvento;
    property DesTipoEvento: WideString read FDesTipoEvento write FDesTipoEvento;
    property DtaCadastramento: TDateTime read FDtaCadastramento write FDtaCadastramento;
    property DtaEfetivacaoCadastro: TDateTime read FDtaEfetivacaoCadastro write FDtaEfetivacaoCadastro;
    property DtaFim: TDateTime read FDtaFim write FDtaFim;
    property DtaGravacaoSisbov: TDateTime read FDtaGravacaoSisbov write FDtaGravacaoSisbov;
    property DtaInicio: TDateTime read FDtaInicio write FDtaInicio;
    property NomArquivoSisbov: WideString read FNomArquivoSisbov write FNomArquivoSisbov;
    property QtdAnimais: Integer read FQtdAnimais write FQtdAnimais;
    property SglGrupoEvento: WideString read FSglGrupoEvento write FSglGrupoEvento;
    property SglTipoEvento: WideString read FSglTipoEvento write FSglTipoEvento;
    property TxtDados: WideString read FTxtDados write FTxtDados;
    property TxtObservacao: WideString read FTxtObservacao write FTxtObservacao;
    property CodSituacaoSisbov: WideString read FCodSituacaoSisbov write FCodSituacaoSisbov;
    property CodAptidao: Integer read FCodAptidao write FCodAptidao;
    property CodCategoria: Integer read FCodCategoria write FCodCategoria;
    property CodFazenda: Integer read FCodFazenda write FCodFazenda;
    property NIRF: WideString read FNIRF write FNIRF;
    property CodLocalizacaoSISBOV: Integer read FCodLocalizacaoSISBOV write FCodLocalizacaoSISBOV;
    property CNPJAglomeracao: WideString read FCNPJAglomeracao write FCNPJAglomeracao;
    property NomArquivoCertificado: WideString read FNomArquivoCertificado write FNomArquivoCertificado;
    property CodPropriedadeRural: Integer read FCodPropriedadeRural write FCodPropriedadeRural;
    property NomPropriedadeRural: WideString read FNomPropriedadeRural write FNomPropriedadeRural;
    property NumCNPJCPFPessoa: WideString read FNumCNPJCPFPessoa write FNumCNPJCPFPessoa;
    property CodPessoa: Integer read FCodPessoa write FCodPessoa;
    property NomPessoa: WideString read FNomPessoa write FNomPessoa;
    property NumCNPJCPFPessoaSecundaria: WideString read FNumCNPJCPFPessoaSecundaria write FNumCNPJCPFPessoaSecundaria;
    property CodPessoaSecundaria: Integer read FCodPessoaSecundaria write FCodPessoaSecundaria;
    property NomPessoaSecundaria: WideString read FNomPessoaSecundaria write FNomPessoaSecundaria;
    property NumGTA: WideString read FNumGTA write FNumGTA;
    property CodSerieGTA: WideString read FCodSerieGTA write FCodSerieGTA;
    property CodEstadoGTA: Integer read FCodEstadoGTA write FCodEstadoGTA;
    property DtaEmissaoGTA: TDateTime read FDtaEmissaoGTA write FDtaEmissaoGTA;
    property DtaValidadeGTA: TDateTime read FDtaValidadeGTA write FDtaValidadeGTA;
    property CodAnimalRMManejo: WideString read FCodAnimalRMManejo write FCodAnimalRMManejo;
    property CodFazendaManejo: Integer read FCodFazendaManejo write FCodFazendaManejo;
    property CodPessoaSecAvaliador: Integer read FCodPessoaSecAvaliador write FCodPessoaSecAvaliador;
    property CodTipoAvaliacao: Integer read FCodTipoAvaliacao write FCodTipoAvaliacao;
    property CodGrauDificuldade: Integer read FCodGrauDificuldade write FCodGrauDificuldade;
    property CodEventoCobertura: Integer read FCodEventoCobertura write FCodEventoCobertura;
    property DesSituacaoCria: WideString read FDesSituacaoCria write FDesSituacaoCria;
    property DtaEventoCobertura: TDateTime read FDtaEventoCobertura write FDtaEventoCobertura;
    property QtdDiasGestacao: Integer read FQtdDiasGestacao write FQtdDiasGestacao;
    property NumOrdemParto: Integer read FNumOrdemParto write FNumOrdemParto;
    property CodAnimalManejoCria: WideString read FCodAnimalManejoCria write FCodAnimalManejoCria;
    property CodAnimalManejoGemeo: WideString read FCodAnimalManejoGemeo write FCodAnimalManejoGemeo;
    property CodAnimalManejoTouro: WideString read FCodAnimalManejoTouro write FCodAnimalManejoTouro;
    property CodAnimalManejoFemea: WideString read FCodAnimalManejoFemea write FCodAnimalManejoFemea;
    property CodEstacaoMonta: Integer read FCodEstacaoMonta write FCodEstacaoMonta;
    property CodAnimalTouro: Integer read FCodAnimalTouro write FCodAnimalTouro;
    property CodAnimalFemea: Integer read FCodAnimalFemea write FCodAnimalFemea;
    property CodPessoaOrigem: Integer read FCodPessoaOrigem write FCodPessoaOrigem;
    property CodPessoaDestino: Integer read FCodPessoaDestino write FCodPessoaDestino;
    property CodEventoAssociado: Integer read FCodEventoAssociado write FCodEventoAssociado;
    property IndVendaCertifTerceira: WideString read FIndVendaCertifTerceira write FIndVendaCertifTerceira;
    property CodExportacaoPropriedade: WideString read FCodExportacaoPropriedade write FCodExportacaoPropriedade;
    property IndMovNErasEras: WideString read FIndMovNErasEras write FIndMovNErasEras;
    property IndMigrarAnimal: WideString read FIndMigrarAnimal write FIndMigrarAnimal;
  end;

implementation

uses ComServ;

function TEvento.Get_CodArquivoSisbov: Integer;
begin
  Result := FCodArquivoSisbov;
end;

function TEvento.Get_CodEvento: Integer;
begin
  Result := FCodEvento;
end;

function TEvento.Get_CodGrupoEvento: Integer;
begin
  Result := FCodGrupoEvento;
end;

function TEvento.Get_CodPessoaProdutor: Integer;
begin
  Result := FCodPessoaProdutor;
end;

function TEvento.Get_CodTipoEvento: Integer;
begin
  Result := FCodTipoEvento;
end;

function TEvento.Get_DesGrupoEvento: WideString;
begin
  Result := FDesGrupoEvento;
end;

function TEvento.Get_DesTipoEvento: WideString;
begin
  Result := FDesTipoEvento;
end;

function TEvento.Get_DtaCadastramento: TDateTime;
begin
  Result := FDtaCadastramento;
end;

function TEvento.Get_DtaEfetivacaoCadastro: TDateTime;
begin
  Result := FDtaEfetivacaoCadastro;
end;

function TEvento.Get_DtaFim: TDateTime;
begin
  Result := FDtaFim;
end;

function TEvento.Get_DtaGravacaoSisbov: TDateTime;
begin
  Result := FDtaGravacaoSisbov;
end;

function TEvento.Get_DtaInicio: TDateTime;
begin
  Result := FDtaInicio;
end;

function TEvento.Get_NomArquivoSisbov: WideString;
begin
  Result := FNomArquivoSisbov;
end;

function TEvento.Get_QtdAnimais: Integer;
begin
  Result := FQtdAnimais;
end;

function TEvento.Get_SglGrupoEvento: WideString;
begin
  Result := FSglGrupoEvento;
end;

function TEvento.Get_SglTipoEvento: WideString;
begin
  Result := FSglTipoEvento;
end;

function TEvento.Get_TxtDados: WideString;
begin
  Result := FTxtDados;
end;

function TEvento.Get_TxtObservacao: WideString;
begin
  Result := FTxtObservacao;
end;

function TEvento.Get_CodSituacaoSisbov: WideString;
begin
  Result := FCodSituacaoSisbov;
end;

function TEvento.Get_CodAptidao: Integer;
begin
  Result := FCodAptidao;
end;

function TEvento.Get_Codcategoria: Integer;
begin
  Result := FCodCategoria;
end;

function TEvento.Get_CodFazenda: Integer;
begin
  Result := FCodFazenda;
end;

function TEvento.Get_CNPJAglomeracao: WideString;
begin
  Result := FCNPJAglomeracao;
end;

function TEvento.Get_NIRF: WideString;
begin
  Result := FNIRF;
end;

function TEvento.Get_NomArquivoCertificado: WideString;
begin
  Result := FNomArquivoCertificado;
end;

function TEvento.Get_CodPessoa: Integer;
begin
  Result := FCodPessoa;
end;

function TEvento.Get_CodPessoaSecundaria: Integer;
begin
  Result := FCodPessoaSecundaria;
end;

function TEvento.Get_CodPropriedadeRural: Integer;
begin
  Result := FCodPropriedadeRural;
end;

function TEvento.Get_DtaEmissaoGTA: TDateTime;
begin
  Result := FDtaEmissaoGta;
end;

function TEvento.Get_NomPessoa: WideString;
begin
  Result := FNomPessoa;
end;

function TEvento.Get_NomPessoaSecundaria: WideString;
begin
  Result := FNomPessoaSecundaria;
end;

function TEvento.Get_NomPropriedadeRural: WideString;
begin
  Result := FNomPropriedadeRural;
end;

function TEvento.Get_NumCNPJCPFPessoa: WideString;
begin
  Result := FNumCNPJCPFPessoa;
end;

function TEvento.Get_NumCNPJCPFPessoaSecundaria: WideString;
begin
  Result := FNumCNPJCPFPessoaSecundaria;
end;

function TEvento.Get_NumGTA: WideString;
begin
  Result := FNumGTA;
end;

function TEvento.Get_CodAnimalRMManejo: WideString;
begin
  Result := CodAnimalRMManejo;
end;

function TEvento.Get_CodFazendaManejo: Integer;
begin
  Result := CodFazendaManejo;
end;

function TEvento.Get_CodPessoaSecAvaliador: Integer;
begin
  Result := CodPessoaSecAvaliador;
end;

function TEvento.Get_CodTipoAvaliacao: Integer;
begin
  Result := CodTipoAvaliacao;
end;

function TEvento.Get_CodAnimalManejoCria: WideString;
begin
  Result := CodAnimalManejoCria;
end;

function TEvento.Get_CodAnimalManejoFemea: WideString;
begin
  Result := CodAnimalManejoFemea;
end;

function TEvento.Get_CodAnimalManejoGemeo: WideString;
begin
  Result := CodAnimalManejoGemeo;
end;

function TEvento.Get_CodAnimalManejoTouro: WideString;
begin
  Result := CodAnimalManejoTouro;
end;

function TEvento.Get_CodEventoCobertura: Integer;
begin
  Result := CodEventoCobertura;
end;

function TEvento.Get_CodGrauDificuldade: Integer;
begin
  Result := CodGrauDificuldade;
end;

function TEvento.Get_DesSituacaoCria: WideString;
begin
  Result := DesSituacaoCria;
end;

function TEvento.Get_DtaEventoCobertura: TDateTime;
begin
  Result := DtaEventoCobertura;
end;

function TEvento.Get_NumOrdemParto: Integer;
begin
  Result := NumOrdemParto;
end;

function TEvento.Get_QtdDiasGestacao: Integer;
begin
  Result := QtdDiasGestacao;
end;

function TEvento.Get_CodEstacaoMonta: Integer;
begin
  Result := CodEstacaoMonta;
end;

function TEvento.Get_CodAnimalTouro: Integer;
begin
  Result := CodAnimalTouro;
end;

function TEvento.Get_CodAnimalFemea: Integer;
begin
  Result := CodAnimalFemea;
end;

function TEvento.Get_CodLocalizacaoSISBOV: Integer;
begin
  Result := FCodLocalizacaoSISBOV;
end;

function TEvento.Get_CodPessoaDestino: Integer;
begin
  Result := FCodPessoaDestino;
end;

function TEvento.Get_CodPessoaOrigem: Integer;
begin
  Result := FCodPessoaOrigem;
end;

function TEvento.Get_CodEventoAssociado: Integer;
begin
  Result := FCodEventoAssociado;
end;

procedure TEvento.Set_CodEventoAssociado(Value: Integer);
begin
  FCodEventoAssociado := Value;
end;

function TEvento.Get_CodExportacaoPropriedade: WideString;
begin
  Result := FCodExportacaoPropriedade;
end;

function TEvento.Get_IndVendaCertifTerceira: WideString;
begin
  Result := FIndVendaCertifTerceira;
end;

procedure TEvento.Set_CodExportacaoPropriedade(const Value: WideString);
begin
  FCodExportacaoPropriedade := Value;
end;

procedure TEvento.Set_IndVendaCertifTerceira(const Value: WideString);
begin
  FIndVendaCertifTerceira := Value;
end;

function TEvento.Get_CodEstadoGTA: Integer;
begin
  Result := FCodEstadoGTA;
end;

function TEvento.Get_CodSerieGTA: WideString;
begin
  Result := FCodSerieGTA;
end;

procedure TEvento.Set_CodEstadoGTA(Value: Integer);
begin
  FCodEstadoGTA := Value;
end;

procedure TEvento.Set_CodSerieGTA(const Value: WideString);
begin
  FCodSerieGTA := Value;
end;

function TEvento.Get_IndMovNErasEras: WideString;
begin
  Result := FIndMovNErasEras;
end;

procedure TEvento.Set_IndMovNErasEras(const Value: WideString);
begin
  FIndMovNErasEras := Value;
end;

function TEvento.Get_DtaValidadeGTA: TDateTime;
begin
  Result := FDtaValidadeGTA;
end;

procedure TEvento.Set_DtaValidadeGTA(Value: TDateTime);
begin
  FDtaValidadeGTA := Value;
end;

function TEvento.Get_IndMigrarAnimal: WideString;
begin
  Result := FIndMigrarAnimal;
end;

procedure TEvento.Set_IndMigrarAnimal(const Value: WideString);
begin
  FIndMigrarAnimal := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TEvento, Class_Evento,
    ciMultiInstance, tmApartment);
end.
