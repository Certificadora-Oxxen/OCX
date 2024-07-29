unit uBoletoBancario;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TBoletoBancario = class(TASPMTSObject, IBoletoBancario)
  private
    FCodOrdemServico:           Integer;
    FCodBoletoBancario:         Integer;
    FCodIdentificacaoBancaria:  Integer;
    FNomBanco:                  WideString;
    FCodSituacaoBoleto:         WideString;
    FSglSituacaoBoleto:         WideString;
    FDesSituacaoBoleto:         WideString;
    FNomPessoaProdutor:         WideString;
    FNumCNPJCPF:                WideString;
    FNumCNPJCPFFormatado:       WideString;
    FNomPropriedadeRural:       WideString;
    FNumImovelReceitaFederal:   WideString;
    FNumRemessaBoleto:          Integer;
    FDtaGeracaoRemessa:         TDateTime;
    FEnderecoCobranca:          IEndereco;
    FDtaVencimentoBoleto:       TDateTime;
    FNumParcela:                Integer;
    FValTotalBoleto:            Double;
    FQtdAnimais:                Integer;
    FValUnitarioVendedor:       Double;
    FValUnitarioTecnico:        Double;
    FValUnitarioCertificadora:  Double;
    FValVistoria:               Double;
    FValTotalOS:                Double;
    FQtdParcelas:               Integer;
    FValPagoBoleto:             Double;
    FDtaCreditoEfetivado:       TDateTime;
    FCodUsuarioUltimaAlteracao: Integer;
    FNomUsuarioUltimaAlteracao: WideString;
    FCodUsuarioCancelamento:    Integer;
    FNomUsuarioCancelamento:    WideString;
    FDtaUltimaAlteracao:        TDateTime;
    FTxtMensagem3:              WideString;
    FTxtMensagem4:              WideString;
    FNomReduzidoBanco:          WideString;
    FCodArqImportBoleto:        Integer;
    FCodSituacaoArqImport:      String;
    FCodTarefa:                 Integer;
    FCodTipoArquivoBoleto:      Integer;
    FCodUsuarioUpLoad:          Integer;
    FDesSituacaoArqImport:      WideString;
    FDesTipoArquivoBoleto:      WideString;
    FDtaImportacao:             TDateTime;
    FDtaProcessamento:          TDateTime;
    FNomArqImportBoleto:        WideString;
    FNomArqUpLoad:              WideString;
    FNomUsuarioUpLoad:          WideString;
    FQtdRegistrosErrados:       Integer;
    FQtdRegistrosProcessados:   Integer;
    FQtdRegistrosTotal:         Integer;
    FTxtMensagem:               WideString;

    FDesSituacaoTarefa:             WideString;
    FDtaInicioPrevistoTarefa:       TDateTime;
    FDtaInicioRealTarefa:           TDateTime;
    FDtaFimRealTarefa:              TDateTime;
    FNomUsuarioProcessamentoTarefa: WideString;

    FCodFormaPagamentoBoleto: Integer;
    FSglFormaPagamentoBoleto: WideString;
    FDesFormaPagamentoBoleto: WideString;
  protected
    function Get_CodBoletoBancario: Integer; safecall;
    function Get_CodIdentificacaoBancaria: Integer; safecall;
    function Get_CodOrdemServico: Integer; safecall;
    function Get_CodSituacaoBoleto: WideString; safecall;
    function Get_CodUsuarioCancelamento: Integer; safecall;
    function Get_CodUsuarioUltimaAlteracao: Integer; safecall;
    function Get_DesSituacaoBoleto: WideString; safecall;
    function Get_DtaCreditoEfetivado: TDateTime; safecall;
    function Get_DtaGeracaoRemessa: TDateTime; safecall;
    function Get_DtaUltimaAlteracao: TDateTime; safecall;
    function Get_DtaVencimentoBoleto: TDateTime; safecall;
    function Get_EnderecoCobranca: Endereco; safecall;
    function Get_NomBanco: WideString; safecall;
    function Get_NomPessoaProdutor: WideString; safecall;
    function Get_NomPropriedadeRural: WideString; safecall;
    function Get_NomUsuarioCancelamento: WideString; safecall;
    function Get_NomUsuarioUltimaAlteracao: WideString; safecall;
    function Get_NumCNPJCPF: WideString; safecall;
    function Get_NumCNPJCPFFormatado: WideString; safecall;
    function Get_NumImovelReceitaFederal: WideString; safecall;
    function Get_NumParcela: Integer; safecall;
    function Get_QtdAnimais: Integer; safecall;
    function Get_QtdParcelas: Integer; safecall;
    function Get_SglSituacaoBoleto: WideString; safecall;
    function Get_TxtMensagem3: WideString; safecall;
    function Get_TxtMensagem4: WideString; safecall;
    function Get_ValPagoBoleto: Double; safecall;
    function Get_ValTotalBoleto: Double; safecall;
    function Get_ValTotalOS: Double; safecall;
    function Get_ValUnitarioCertificadora: Double; safecall;
    function Get_ValUnitarioTecnico: Double; safecall;
    function Get_ValUnitarioVendedor: Double; safecall;
    procedure Set_CodBoletoBancario(Value: Integer); safecall;
    procedure Set_CodIdentificacaoBancaria(Value: Integer); safecall;
    procedure Set_CodOrdemServico(Value: Integer); safecall;
    procedure Set_CodSituacaoBoleto(const Value: WideString); safecall;
    procedure Set_CodUsuarioCancelamento(Value: Integer); safecall;
    procedure Set_CodUsuarioUltimaAlteracao(Value: Integer); safecall;
    procedure Set_DesSituacaoBoleto(const Value: WideString); safecall;
    procedure Set_DtaCreditoEfetivado(Value: TDateTime); safecall;
    procedure Set_DtaGeracaoRemessa(Value: TDateTime); safecall;
    procedure Set_DtaUltimaAlteracao(Value: TDateTime); safecall;
    procedure Set_DtaVencimentoBoleto(Value: TDateTime); safecall;
    procedure Set_EnderecoCobranca(const Value: Endereco); safecall;
    procedure Set_NomBanco(const Value: WideString); safecall;
    procedure Set_NomPessoaProdutor(const Value: WideString); safecall;
    procedure Set_NomPropriedadeRural(const Value: WideString); safecall;
    procedure Set_NomUsuarioCancelamento(const Value: WideString); safecall;
    procedure Set_NomUsuarioUltimaAlteracao(const Value: WideString); safecall;
    procedure Set_NumCNPJCPF(const Value: WideString); safecall;
    procedure Set_NumCNPJCPFFormatado(const Value: WideString); safecall;
    procedure Set_NumImovelReceitaFederal(const Value: WideString); safecall;
    procedure Set_NumParcela(Value: Integer); safecall;
    procedure Set_QtdAnimais(Value: Integer); safecall;
    procedure Set_QtdParcelas(Value: Integer); safecall;
    procedure Set_SglSituacaoBoleto(const Value: WideString); safecall;
    procedure Set_TxtMensagem3(const Value: WideString); safecall;
    procedure Set_TxtMensagem4(const Value: WideString); safecall;
    procedure Set_ValPagoBoleto(Value: Double); safecall;
    procedure Set_ValTotalBoleto(Value: Double); safecall;
    procedure Set_ValTotalOS(Value: Double); safecall;
    procedure Set_ValUnitarioCertificadora(Value: Double); safecall;
    procedure Set_ValUnitarioTecnico(Value: Double); safecall;
    procedure Set_ValUnitarioVendedor(Value: Double); safecall;
    function Get_NomReduzidoBanco: WideString; safecall;
    procedure Set_NomReduzidoBanco(const Value: WideString); safecall;
    function Get_CodArqImportBoleto: Integer; safecall;
    function Get_CodSituacaoArqImport: WideString; safecall;
    function Get_CodTarefa: Integer; safecall;
    function Get_CodTipoArquivoBoleto: Integer; safecall;
    function Get_CodUsuarioUpLoad: Integer; safecall;
    function Get_DesSituacaoArqImport: WideString; safecall;
    function Get_DesTipoArquivoBoleto: WideString; safecall;
    function Get_DtaImportacao: TDateTime; safecall;
    function Get_DtaProcessamento: TDateTime; safecall;
    function Get_NomArqImportBoleto: WideString; safecall;
    function Get_NomArqUpLoad: WideString; safecall;
    function Get_NomUsuarioUpLoad: WideString; safecall;
    function Get_QtdRegistrosErrados: Integer; safecall;
    function Get_QtdRegistrosProcessados: Integer; safecall;
    function Get_QtdRegistrosTotal: Integer; safecall;
    function Get_TxtMensagem: WideString; safecall;
    procedure Set_CodArqImportBoleto(Value: Integer); safecall;
    procedure Set_CodSituacaoArqImport(const Value: WideString); safecall;
    procedure Set_CodTarefa(Value: Integer); safecall;
    procedure Set_CodTipoArquivoBoleto(Value: Integer); safecall;
    procedure Set_CodUsuarioUpLoad(Value: Integer); safecall;
    procedure Set_DesSituacaoArqImport(const Value: WideString); safecall;
    procedure Set_DesTipoArquivoBoleto(const Value: WideString); safecall;
    procedure Set_DtaImportacao(Value: TDateTime); safecall;
    procedure Set_DtaProcessamento(Value: TDateTime); safecall;
    procedure Set_NomArqImportBoleto(const Value: WideString); safecall;
    procedure Set_NomArqUpLoad(const Value: WideString); safecall;
    procedure Set_NomUsuarioUpLoad(const Value: WideString); safecall;
    procedure Set_QtdRegistrosErrados(Value: Integer); safecall;
    procedure Set_QtdRegistrosProcessados(Value: Integer); safecall;
    procedure Set_QtdRegistrosTotal(Value: Integer); safecall;
    procedure Set_TxtMensagem(const Value: WideString); safecall;
    function Get_DesSituacaoTarefa: WideString; safecall;
    function Get_DtaFimReal: TDateTime; safecall;
    function Get_DtaInicioPrevistoTarefa: TDateTime; safecall;
    function Get_DtaInicioRealTarefa: TDateTime; safecall;
    function Get_NomUsuarioTarefaProcessamento: WideString; safecall;
    procedure Set_DesSituacaoTarefa(const Value: WideString); safecall;
    procedure Set_DtaFimReal(Value: TDateTime); safecall;
    procedure Set_DtaInicioPrevistoTarefa(Value: TDateTime); safecall;
    procedure Set_DtaInicioRealTarefa(Value: TDateTime); safecall;
    procedure Set_NomUsuarioTarefaProcessamento(const Value: WideString);
      safecall;
    function Get_CodFormaPagamentoBoleto: Integer; safecall;
    function Get_DesFormaPagamentoBoleto: WideString; safecall;
    function Get_SglFormaPagamentoBoleto: WideString; safecall;
    procedure Set_CodFormaPagamentoBoleto(Value: Integer); safecall;
    procedure Set_DesFormaPagamentoBoleto(const Value: WideString); safecall;
    procedure Set_SglFormaPagamentoBoleto(const Value: WideString); safecall;
    function Get_ValVistoria: Double; safecall;
    procedure Set_ValVistoria(Value: Double); safecall;
  public
    property CodOrdemServico:           Integer      read FCodOrdemServico write FCodOrdemServico;
    property CodBoletoBancario:         Integer      read FCodBoletoBancario write FCodBoletoBancario;
    property CodIdentificacaoBancaria:  Integer      read FCodIdentificacaoBancaria write FCodIdentificacaoBancaria;
    property NomBanco:                  WideString   read FNomBanco write FNomBanco;
    property CodSituacaoBoleto:         WideString   read FCodSituacaoBoleto write FCodSituacaoBoleto;
    property SglSituacaoBoleto:         WideString   read FSglSituacaoBoleto write FSglSituacaoBoleto;
    property DesSituacaoBoleto:         WideString   read FDesSituacaoBoleto write FDesSituacaoBoleto;
    property NomPessoaProdutor:         WideString   read FNomPessoaProdutor write FNomPessoaProdutor;
    property NumCNPJCPF:                WideString   read FNumCNPJCPF write FNumCNPJCPF;
    property NumCNPJCPFFormatado:       WideString   read FNumCNPJCPFFormatado write FNumCNPJCPFFormatado;
    property NomPropriedadeRural:       WideString   read FNomPropriedadeRural write FNomPropriedadeRural;
    property NumImovelReceitaFederal:   WideString   read FNumImovelReceitaFederal write FNumImovelReceitaFederal;
    property NumRemessaBoleto:          Integer      read FNumRemessaBoleto write FNumRemessaBoleto;
    property DtaGeracaoRemessa:         TDateTime    read FDtaGeracaoRemessa write FDtaGeracaoRemessa;
    property EnderecoCobranca:          IEndereco    read FEnderecoCobranca write FEnderecoCobranca;
    property DtaVencimentoBoleto:       TDateTime    read FDtaVencimentoBoleto write FDtaVencimentoBoleto;
    property NumParcela:                Integer      read FNumParcela write FNumParcela;
    property ValTotalBoleto:            Double       read FValTotalBoleto write FValTotalBoleto;
    property QtdAnimais:                Integer      read FQtdAnimais write FQtdAnimais;
    property ValUnitarioVendedor:       Double       read FValUnitarioVendedor write FValUnitarioVendedor;
    property ValUnitarioTecnico:        Double       read FValUnitarioTecnico write FValUnitarioTecnico;
    property ValUnitarioCertificadora:  Double       read FValUnitarioCertificadora write FValUnitarioCertificadora;
    property ValVistoria:               Double       read FValVistoria write FValVistoria;    
    property ValTotalOS:                Double       read FValTotalOS write FValTotalOS;
    property QtdParcelas:               Integer      read FQtdParcelas write FQtdParcelas;
    property ValPagoBoleto:             Double       read FValPagoBoleto write FValPagoBoleto;
    property DtaCreditoEfetivado:       TDateTime    read FDtaCreditoEfetivado write FDtaCreditoEfetivado;
    property CodUsuarioUltimaAlteracao: Integer      read FCodUsuarioUltimaAlteracao write FCodUsuarioUltimaAlteracao;
    property NomUsuarioUltimaAlteracao: WideString   read FNomUsuarioUltimaAlteracao write FNomUsuarioUltimaAlteracao;
    property CodUsuarioCancelamento:    Integer      read FCodUsuarioCancelamento write FCodUsuarioCancelamento;
    property NomUsuarioCancelamento:    WideString   read FNomUsuarioCancelamento write FNomUsuarioCancelamento;
    property DtaUltimaAlteracao:        TDateTime    read FDtaUltimaAlteracao write FDtaUltimaAlteracao;
    property TxtMensagem3:              WideString   read FTxtMensagem3 write FTxtMensagem3;
    property TxtMensagem4:              WideString   read FTxtMensagem4 write FTxtMensagem4;
    property NomReduzidoBanco:          WideString   read FNomReduzidoBanco write FNomReduzidoBanco;

    property CodArqImportBoleto:        Integer     read FCodArqImportBoleto write FCodArqImportBoleto;
    property CodSituacaoArqImport:      String      read FCodSituacaoArqImport write FCodSituacaoArqImport;
    property CodTarefa:                 Integer     read FCodTarefa write FCodTarefa;
    property CodTipoArquivoBoleto:      Integer     read FCodTipoArquivoBoleto write FCodTipoArquivoBoleto;
    property CodUsuarioUpLoad:          Integer     read FCodUsuarioUpLoad write FCodUsuarioUpLoad;
    property DesSituacaoArqImport:      WideString  read FDesSituacaoArqImport write FDesSituacaoArqImport;
    property DesTipoArquivoBoleto:      WideString  read FDesTipoArquivoBoleto write FDesTipoArquivoBoleto;
    property DtaImportacao:             TDateTime   read FDtaImportacao write FDtaImportacao;
    property DtaProcessamento:          TDateTime   read FDtaProcessamento write FDtaProcessamento;
    property NomArqImportBoleto:        WideString  read FNomArqImportBoleto write FNomArqImportBoleto;
    property NomArqUpLoad:              WideString  read FNomArqUpLoad write FNomArqUpLoad;
    property NomUsuarioUpLoad:          WideString  read FNomUsuarioUpLoad write FNomUsuarioUpLoad;
    property QtdRegistrosErrados:       Integer     read FQtdRegistrosErrados write FQtdRegistrosErrados;
    property QtdRegistrosProcessados:   Integer     read FQtdRegistrosProcessados write FQtdRegistrosProcessados;
    property QtdRegistrosTotal:         Integer     read FQtdRegistrosTotal write FQtdRegistrosTotal;
    property TxtMensagem:               WideString  read FTxtMensagem write FTxtMensagem;

    property DesSituacaoTarefa:             WideString read FDesSituacaoTarefa write FDesSituacaoTarefa;
    property DtaInicioPrevistoTarefa:       TDateTime  read FDtaInicioPrevistoTarefa write FDtaInicioPrevistoTarefa;
    property DtaInicioRealTarefa:           TDateTime  read FDtaInicioRealTarefa write FDtaInicioRealTarefa;
    property DtaFimRealTarefa:              TDateTime  read FDtaFimRealTarefa write FDtaFimRealTarefa;
    property NomUsuarioProcessamentoTarefa: WideString read FNomUsuarioProcessamentoTarefa write FNomUsuarioProcessamentoTarefa;

    property CodFormaPagamentoBoleto: Integer    read FCodFormaPagamentoBoleto write FCodFormaPagamentoBoleto;
    property SglFormaPagamentoBoleto: WideString read FSglFormaPagamentoBoleto write FSglFormaPagamentoBoleto;
    property DesFormaPagamentoBoleto: WideString read FDesFormaPagamentoBoleto write FDesFormaPagamentoBoleto;



