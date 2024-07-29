unit uIntComunicado;

interface

uses uIntPessoa;

type
  TIntComunicado = class
  private
    FCodComunicado: Integer;
    FTxtAssunto: String;
    FTxtComunicado: String;
    FDtaInicioValidade: TDateTime;
    FDtaFimValidade: TDateTime;
    FDtaEnvioComunicado: TDateTime;
    FCodUsuarioEnvio: Integer;
    FNomUsuarioEnvio: String;
    FPessoaEnvio: TIntPessoa;
    FCodPapelEnvio: Integer;
    FDesPapelEnvio: String;
    FCodOpcaoEnvio: Integer;
    FDesOpcaoEnvio: String;
    FCodUsuarioOpcaoEnvio: Integer;
    FNomUsuarioOpcaoEnvio: String;
    FPessoaOpcaoEnvio: TIntPessoa;
    FCodPapelOpcaoEnvio: Integer;
    FDesPapelOpcaoEnvio: String;
    FDesSituacao: String;
    FDtaLeitura: TDateTime;
  public
    constructor Create;
    destructor Destroy; override;

    property CodComunicado: Integer read FCodComunicado write FCodComunicado;
    property TxtAssunto: String read FTxtAssunto write FTxtAssunto;
    property TxtComunicado: String read FTxtComunicado write FTxtComunicado;
    property DtaInicioValidade: TDateTime read FDtaInicioValidade write FDtaInicioValidade;
    property DtaFimValidade: TDateTime read FDtaFimValidade write FDtaFimValidade;
    property DtaEnvioComunicado: TDateTime read FDtaEnvioComunicado write FDtaEnvioComunicado;
    property CodUsuarioEnvio: Integer read FCodUsuarioEnvio write FCodUsuarioEnvio;
    property NomUsuarioEnvio: String read FNomUsuarioEnvio write FNomUsuarioEnvio;
    property PessoaEnvio: TIntPessoa read FPessoaEnvio write FPessoaEnvio;
    property CodPapelEnvio: Integer read FCodPapelEnvio write FCodPapelEnvio;
    property DesPapelEnvio: String read FDesPapelEnvio write FDesPapelEnvio;
    property CodOpcaoEnvio: Integer read FCodOpcaoEnvio write FCodOpcaoEnvio;
    property DesOpcaoEnvio: String read FDesOpcaoEnvio write FDesOpcaoEnvio;
    property CodUsuarioOpcaoEnvio: Integer read FCodUsuarioOpcaoEnvio write FCodUsuarioOpcaoEnvio;
    property NomUsuarioOpcaoEnvio: String read FNomUsuarioOpcaoEnvio write FNomUsuarioOpcaoEnvio;
    property PessoaOpcaoEnvio: TIntPessoa read FPessoaOpcaoEnvio write FPessoaOpcaoEnvio;
    property CodPapelOpcaoEnvio: Integer read FCodPapelOpcaoEnvio write FCodPapelOpcaoEnvio;
    property DesPapelOpcaoEnvio: String read FDesPapelOpcaoEnvio write FDesPapelOpcaoEnvio;
    property DesSituacao: String read FDesSituacao write FDesSituacao;
    property DtaLeitura: TDateTime read FDtaLeitura write FDtaLeitura;
  end;

implementation

{ TIntComunicado }

constructor TIntComunicado.Create;
begin
  inherited;
  FPessoaEnvio := TIntPessoa.Create;
  FPessoaOpcaoEnvio := TIntPessoa.Create;
end;

destructor TIntComunicado.Destroy;
begin
  FPessoaEnvio.Free;
  FPessoaOpcaoEnvio.Free;
  inherited;
end;

end.
