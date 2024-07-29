unit uComunicados;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens, uComunicado,
  uIntComunicados, uIntComunicado;

type
  TComunicados = class(TASPMTSObject, IComunicados)
  private
    FIntComunicados : TIntComunicados;
    FInicializado : Boolean;
    FComunicado: TComunicado;
  protected
    function BOF: WordBool; safecall;
    function Deslocar(QtdRegistros: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function NumeroRegistros: Integer; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumRegistro: Integer); safecall;
    function PesquisarNaoLidos(CodUsuario: Integer): Integer; safecall;
    function PesquisarHistorico(CodUsuarioDestinatario: Integer; DtaInicio,
      DtaFim: TDateTime): Integer; safecall;
    function EnviarParaUsuario(CodUsuario: Integer; const TxtAssunto,
      TxtComunicado: WideString; DtaInicioValidade,
      DtaFimValidade: TDateTime; const IndComunicadoImportante: WideString;
      CodPapel, CodOpcaoEnvioComunicado: Integer): Integer; safecall;
    function EnviarParaTodos(const TxtAssunto, TxtComunicado: WideString;
      DtaInicioValidade, DtaFimValidade: TDateTime;
      const IndComunicadoImportante: WideString; CodPapel,
      CodOpcaoEnvioComunicado: Integer): Integer; safecall;
    function EnviarParaProdutores(CodTecnico, CodAssociacao: Integer;
      const TxtAssunto, TxtComunicado: WideString; DtaInicioValidade,
      DtaFimValidade: TDateTime; const IndComunicadoImportante: WideString;
      CodPapel, CodOpcaoEnvioComunicado: Integer): Integer; safecall;
    function EnviarParaTecnicos(CodProdutor: Integer; const TxtAssunto,
      TxtComunicado: WideString; DtaInicioValidade,
      DtaFimValidade: TDateTime; const IndComunicadoImportante: WideString;
      CodPapel, CodOpcaoEnvioComunicado: Integer): Integer; safecall;
    function EnviarParaAssociacao(CodProdutor: Integer; const TxtAssunto,
      TxtComunicado: WideString; DtaInicioValidade,
      DtaFimValidade: TDateTime; const IndComunicadoImportante: WideString;
      CodPapel, CodOpcaoEnvioComunicado: Integer): Integer; safecall;
    function BuscarEnviado(CodComunicado: Integer): Integer; safecall;
    function MarcarComoLido(CodComunicado: Integer): Integer; safecall;
    function PesquisarEnviados(CodUsuarioEnvio: Integer; DtaInicio,
      DtaFim: TDateTime): Integer; safecall;
    function PesquisarDestinatarios(CodComunicado: Integer;
      const IndComunicadoLido: WideString): Integer; safecall;
    function BuscarRecebido(CodComunicado,
      CodUsuarioDestinatario: Integer): Integer; safecall;
    function Get_Comunicado: IComunicado; safecall;
    function FinalizarComunicado(CodComunicado: Integer): Integer; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TComunicados.AfterConstruction;
begin
  inherited;
  FComunicado := TComunicado.Create;
  FComunicado.ObjAddRef;
  FInicializado := False;
end;

procedure TComunicados.BeforeDestruction;
begin
  If FIntComunicados <> nil Then Begin
    FIntComunicados.Free;
  End;
  If FComunicado <> nil Then Begin
    FComunicado.ObjRelease;
    FComunicado := nil;
  End;
  inherited;
end;

function TComunicados.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntComunicados := TIntComunicados.Create;
  Result := FIntComunicados.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TComunicados.BOF: WordBool;
begin
  Result := FIntComunicados.BOF;
end;

function TComunicados.Deslocar(QtdRegistros: Integer): Integer;
begin
  Result := FIntComunicados.Deslocar(QtdRegistros);
end;

function TComunicados.EOF: WordBool;
begin
  Result := FIntComunicados.EOF;
end;

function TComunicados.NumeroRegistros: Integer;
begin
  Result := FIntComunicados.NumeroRegistros;
end;

function TComunicados.ValorCampo(const NomeColuna: WideString): OleVariant;
begin
  Result := FIntComunicados.ValorCampo(NomeColuna);
end;

procedure TComunicados.FecharPesquisa;
begin
  FIntComunicados.FecharPesquisa;
end;

procedure TComunicados.IrAoAnterior;
begin
  FIntComunicados.IrAoAnterior;
end;

procedure TComunicados.IrAoPrimeiro;
begin
  FIntComunicados.IrAoPrimeiro;
end;

procedure TComunicados.IrAoProximo;
begin
  FIntComunicados.IrAoProximo;
