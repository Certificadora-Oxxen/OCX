unit uIntOrdemServicoResumida;

interface

type
  TIntOrdemServicoResumida = class(TObject)
  private
    FCodOrdemServico: Integer;
    FNomProdutor: String;
    FNomPropriedadeRural: String;
    FNumCNPJCPFProdutorFormatado: String;
    FNumImovelReceitaFederal: String;
    FNumOrdemServico: Integer;
    FQtdAnimais: Integer;
    FCodPessoaProdutor: Integer;
    FCodPropriedadeRural: Integer;
    FCodSituacaoOS: Integer;
    FDesSituacaoOS: String;
    FSglProdutor: String;
    FSglSituacaoOS: String;
    FCodLocalizacaoSisbov: Integer;

    FDtaEnvioPedido: TDateTime;
    FNomServicoEnvio: String;
    FNroConhecimento: String;    
  public
    property CodOrdemServico: Integer read FCodOrdemServico write FCodOrdemServico;
    property NomProdutor: String read FNomProdutor write FNomProdutor;
    property NomPropriedadeRural: String read FNomPropriedadeRural write FNomPropriedadeRural;
    property NumCNPJCPFProdutorFormatado: String read FNumCNPJCPFProdutorFormatado write FNumCNPJCPFProdutorFormatado;
    property NumImovelReceitaFederal: String read FNumImovelReceitaFederal write FNumImovelReceitaFederal;
    property NumOrdemServico: Integer read FNumOrdemServico write FNumOrdemServico;
    property QtdAnimais: Integer read FQtdAnimais write FQtdAnimais;
    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property CodPropriedadeRural: Integer read FCodPropriedadeRural write FCodPropriedadeRural;
    property CodSituacaoOS: Integer read FCodSituacaoOS write FCodSituacaoOS;
    property DesSituacaoOS: String read FDesSituacaoOS write FDesSituacaoOS;
    property SglProdutor: String read FSglProdutor write FSglProdutor;
    property SglSituacaoOS: String read FSglSituacaoOS write FSglSituacaoOS;
    property CodLocalizacaoSisbov: Integer read FCodLocalizacaoSisbov write FCodLocalizacaoSisbov;

    property DtaEnvioPedido: TDateTime read FDtaEnvioPedido write FDtaEnvioPedido;
    property NomServicoEnvio: String read FNomServicoEnvio write FNomServicoEnvio;
    property NroConhecimento: String read FNroConhecimento write FNroConhecimento;
  end;

implementation

end.
