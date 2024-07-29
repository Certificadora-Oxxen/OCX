unit uIntMotivoBloqueio;

interface

type
  TIntMotivoBloqueio = class
  private
    FCodMotivoBloqueio: Integer;
    FDesMotivoBloqueio: String;
    FTxtMotivoUsuario: String;
    FTxtObservacaoUsuario: String;
    FTxtProcedimentoUsuario: String;
    FCodAplicacaoBloqueio: String;
    FDesAplicacaoBloqueio: String;
    FIndRestritoSistema: String;
  public
    property CodMotivoBloqueio: Integer read FCodMotivoBloqueio write FCodMotivoBloqueio;
    property DesMotivoBloqueio: String read FDesMotivoBloqueio write FDesMotivoBloqueio;
    property TxtMotivoUsuario: String read FTxtMotivoUsuario write FTxtMotivoUsuario;
    property TxtObservacaoUsuario: String read FTxtObservacaoUsuario write FTxtObservacaoUsuario;
    property TxtProcedimentoUsuario: String read FTxtProcedimentoUsuario write FTxtProcedimentoUsuario;
    property CodAplicacaoBloqueio: String read FCodAplicacaoBloqueio write FCodAplicacaoBloqueio;
    property DesAplicacaoBloqueio: String read FDesAplicacaoBloqueio write FDesAplicacaoBloqueio;
    property IndRestritoSistema: String read FIndRestritoSistema write FIndRestritoSistema;
  end;

implementation

end.