end;

procedure TComunicados.IrAoUltimo;
begin
  FIntComunicados.IrAoUltimo;
end;

procedure TComunicados.Posicionar(NumRegistro: Integer);
begin
  FIntComunicados.Posicionar(NumRegistro);
end;

function TComunicados.PesquisarNaoLidos(CodUsuario: Integer): Integer;
begin
  Result := FIntComunicados.PesquisarNaoLidos(CodUsuario);
end;

function TComunicados.PesquisarHistorico(CodUsuarioDestinatario: Integer;
  DtaInicio, DtaFim: TDateTime): Integer;
begin
  Result := FIntComunicados.PesquisarHistorico(CodUsuarioDestinatario, DtaInicio, DtaFim);
end;

function TComunicados.EnviarParaUsuario(CodUsuario: Integer;
  const TxtAssunto, TxtComunicado: WideString; DtaInicioValidade,
  DtaFimValidade: TDateTime; const IndComunicadoImportante: WideString;
  CodPapel, CodOpcaoEnvioComunicado: Integer): Integer;
begin
  Result := FIntComunicados.EnviarParaUsuario(CodUsuario, TxtAssunto, TxtComunicado,
    DtaInicioValidade, DtaFimValidade, IndComunicadoImportante, CodPapel,
    CodOpcaoEnvioComunicado);
end;

function TComunicados.EnviarParaTodos(const TxtAssunto,
  TxtComunicado: WideString; DtaInicioValidade, DtaFimValidade: TDateTime;
  const IndComunicadoImportante: WideString; CodPapel,
  CodOpcaoEnvioComunicado: Integer): Integer;
begin
  Result := FIntComunicados.EnviarParaTodos(TxtAssunto, TxtComunicado,
    DtaInicioValidade, DtaFimValidade, IndComunicadoImportante, CodPapel,
    CodOpcaoEnvioComunicado);
end;

function TComunicados.EnviarParaProdutores(CodTecnico,
  CodAssociacao: Integer; const TxtAssunto, TxtComunicado: WideString;
  DtaInicioValidade, DtaFimValidade: TDateTime;
  const IndComunicadoImportante: WideString; CodPapel,
  CodOpcaoEnvioComunicado: Integer): Integer;
begin
  Result := FIntComunicados.EnviarParaProdutores(CodTecnico, CodAssociacao, TxtAssunto,
    TxtComunicado, DtaInicioValidade, DtaFimValidade, IndComunicadoImportante, CodPapel,
    CodOpcaoEnvioComunicado);
end;

function TComunicados.EnviarParaTecnicos(CodProdutor: Integer;
  const TxtAssunto, TxtComunicado: WideString; DtaInicioValidade,
  DtaFimValidade: TDateTime; const IndComunicadoImportante: WideString;
  CodPapel, CodOpcaoEnvioComunicado: Integer): Integer;
begin
  Result := FIntComunicados.EnviarParaTecnicos(CodProdutor, TxtAssunto, TxtComunicado,
    DtaInicioValidade, DtaFimValidade, IndComunicadoImportante, CodPapel,
    CodOpcaoEnvioComunicado);
end;

function TComunicados.EnviarParaAssociacao(CodProdutor: Integer;
  const TxtAssunto, TxtComunicado: WideString; DtaInicioValidade,
  DtaFimValidade: TDateTime; const IndComunicadoImportante: WideString;
  CodPapel, CodOpcaoEnvioComunicado: Integer): Integer;
begin
  Result := FIntComunicados.EnviarParaAssociacao(CodProdutor, TxtAssunto, TxtComunicado,
    DtaInicioValidade, DtaFimValidade, IndComunicadoImportante, CodPapel,
    CodOpcaoEnvioComunicado);
end;

function TComunicados.BuscarEnviado(CodComunicado: Integer): Integer;
begin
  Result := FIntComunicados.BuscarEnviado(CodComunicado);
end;

function TComunicados.MarcarComoLido(CodComunicado: Integer): Integer;
begin
  Result := FIntComunicados.MarcarComoLido(CodComunicado);
end;

function TComunicados.PesquisarEnviados(CodUsuarioEnvio: Integer;
  DtaInicio, DtaFim: TDateTime): Integer;
begin
  Result := FIntComunicados.PesquisarEnviados(CodUsuarioEnvio, DtaInicio, DtaFim);
end;

function TComunicados.PesquisarDestinatarios(CodComunicado: Integer;
  const IndComunicadoLido: WideString): Integer;
begin
  Result := FIntComunicados.PesquisarDestinatarios(CodComunicado, IndComunicadoLido);
end;

