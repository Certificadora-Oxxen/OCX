unit uIntBloqueio;

interface

type
  TIntBloqueio = class
  private
    FDtaInicioBloqueio: TDateTime;
    FDtaFimBloqueio: TDateTime;
    FCodMotivoBloqueio: Integer;
    FCodAplicacaoBloqueio: String;
    FTxtMotivoBloqueio: String;
    FTxtObservacaoBloqueio: String;
    FTxtObservacaoUsuario: String;
    FTxtProcedimentoUsuario: String;
    FCodUsuario: Integer;
    FCodPessoaProdutor: Integer;
    FTxtMotivoUsuario: String;
    FCodUsuarioResponsavel: Integer;
    FNomUsuarioResponsavel: String;
    FNomUsuario: String;
    FNomPessoa: String;
  public
    property DtaInicioBloqueio: TDateTime   read FDtaInicioBloqueio      write FDtaInicioBloqueio;
    property DtaFimBloqueio: TDateTime   read FDtaFimBloqueio      write FDtaFimBloqueio;
    property CodMotivoBloqueio: Integer     read FCodMotivoBloqueio      write FCodMotivoBloqueio;
    property CodAplicacaoBloqueio: String   read FCodAplicacaoBloqueio   write FCodAplicacaoBloqueio;
    property TxtMotivoBloqueio: String      read FTxtMotivoBloqueio      write FTxtMotivoBloqueio;
    property TxtObservacaoBloqueio: String  read FTxtObservacaoBloqueio  write FTxtObservacaoBloqueio;
    property TxtObservacaoUsuario: String   read FTxtObservacaoUsuario   write FTxtObservacaoUsuario;
    property TxtProcedimentoUsuario: String read FTxtProcedimentoUsuario write FTxtProcedimentoUsuario;
    property CodUsuario: Integer read FCodUsuario write FCodUsuario;
    property CodPessoaProdutor: Integer read FCodPessoaProdutor write FCodPessoaProdutor;
    property TxtMotivoUsuario: String read FTxtMotivoUsuario write FTxtMotivoUsuario;
    property CodUsuarioResponsavel: Integer read FCodUsuarioResponsavel write FCodUsuarioResponsavel;
    property NomUsuarioResponsavel: String read FNomUsuarioResponsavel write FNomUsuarioResponsavel;
    property NomUsuario: String read FNomUsuario write FNomUsuario;
    property NomPessoa: String read FNomPessoa write FNomPessoa;
  end;

implementation

end.
