// *****************************************************************************
// *  Projeto            : HERDOM
// *  Desenvolvedor      : Rafael Mundim Silva
// *  Versão             : 1
// *  Data               : 13/08/2004
// *  Documentação       :
// *  Descrição Resumida :
// *****************************************************************************
// *  Últimas Alterações
// *
// *****************************************************************************

unit uIntEmailEnvio;

interface

type
  TIntEmailEnvio = class
  private
    FCodEmailEnvio      : Integer;
    FCodTipoEmail       : Integer;
    FDesTipoEmail       : String;
    FTxtAssunto         : String;
    FTxtCorpoEmail      : String;
    FCodTipoMensagem    : Integer;
    FDesTipoMensagem    : String;
    FTxtMensagem        : String;
    FCodSituacaoEmail   : Integer;
    FSglSituacaoEmail   : String;
    FDesSituacaoEmail   : String;
    FDtaUltimoEnvio     : TDateTime;
    FQtdDuracaoEnvio    : Integer;
    FQtdVezesEnvio      : Integer;
  public
    property CodEmailEnvio    : Integer   read FCodEmailEnvio    write FCodEmailEnvio;
    property CodTipoEmail     : Integer   read FCodTipoEmail     write FCodTipoEmail;
    property DesTipoEmail     : String    read FDesTipoEmail     write FDesTipoEmail;
    property TxtAssunto       : String    read FTxtAssunto       write FTxtAssunto;
    property TxtCorpoEmail    : String    read FTxtCorpoEmail    write FTxtCorpoEmail;
    property CodTipoMensagem  : Integer   read FCodTipoMensagem  write FCodTipoMensagem;
    property DesTipoMensagem  : String    read FDesTipoMensagem  write FDesTipoMensagem;
    property TxtMensagem      : String    read FTxtMensagem      write FTxtMensagem;
    property CodSituacaoEmail : Integer   read FCodSituacaoEmail write FCodSituacaoEmail;
    property SglSituacaoEmail : String    read FSglSituacaoEmail write FSglSituacaoEmail;
    property DesSituacaoEmail : String    read FDesSituacaoEmail write FDesSituacaoEmail;
    property DtaUltimoEnvio   : TDateTime read FDtaUltimoEnvio   write FDtaUltimoEnvio;
    property QtdDuracaoEnvio  : Integer   read FQtdDuracaoEnvio  write FQtdDuracaoEnvio;
    property QtdVezesEnvio    : Integer   read FQtdVezesEnvio    write FQtdVezesEnvio;
  end;

implementation

end.