function TComunicados.BuscarRecebido(CodComunicado,
  CodUsuarioDestinatario: Integer): Integer;
begin
  Result := FIntComunicados.BuscarRecebido(CodComunicado, CodUsuarioDestinatario);
end;

function TComunicados.Get_Comunicado: IComunicado;
begin
  FComunicado.CodComunicado := FIntComunicados.IntComunicado.CodComunicado;
  FComunicado.TxtAssunto := FIntComunicados.IntComunicado.TxtAssunto;
  FComunicado.TxtComunicado := FIntComunicados.IntComunicado.TxtComunicado;
  FComunicado.DtaInicioValidade := FIntComunicados.IntComunicado.DtaInicioValidade;
  FComunicado.DtaFimValidade := FIntComunicados.IntComunicado.DtaFimValidade;
  FComunicado.DtaEnvioComunicado := FIntComunicados.IntComunicado.DtaEnvioComunicado;
  FComunicado.CodUsuarioEnvio := FIntComunicados.IntComunicado.CodUsuarioEnvio;
  FComunicado.NomUsuarioEnvio := FIntComunicados.IntComunicado.NomUsuarioEnvio;
  FComunicado.PessoaEnvio.CodPessoa := FIntComunicados.IntComunicado.PessoaEnvio.CodPessoa;
  FComunicado.PessoaEnvio.NomPessoa := FIntComunicados.IntComunicado.PessoaEnvio.NomPessoa;
  FComunicado.PessoaEnvio.NomReduzidoPessoa := FIntComunicados.IntComunicado.PessoaEnvio.NomReduzidoPessoa;
  FComunicado.PessoaEnvio.CodNaturezaPessoa := FIntComunicados.IntComunicado.PessoaEnvio.CodNaturezaPessoa;
  FComunicado.PessoaEnvio.NumCNPJCPF := FIntComunicados.IntComunicado.PessoaEnvio.NumCNPJCPF;
  FComunicado.PessoaEnvio.NumCNPJCPFFormatado := FIntComunicados.IntComunicado.PessoaEnvio.NumCNPJCPFFormatado;
  FComunicado.CodPapelEnvio := FIntComunicados.IntComunicado.CodPapelEnvio;
  FComunicado.DesPapelEnvio := FIntComunicados.IntComunicado.DesPapelEnvio;
  FComunicado.CodOpcaoEnvio := FIntComunicados.IntComunicado.CodOpcaoEnvio;
  FComunicado.DesOpcaoEnvio := FIntComunicados.IntComunicado.DesOpcaoEnvio;
  FComunicado.CodUsuarioOpcaoEnvio := FIntComunicados.IntComunicado.CodUsuarioOpcaoEnvio;
  FComunicado.NomUsuarioOpcaoEnvio := FIntComunicados.IntComunicado.NomUsuarioOpcaoEnvio;
  FComunicado.PessoaOpcaoEnvio.CodPessoa := FIntComunicados.IntComunicado.PessoaOpcaoEnvio.CodPessoa;
  FComunicado.PessoaOpcaoEnvio.NomPessoa := FIntComunicados.IntComunicado.PessoaOpcaoEnvio.NomPessoa;
  FComunicado.PessoaOpcaoEnvio.NomReduzidoPessoa := FIntComunicados.IntComunicado.PessoaOpcaoEnvio.NomReduzidoPessoa;
  FComunicado.PessoaOpcaoEnvio.CodNaturezaPessoa := FIntComunicados.IntComunicado.PessoaOpcaoEnvio.CodNaturezaPessoa;
  FComunicado.PessoaOpcaoEnvio.NumCNPJCPF := FIntComunicados.IntComunicado.PessoaOpcaoEnvio.NumCNPJCPF;
  FComunicado.PessoaOpcaoEnvio.NumCNPJCPFFormatado := FIntComunicados.IntComunicado.PessoaOpcaoEnvio.NumCNPJCPFFormatado;
  FComunicado.CodPapelOpcaoEnvio := FIntComunicados.IntComunicado.CodPapelOpcaoEnvio;
  FComunicado.DesPapelOpcaoEnvio := FIntComunicados.IntComunicado.DesPapelOpcaoEnvio;
  FComunicado.DesSituacao := FIntComunicados.IntComunicado.DesSituacao;
  FComunicado.DtaLeitura := FIntComunicados.IntComunicado.DtaLeitura;
  Result := FComunicado;
end;

function TComunicados.FinalizarComunicado(CodComunicado: Integer): Integer;
begin
  Result := FIntComunicados.FinalizarComunicado(CodComunicado);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TComunicados, Class_Comunicados,
    ciMultiInstance, tmApartment);
end.
