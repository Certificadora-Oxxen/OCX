// *****************************************************************************
// *  Projeto            : HERDOM
// *  Desenvolvedor      : Rafael Mundim Silva
// *  Versão             : 1
// *  Data               : 04/08/2004
// *  Documentação       : Arquivos FTP de Retorno - Definição das Classes.doc
// *  Descrição Resumida : Armazenar atributos de um arquivo recebido via FTP
// *                       pelo sistema
// *****************************************************************************
// *  Últimas Alterações
// *
// *****************************************************************************

unit uIntArquivoFTPRetorno;

interface

type
  TIntArquivoFTPRetorno = class
  private
    FCodArquivoFTPRetorno    : Integer;
    FCodRotinaFTPRetorno     : Integer;
    FDesRotinaFTPRetorno     : String;
    FNomArquivoLocal         : String;
    FNomArquivoRemoto        : String;
    FDtaCriacaoArquivo       : TDateTime;
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
    property CodArquivoFTPRetorno    : Integer   read FCodArquivoFTPRetorno     write FCodArquivoFTPRetorno;
    property CodRotinaFTPRetorno     : Integer   read FCodRotinaFTPRetorno      write FCodRotinaFTPRetorno;
    property DesRotinaFTPRetorno     : String    read FDesRotinaFTPRetorno      write FDesRotinaFTPRetorno;
    property NomArquivoLocal         : String    read FNomArquivoLocal          write FNomArquivoLocal;
    property NomArquivoRemoto        : String    read FNomArquivoRemoto         write FNomArquivoRemoto;
    property DtaCriacaoArquivo       : TDateTime read FDtaCriacaoArquivo        write FDtaCriacaoArquivo;
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
