unit uIntMovimentoEstoqueSemen;

interface

type
  TIntMovimentoEstoqueSemen = class
  private
    FCodAnimal: Integer;
    FCodAnimalFemea: Integer;
    FCodAnimalManejo: String;
    FCodAnimalManejoFemea: String;
    FCodFazenda: Integer;
    FCodFazendaRelacionada: Integer;
    FCodMovimento: Integer;
    FCodPessoaSecundaria: Integer;
    FCodTipoMovEstoqueSemen: Integer;
    FDesTipoMovEstoqueSemen: String;
    FDtaMovimento: TDateTime;
    FNomFazenda: String;
    FNomFazendaRelacionada: String;
    FNomPessoaSecundaria: String;
    FNumCNPJCPFPessoaSecundaria: String;
    FNumPartida: String;
    FQtdDosesSemenApto: Integer;
    FSglFazenda: String;
    FSglFazendaManejo: String;
    FSglFazendaManejoFemea: String;
    FSglFazendaRelacionada: String;
    FSglTipoMovEstoqueSemen: String;
    FCodOperacaoMovEstoqueApto: WideString;
    FCodOperacaoMovEstoqueInapto: WideString;
    FCodUsuario: Integer;
    FDesOperacaoMovEstoqueApto: WideString;
    FDesOperacaoMovEstoqueInapto: WideString;
    FDtaCadastramento: TDateTime;
    FIndMovimentoEstorno: WideString;
    FNomUsuario: String;
    FQtdDosesSemenInapto: Integer;
    FTxtObservacao: String;
    FSeqMovimento: Integer;
    FDesApelido: String;
    FNomAnimal: String;
  public
    property CodAnimal: Integer read FCodAnimal write FCodAnimal;
    property CodAnimalFemea: Integer read FCodAnimalFemea write FCodAnimalFemea;
    property CodAnimalManejo: String read FCodAnimalManejo write FCodAnimalManejo;
    property CodAnimalManejoFemea: String read FCodAnimalManejoFemea write FCodAnimalManejoFemea;
    property CodFazenda: Integer read FCodFazenda write FCodFazenda;
    property CodFazendaRelacionada: Integer read FCodFazendaRelacionada write FCodFazendaRelacionada;
    property CodMovimento: Integer read FCodMovimento write FCodMovimento;
    property CodPessoaSecundaria: Integer read FCodPessoaSecundaria write FCodPessoaSecundaria;
    property CodTipoMovEstoqueSemen: Integer read FCodTipoMovEstoqueSemen write FCodTipoMovEstoqueSemen;
    property DesTipoMovEstoqueSemen: String read FDesTipoMovEstoqueSemen write FDesTipoMovEstoqueSemen;
    property DtaMovimento: TDateTime read FDtaMovimento write FDtaMovimento;
    property NomFazenda: String read FNomFazenda write FNomFazenda;
    property NomFazendaRelacionada: String read FNomFazendaRelacionada write FNomFazendaRelacionada;
    property NomPessoaSecundaria: String read FNomPessoaSecundaria write FNomPessoaSecundaria;
    property NumCNPJCPFPessoaSecundaria: String read FNumCNPJCPFPessoaSecundaria write FNumCNPJCPFPessoaSecundaria;
    property NumPartida: String read FNumPartida write FNumPartida;
    property QtdDosesSemenApto: Integer read FQtdDosesSemenApto write FQtdDosesSemenApto;
    property SglFazenda: String read FSglFazenda write FSglFazenda;
    property SglFazendaManejo: String read FSglFazendaManejo write FSglFazendaManejo;
    property SglFazendaManejoFemea: String read FSglFazendaManejoFemea write FSglFazendaManejoFemea;
    property SglFazendaRelacionada: String read FSglFazendaRelacionada write FSglFazendaRelacionada;
    property SglTipoMovEstoqueSemen: String read FSglTipoMovEstoqueSemen write FSglTipoMovEstoqueSemen;
    property CodOperacaoMovEstoqueApto: WideString read FCodOperacaoMovEstoqueApto write FCodOperacaoMovEstoqueApto;
    property CodOperacaoMovEstoqueInapto: WideString read FCodOperacaoMovEstoqueInapto write FCodOperacaoMovEstoqueInapto;
    property CodUsuario: Integer read FCodUsuario write FCodUsuario;
    property DesOperacaoMovEstoqueApto: WideString read FDesOperacaoMovEstoqueApto write FDesOperacaoMovEstoqueApto;
    property DesOperacaoMovEstoqueInapto: WideString read FDesOperacaoMovEstoqueInapto write FDesOperacaoMovEstoqueInapto;
    property DtaCadastramento: TDateTime read FDtaCadastramento write FDtaCadastramento;
    property IndMovimentoEstorno: WideString read FIndMovimentoEstorno write FIndMovimentoEstorno;
    property NomUsuario: String read FNomUsuario write FNomUsuario;
    property QtdDosesSemenInapto: Integer read FQtdDosesSemenInapto write FQtdDosesSemenInapto;
    property TxtObservacao: String read FTxtObservacao write FTxtObservacao;
    property SeqMovimento: Integer read FSeqMovimento write FSeqMovimento;
    property DesApelido: String read FDesApelido write FDesApelido;
    property NomAnimal: String read FNomAnimal write FNomAnimal;
  end;

implementation

end.
