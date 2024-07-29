// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Vers�o             : 1
// *  Data               : 06/08/2002
// *  Documenta��o       : Gerenciamento de Rebanho - Especifica��o das
// *                       classes.doc
// *  Descri��o Resumida : Cadastro de Localidades
// ********************************************************************
// *  �ltimas Altera��es
// *   Jerry    06/08/2002    Cria��o
// *   H�talo   06/08/2002    Adicionar m�todo Inserir,Excluir,Alterar.
// *
// *
// ********************************************************************
unit uIntLocalidade;

interface

type
  TIntLocalidade = class
  private
    FCodLocalidade        : Integer;
    FNomLocalidade        : String;
    FCodEstado            : Integer;
    FSglEstado            : String;
    FCodEstadoSisBov      : Integer;
    FNumLatitude          : Integer;
    FNumLongitude         : Integer;
    FCodMunicipio         : Integer;
    FNomMunicipio         : String;
    FDesTipoLocalidade    : String;
    FCodPais              : Integer;
    FNomPais              : String;
    FCodPaisSisBov        : Integer;
    FCodMicroRegiao       : Integer;
    FNomMicroRegiao       : String;
    FCodMicroRegiaoSisBov : Integer;
    FNumMunicipioIBGE     : String;
    FDtaEfetivacaoCadastro : TDateTime;
  public
    property CodLocalidade       : Integer      read FCodLocalidade         write FCodLocalidade;
    property NomLocalidade       : String       read FNomLocalidade         write FNomLocalidade;
    property NumLatitude         : Integer      read FNumLatitude           write FNumLatitude;
    property NumLongitude        : Integer      read FNumLongitude          write FNumLongitude;
    property DesTipoLocalidade   : String       read FDesTipoLocalidade     write FDesTipoLocalidade;
    property CodPais             : Integer      read FCodPais               write FCodPais;
    property NomPais             : String       read FNomPais               write FNomPais;
    property CodPaisSisBov       : Integer      read FCodPaisSisBov         write FCodPaisSisBov;
    property CodEstado           : Integer      read FCodEstado             write FCodEstado;
    property SglEstado           : String       read FSglEstado             write FSglEstado;
    property CodEstadoSisBov     : Integer      read FCodEstadoSisBov       write FCodEstadoSisBov;
    property CodMicroRegiao      : Integer      read FCodMicroRegiao        write FCodMicroRegiao;
    property NomMicroRegiao      : String       read FNomMicroRegiao        write FNomMicroRegiao;
    property CodMicroRegiaoSisBov: Integer      read FCodMicroRegiaoSisBov  write FCodMicroRegiaoSisBov;
    property CodMunicipio        : Integer      read FCodMunicipio          write FCodMunicipio;
    property NomMunicipio        : String       read FNomMunicipio          write FNomMunicipio;
    property NumMunicipioIBGE    : String       read FNumMunicipioIBGE      write FNumMunicipioIBGE;
    property DtaEfetivacaoCadastro : TDateTime  read FDtaEfetivacaoCadastro write FDtaEfetivacaoCadastro;
  end;

implementation

end.
