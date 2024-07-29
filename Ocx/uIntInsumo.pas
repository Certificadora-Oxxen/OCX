// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 16/09/2002
// *  Documentação       :
// *  Código Classe      :  63
// *  Descrição Resumida : Cadastro de Insumo
// ************************************************************************
// *  Últimas Alterações
// *   Hitalo    16/10/2002    Criação
// *
// ********************************************************************
unit uIntInsumo;

interface
type
  TIntInsumo = class
  Private
    FCodInsumo                   : Integer;
    FDesInsumo                   : WideString;
    FCodTipoInsumo               : Integer;
    FSglTipoInsumo               : WideString;
    FDesTipoInsumo               : WideString;
    FCodSubTipoInsumo            : Integer;
    FSglSubTipoInsumo            : WideString;
    FDesSubTipoInsumo            : WideString;
    FCodFabricanteInsumo         : Integer;
    FNomFabricanteInsumo         : WideString;
    FNomReduzidoFabricanteInsumo : WideString;
    FTxtObservacao               : WideString;
  public
    property  CodInsumo                   : Integer      Read FCodInsumo  write FCodInsumo;
    property  DesInsumo                   : WideString   Read FDesInsumo  write FDesInsumo;
    property  CodTipoInsumo               : Integer      Read FCodTipoInsumo  write FCodTipoInsumo;
    property  SglTipoInsumo               : WideString   Read FSglTipoInsumo  write FSglTipoInsumo;
    property  DesTipoInsumo               : WideString   Read FDesTipoInsumo  write FDesTipoInsumo;
    property  CodSubTipoInsumo            : Integer      Read FCodSubTipoInsumo  write FCodSubTipoInsumo;
    property  SglSubTipoInsumo            : WideString   Read FSglSubTipoInsumo  write FSglSubTipoInsumo;
    property  DesSubTipoInsumo            : WideString   Read FDesSubTipoInsumo  write FDesSubTipoInsumo;
    property  CodFabricanteInsumo         : Integer      Read FCodFabricanteInsumo  write FCodFabricanteInsumo;
    property  NomFabricanteInsumo         : WideString   Read FNomFabricanteInsumo  write FNomFabricanteInsumo;
    property  NomReduzidoFabricanteInsumo : WideString   Read FNomReduzidoFabricanteInsumo  write FNomReduzidoFabricanteInsumo;
    property  TxtObservacao               : WideString   Read FTxtObservacao  write FTxtObservacao;
  end;
implementation

end.
