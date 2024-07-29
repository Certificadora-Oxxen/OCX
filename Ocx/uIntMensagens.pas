unit uIntMensagens;

interface

uses Classes, SysUtils, uConexao, DB, SqlExpr, Variants, StrUtils;

const
  MAX_MENSAGENS_INTERNAS = 99;
  CERRO_GERAL            = 10241;  
type
  {TIntMensagem}
  TIntMensagem = class(TCollectionItem)
  private
    FCodigo: Integer;
    FTexto: String;
    FClasse: String;
    FMetodo: String;
    FTipo: Integer;
  public
    property Codigo: Integer read FCodigo write FCodigo;
    property Texto:  String  read FTexto  write FTexto;
    property Classe: String  read FClasse write FClasse;
    property Metodo: String  read FMetodo write FMetodo;
    property Tipo:   Integer read FTipo   write FTipo;
  end;

  {TIntMensagens}
  TIntMensagens = class(TCollection)
  private
    FConexao : TConexao;
    FGerarLog : Boolean;
    FNomeArquivo : String;
    FNivelDetalhe : Integer;
    FQuery: TSQLQuery;
    FErroGerar: Integer;
    FTipoGerar: Integer;
    FInicializado : Boolean;

    function GetItem(Index: Integer): TIntMensagem;
    procedure SetItem(Index: Integer; Value: TIntMensagem);
    function Add(Codigo: Integer; Texto, Classe, Metodo: String;
      Tipo: Integer): TIntMensagem;
    procedure GerarLog(Codigo: Integer; Txt, Classe, Metodo: String;
      TipoGerar: Integer);
  public
    constructor Create(ItemClass: TCollectionItemClass);
    destructor Destroy; override;
    function Inicializar(ConexaoBD: TConexao; GerarLog: Boolean; NomeArquivoLog: String;
      NivelDetalheLog: Integer): Integer;
    function GerarMensagem(Codigo: Integer; Args: array of const): String;
    function Adicionar(Codigo: Integer; Classe, Metodo: String;
      Args: array of const): Integer; overload;
    function Adicionar(TxtMsg: String; CodTipo: Integer; Classe, Metodo: String;
      Args: array of const): Integer; overload;
    function BuscarTextoMensagem(Codigo: Integer): String;
    function BuscarTipoMensagem(Codigo: Integer): Integer;

    property Items[Index: Integer]: TIntMensagem read GetItem write SetItem; default;
    property Inicializado: Boolean read FInicializado;
    property NomeArquivo: String read FNomeArquivo write FNomeArquivo;
  end;

  {TColMensagens}
  TColMensagens = class(TCollection)
  private
    function GetItem(Index: Integer): TIntMensagem;
    procedure SetItem(Index: Integer; Value: TIntMensagem);
  public
    function Add(Codigo: Integer; Texto, Classe, Metodo: String;
      Tipo: Integer): TIntMensagem;
    property Items[Index: Integer]: TIntMensagem read GetItem write SetItem; default;
  end;

  {THerdomException}
  EHerdomException = class(Exception)
  private
    FCodigoErro: Integer;
    FNomeClasse,
    FNomeMetodo: String;
    FParametros: array of TVarRec;
    FIndMensagemEnviada: Boolean;
  public
    constructor Create(ECodigoErro: Integer; EClasse, EMetodo: String;
      EParametros: array of const; EIndMensagemEnviada: Boolean);
    destructor Free;

    procedure gerarMensagem(Mensagens: TIntMensagens);
    property CodigoErro: Integer read FCodigoErro;
    property IndMensagemEnviada: Boolean read FIndMensagemEnviada;
    property NomeClasse: String read FNomeClasse;
    property NomeMetodo: String read FNomeMetodo;
  end;

implementation
{$R mensagens.res}

{TColMensagens}
function TColMensagens.Add(Codigo: Integer; Texto, Classe, Metodo: String;
  Tipo: Integer): TIntMensagem;
begin
  Result := TIntMensagem(inherited Add);
  Result.Codigo := Codigo;
  Result.Texto  := Texto;
  Result.Classe := Classe;
  Result.Metodo := Metodo;
  Result.Tipo   := Tipo;
