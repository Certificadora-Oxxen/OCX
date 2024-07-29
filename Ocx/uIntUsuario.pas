unit uIntUsuario;

interface

type
  TIntUsuario = class
  private
    FCodUsuario               : Integer;
    FNomUsuario               : String;
    FNomTratamento            : String;
    FCodPessoa                : Integer;
    FNomPessoa                : String;
    FCodNaturezaPessoa        : String;
    FNumCNPJCPF               : String;
    FCodPapel                 : Integer;
    FDesPapel                 : String;
    FCodPerfil                : Integer;
    FDesPerfil                : String;
    FQtdAcumLoginsCorretos    : Integer;
    FQtdAcumLoginsIncorretos  : Integer;
    FDtaUltimoLoginCorreto    : TDateTime;
    FDtaUltimoLoginIncorreto  : TDateTime;
    FQtdLoginsIncorretos      : Integer;
    FDtaCriacaoUsuario        : TDateTime;
    FNumCNPJCPFFormatado      : String;
    FDtaPenultimoLoginCorreto : TDateTime;
    FDtaFimValidade           : TDateTime;
    FIndUsuarioFTP            : String;
    FNomUsuarioReduzido       : String;
  public
    property CodUsuario               : Integer        read FCodUsuario               write FCodUsuario;
    property NomUsuario               : String         read FNomUsuario               write FNomUsuario;
    property NomTratamento            : String         read FNomTratamento            write FNomTratamento;
    property CodPessoa                : Integer        read FCodPessoa                write FCodPessoa;
    property NomPessoa                : String         read FNomPessoa                write FNomPessoa;
    property CodNaturezaPessoa        : String         read FCodNaturezaPessoa        write FCodNaturezaPessoa;
    property NumCNPJCPF               : String         read FNumCNPJCPF               write FNumCNPJCPF;
    property CodPapel                 : Integer        read FCodPapel                 write FCodPapel;
    property DesPapel                 : String         read FDesPapel                 write FDesPapel;
    property CodPerfil                : Integer        read FCodPerfil                write FCodPerfil;
    property DesPerfil                : String         read FDesPerfil                write FDesPerfil;
    property QtdAcumLoginsCorretos    : Integer        read FQtdAcumLoginsCorretos    write FQtdAcumLoginsCorretos;
    property QtdAcumLoginsIncorretos  : Integer        read FQtdAcumLoginsIncorretos  write FQtdAcumLoginsIncorretos;
    property DtaUltimoLoginCorreto    : TDateTime      read FDtaUltimoLoginCorreto    write FDtaUltimoLoginCorreto;
    property DtaUltimoLoginIncorreto  : TDateTime      read FDtaUltimoLoginIncorreto  write FDtaUltimoLoginIncorreto;
    property QtdLoginsIncorretos      : Integer        read FQtdLoginsIncorretos      write FQtdLoginsIncorretos;
    property DtaCriacaoUsuario        : TDateTime      read FDtaCriacaoUsuario        write FDtaCriacaoUsuario;
    property NumCNPJCPFFormatado      : String         read FNumCNPJCPFFormatado      write FNumCNPJCPFFormatado;
    property DtaPenultimoLoginCorreto : TDateTime      read FDtaPenultimoLoginCorreto write FDtaPenultimoLoginCorreto;
    property DtaFimValidade           : TDateTime      read FDtaFimValidade           write FDtaFimValidade;
    property IndUsuarioFTP            : String         read FIndUsuarioFTP            write FIndUsuarioFTP;
    property NomUsuarioReduzido       : String         read FNomUsuarioReduzido       write FNomUsuarioReduzido;    
  end;

implementation

end.
