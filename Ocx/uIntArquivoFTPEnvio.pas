// *****************************************************************************
// *  Projeto            : HERDOM
// *  Desenvolvedor      : Rafael Mundim Silva
// *  Versão             : 1
// *  Data               : 28/07/2004
// *  Documentação       : Envio Arquivos FTP - Definição das Classes.doc
// *                       classes.doc
// *  Descrição Resumida : Armazenar atributos de um arquivo a ser (ou já)
// *                       enviado via FTP
// *****************************************************************************
// *  Últimas Alterações
// *
// *****************************************************************************

unit uIntArquivoFTPEnvio;

interface

type
  TIntArquivoFTPEnvio = class
  private
    FCodArquivoFTPEnvio      : Integer;
    FCodRotinaFTPEnvio       : Integer;
    FDesRotinaFTPEnvio       : String;
    FNomArquivoLocal         : String;
    FNomArquivoRemoto        : String;
    FTxtCaminhoLocal         : String;
    FQtdBytesArquivo         : Integer;
    FCodTipoMensagem         : Integer;
    FDesTipoMensagem         : String;
    FTxtMensagem             : String;
    FCodSituacaoArquivoFTP   : Integer;
    FSglSituacaoArquivoFTP   : String;
    FDesSituacaoArquivoFTP   : String;
    FDtaUltimaTransferencia  : TDateTime;
    FQtdDuracaoTransferencia : Integer;
    FQtdVezesTransferencia   : Integer;
  public
    property CodArquivoFTPEnvio      : Integer   read FCodArquivoFTPEnvio       write FCodArquivoFTPEnvio;
    property CodRotinaFTPEnvio       : Integer   read FCodRotinaFTPEnvio        write FCodRotinaFTPEnvio;
    property DesRotinaFTPEnvio       : String    read FDesRotinaFTPEnvio        write FDesRotinaFTPEnvio;
    property NomArquivoLocal         : String    read FNomArquivoLocal          write FNomArquivoLocal;
    property NomArquivoRemoto        : String    read FNomArquivoRemoto         write FNomArquivoRemoto;
    property TxtCaminhoLocal         : String    read FTxtCaminhoLocal          write FTxtCaminhoLocal;
    property QtdBytesArquivo         : Integer   read FQtdBytesArquivo          write FQtdBytesArquivo;
    property CodTipoMensagem         : Integer   read FCodTipoMensagem          write FCodTipoMensagem;
    property DesTipoMensagem         : String    read FDesTipoMensagem          write FDesTipoMensagem;
    property TxtMensagem             : String    read FTxtMensagem              write FTxtMensagem;
    property CodSituacaoArquivoFTP   : Integer   read FCodSituacaoArquivoFTP    write FCodSituacaoArquivoFTP;
    property SglSituacaoArquivoFTP   : String    read FSglSituacaoArquivoFTP    write FSglSituacaoArquivoFTP;
    property DesSituacaoArquivoFTP   : String    read FDesSituacaoArquivoFTP    write FDesSituacaoArquivoFTP;
    property DtaUltimaTransferencia  : TDateTime read FDtaUltimaTransferencia   write FDtaUltimaTransferencia;
    property QtdDuracaoTransferencia : Integer   read FQtdDuracaoTransferencia  write FQtdDuracaoTransferencia;
    property QtdVezesTransferencia   : Integer   read FQtdVezesTransferencia    write FQtdVezesTransferencia;
  end;

implementation

end.