end;

function TColMensagens.GetItem(Index: Integer): TIntMensagem;
begin
  Result := TIntMensagem(inherited GetItem(Index));
end;

procedure TColMensagens.SetItem(Index: Integer; Value: TIntMensagem);
begin
  inherited SetItem(Index, Value);
end;

{TIntMensagens}
constructor TIntMensagens.Create(ItemClass: TCollectionItemClass);
begin
  inherited Create(ItemClass);
  FInicializado := False;
  FGerarLog := True;
  FNivelDetalhe := 3;
  FQuery := TSQLQuery.Create(nil);
  FQuery.SQL.Add('select cod_mensagem, ');
  FQuery.SQL.Add('       txt_mensagem, ');
  FQuery.SQL.Add('       cod_tipo_mensagem ');
  FQuery.SQL.Add('  from tab_mensagem ');
  FQuery.SQL.Add(' where cod_mensagem = :cod ');
end;

destructor TIntMensagens.Destroy;
begin
  FQuery.Free;
  inherited;
end;

function TIntMensagens.Adicionar(Codigo: Integer; Classe, Metodo: String;
  Args: array of const): Integer;
const
  LOCK: String = 'LOCK REQUEST TIME OUT PERIOD EXCEEDED';
  TAM: Integer = 37; // Tamanho do string de erro de lock
var
  Txt : String;
  PL : Integer;
begin
  FErroGerar := 0;

  // Consiste se é mensagem de banco de dados e se já foi inicializado
  If Codigo > MAX_MENSAGENS_INTERNAS Then Begin
    If Not FInicializado Then Begin
      Self.Add(8, FmtLoadStr(8, ['TIntMensagens', 'GerarMensagem']), 'TIntMensagens', 'GerarMensagem', 3);
      Self.Add(Codigo, FmtLoadStr(8, ['TIntMensagens', 'GerarMensagem']), Classe, Metodo, FTipoGerar);
    End;
  End;

  // Monta Texto
  Txt := GerarMensagem(Codigo, Args);

  // Se for erro de Lock Request Time Out, traduz mensagem para usuário
  PL := Pos(LOCK, Uppercase(Txt));
  If PL > 0 Then Begin
    Txt := Copy(Txt, 1, PL - 1) +
           'Esgotado o tempo limite de espera por liberação de recursos' +
           Copy(Txt, PL + TAM, Length(Txt) - ((TAM + PL) - 1));
  End;

  // Adiciona Erro na coleção
  If FErroGerar = 0 Then Begin
    Self.Add(Codigo, Txt, Classe, Metodo, FTipoGerar);
    Result := 0;
  End Else Begin
    Self.Add(FErroGerar, Txt, 'TIntMensagens', 'GerarMensagem', FTipoGerar);
    Self.Add(Codigo, Txt, Classe, Metodo, FTipoGerar);
    Result := -FErroGerar;
  End;

  // Tenta Gerar o Log
  If FGerarLog Then Begin
    If ((FNivelDetalhe = 3) and (FTipoGerar > 0)) or
       ((FNivelDetalhe = 2) and (FTipoGerar > 1)) or
       ((FNivelDetalhe = 1) and (FTipoGerar > 2)) Then Begin
      If FErroGerar = 0 Then Begin
        GerarLog(Codigo, Txt, Classe, Metodo, FTipoGerar);
      End Else Begin
        GerarLog(FErroGerar, Txt, 'TIntMensagens', 'GerarMensagem', FTipoGerar);
        GerarLog(Codigo, Txt, Classe, Metodo, FTipoGerar);
      End;
    End;
  End;
end;

function TIntMensagens.Adicionar(TxtMsg: String; CodTipo: Integer; Classe,
  Metodo: String; Args: array of const): Integer;
var
  Txt : String;
