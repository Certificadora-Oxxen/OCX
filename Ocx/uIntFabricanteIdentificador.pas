// ********************************************************************
// *  Projeto            : HERDOM
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Adalberto Knychala Neto
// *  Versão             : 1
// *  Data               : 03/08/2004
// *  Documentação       : Atributos de Ordem de Serviço - Definição das Classes.doc
// *  Código Classe      : 99
// *  Descrição Resumida : Fornece todas as operações a serem realizadas com a entidade que representa
// *                       um fabricante de identificadores.
// ************************************************************************
// *  Últimas Alterações :
// *
// ********************************************************************
unit uIntFabricanteIdentificador;

interface

type
  TIntFabricanteIdentificador = class
  private
    FCodFabricanteIdentificador: Integer;
    FCodRotinaFTPEnvio: Integer;
    FCodRotinaFTPRetorno: Integer;
    FDesRotinaFTPEnvio: String;
    FDesRotinaFTPRetorno: String;
    FIndEnvioPedidoEmail: String;
    FIndEnvioPedidoFTP: String;
    FIndRetornoSituacaoFTP: String;
    FNomFabricanteIdentificador: String;
    FNomReduzidoFabricante: String;
    FNumCNPJFabricante: String;
    FNumCNPJFabricanteFormatado: String;
    FNumMaximoPedido: Integer;
    FNumOrdem: Integer;
    FNumUltimaRemessa: Integer;
    FNumUltimoPedido: Integer;
    FTxtEmailFabricante: String;
  public
    property CodFabricanteIdentificador: Integer read FCodFabricanteIdentificador write FCodFabricanteIdentificador;
    property CodRotinaFTPEnvio: Integer read FCodRotinaFTPEnvio write FCodRotinaFTPEnvio;
    property CodRotinaFTPRetorno: Integer read FCodRotinaFTPRetorno write FCodRotinaFTPRetorno;
    property DesRotinaFTPEnvio: String read FDesRotinaFTPEnvio write FDesRotinaFTPEnvio;
    property DesRotinaFTPRetorno: String read FDesRotinaFTPRetorno write FDesRotinaFTPRetorno;
    property IndEnvioPedidoEmail: String read FIndEnvioPedidoEmail write FIndEnvioPedidoEmail;
    property IndEnvioPedidoFTP: String  read FIndEnvioPedidoFTP write FIndEnvioPedidoFTP;
    property IndRetornoSituacaoFTP: String read FIndRetornoSituacaoFTP write FIndRetornoSituacaoFTP;
    property NomFabricanteIdentificador: String read FNomFabricanteIdentificador write FNomFabricanteIdentificador;
    property NomReduzidoFabricante: String read FNomReduzidoFabricante  write FNomReduzidoFabricante;
    property NumCNPJFabricante: String  read FNumCNPJFabricante write FNumCNPJFabricante;
    property NumCNPJFabricanteFormatado: String read FNumCNPJFabricanteFormatado write FNumCNPJFabricanteFormatado;
    property NumMaximoPedido: Integer read FNumMaximoPedido write FNumMaximoPedido;
    property NumOrdem: Integer read FNumOrdem write FNumOrdem;
    property NumUltimaRemessa: Integer read FNumUltimaRemessa write FNumUltimaRemessa;
    property NumUltimoPedido: Integer read FNumUltimoPedido  write FNumUltimoPedido;
    property TxtEmailFabricante: String  read FTxtEmailFabricante write FTxtEmailFabricante;
  end;

implementation



end.
