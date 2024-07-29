// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Adalberto Knychala Neto
// *  Versão             : 1
// *  Data               : 03/08/2004
// *  Documentação       : Atributos de Ordem de Serviço - Definição das Classes.doc
// *  Código Classe      : 103
// *  Descrição Resumida : Armazena os atributos de um arquivo de remessa de pedidos
// *                       de identificadores gerado no sistema.
// ************************************************************************
// *  Últimas Alterações :
// *
// ********************************************************************
unit uIntArquivoRemessaPedido;

{$DEFINE MSSQL}

interface

type
  TIntArquivoRemessaPedido = class
  private
    FCodArquivoFTPEnvio: Integer;
    FCodArquivoRemessaPedido: Integer;
    FCodEmailEnvio: Integer;
    FCodFabricanteIdentificador: Integer;
    FCodSituacaoArquivoFTP: Integer;
    FCodSituacaoEmail: Integer;
    FDesSituacaoEmail: String;
    FDtaCriacaoArquivo: TDateTime;
    FDtaUltimaTransferencia: TDateTime;
    FDtaUltimoEnvio: TDateTime;
    FIndEnvioPedidoEmail: String;
    FIndEnvioPedidoFTP: String;
    FNomArquivoRemessaPedido: String;
    FNomArquivoFichaPedido: String;    
    FNomReduzidoFabricante: String;
    FNumRemessaFabricante: Integer;
    FQtdBytesArquivoRemessa: Integer;
    FQtdBytesArquivoFicha: Integer;    
    FSglSituacaoArquivoFTP: String;
    FSglSituacaoEmail: String;
    FDesSituacaoArquivoFTP: String;
    FNumPedidoFabricanteInicio: Integer;
    FQtdPedidosRemessa: Integer;
    FCodUsuarioCriacao: Integer;
    FNomUsuarioCriacao: String;
    FTxtCaminho: String;
    FCodTipoArquivoRemessa: Integer;
    FDesTipoArquivoRemessa: String;
  public
    property CodArquivoFTPEnvio: Integer read FCodArquivoFTPEnvio write FCodArquivoFTPEnvio;
    property CodArquivoRemessaPedido: Integer read FCodArquivoRemessaPedido write FCodArquivoRemessaPedido;
    property CodEmailEnvio: Integer read FCodEmailEnvio write FCodEmailEnvio;
    property CodFabricanteIdentificador: Integer read FCodFabricanteIdentificador write FCodFabricanteIdentificador;
    property CodSituacaoArquivoFTP: Integer read FCodSituacaoArquivoFTP write FCodSituacaoArquivoFTP;
    property CodSituacaoEmail: Integer read FCodSituacaoEmail write FCodSituacaoEmail;
    property DesSituacaoEmail: String read FDesSituacaoEmail write FDesSituacaoEmail;
    property DtaCriacaoArquivo: TDateTime read FDtaCriacaoArquivo write FDtaCriacaoArquivo;
    property DtaUltimaTransferencia: TDateTime read FDtaUltimaTransferencia write FDtaUltimaTransferencia;
    property DtaUltimoEnvio: TDateTime read FDtaUltimoEnvio write FDtaUltimoEnvio;
    property IndEnvioPedidoEmail: String read FIndEnvioPedidoEmail write FIndEnvioPedidoEmail;
    property IndEnvioPedidoFTP: String read FIndEnvioPedidoFTP write FIndEnvioPedidoFTP;
    property NomArquivoRemessaPedido: String read FNomArquivoRemessaPedido write FNomArquivoRemessaPedido;
    property NomArquivoFichaPedido: String read FNomArquivoFichaPedido write FNomArquivoFichaPedido;
    property NomReduzidoFabricante: String read FNomReduzidoFabricante write FNomReduzidoFabricante;
    property NumRemessaFabricante: Integer read FNumRemessaFabricante write FNumRemessaFabricante;
    property QtdBytesArquivoRemessa: Integer read FQtdBytesArquivoRemessa write FQtdBytesArquivoRemessa;
    property QtdBytesArquivoFicha: Integer read FQtdBytesArquivoFicha write FQtdBytesArquivoFicha;    
    property SglSituacaoArquivoFTP: String read FSglSituacaoArquivoFTP write FSglSituacaoArquivoFTP;
    property SglSituacaoEmail: String read FSglSituacaoEmail write FSglSituacaoEmail;
    property DesSituacaoArquivoFTP: String read FDesSituacaoArquivoFTP write FDesSituacaoArquivoFTP;
    property NumPedidoFabricanteInicio: Integer read FNumPedidoFabricanteInicio write FNumPedidoFabricanteInicio;
    property QtdPedidosRemessa: Integer read FQtdPedidosRemessa write FQtdPedidosRemessa;
    property CodUsuarioCriacao: Integer read FCodUsuarioCriacao write FCodUsuarioCriacao;
    property NomUsuarioCriacao: String read FNomUsuarioCriacao write FNomUsuarioCriacao;
    property TxtCaminho: String read FTxtCaminho write FTxtCaminho;
    property CodTipoArquivoRemessa: Integer read FCodTipoArquivoRemessa write FCodTipoArquivoRemessa;
    property DesTipoArquivoRemessa: String read FDesTipoArquivoRemessa write FDesTipoArquivoRemessa;
  end;

implementation

end.