begin
  Result := 0;

  Try
    Txt := Format(TxtMsg, Args);
  Except
    On E: Exception do Begin
      Self.Add(5, FmtLoadStr(5, [E.Message, TxtMsg]), 'TIntMensagens', 'Adicionar', 3);
      Result := -5;
    End;
  End;

  If FTipoGerar = 0 then
    FTipoGerar:= CodTipo;

  If Result = 0 Then Begin
    Self.Add(99, Txt, Classe, Metodo, FTipoGerar);
  End;

  // Tenta Gerar o Log
  If FGerarLog Then Begin
    GerarLog(99, Txt, Classe, Metodo, 3);
  End;
end;

function TIntMensagens.BuscarTextoMensagem(Codigo: Integer): String;
var
  Txt : String;
begin
  Result := '#ERRO_BUSCANDO_MENSAGEM#';

  // Consiste se é mensagem de banco de dados e se já foi inicializado
  If Codigo > MAX_MENSAGENS_INTERNAS Then Begin
    If Not FInicializado Then Begin
      Self.Add(8, FmtLoadStr(8, ['TIntMensagens', 'BuscarTextoMensagem']), 'TIntMensagens', 'GerarMensagem', 3);
      Exit;
    End;
  End;

  // Monta Texto
  Txt := GerarMensagem(Codigo, []);

  // Adiciona Erro na coleção
  If FErroGerar = 0 Then Begin
    Result := Txt;
  End Else Begin
    Self.Add(FErroGerar, Txt, 'TIntMensagens', 'GerarMensagem', FTipoGerar);
  End;
end;

function TIntMensagens.BuscarTipoMensagem(Codigo: Integer): Integer;
var
  Q : TSQLQuery;
begin
  Result := -1;

  // Consiste se é mensagem de banco de dados e se já foi inicializado
  If Codigo > MAX_MENSAGENS_INTERNAS Then Begin
    If Not FInicializado Then Begin
      Self.Add(8, FmtLoadStr(8, ['TIntMensagens', 'BuscarTipoMensagem']), 'TIntMensagens', 'BuscarTipoMensagem', 3);
      Exit;
    End;
  End;

  Q := TSQLQuery.Create(nil);
  Try
    Q.SQLConnection := FConexao.SQLConnection;
    Q.SQL.Add('select cod_tipo_mensagem ');
    Q.SQL.Add('  from tab_mensagem ');
    Q.SQL.Add(' where cod_mensagem = :cod_mensagem ');
    Q.ParamByName('cod_mensagem').AsInteger := Codigo;
    Try
      Q.Open;

      If Q.IsEmpty Then Begin
        Self.Add(4, FmtLoadStr(4, ['TIntMensagens']), 'TIntMensagens', 'BuscarTipoMensagem', 3);
        Exit;
      End;
      Result := Q.FieldByName('cod_tipo_mensagem').AsInteger;
    Except
      On E:Exception do Begin
        Self.Add(5, FmtLoadStr(5, [E.Message, IntToStr(Codigo)]), 'TIntMensagens', 'BuscarTipoMensagem', 3);
        Exit;
      End;
    End;
  Finally
    Q.Free;
  End;
end;

procedure TIntMensagens.GerarLog(Codigo: Integer; Txt, Classe, Metodo: String;
  TipoGerar: Integer);
var
  Arq : Integer;
  F : TextFile;
  T : TDateTime;
  Aberto : Boolean;
  Gravar : String;
begin
  FTipoGerar := 3;
  If FNomeArquivo <> '' Then Begin
    // Cria arquivo de log se ele não existir
    If Not FileExists(FNomeArquivo) Then Begin
      Arq := FileCreate(FNomeArquivo);
      If Arq < 0 Then Begin
        FErroGerar := 13;
        Exit;
      End Else Begin
        FileClose(Arq);
      End;
    End;

    // Abre arquivo
    AssignFile(F, FNomeArquivo);
    Aberto := False;
    T := Now + EncodeTime(0, 0, 5, 0);
    While Now < T Do Begin
      {$I-}
      Append(F);
      {$I+}
      If IOResult = 0 Then Begin
        Aberto := True;
        Break;
      End;
    End;

    // Trata eventual erro na abertura
    If Not Aberto Then Begin
      FErroGerar := 9;
      Exit;
    End;

    // Grava registro de log no arquivo
    Gravar := FormatDateTime('dd/mm/yyyy hh:nn:ss.zzz', now) + ',' +
              IntToStr(Codigo) + ',"' +
              Txt + '","' +
              Classe + '","' +
              Metodo + '",' +
              IntToStr(TipoGerar) + ', "' +
              FConexao.NomUsuario + '"' + #13;
    {$I-}
    WriteLn(F, Gravar);
    {$I+}

    If IOResult <> 0 Then Begin
      FErroGerar := 10;
      CloseFile(F);
      Exit;
    End;

    // Fecha Arquivo
    CloseFile(F);
  End;