end;

implementation

uses ComServ;

function TBoletoBancario.Get_CodBoletoBancario: Integer;
begin
  Result := FCodBoletoBancario
end;

function TBoletoBancario.Get_CodIdentificacaoBancaria: Integer;
begin
  Result := FCodIdentificacaoBancaria;
end;

function TBoletoBancario.Get_CodOrdemServico: Integer;
begin
  Result := FCodOrdemServico;
end;

function TBoletoBancario.Get_CodSituacaoBoleto: WideString;
begin
  Result := FCodSituacaoBoleto;
end;

function TBoletoBancario.Get_CodUsuarioCancelamento: Integer;
begin
  Result := FCodUsuarioCancelamento;
end;

function TBoletoBancario.Get_CodUsuarioUltimaAlteracao: Integer;
begin
  Result := FCodUsuarioUltimaAlteracao;
end;

function TBoletoBancario.Get_DesSituacaoBoleto: WideString;
begin
  Result := FDesSituacaoBoleto;
end;

function TBoletoBancario.Get_DtaCreditoEfetivado: TDateTime;
begin
  Result := FDtaCreditoEfetivado;
end;

function TBoletoBancario.Get_DtaGeracaoRemessa: TDateTime;
begin
  Result := FDtaGeracaoRemessa;
end;

