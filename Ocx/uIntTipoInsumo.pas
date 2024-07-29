// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Carlos Augusto
// *  Versão             : 1
// *  Data               : 10/09/2002
// *  Documentação       :
// *  Descrição Resumida : Cadastro de Tipos de Insumo
// ************************************************************************
// *  Últimas Alterações
// *
// *
// ********************************************************************
unit uIntTipoInsumo;

interface
type
  TIntTipoInsumo = class
 private
    FCodTipoInsumo:Integer;
    FSglTipoInsumo:String;
    FDesTipoInsumo:String;
    FIndSubTipoObrigatorio:String;
    FIndAdmitePartidaLote:String;
    FIndRestritoSistema:String;
    FCodSubEventoSanitario:Integer;
    FSglSubEventoSanitario:String;
    FDesSubEventoSanitario:String;
    FQtdIntervaloMinimoAplicacao:Integer;
    FNumOrdem:Integer;
  Public
    property CodTipoInsumo                      : Integer     read FCodTipoInsumo               write FCodTipoInsumo;
    property SglTipoInsumo                      : String      read FSglTipoInsumo               write FSglTipoInsumo;
    property DesTipoInsumo                      : String      read FDesTipoInsumo               write FDesTipoInsumo;
    property IndSubTipoObrigatorio              : String      read FIndSubTipoObrigatorio       write FIndSubTipoObrigatorio;
    property IndAdmitePartidaLote               : String      read FIndAdmitePartidaLote        write FIndAdmitePartidaLote;
    property IndRestritoSistema                 : String      read FIndRestritoSistema          write FIndRestritoSistema;
    property CodSubEventoSanitario              : Integer     read FCodSubEventoSanitario       write FCodSubEventoSanitario;
    property SglSubEventoSanitario              : String      read FSglSubEventoSanitario       write FSglSubEventoSanitario;
    property DesSubEventoSanitario              : String      read FDesSubEventoSanitario       write FDesSubEventoSanitario;
    property QtdIntervaloMinimoAplicacao        : Integer     read FQtdIntervaloMinimoAplicacao write FQtdIntervaloMinimoAplicacao;
    property NumOrdem                           : Integer     read FNumOrdem                    write FNumOrdem;
  end;
implementation

end.