end;

function TIntMensagens.Add(Codigo: Integer; Texto, Classe, Metodo: String;
  Tipo: Integer): TIntMensagem;
begin
  Result := TIntMensagem(inherited Add);
  Result.Codigo := Codigo;
  Result.Texto  := Texto;
  Result.Classe := Classe;
  Result.Metodo := Metodo;
  Result.Tipo   := Tipo;
end;

function TIntMensagens.GerarMensagem(Codigo: Integer; Args: array of const): String;
begin
  FErroGerar := 0;
  FTipoGerar := 0;

  // Mensagens Internas (não presentes no BD)
  If Codigo <= MAX_MENSAGENS_INTERNAS Then Begin
    // Tenta formatar mensagem com argumentos passados
    Try
      Result := FmtLoadStr(Codigo, Args);
      FTipoGerar := 2;
    Except
      On E:Exception do Begin
        Result := FmtLoadStr(5, [E.Message , IntToStr(Codigo)]);
        FErroGerar := 5;
        Exit;
      End;
    End;
  End Else Begin
    // Executa query para buscar mensagem no banco
    FQuery.Close;
    FQuery.SQLConnection := FConexao.SQLConnection;
    FQuery.ParamByName('cod').AsInteger := Codigo;
    Try
      FQuery.Open;

      If FQuery.IsEmpty Then Begin
        Result := FmtLoadStr(4, [IntToStr(Codigo), 'TIntMensagens.GerarMensagem']);
        FErroGerar := 4;
        Exit;
      End;

      // Tenta formatar mensagem obtida com os argumentos passados
      Try
        Result := Format(FQuery.FieldByName('txt_mensagem').AsString, Args);
        FTipoGerar := FQuery.FieldByName('cod_tipo_mensagem').AsInteger;
      Except
        On E:Exception do Begin
          Result := FmtLoadStr(5, [E.Message , IntToStr(Codigo)]);
          FErroGerar := 5;
          Exit;
        End;
      End;
    Except
      On E: EDatabaseError do Begin
        Result := FmtLoadStr(6, [E.Message , IntToStr(Codigo)]);
        FErroGerar := 6;
        Exit;
      End;
    End;
  End;
end;

function TIntMensagens.GetItem(Index: Integer): TIntMensagem;
begin
  Result := TIntMensagem(inherited GetItem(Index));
end;

function TIntMensagens.Inicializar(ConexaoBD: TConexao; GerarLog: Boolean;
  NomeArquivoLog: String; NivelDetalheLog: Integer): Integer;
begin
  // Consiste parâmetros do método inicializar
  If ConexaoBD = nil Then Begin
    Raise Exception.CreateResFmt(2, ['TIntMensagens.Inicializar']);
    Result := -1;
    Exit;
  End;

  If Not ConexaoBD.Ativa Then Begin
    Raise Exception.CreateResFmt(3, ['TIntMensagens.Inicializar']);
    Result := -1;
    Exit;
  End;

  If GerarLog Then Begin
    If NomeArquivoLog = '' Then Begin
      Raise Exception.CreateResFmt(7, ['TIntMensagens.Inicializar']);
      Result := -1;
      Exit;
    End;
  End;

  If (NivelDetalheLog < 1) or (NivelDetalheLog > 3) Then Begin
    Raise Exception.CreateResFmt(14, [IntToStr(NivelDetalheLog), 'TIntMensagens.Inicializar']);
    Result := -1;
    Exit;
  End;

  FConexao      := ConexaoBD;
  FGerarLog     := GerarLog;
  FNomeArquivo  := NomeArquivoLog;
  FNivelDetalhe := NivelDetalheLog;
  FInicializado := True;

  Result := 0;