function TBoletoBancario.Get_DtaUltimaAlteracao: TDateTime;
begin
  Result := FDtaUltimaAlteracao;
end;

function TBoletoBancario.Get_DtaVencimentoBoleto: TDateTime;
begin
  Result := FDtaVencimentoBoleto;
end;

function TBoletoBancario.Get_EnderecoCobranca: Endereco;
begin
  Result := FEnderecoCobranca;
end;

function TBoletoBancario.Get_NomBanco: WideString;
begin
  Result := FNomBanco;
end;

function TBoletoBancario.Get_NomPessoaProdutor: WideString;
begin
  Result := FNomPessoaProdutor;
end;

function TBoletoBancario.Get_NomPropriedadeRural: WideString;
begin
  Result := FNomPropriedadeRural;
end;

function TBoletoBancario.Get_NomUsuarioCancelamento: WideString;
begin
  Result := FNomUsuarioCancelamento;
end;

function TBoletoBancario.Get_NomUsuarioUltimaAlteracao: WideString;
begin
  Result := FNomUsuarioUltimaAlteracao;
end;

function TBoletoBancario.Get_NumCNPJCPF: WideString;
begin
  Result := FNumCNPJCPF;
end;

function TBoletoBancario.Get_NumCNPJCPFFormatado: WideString;
begin
  Result := FNumCNPJCPFFormatado; 
