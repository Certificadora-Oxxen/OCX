// *****************************************************************************
// *  Projeto            : HERDOM
// *  Desenvolvedor      : Rafael Mundim Silva
// *  Vers�o             : 1
// *  Data               : 02/08/2004
// *  Documenta��o       : Ocorr�ncias Sistema - Defini��o das Classes.doc
// *  Descri��o Resumida : Armazena atributos referentes � ocorr�ncia no sistema
// *                       de uma mensagem de advert�ncia ou erro.
// *****************************************************************************
// *  �ltimas Altera��es
// *
// *****************************************************************************

unit uIntOcorrenciaSistema;

interface

type
  TIntOcorrenciaSistema = class
  private
    FCodOcorrenciaSistema    : Integer;
    FDtaOcorrenciaSistema    : TDateTime;
    FIndOcorrenciaTratada    : String;
    FCodAplicativo           : Integer;
    FNomAplicativo           : String;
    FCodTipoMensagem         : Integer;
    FDesTipoMensagem         : String;
    FTxtMensagem             : String;
    FTxtIdentificacao        : String;
    FTxtLegendaIdentificacao : String;
  public
    property CodOcorrenciaSistema    : Integer   read FCodOcorrenciaSistema    write FCodOcorrenciaSistema;
    property DtaOcorrenciaSistema    : TDateTime read FDtaOcorrenciaSistema    write FDtaOcorrenciaSistema;
    property IndOcorrenciaTratada    : String    read FIndOcorrenciaTratada    write FIndOcorrenciaTratada;
    property CodAplicativo           : Integer   read FCodAplicativo           write FCodAplicativo;
    property NomAplicativo           : String    read FNomAplicativo           write FNomAplicativo;
    property CodTipoMensagem         : Integer   read FCodTipoMensagem         write FCodTipoMensagem;
    property DesTipoMensagem         : String    read FDesTipoMensagem         write FDesTipoMensagem;
    property TxtMensagem             : String    read FTxtMensagem             write FTxtMensagem;
    property TxtIdentificacao        : String    read FTxtIdentificacao        write FTxtIdentificacao;
    property TxtLegendaIdentificacao : String    read FTxtLegendaIdentificacao write FTxtLegendaIdentificacao;
  end;

implementation

end.