end;

procedure TIntMensagens.SetItem(Index: Integer; Value: TIntMensagem);
begin
  inherited SetItem(Index, Value);
end;

//
// Mensagens Internas
//
// 001 - Configuração, sessão ou valor não encontrados (%s)
// 002 - Conexão não informada (%s)
// 003 - Conexão não ativada (%s)
// 004 - Mensagem '%s' não cadastrada no banco (%s)
// 005 - Erro '%s' ao tentar formatar mensagem (%s)
// 006 - Erro '%s' ao tentar obter mensagem no banco (%s)
// 007 - Arquivo de Log não informado (%s)
// 008 - Objeto '%s' ainda não inicializado (%s)
// 009 - Erro '%s' na abertura do arquivo de log '%s' (%s)
// 010 - Erro '%s' arquivo '%s' (%s)
// 011 - Erro '%s' durante a conexão com o servidor BD
// 012 - Erro '%s' ao acessar database padrão
// 013 - Erro '%s' na criação do arquivo de log '%s' (%s)
// 014 - Nivel de detalhe de log %s inválido (%s)
// 015 - Mensagem não informada (%s)

{ EHerdomException }

constructor EHerdomException.Create(ECodigoErro: Integer; EClasse,
  EMetodo: String; EParametros: array of TVarRec; EIndMensagemEnviada: Boolean);
var
  I: Integer;
begin
  FCodigoErro := ECodigoErro;
  SetLength(FParametros, Length(EParametros));
  for I := Low(EParametros) to High(EParametros) Do
  // for I := 0 to Length(EParametros) - 1 do
  begin
    FParametros[I].VType := EParametros[I].VType;
    case EParametros[I].VType of
      vtExtended:
        FParametros[I].VExtended := EParametros[I].VExtended;
      vtInteger:
        FParametros[I].VInteger := EParametros[I].VInteger;
      vtBoolean:
        FParametros[I].VBoolean := EParametros[I].VBoolean;
      vtChar:
        FParametros[I].VChar := EParametros[I].VChar;
      vtString:
        String(FParametros[I].VString) := String(EParametros[I].VString);
      vtPointer:
        FParametros[I].VPointer := EParametros[I].VPointer;
      vtPChar, vtAnsiString: begin
        FParametros[I].VType := vtPChar;
        FParametros[I].VPChar := StrAlloc(StrLen(EParametros[I].VPChar) + 1);
        StrCopy(FParametros[I].VPChar, EParametros[I].VPChar);
      end;
      vtObject:
        FParametros[I].VObject := EParametros[I].VObject;
      vtClass:
        FParametros[I].VClass := EParametros[I].VClass;
      vtWideChar:
        FParametros[I].VWideChar := EParametros[I].VWideChar;
      vtPWideChar:
        FParametros[I].VPWideChar := EParametros[I].VPWideChar;
      vtCurrency:
        FParametros[I].VCurrency := EParametros[I].VCurrency;
      vtVariant:
        FParametros[I].VVariant := EParametros[I].VVariant;
      vtInterface:
        FParametros[I].VInterface := EParametros[I].VInterface;
      vtWideString:
        FParametros[I].VWideString := EParametros[I].VWideString;
      vtInt64:
        FParametros[I].VInt64 := EParametros[I].VInt64;
      else
        FParametros[I] := EParametros[I];
      end;
  end;
  FNomeClasse := EClasse;
  FNomeMetodo := EMetodo;
  FIndMensagemEnviada := EIndMensagemEnviada;
end;

destructor EHerdomException.Free;
begin
  SetLength(FParametros, 0);
end;

procedure EHerdomException.gerarMensagem(Mensagens: TIntMensagens);
begin
  // Se a menagem não foi enviada, então envia.
  if not FIndMensagemEnviada then
  begin
    Mensagens.Adicionar(FCodigoErro, FNomeClasse, FNomeMetodo, FParametros);
  end;
end;

end.
