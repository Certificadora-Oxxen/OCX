unit uIntBoletoBancario;

interface

uses uIntEndereco;

type

TIntBoletoBancario = Class
  private
    FCodOrdemServico:           Integer;
    FCodBoletoBancario:         Integer;
    FCodIdentificacaoBancaria:  Integer;
    FNomBanco:                  String;
    FCodSituacaoBoleto:         String;
    FSglSituacaoBoleto:         String;
    FDesSituacaoBoleto:         String;
    FNomPessoaProdutor:         String;
    FNumCNPJCPF:                String;
    FNumCNPJCPFFormatado:       String;
    FNomPropriedadeRural:       String;
    FNumImovelReceitaFederal:   String;
    FDtaGeracaoRemessa:         TDateTime;
    FEnderecoCobranca:          TIntEndereco;
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
    FNomUsuarioUltimaAlteracao: String;
    FCodUsuarioCancelamento:    Integer;
    FNomUsuarioCancelamento:    String;
    FDtaUltimaAlteracao:        TDateTime;
    FTxtMensagem3:              String;
    FTxtMensagem4:              String;
    FNomReduzidoBanco:          String;
    FCodArqImportBoleto:        Integer;
    FCodSituacaoArqImport:      String;
    FCodTarefa:                 Integer;
    FCodTipoArquivoBoleto:      Integer;
    FCodUsuarioUpLoad:          Integer;
    FDesSituacaoArqImport:      String;
    FDesTipoArquivoBoleto:      String;
    FDtaImportacao:             TDateTime;
    FDtaProcessamento:          TDateTime;
    FNomArqImportBoleto:        String;
    FNomArqUpLoad:              String;
    FNomUsuarioUpLoad:          String;
    FQtdRegistrosErrados:       Integer;
    FQtdRegistrosProcessados:   Integer;
    FQtdRegistrosTotal:         Integer;
    FTxtMensagem:               String;

    FDesSituacaoTarefa:             String;
    FDtaInicioPrevistoTarefa:       TDateTime;
    FDtaInicioRealTarefa:           TDateTime;
    FDtaFimRealTarefa:              TDateTime;
    FNomUsuarioProcessamentoTarefa: String;

    FCodFormaPagamentoBoleto: Integer;
    FSglFormaPagamentoBoleto: String;
    FDesFormaPagamentoBoleto: String;

  public
    property CodOrdemServico:           Integer      read FCodOrdemServico           write FCodOrdemServico;
    property CodBoletoBancario:         Integer      read FCodBoletoBancario         write FCodBoletoBancario;
    property CodIdentificacaoBancaria:  Integer      read FCodIdentificacaoBancaria  write FCodIdentificacaoBancaria;
    property NomBanco:                  String       read FNomBanco                  write FNomBanco;
    property CodSituacaoBoleto:         String       read FCodSituacaoBoleto         write FCodSituacaoBoleto;
    property SglSituacaoBoleto:         String       read FSglSituacaoBoleto         write FSglSituacaoBoleto;
    property DesSituacaoBoleto:         String       read FDesSituacaoBoleto         write FDesSituacaoBoleto;
    property NomPessoaProdutor:         String       read FNomPessoaProdutor         write FNomPessoaProdutor;
    property NumCNPJCPF:                String       read FNumCNPJCPF                write FNumCNPJCPF;
    property NumCNPJCPFFormatado:       String       read FNumCNPJCPFFormatado       write FNumCNPJCPFFormatado;
    property NomPropriedadeRural:       String       read FNomPropriedadeRural       write FNomPropriedadeRural;
    property NumImovelReceitaFederal:   String       read FNumImovelReceitaFederal   write FNumImovelReceitaFederal;
    property DtaGeracaoRemessa:         TDateTime    read FDtaGeracaoRemessa         write FDtaGeracaoRemessa;
    property EnderecoCobranca:          TIntEndereco read FEnderecoCobranca          write FEnderecoCobranca;
    property DtaVencimentoBoleto:       TDateTime    read FDtaVencimentoBoleto       write FDtaVencimentoBoleto;
    property NumParcela:                Integer      read FNumParcela                write FNumParcela;
    property ValTotalBoleto:            Double       read FValTotalBoleto            write FValTotalBoleto;
    property QtdAnimais:                Integer      read FQtdAnimais                write FQtdAnimais;
    property ValUnitarioVendedor:       Double       read FValUnitarioVendedor       write FValUnitarioVendedor;
    property ValUnitarioTecnico:        Double       read FValUnitarioTecnico        write FValUnitarioTecnico;
    property ValUnitarioCertificadora:  Double       read FValUnitarioCertificadora  write FValUnitarioCertificadora;
    property ValVistoria:               Double       read FValVistoria               write FValVistoria;
    property ValTotalOS:                Double       read FValTotalOS                write FValTotalOS;
    property QtdParcelas:               Integer      read FQtdParcelas               write FQtdParcelas;
    property ValPagoBoleto:             Double       read FValPagoBoleto             write FValPagoBoleto;
    property DtaCreditoEfetivado:       TDateTime    read FDtaCreditoEfetivado       write FDtaCreditoEfetivado;
    property CodUsuarioUltimaAlteracao: Integer      read FCodUsuarioUltimaAlteracao write FCodUsuarioUltimaAlteracao;
    property NomUsuarioUltimaAlteracao: String       read FNomUsuarioUltimaAlteracao write FNomUsuarioUltimaAlteracao;
    property CodUsuarioCancelamento:    Integer      read FCodUsuarioCancelamento    write FCodUsuarioCancelamento;
    property NomUsuarioCancelamento:    String       read FNomUsuarioCancelamento    write FNomUsuarioCancelamento;
    property DtaUltimaAlteracao:        TDateTime    read FDtaUltimaAlteracao        write FDtaUltimaAlteracao;
    property TxtMensagem3:              String       read FTxtMensagem3              write FTxtMensagem3;
    property TxtMensagem4:              String       read FTxtMensagem4              write FTxtMensagem4;
    property NomReduzidoBanco:          String       read FNomReduzidoBanco          write FNomReduzidoBanco;

    property CodArqImportBoleto:        Integer     read FCodArqImportBoleto         write FCodArqImportBoleto;
    property CodSituacaoArqImport:      String      read FCodSituacaoArqImport       write FCodSituacaoArqImport;
    property CodTarefa:                 Integer     read FCodTarefa                  write FCodTarefa;
    property CodTipoArquivoBoleto:      Integer     read FCodTipoArquivoBoleto       write FCodTipoArquivoBoleto;
    property CodUsuarioUpLoad:          Integer     read FCodUsuarioUpLoad           write FCodUsuarioUpLoad;
    property DesSituacaoArqImport:      String      read FDesSituacaoArqImport       write FDesSituacaoArqImport;
    property DesTipoArquivoBoleto:      String      read FDesTipoArquivoBoleto       write FDesTipoArquivoBoleto;
    property DtaImportacao:             TDateTime   read FDtaImportacao              write FDtaImportacao;
    property DtaProcessamento:          TDateTime   read FDtaProcessamento           write FDtaProcessamento;
    property NomArqImportBoleto:        String      read FNomArqImportBoleto         write FNomArqImportBoleto;
    property NomArqUpLoad:              String      read FNomArqUpLoad               write FNomArqUpLoad;
    property NomUsuarioUpLoad:          String      read FNomUsuarioUpLoad           write FNomUsuarioUpLoad;
    property QtdRegistrosErrados:       Integer     read FQtdRegistrosErrados        write FQtdRegistrosErrados;
    property QtdRegistrosProcessados:   Integer     read FQtdRegistrosProcessados    write FQtdRegistrosProcessados;
    property QtdRegistrosTotal:         Integer     read FQtdRegistrosTotal          write FQtdRegistrosTotal;
    property TxtMensagem:               String      read FTxtMensagem                write FTxtMensagem;

    property DesSituacaoTarefa:             String read FDesSituacaoTarefa             write FDesSituacaoTarefa;
    property DtaInicioPrevistoTarefa:       TDateTime  read FDtaInicioPrevistoTarefa   write FDtaInicioPrevistoTarefa;
    property DtaInicioRealTarefa:           TDateTime  read FDtaInicioRealTarefa       write FDtaInicioRealTarefa;
    property DtaFimRealTarefa:              TDateTime  read FDtaFimRealTarefa          write FDtaFimRealTarefa;
    property NomUsuarioProcessamentoTarefa: String read FNomUsuarioProcessamentoTarefa write FNomUsuarioProcessamentoTarefa;

    property CodFormaPagamentoBoleto: Integer    read FCodFormaPagamentoBoleto write FCodFormaPagamentoBoleto;
    property SglFormaPagamentoBoleto: String read FSglFormaPagamentoBoleto     write FSglFormaPagamentoBoleto;
    property DesFormaPagamentoBoleto: String read FDesFormaPagamentoBoleto     write FDesFormaPagamentoBoleto;
end;

implementation

end.
