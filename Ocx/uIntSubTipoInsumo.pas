// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Carlos Augusto
// *  Versão             : 1
// *  Data               : 10/09/2002
// *  Documentação       :
// *  Descrição Resumida : Cadastro de SubTipos de Insumo
// ************************************************************************
// *  Últimas Alterações
// *
// *
// ********************************************************************
unit uIntSubTipoInsumo;

interface
type
  TIntSubTipoInsumo = class
 private
    FCodSubTipoInsumo:Integer;
    FSglSubTipoInsumo:String;
    FDesSubTipoInsumo:String;
    FCodTipoInsumo:Integer;
    FSglTipoInsumo:String;
    FDesTipoInsumo:String;
    FIndSexoAnimalAplicacao:String;
    FQtdIntervaloMinimoAplicacao:Integer;
    FNumOrdem:Integer;
  Public
    property CodSubTipoInsumo                   : Integer     read FCodSubTipoInsumo            write FCodSubTipoInsumo;
    property SglSubTipoInsumo                   : String      read FSglSubTipoInsumo            write FSglSubTipoInsumo;
    property DesSubTipoInsumo                   : String      read FDesSubTipoInsumo            write FDesSubTipoInsumo;
    property CodTipoInsumo                      : Integer     read FCodTipoInsumo               write FCodTipoInsumo;
    property SglTipoInsumo                      : String      read FSglTipoInsumo               write FSglTipoInsumo;
    property DesTipoInsumo                      : String      read FDesTipoInsumo               write FDesTipoInsumo;
    property QtdIntervaloMinimoAplicacao        : Integer     read FQtdIntervaloMinimoAplicacao write FQtdIntervaloMinimoAplicacao;
    property IndSexoAnimalAplicacao             : String      read FIndSexoAnimalAplicacao      write FIndSexoAnimalAplicacao;
    property NumOrdem                           : Integer     read FNumOrdem                    write FNumOrdem;
  end;
implementation

end.