end;

function TBoletoBancario.Get_NumImovelReceitaFederal: WideString;
begin
  Result := FNumImovelReceitaFederal;
end;

function TBoletoBancario.Get_NumParcela: Integer;
begin
  Result := FNumParcela;
end;

function TBoletoBancario.Get_QtdAnimais: Integer;
begin
  Result := FQtdAnimais;
end;

function TBoletoBancario.Get_QtdParcelas: Integer;
begin
  Result := FQtdParcelas;
end;

function TBoletoBancario.Get_SglSituacaoBoleto: WideString;
begin
  Result := FSglSituacaoBoleto;
end;

function TBoletoBancario.Get_TxtMensagem3: WideString;
begin
  Result := FTxtMensagem3;
end;

function TBoletoBancario.Get_TxtMensagem4: WideString;
begin
  Result := FTxtMensagem4; 
end;

function TBoletoBancario.Get_ValPagoBoleto: Double;
begin
  Result := FValPagoBoleto;
end;

function TBoletoBancario.Get_ValTotalBoleto: Double;
begin
  Result := FValTotalBoleto;
end;

function TBoletoBancario.Get_ValTotalOS: Double;
begin
  Result := FValTotalOS;
end;

function TBoletoBancario.Get_ValUnitarioCertificadora: Double;
begin
  Result := FValUnitarioCertificadora;
