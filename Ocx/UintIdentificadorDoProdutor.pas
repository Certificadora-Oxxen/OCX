unit UIntIdentificadorDoProdutor;

interface

type
  TIntIdentificadorDoProdutor = class
  private
    FCodTipoIdentificador        : Integer;
    FSglTipoIdentificador        : String;
    FDesTipoIdentificador        : String;
    FCodPosicaoIdentificador     : Integer;
    FSglPosicaoIdentificador     : String;
    FDesPosicaoIdentificador     : String;
    FCodGrupoIdentificador       : String;
  public
    property  CodTipoIdentificador      : Integer        Read FCodTipoIdentificador        write FCodTipoIdentificador;
    property  SglTipoIdentificador      : String         Read FSglTipoIdentificador        write FSglTipoIdentificador;
    property  DesTipoIdentificador      : String         Read FDesTipoIdentificador        write FDesTipoIdentificador;
    property  CodPosicaoIdentificador   : Integer        Read FCodPosicaoIdentificador     write FCodPosicaoIdentificador;
    property  SglPosicaoIdentificador   : String         Read FSglPosicaoIdentificador     write FSglPosicaoIdentificador;
    property  DesPosicaoIdentificador   : String         Read FDesPosicaoIdentificador     write FDesPosicaoIdentificador;
    property  CodGrupoIdentificador     : String         Read FCodGrupoIdentificador       write FCodGrupoIdentificador;
  end;

implementation



end.
