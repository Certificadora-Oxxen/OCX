// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Vers�o             : 1
// *  Data               : 11/09/2002
// *  Documenta��o       :
// *  C�digo Classe      :  60
// *  Descri��o Resumida : Cadastro de Fabricante Insumo
// ************************************************************************
// *  �ltimas Altera��es
// *   Hitalo    09/10/2002    Cria��o
// *
// ********************************************************************
unit uIntFabricanteInsumo;

interface

type
  TIntFabricanteInsumo = class
  Private
    FCodFabricanteInsumo         : Integer;
    FNomFabricanteInsumo         : WideString;
    FNomReduzidoFabricanteInsumo : WideString;
    FNumRegistroFabricante       : Integer;
  public
    property  CodFabricanteInsumo          : Integer      Read FCodFabricanteInsumo  write FCodFabricanteInsumo;
    property  NomFabricanteInsumo          : WideString   Read FNomFabricanteInsumo  write FNomFabricanteInsumo;
    property  NomReduzidoFabricanteInsumo  : WideString   Read FNomReduzidoFabricanteInsumo  write FNomReduzidoFabricanteInsumo;
    property  NumRegistroFabricante        : Integer      Read FNumRegistroFabricante  write FNumRegistroFabricante;
  end;

implementation

end.