end;

function TBoletoBancario.Get_ValUnitarioTecnico: Double;
begin
  Result := FValUnitarioTecnico;
end;

function TBoletoBancario.Get_ValUnitarioVendedor: Double;
begin
  Result := FValUnitarioVendedor;
end;

procedure TBoletoBancario.Set_CodBoletoBancario(Value: Integer);
begin
  FCodBoletoBancario := Value;
end;

procedure TBoletoBancario.Set_CodIdentificacaoBancaria(Value: Integer);
begin
  FCodIdentificacaoBancaria := Value;
end;

procedure TBoletoBancario.Set_CodOrdemServico(Value: Integer);
begin
  FCodOrdemServico := Value;
end;

procedure TBoletoBancario.Set_CodSituacaoBoleto(const Value: WideString);
begin
  FCodSituacaoBoleto := Value;
end;

procedure TBoletoBancario.Set_CodUsuarioCancelamento(Value: Integer);
begin
  FCodUsuarioCancelamento := Value;
end;

procedure TBoletoBancario.Set_CodUsuarioUltimaAlteracao(Value: Integer);
begin
  FCodUsuarioUltimaAlteracao := Value;
end;

procedure TBoletoBancario.Set_DesSituacaoBoleto(const Value: WideString);
begin
  FDesSituacaoBoleto := Value;
