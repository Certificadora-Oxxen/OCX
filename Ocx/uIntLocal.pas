// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Vers�o             : 1
// *  Data               : 15/08/2002
// *  Documenta��o       : Propriedades Rurais, Fazendas, etc - Defini��o das
// *                       classes.doc
// *  C�digo Classe      : 32
// *  Descri��o Resumida : Cadastro de Locais
// ************************************************************************
// *  �ltimas Altera��es
// *   Jerry    15/08/2002    Cria��o
// *   Hitalo   15/08/2002    Retirar os Campos NumIncra, NumPropriedadeRural
// *                          do metodo buscar e propriedade Buscar
// *
// ***************************************************************************
unit uIntLocal;

interface

type
  TIntLocal = class
  private
    FCodPessoaProdutor: Integer;
    FCodFazenda: Integer;
    FCodLocal: Integer;
    FSglLocal: String;
    FDesLocal: String;
    FSglFazenda: String;
    FNomFazenda: String;
    FCodEstado: Integer;
    FSglEstado: String;
    FDtaCadastramento : TDateTime;
    FIndPrincipal: String;
  public
    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property CodFazenda: Integer read FCodFazenda write FCodFazenda;
    property CodLocal: Integer read FCodLocal write FCodLocal;
    property SglLocal: String read FSglLocal write FSglLocal;
    property DesLocal: String read FDesLocal write FDesLocal;
    property SglFazenda: String read FSglFazenda write FSglFazenda;
    property NomFazenda: String read FNomFazenda write FNomFazenda;
    property CodEstado: Integer read FCodEstado write FCodEstado;
    property SglEstado: String read FSglEstado write FSglEstado;
    property DtaCadastramento: TDateTime read FDtaCadastramento write FDtaCadastramento;
    property IndPrincipal: String read FIndPrincipal write FIndPrincipal;
  end;

implementation

end.