end;

procedure TBoletoBancario.Set_DtaCreditoEfetivado(Value: TDateTime);
begin
  FDtaCreditoEfetivado := Value;
end;

procedure TBoletoBancario.Set_DtaGeracaoRemessa(Value: TDateTime);
begin
  FDtaGeracaoRemessa := Value;
end;

procedure TBoletoBancario.Set_DtaUltimaAlteracao(Value: TDateTime);
begin
  FDtaUltimaAlteracao := Value;
end;

procedure TBoletoBancario.Set_DtaVencimentoBoleto(Value: TDateTime);
begin
  FDtaVencimentoBoleto := Value;
end;

procedure TBoletoBancario.Set_EnderecoCobranca(const Value: Endereco);
begin
  FEnderecoCobranca := Value;
end;

procedure TBoletoBancario.Set_NomBanco(const Value: WideString);
begin
  FNomBanco := Value;
end;

procedure TBoletoBancario.Set_NomPessoaProdutor(const Value: WideString);
begin
  FNomPessoaProdutor := Value;
end;

procedure TBoletoBancario.Set_NomPropriedadeRural(const Value: WideString);
begin
  FNomPropriedadeRural := Value;
end;

procedure TBoletoBancario.Set_NomUsuarioCancelamento(
  const Value: WideString);
begin
  FNomUsuarioCancelamento := Value;
end;

procedure TBoletoBancario.Set_NomUsuarioUltimaAlteracao(
  const Value: WideString);
begin
  FNomUsuarioUltimaAlteracao := Value;
end;

procedure TBoletoBancario.Set_NumCNPJCPF(const Value: WideString);
begin
  FNumCNPJCPF := Value;
end;

procedure TBoletoBancario.Set_NumCNPJCPFFormatado(const Value: WideString);
begin
  FNumCNPJCPFFormatado := Value;
end;

procedure TBoletoBancario.Set_NumImovelReceitaFederal(
  const Value: WideString);
begin
  FNumImovelReceitaFederal := Value;
end;

procedure TBoletoBancario.Set_NumParcela(Value: Integer);
begin
  FNumParcela := Value;
end;

procedure TBoletoBancario.Set_QtdAnimais(Value: Integer);
begin
  FQtdAnimais := Value;
end;

procedure TBoletoBancario.Set_QtdParcelas(Value: Integer);
begin
  FQtdParcelas := Value;
end;

procedure TBoletoBancario.Set_SglSituacaoBoleto(const Value: WideString);
begin
  FSglSituacaoBoleto := Value;
end;

procedure TBoletoBancario.Set_TxtMensagem3(const Value: WideString);
begin
  FTxtMensagem3 := Value;
end;

procedure TBoletoBancario.Set_TxtMensagem4(const Value: WideString);
begin
  FTxtMensagem4 := Value;
end;

procedure TBoletoBancario.Set_ValPagoBoleto(Value: Double);
begin
  FValPagoBoleto := Value;
end;

procedure TBoletoBancario.Set_ValTotalBoleto(Value: Double);
begin
  FValTotalBoleto := Value;
end;

procedure TBoletoBancario.Set_ValTotalOS(Value: Double);
begin
  FValTotalOS := Value;
end;

procedure TBoletoBancario.Set_ValUnitarioCertificadora(Value: Double);
begin
  FValUnitarioCertificadora := Value;
end;

procedure TBoletoBancario.Set_ValUnitarioTecnico(Value: Double);
begin
  FValUnitarioTecnico := Value;
end;

procedure TBoletoBancario.Set_ValUnitarioVendedor(Value: Double);
begin
  FValUnitarioVendedor := Value;
end;

function TBoletoBancario.Get_NomReduzidoBanco: WideString;
begin
  Result := FNomReduzidoBanco;
end;

procedure TBoletoBancario.Set_NomReduzidoBanco(const Value: WideString);
begin
  FNomReduzidoBanco := Value;
end;

function TBoletoBancario.Get_CodArqImportBoleto: Integer;
begin
  Result := FCodArqImportBoleto;
end;

function TBoletoBancario.Get_CodSituacaoArqImport: WideString;
begin
  Result := FCodSituacaoArqImport;
end;

function TBoletoBancario.Get_CodTarefa: Integer;
begin
  Result := FCodTarefa;
end;

function TBoletoBancario.Get_CodTipoArquivoBoleto: Integer;
begin
  Result := FCodTipoArquivoBoleto;
end;

function TBoletoBancario.Get_CodUsuarioUpLoad: Integer;
begin
  Result := FCodUsuarioUpLoad;
end;

function TBoletoBancario.Get_DesSituacaoArqImport: WideString;
begin
  Result := FDesSituacaoArqImport;
end;

function TBoletoBancario.Get_DesTipoArquivoBoleto: WideString;
begin
  Result := FDesTipoArquivoBoleto;
end;

function TBoletoBancario.Get_DtaImportacao: TDateTime;
begin
  Result := FDtaImportacao;
end;

function TBoletoBancario.Get_DtaProcessamento: TDateTime;
begin
  Result := FDtaProcessamento;
end;

function TBoletoBancario.Get_NomArqImportBoleto: WideString;
begin
  Result := FNomArqImportBoleto;
end;

function TBoletoBancario.Get_NomArqUpLoad: WideString;
begin
  Result := FNomArqUpLoad;
end;

function TBoletoBancario.Get_NomUsuarioUpLoad: WideString;
begin
  Result := FNomUsuarioUpLoad;
end;

function TBoletoBancario.Get_QtdRegistrosErrados: Integer;
begin
  Result := FQtdRegistrosErrados;
end;

function TBoletoBancario.Get_QtdRegistrosProcessados: Integer;
begin
  Result := FQtdRegistrosProcessados;
end;

function TBoletoBancario.Get_QtdRegistrosTotal: Integer;
begin
  Result := FQtdRegistrosTotal;
end;

function TBoletoBancario.Get_TxtMensagem: WideString;
begin
  Result := FTxtMensagem;
end;

procedure TBoletoBancario.Set_CodArqImportBoleto(Value: Integer);
begin
  FCodArqImportBoleto := Value;
end;

procedure TBoletoBancario.Set_CodSituacaoArqImport(
  const Value: WideString);
begin
  FCodSituacaoArqImport := Value;
end;

procedure TBoletoBancario.Set_CodTarefa(Value: Integer);
begin
  FCodTarefa := Value;
end;

procedure TBoletoBancario.Set_CodTipoArquivoBoleto(Value: Integer);
begin
  FCodTipoArquivoBoleto := Value;
end;

procedure TBoletoBancario.Set_CodUsuarioUpLoad(Value: Integer);
begin
  FCodUsuarioUpLoad := Value;
end;

procedure TBoletoBancario.Set_DesSituacaoArqImport(
  const Value: WideString);
begin
  FDesSituacaoArqImport := Value;
end;

procedure TBoletoBancario.Set_DesTipoArquivoBoleto(
  const Value: WideString);
begin
  FDesTipoArquivoBoleto := Value;
end;

procedure TBoletoBancario.Set_DtaImportacao(Value: TDateTime);
begin
  FDtaImportacao := Value;
end;

procedure TBoletoBancario.Set_DtaProcessamento(Value: TDateTime);
begin
  FDtaProcessamento := Value;
end;

procedure TBoletoBancario.Set_NomArqImportBoleto(const Value: WideString);
begin
  FNomArqImportBoleto := Value;
end;

procedure TBoletoBancario.Set_NomArqUpLoad(const Value: WideString);
begin
  FNomArqUpLoad := Value;
end;

procedure TBoletoBancario.Set_NomUsuarioUpLoad(const Value: WideString);
begin
  FNomUsuarioUpLoad := Value;
end;

procedure TBoletoBancario.Set_QtdRegistrosErrados(Value: Integer);
begin
  FQtdRegistrosErrados := Value;
end;

procedure TBoletoBancario.Set_QtdRegistrosProcessados(Value: Integer);
begin
  FQtdRegistrosProcessados := Value;
end;

procedure TBoletoBancario.Set_QtdRegistrosTotal(Value: Integer);
begin
  FQtdRegistrosTotal := Value;
end;

procedure TBoletoBancario.Set_TxtMensagem(const Value: WideString);
begin
  FTxtMensagem := Value;
end;

function TBoletoBancario.Get_DesSituacaoTarefa: WideString;
begin
  Result := FDesSituacaoTarefa;
end;

function TBoletoBancario.Get_DtaFimReal: TDateTime;
begin
  Result :=  FDtaFimRealTarefa;
end;

function TBoletoBancario.Get_DtaInicioPrevistoTarefa: TDateTime;
begin
  Result := FDtaInicioPrevistoTarefa;
end;

function TBoletoBancario.Get_DtaInicioRealTarefa: TDateTime;
begin
  Result := FDtaInicioRealTarefa;
end;

function TBoletoBancario.Get_NomUsuarioTarefaProcessamento: WideString;
begin
  Result := FNomUsuarioProcessamentoTarefa;
end;

procedure TBoletoBancario.Set_DesSituacaoTarefa(const Value: WideString);
begin
  FDesSituacaoTarefa := Value;
end;

procedure TBoletoBancario.Set_DtaFimReal(Value: TDateTime);
begin
  FDtaFimRealTarefa := Value;
end;

procedure TBoletoBancario.Set_DtaInicioPrevistoTarefa(Value: TDateTime);
begin
  FDtaInicioPrevistoTarefa := Value;
end;

procedure TBoletoBancario.Set_DtaInicioRealTarefa(Value: TDateTime);
begin
  FDtaInicioRealTarefa := Value;
end;

procedure TBoletoBancario.Set_NomUsuarioTarefaProcessamento(
  const Value: WideString);
begin
  FNomUsuarioProcessamentoTarefa := Value;
end;

function TBoletoBancario.Get_CodFormaPagamentoBoleto: Integer;
begin
  Result := FCodFormaPagamentoBoleto;
end;

function TBoletoBancario.Get_DesFormaPagamentoBoleto: WideString;
begin
  Result := FDesFormaPagamentoBoleto;
end;

function TBoletoBancario.Get_SglFormaPagamentoBoleto: WideString;
begin
  Result := FSglFormaPagamentoBoleto;
end;

procedure TBoletoBancario.Set_CodFormaPagamentoBoleto(Value: Integer);
begin
  FCodFormaPagamentoBoleto := Value;
end;

procedure TBoletoBancario.Set_DesFormaPagamentoBoleto(
  const Value: WideString);
begin
  FSglFormaPagamentoBoleto := Value;
end;

procedure TBoletoBancario.Set_SglFormaPagamentoBoleto(
  const Value: WideString);
begin
  FDesFormaPagamentoBoleto := Value;
end;

function TBoletoBancario.Get_ValVistoria: Double;
begin
  Result := FValVistoria;
end;

procedure TBoletoBancario.Set_ValVistoria(Value: Double);
begin
  FValVistoria := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TBoletoBancario, Class_BoletoBancario,
    ciMultiInstance, tmApartment);
end.
