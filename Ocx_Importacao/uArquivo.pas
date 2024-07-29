unit uArquivo;

interface

uses Sysutils, uLibZip, ZipUtils, variants;

type
  TArquivoEscrita = class
  private
    { Private declarations }
    FCompactar: Boolean;
    FArquivo: TextFile;
    FNomeArquivo: String;
    FTipoLinha: Integer;
    FLinhaDados: String;
    FHeaderDefinido: Boolean;
    FInicializado: Boolean;
    FLimparAoAbrir: Boolean;
    FLinhasEscritas: Integer;
    FNomCertificadoraArquivoExistente: String;
    FNumCNPJCertificadoraArquivoExistente: String;
    FNaturezaProdutorArquivoExistente: String;
    FNumCNPJCPFProdutorArquivoExistente: String;
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;
    procedure ZerarArquivo;
    function Inicializar: Integer;
    function AdicionarComentario(Comentario: String): Integer;
    function DefinirHeader(DtaGeracao: TDateTime; NomCertificadora,
      NumCNPJCertificadora: String): Integer; overload;
    function DefinirHeader(DtaGeracao: TDateTime; NomCertificadora,
      NumCNPJCertificadora, NaturezaProdutor,
      NumCNPJCPFProdutor: String): Integer; overload;
    function AdicionarLinha: Integer;
    function AdicionarColuna(Valor: Variant): Integer;
    function AdicionarLinhaTexto(Linha: String): Integer;
    function CancelarLinha: Integer;
    function Finalizar: Integer;
    property NomeArquivo: String read FNomeArquivo write FNomeArquivo;
    property TipoLinha: Integer read FTipoLinha write FTipoLinha;
    property LinhasEscritas: Integer read FLinhasEscritas;
    property LimparAoAbrir: Boolean read FLimparAoAbrir write FLimparAoAbrir;
    property Compactar: Boolean read FCompactar write FCompactar;
  end;

  TArquivoLeitura = class
  private
    { Private declarations }
    FArquivo: TextFile;
    FNomeArquivo: String;
    FDtaGeracao: TDateTime;
    FNomCertificadora: String;
    FNumCNPJCertificadora: String;
    FNaturezaProdutor: String;
    FNumCNPJCPFProdutor: String;
    FTipoLinha: Integer;
    FLinhaTexto: String;
    FLinhasLidas: Integer;
    FNumeroColunas: Integer;
    FInicializado: Boolean;
    FLinhaaLinha: Boolean;
    function GetEOF: Boolean;
    function LerLinha: Integer;
    function LerHeader: Integer;
    function GetValorColuna(Coluna: Integer): Variant;
  public
    { Public declarations }
    Linha: Array of Variant;
    constructor Create;
    destructor Destroy; override;
    procedure ZerarArquivo;
    function Inicializar: Integer;
    function Posicionar(NumLinha: Integer): Integer;
    function ObterLinha: Integer;
    function Finalizar: Integer;
    property NomeArquivo: String read FNomeArquivo write FNomeArquivo;
    property DtaGeracao: TDateTime read FDtaGeracao;
    property NomCertificadora: String read FNomCertificadora;
    property NumCNPJCertificadora: String read FNumCNPJCertificadora;
    property NaturezaProdutor: String read FNaturezaProdutor;
    property NumCNPJCPFProdutor: String read FNumCNPJCPFProdutor;
    property LinhaTexto: String read FLinhaTexto;
    property TipoLinha: Integer read FTipoLinha;
    property NumeroColunas: Integer read FNumeroColunas;
    property ValorColuna[Coluna: Integer]: Variant read GetValorColuna;
    property EOF: Boolean read GetEOF;
    property LinhasLidas: Integer read FLinhasLidas;
    property LinhaaLinha: Boolean read FLinhaaLinha write FLinhaaLinha;
  end;

  TArquivoPosicionalLeitura = class
  private
    { Private declarations }
    FInicializado: Boolean;
    FArquivo: TextFile;
    FNomeArquivo: String;
    FLinhaTexto: String;
    FColunas: Array of Variant;
    FNumeroColunas: Integer;
    FLinhasLidas: Integer;
    FTipoLinha: Integer;
    function GetEOF: Boolean;
    function GetValorColuna(Coluna: Integer): Variant;
  public
    { Public declarations }
    RotinaLeitura: procedure(Owner: TArquivoPosicionalLeitura);
    constructor Create;
    destructor Destroy; override;
    function Inicializar: Integer;
    function ReInicializar: Integer;
    function Finalizar: Integer;
    function ObterLinha: Integer;
    procedure LimparColunas;
    procedure AdicionarColuna(Valor: Variant);
    property NomeArquivo: String read FNomeArquivo write FNomeArquivo;
    property LinhaTexto: String read FLinhaTexto;
    property TipoLinha: Integer read FTipoLinha write FTipoLinha;
    property NumeroColunas: Integer read FNumeroColunas;
    property ValorColuna[Coluna: Integer]: Variant read GetValorColuna;
    property EOF: Boolean read GetEOF;
    property LinhasLidas: Integer read FLinhasLidas;
  end;

  TArquivoPosicionalEscrita = class
  private
    { Private declarations }
    FInicializado: Boolean;
    FArquivo: TextFile;
    FNomeArquivo: String;
    FLinhaDados: String;
    FLinhasEscritas: Integer;
    FLimparAoAbrir: Boolean;
    FCompactar: Boolean;
    FTipoLinha: Integer;
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;
    function Inicializar: Integer;
    function AdicionarLinha: Integer;
    function AdicionarColuna(Valor: String): Integer;
    function AdicionarLinhaTexto(Linha: String): Integer;
    function CancelarLinha: Integer;
    function Finalizar: Integer;
    property NomeArquivo: String read FNomeArquivo write FNomeArquivo;
    property TipoLinha: Integer read FTipoLinha write FTipoLinha;
    property LinhasEscritas: Integer read FLinhasEscritas;
    property LimparAoAbrir: Boolean read FLimparAoAbrir write FLimparAoAbrir;
    property Compactar: Boolean read FCompactar write FCompactar;
  end;

  procedure TrataNomeArquivo(var NomeArquivo: String);
  function TrataString(Texto: String): String;
  function TrataData(var Data: Variant): Integer;
  function TrataBoolean(var Valor: Variant): Integer;
  function TrataFloat(var Valor: Variant): Integer;

const
  {Erros possíveis retornados pelas rotinas}
  EInicializarEscrita: Integer = -1;
  EAdicionarComentario: Integer = -2;
  EDefinirHeader: Integer = -3;
  EAdicionarLinha: Integer = -4;
  ETipoDeValorNaoReconhecido: Integer = -5;
  EFinalizarEscrita: Integer = -6;
  ETipoColunaDesconhecido: Integer = -7;
  ECampoNumericoInvalido: Integer = -8;
  ECampoStringInvalido: Integer = -9;
  EDelimitadorStringInvalido: Integer = -10;
  EDelimitadorOutroCampoInvalido: Integer = -11;
  EOutroCampoInvalido: Integer = -12;
  EAdicionarColunaEscrita: Integer = -13;
  EDefinirTipoLinha: Integer = -14;
  EAdicionarColunaLeitura: Integer = -15;
  ELerLinha: Integer = -16;
  ELerHeader: Integer = -17;
  EInicializarLeitura: Integer = -18;
  EObterLinha: Integer = -19;
  EDataInvalida: Integer = -20;
  EBooleanInvalido: Integer = -21;
  EFinalizarLeitura: Integer = -22;
  ENaoInicializado: Integer = -23;
  EFloatInvalido: Integer = -24;
  EArquivoInexistente: Integer = -25;
  EAdicionarLinhaTexto: Integer = -26;
  EFinalDeLinhaInesperado: Integer = -27;
  EJaInicializado: Integer = -28;
  ELerArquivoExistente: Integer = -29;
  EHeaderInconsistente: Integer = -30;
  ECancelarLinha: Integer = -31;
  EPosicionarLinhas: Integer = -32;
  EPosicaoInvalida: Integer = -33;
  EArquivoZipNaoEncontrado: Integer = -34;
  EExtraindoArquivo: Integer = -35;
  ECriandoArquivoZip: Integer = -36;

implementation

procedure TrataNomeArquivo(var NomeArquivo: String);
const
  aMinuscula: String = 'àáäâãèéëêìíïîòóöôõùúüûç';
  aMinusculaNula: String = 'aaaaaeeeeiiiiooooouuuuc';
  aMaiuscula: String = 'ÀÁÄÂÃÈÉËÊÌÍÏÎÒÓÖÔÕÙÚÜÛÇ';
  aMaiusculaNula: String = 'AAAAAEEEEIIIIOOOOOUUUUC';
var
  sAux: String;
  iAux, jAux: Integer;
begin
  sAux := ExtractFileName(NomeArquivo);
  for iAux := 1 to Length(sAux) do begin
    jAux := Pos(sAux[iAux], aMinuscula);
    if jAux > 0 then sAux[iAux] := aMinusculaNula[jAux];
    jAux := Pos(sAux[iAux], aMaiuscula);
    if jAux > 0 then sAux[iAux] := aMaiusculaNula[jAux];
  end;
  NomeArquivo := ExtractFilePath(NomeArquivo)+sAux;
end;

function TrataString(Texto: String): String;
var
  iAux: Integer;
begin
  Result := '';
  for iAux := 1 to Length(Texto) do begin
    if Texto[iAux] = #34 then begin
      Result := Result + #34;
    end;
    Result := Result + Texto[iAux];
  end;
end;

function TrataData(var Data: Variant): Integer;
var
  sData: String;
  dd, mm, yyyy, hh, nn, ss: word;
begin
  try
    sData := Data;
    yyyy := StrToInt(Copy(sData, 1, 4));
    mm := StrToInt(Copy(sData, 6, 2));
    dd := StrToInt(Copy(sData, 9, 2));
    Data := EncodeDate(yyyy, mm, dd);
    if Length(sData) > 10 then begin
      hh := StrToInt(Copy(sData, 12, 2));
      nn := StrToInt(Copy(sData, 15, 2));
      ss := StrToInt(Copy(sData, 18, 2));
      Data := Data + EncodeTime(hh, nn, ss, 0);
    end;
    Result := 0;
  except
    Result := EDataInvalida;
  end;
end;

function TrataBoolean(var Valor: Variant): Integer;
begin
  try
    if UpperCase(Valor) = 'TRUE' then begin
      Valor := True;
    end else if UpperCase(Valor) = 'FALSE' then begin
      Valor := False;
    end else begin
      Abort;
    end;
    Result := 0;
  except
    Result := EBooleanInvalido;
  end;
end;

function TrataFloat(var Valor: Variant): Integer;
var
  cDecimalSeparator, cThousandSeparator: Char;
begin
  {Guarda configurações do sistema}
  cDecimalSeparator := DecimalSeparator;
  cThousandSeparator := ThousandSeparator;
  try
    {Atribui definições temporárias}
    DecimalSeparator := #46;
    ThousandSeparator := #0;
    try
      Valor := StrToFloat(Valor);
      Result := 0;
    except
      Result := EFloatInvalido;
    end;
  finally
    {Restabelece configuração padrão do aplicativo}
    DecimalSeparator := cDecimalSeparator;
    ThousandSeparator := cThousandSeparator;
  end;
end;

{ TArquivoEscrita }

procedure TArquivoEscrita.ZerarArquivo;
begin
  FInicializado := False;
  FHeaderDefinido := False;
  FNomeArquivo := '';
  FTipoLinha := -1;
  FLinhaDados := '';
  FNomCertificadoraArquivoExistente := '';
  FNumCNPJCertificadoraArquivoExistente := '';
  FNaturezaProdutorArquivoExistente := '';
  FNumCNPJCPFProdutorArquivoExistente := '';
end;

constructor TArquivoEscrita.Create;
begin
  FLimparAoAbrir := True;
  FCompactar := False;
  ZerarArquivo;
end;

destructor TArquivoEscrita.Destroy;
begin
  if FInicializado then begin
    CloseFile(FArquivo);
  end;
  inherited;
end;

function TArquivoEscrita.Inicializar: Integer;
var
  sAux, sArquivoExt: String;
  iAux: Integer;
  ArquivoZip: unzFile;
  ArquivoExistente: TArquivoLeitura;
begin
  TrataNomeArquivo(FNomeArquivo);
  if FInicializado then begin
    Result := EJaInicializado;
    Exit;
  end;
  sAux := UpperCase(ExtractFileExt(FNomeArquivo));
  if sAux = '.ZIP' then begin
    iAux := Pos('.ZIP', UpperCase(FNomeArquivo));
    sAux := Copy(FNomeArquivo, 1, iAux);
    FNomeArquivo := sAux + 'xhu';
    FCompactar := True;
  end;
  try
    if not FLimparAoAbrir then begin
      if FCompactar then begin
        iAux := Pos(ExtractFileExt(FNomeArquivo), FNomeArquivo);
        if iAux = 0 then begin
          Result := EArquivoZipNaoEncontrado;
          Exit;
        end;
        sAux := Copy(FNomeArquivo, 1, iAux)+'ZIP';
        Result := AbrirUnZip(sAux, ArquivoZip);
        if Result < 0 then begin
          Result := EArquivoZipNaoEncontrado;
          Exit;
        end;
        FNomeArquivo := NomeArquivoCorrenteDoUnzip(ArquivoZip);
        Result := ExtrairArquivoDoUnZip(ArquivoZip, sArquivoExt, ExtractFilePath(sAux));
        if Result < 0 then begin
          FecharUnZip(ArquivoZip);
          Result := EExtraindoArquivo;
          Exit;
        end;
        FecharUnZip(ArquivoZip);
        DeleteFile(sAux);
        FNomeArquivo := ExtractFilePath(sAux)+FNomeArquivo;
      end;
      ArquivoExistente := TArquivoLeitura.Create;
      try
        ArquivoExistente.NomeArquivo := FNomeArquivo;
        if ArquivoExistente.Inicializar < 0 then begin
          Result := ELerArquivoExistente;
          Exit;
        end;
        FNomCertificadoraArquivoExistente := ArquivoExistente.NomCertificadora;
        FNumCNPJCertificadoraArquivoExistente := ArquivoExistente.NumCNPJCertificadora;
        FNaturezaProdutorArquivoExistente := ArquivoExistente.NaturezaProdutor;
        FNumCNPJCPFProdutorArquivoExistente := ArquivoExistente.NumCNPJCPFProdutor;
        FHeaderDefinido := True;
        ArquivoExistente.Finalizar;
      finally
        ArquivoExistente.Free;
      end;
    end;
    AssignFile(FArquivo, FNomeArquivo);
    if FLimparAoAbrir then begin
      Rewrite(FArquivo);
    end else begin
      Append(FArquivo);
    end;
    FInicializado := True;
    FLinhasEscritas := 0;
    Result := 0;
  except
    Result := EInicializarEscrita;
  end;
end;

function TArquivoEscrita.AdicionarComentario(Comentario: String): Integer;
begin
  try
    if not(FInicializado) then begin
      Result := ENaoInicializado;
      Exit;
    end;
    if (FLinhaDados <> '') then begin
      Writeln(FArquivo, FLinhaDados);
      FLinhaDados := '';
      Inc(FLinhasEscritas);
    end;
    Writeln(FArquivo, '# '+Comentario);
    Inc(FLinhasEscritas);
    Result := 0;
  except
    Result := EAdicionarComentario;
  end;
end;

function TArquivoEscrita.DefinirHeader(DtaGeracao: TDateTime;
  NomCertificadora, NumCNPJCertificadora: String): Integer;
begin
  try
    if not(FInicializado) then begin
      Result := ENaoInicializado;
      Exit;
    end;
    if not(FLimparAoAbrir) then begin
      if (FNomCertificadoraArquivoExistente <> NomCertificadora)
      or (FNumCNPJCertificadoraArquivoExistente <> NumCNPJCertificadora)
      or (FNaturezaProdutorArquivoExistente <> '')
      or (FNumCNPJCPFProdutorArquivoExistente <> '') then begin
        Result := EHeaderInconsistente;
        Exit;
      end else begin
        Result := 0;
        Exit;
      end;
    end else if (FHeaderDefinido) then begin
      Abort;
    end;
    Writeln(FArquivo,
      '0;'+ {Tipo da linha - header}
      #35+FormatDateTime('yyyy-mm-dd hh:nn:ss', DtaGeracao)+#35#59+ {Data formato padrão}
      #34+TrataString(NomCertificadora)+#34+#59+ {Nome da Certificadora}
      #34+NumCNPJCertificadora+#34); {Número do CNPJ da Certificadora}
    Inc(FLinhasEscritas);
    FHeaderDefinido := True;
    Result := 0;
  except
    Result := EDefinirHeader;
  end;
end;

function TArquivoEscrita.DefinirHeader(DtaGeracao: TDateTime;
  NomCertificadora, NumCNPJCertificadora, NaturezaProdutor,
  NumCNPJCPFProdutor: String): Integer;
begin
  try
    if not(FInicializado) then begin
      Result := ENaoInicializado;
      Exit;
    end;
    if not(FLimparAoAbrir) then begin
      if (FNomCertificadoraArquivoExistente <> NomCertificadora)
      or (FNumCNPJCertificadoraArquivoExistente <> NumCNPJCertificadora)
      or (FNaturezaProdutorArquivoExistente <> NaturezaProdutor)
      or (FNumCNPJCPFProdutorArquivoExistente <> NumCNPJCPFProdutor) then begin
        Result := EHeaderInconsistente;
        Exit;
      end else begin
        Result := 0;
        Exit;
      end;
    end else if (FHeaderDefinido) then begin
      Abort;
    end;
    Writeln(FArquivo,
      '0;'+ {Tipo da linha - header}
      #35+FormatDateTime('yyyy-mm-dd hh:nn:ss', DtaGeracao)+#35#59+ {Data formato padrão}
      #34+TrataString(NomCertificadora)+#34#59+ {Nome da Certificadora}
      #34+NumCNPJCertificadora+#34#59+ {Número do CNPJ da Certificadora}
      #34+NaturezaProdutor+#34#59+ {Natureza do Produtor}
      #34+NumCNPJCPFProdutor+#34); {Número do CNPJ ou CPF do produtor}
    Inc(FLinhasEscritas);
    FHeaderDefinido := True;
    Result := 0;
  except
    Result := EDefinirHeader;
  end;
end;

function TArquivoEscrita.AdicionarLinha: Integer;
begin
  try
    if not(FInicializado) then begin
      Result := ENaoInicializado;
      Exit;
    end;
    if not(FHeaderDefinido) then Abort;
    Writeln(FArquivo, FLinhaDados);
    FLinhaDados := '';
    Inc(FLinhasEscritas);
    Result := 0;
  except
    Result := EAdicionarLinha;
  end;
end;

function TArquivoEscrita.AdicionarColuna(Valor: Variant): Integer;
var
  sAux: String;
  fAux: Extended;
  cDecimalSeparator, cThousandSeparator: Char;
begin
  {Guarda configurações do sistema}
  cDecimalSeparator := DecimalSeparator;
  cThousandSeparator := ThousandSeparator;
  try
    {Seta configurações necessárias}
    DecimalSeparator := #46;
    ThousandSeparator := #0;
    try
      if not(FInicializado) then begin
        Result := ENaoInicializado;
        Exit;
      end;
      if not(FHeaderDefinido) then Abort;
      {Tratando o tipo do dado}
      if VarType(Valor) = varSmallint then begin
        sAux := IntToStr(Valor);
      end else if VarType(Valor) = varInteger then begin
        sAux := IntToStr(Valor);
      end else if VarType(Valor) = varSingle then begin
        sAux := FloatToStr(Valor);
      end else if VarType(Valor) = varDouble then begin
        sAux := FloatToStr(Valor);
      end else if VarType(Valor) = varCurrency then begin
        sAux := CurrToStr(Valor);
      end else if VarType(Valor) = varShortInt then begin
        sAux := IntToStr(Valor);
      end else if VarType(Valor) = varByte then begin
        sAux := IntToStr(Valor);
      end else if VarType(Valor) = varLongWord then begin
        sAux := IntToStr(Valor);
      end else if VarType(Valor) = varDate then begin
        if Valor = 0 then begin
          sAux := '0';
        end else begin
          fAux := Valor;
          fAux := Trunc(fAux);
          if Valor = fAux  then begin
            sAux := #35+FormatDateTime('yyyy-mm-dd', Valor)+#35;
          end else begin
            sAux := #35+FormatDateTime('yyyy-mm-dd hh:nn:ss', Valor)+#35;
          end;
        end;
      end else if VarType(Valor) = varBoolean then begin
        if Valor then begin
          sAux := '#TRUE#';
        end else begin
          sAux := '#FALSE#';
        end;
      end else if VarType(Valor) = varString then begin
        sAux := #34+TrataString(Valor)+#34;
      end else begin
        Result := ETipoDeValorNaoReconhecido;
        Exit;
      end;
      {Definindo a linha de dados}
      if FLinhaDados = '' then begin
        if FTipoLinha > -1 then begin
          FLinhaDados := IntToStr(FTipoLinha)+#59+sAux;
        end else begin
          FLinhaDados := sAux;
        end;
      end else begin
        FLinhaDados := FLinhaDados + #59 + sAux;
      end;
      Result := 0;
    except
      on E: Exception do begin
        Result := EAdicionarColunaEscrita;
        Raise Exception.CreateFmt('Não foi possível adicionar a coluna. Erro identificado: "%s"', [E.Message]);
      end;
    end;
  finally
    DecimalSeparator := cDecimalSeparator;
    ThousandSeparator := cThousandSeparator;
  end;
end;

function TArquivoEscrita.AdicionarLinhaTexto(Linha: String): Integer;
begin
  try
    if not(FInicializado) then begin
      Result := ENaoInicializado;
      Exit;
    end;
    Writeln(FArquivo, Linha);
    Inc(FLinhasEscritas);
    Result := 0;
  except
    Result := EAdicionarLinhaTexto;
  end;
end;

function TArquivoEscrita.CancelarLinha: Integer;
begin
  try
    if not(FInicializado) then begin
      Result := ENaoInicializado;
      Exit;
    end;
    FLinhaDados := '';
    Result := 0;
  except
    Result := ECancelarLinha;
  end;
end;

function TArquivoEscrita.Finalizar: Integer;
var
  iAux: Integer;
  sAux: String;
  ArquivoZip: zipFile;
begin
  try
    if not(FInicializado) then begin
      Result := ENaoInicializado;
      Exit;
    end;
    Result := 0;
    if FLinhaDados <> '' then begin
      Writeln(FArquivo, FLinhaDados);
      Inc(FLinhasEscritas);
    end;
    CloseFile(FArquivo);
    if FCompactar then begin
      iAux := Pos(ExtractFileExt(FNomeArquivo), FNomeArquivo);
      if iAux = 0 then begin
        sAux := FNomeArquivo + '.zip';
      end else begin
        sAux := Copy(FNomeArquivo, 1, iAux)+'zip';
      end;
      Result := AbrirZip(sAux, ArquivoZip);
      if Result < 0 then begin
        Result := ECriandoArquivoZIP;
        Exit;
      end;
      Result := AdicionarArquivoNoZip(ArquivoZip, FNomeArquivo);
      if Result < 0 then begin
        Result := ECriandoArquivoZip;
      end;
      FecharZip(ArquivoZip, '');
      DeleteFile(FNomeArquivo);
      if Result < 0 then begin
        DeleteFile(sAux);
      end;
    end;
    ZerarArquivo;
  except
    Result := EFinalizarEscrita;
  end;
end;

{ TArquivoLeitura }

procedure TArquivoLeitura.ZerarArquivo;
begin
  FNomeArquivo := '';
  FDtaGeracao := 0;
  FNomCertificadora := '';
  FNumCNPJCertificadora := '';
  FNaturezaProdutor := '';
  FNumCNPJCPFProdutor := '';
  FTipoLinha := -1;
  FLinhaTexto := '';
  FLinhasLidas := 0;
  FInicializado := False;
end;

constructor TArquivoLeitura.Create;
begin
  FLinhaaLinha := False;
  ZerarArquivo;
end;

destructor TArquivoLeitura.Destroy;
begin
  if FInicializado then begin
    CloseFile(FArquivo);
  end;
  inherited;
end;

function TArquivoLeitura.GetEOF: Boolean;
begin
  Result := System.Eof(FArquivo);
end;

function TArquivoLeitura.GetValorColuna(Coluna: Integer): Variant;
begin
  if not(FInicializado) then Abort;
  if (Coluna < 1) or (Coluna > FNumeroColunas) then Abort;
  Result := Linha[Coluna-1];
end;

function TArquivoLeitura.LerLinha: Integer;
var
  bAux: Boolean;
  sAux: String;
  iAux, jAux: Integer;
  bString, bNumber, bOther, bTipo: Boolean;

  procedure RemoverColunas;
  begin
    {Remove as colunas de uma linha lida, caso existam}
    if Length(Linha) > 0 then begin
      SetLength(Linha, 0);
    end;
    FTipoLinha := -1;
    FNumeroColunas := 0;
    bTipo := False;
  end;

  procedure ZerarColuna;
  begin
    {Limpa informações referentes a leitura de uma coluna}
    bString := False;
    bNumber := False;
    bOther := False;
    bAux := False;
    sAux := '';
  end;

  function MontarColuna(Caracter: Char): Integer;
  begin
    {Realiza a leitura de uma coluna}
    Result := 0;
    if not(bString) and not(bNumber) and not(bOther) then begin
      {Tenta identificar o tipo do campo (coluna)}
      if Caracter = #34 then begin
        {Um campo do tipo string foi identificado}
        bString := True;
        bAux := False;
      end else if Caracter = #35 then begin
        {Um campo do tipo TDatetime ou Booleano foi identificado}
        bOther := True;
      end else if Caracter in ['0'..'9', #45, #46] then begin
        {Um campo do tipo número foi identificado}
        bNumber := True;
        sAux := sAux + Caracter;
      end else begin
        {Não foi possível identificar o tipo do campo, retorna erro}
        Result := ETipoColunaDesconhecido;
      end;
    end else if bNumber then begin
      {Trata os campos do tipo númerico}
      if Caracter = #59 then begin
        {Fim do campo numérico}
        Result := 1;
      end else if Caracter in ['0'..'9', #46] then begin
        {Concatena o caracter númerico junto a string p/ ser convertido posteriormente}
        sAux := sAux + Caracter;
      end else begin
        {O caracter da posição não é númerico, retorna erro}
        Result := ECampoNumericoInvalido;
      end;
    end else if bString then begin
      {Trata os campos do tipo string}
      if (Caracter = #34) and not(bAux) then begin
        {Uma aspa foi encontrada, abre escuta para próximo caracter}
        bAux := True;
      end else if (Caracter = #34) and bAux then begin
        {Uma nova aspa foi encontrada, desliga escuta para próximo caracter
         imprimindo uma única aspa para o usuário}
        sAux := sAux + #34;
        bAux := False;
      end else if bAux and (Caracter <> #59) then begin
        {Uma nova aspa não foi encontrada com escuta em aberto, sendo o caracter
         lido diferente do delimitador de campo, retorna erro}
        Result := EDelimitadorStringInvalido;
      end else if bAux and (Caracter = #59) then begin
        {Um delimitador de campo foi identificado, encerra a leitura do campo}
        Result := 1;
      end else begin
        {Um caracter normal foi lido, concatena o caracter lido com a lista de
         caracteres já lidos anteriormente}
        sAux := sAux + Caracter;
      end;
    end else if bOther then begin
      if not(bAux) and (Caracter = #35) then begin
        {O identificador de final deste tipo de campo foi encontrado}
        bAux := True;
      end else if bAux and (Caracter <> #59) then begin
        {O caracter sucessor do identificador não é o caracter delimitador de
         coluna, retorna erro}
        Result := EDelimitadorOutroCampoInvalido;
      end else if bAux and (Caracter = #59) then begin
        {Um delimitador de campo foi identificado, encerra a leitura do campo}
        Result := 1;
      end else if Caracter in ['T', 'R', 'U', 'E', 'F', 'A', 'L', 'S', '0'..'9', ':', '-', #32] then begin
        {Um caracter normal foi lido, concatena o caracter lido com a lista de
         caracteres já lidos anteriormente}
        sAux := sAux + Caracter;
      end else begin
        {O caracter da posição não é válida para tipo de campo, retorna erro}
        Result := EOutroCampoInvalido;
      end;
    end;
  end;

  function DefinirTipoLinha: Integer;
  begin
    {Define o tipo da linha lida}
    try
      FTipoLinha := StrToInt(sAux);
      bTipo := True;
      ZerarColuna;
      Result := 0;
    except
      Result := EDefinirTipoLinha;
    end;
  end;

  function AdicionarColuna: Integer;
  var
    iAjuda: Integer;
  begin
    {Adiciona a coluna lida ao vetor de colunas}
    try
      jAux := Length(Linha);
      SetLength(Linha, jAux+1);
      if bString then begin
        Linha[jAux] := sAux;
      end else if bNumber then begin
        if Pos(#46, sAux) > 0 then begin
          Linha[jAux] := sAux;
          if TrataFloat(Linha[jAux]) < 0 then Abort;
        end else begin
          Linha[jAux] := StrToInt(sAux);
        end;
      end else if bOther then begin
        iAjuda := Length(sAux);
        if not(iAjuda in [10, 19, 4, 5]) then Abort;
        Linha[jAux] := sAux;
        case (iAjuda) of
          10, 19:
            if TrataData(Linha[jAux]) < 0 then Abort;
          4, 5:
            if TrataBoolean(Linha[jAux]) < 0 then Abort;
        end;
      end else begin
        Abort;
      end;
      Inc(FNumeroColunas);
      ZerarColuna;
      Result := 0;
    except
      Result := EAdicionarColunaLeitura;
    end;
  end;

begin
  try
    RemoverColunas;
    ZerarColuna;
    if (FLinhaTexto = '') or (Copy(FLinhaTexto, 1, 1) = #35) then begin
      Result := 0;
      Exit;
    end;
    for iAux := 1 to Length(FLinhaTexto) do begin
      Result := MontarColuna(FLinhaTexto[iAux]);
      if Result < 0 then begin
        Exit;
      end else if Result = 1 then begin
        if bTipo then begin
          Result := AdicionarColuna;
          if Result < 0 then Exit;
        end else begin
          Result := DefinirTipoLinha;
          if Result < 0 then Exit;
        end;
      end;
    end;
    if (bString or bOther) and not(bAux) then begin
      Result := EFinalDeLinhaInesperado;
      Exit;
    end else if (sAux <> '') or (bAux and (sAux = '')) then begin
      Result := AdicionarColuna;
    end else begin
      Result := 0;
    end;
  except
    Result := ELerLinha;
  end;
end;

function TArquivoLeitura.LerHeader: Integer;
begin
  try
    FTipoLinha := -1;
    FLinhaTexto := #35;
    while ((Copy(FLinhaTexto, 1, 1) = #35) or (FLinhaTexto = ''))
    and not(EOF) do begin
      Readln(FArquivo, FLinhaTexto);
      FLinhaTexto := Trim(FLinhaTexto);
      Inc(FLinhasLidas);
    end;
    Result := LerLinha;
    if Result < 0 then Abort;
    if FTipoLinha <> 0 then Abort;
    if (FNumeroColunas <> 3) and (FNumeroColunas <> 5) then Abort;
    FInicializado := True;
    FDtaGeracao := ValorColuna[1];
    FNomCertificadora := ValorColuna[2];
    FNumCNPJCertificadora := ValorColuna[3];
    if FNumeroColunas = 5 then begin
      FNaturezaProdutor := ValorColuna[4];
      FNumCNPJCPFProdutor := ValorColuna[5];
    end;
  except
    Result := ELerHeader;
  end;
end;

function TArquivoLeitura.Inicializar: Integer;
begin
  if FInicializado then begin
    Result := EJaInicializado;
    Exit;
  end;
  try
    if not(FileExists(FNomeArquivo)) then begin
      Result := EArquivoInexistente;
      Exit;
    end;
    AssignFile(FArquivo, FNomeArquivo);
    Reset(FArquivo);
    FInicializado := True;
    FLinhasLidas := 0;
    Result := LerHeader;
    if Result = 0 then begin
      if FLinhaaLinha then begin
        {Retorna ao início do arquivo permitindo percorrer por inteiro
        o mesmo ("linha-a-linha")}
        CloseFile(FArquivo);
        Reset(FArquivo);
        FLinhasLidas := 0;
      end;
      FInicializado := True;
    end;
  except
    Result := EInicializarLeitura;
  end;
end;

function TArquivoLeitura.Posicionar(NumLinha: Integer): Integer;
var
  sAux: String;
begin
  try
    if NumLinha > FLinhasLidas then begin
      while FLinhasLidas < (NumLinha-1) do begin
        Readln(FArquivo, sAux);
        Inc(FLinhasLidas);
      end;
      Result := ObterLinha;
    end else begin
      Result := EPosicaoInvalida;
    end;
  except
    Result := EPosicionarLinhas;
  end;
end;

function TArquivoLeitura.ObterLinha: Integer;
begin
  try
    if not(FInicializado) then begin
      Result := ENaoInicializado;
      Exit;
    end;
    if FLinhaaLinha then begin
      Readln(FArquivo, FLinhaTexto);
      Inc(FLinhasLidas);
    end else begin
      FLinhaTexto := #35;
      while ((Copy(FLinhaTexto, 1, 1) = #35) or (FLinhaTexto = ''))
      and not(EOF) do begin
        Readln(FArquivo, FLinhaTexto);
        FLinhaTexto := Trim(FLinhaTexto);
        Inc(FLinhasLidas);
      end;
    end;
    Result := LerLinha;
  except
    Result := EObterLinha;
  end;
end;

function TArquivoLeitura.Finalizar: Integer;
begin
  try
    CloseFile(FArquivo);
    ZerarArquivo;
    Result := 0;
  except
    Result := EFinalizarLeitura;
  end;
end;

{ TArquivoPosicionalLeitura }

constructor TArquivoPosicionalLeitura.Create;
begin
  FNomeArquivo := '';
  FLinhaTexto := '';
  FLinhasLidas := 0;
  FTipoLinha := 0;
  FNumeroColunas := 0;
  RotinaLeitura := nil;
  FInicializado := False;
end;

destructor TArquivoPosicionalLeitura.Destroy;
begin
  if FInicializado then begin
    CloseFile(FArquivo);
  end;
  inherited;
end;

function TArquivoPosicionalLeitura.Inicializar: Integer;
begin
  if FInicializado then begin
    Result := EJaInicializado;
    Exit;
  end;
  try
    if not(FileExists(FNomeArquivo)) then begin
      Result := EArquivoInexistente;
      Exit;
    end;
    AssignFile(FArquivo, FNomeArquivo);
    Reset(FArquivo);
    FInicializado := True;
    FLinhasLidas := 0;
    FInicializado := True;
    Result := 0;
  except
    Result := EInicializarLeitura;
  end;
end;

function TArquivoPosicionalLeitura.ReInicializar: Integer;
begin
  if not FInicializado then begin
    Result := ENaoInicializado;
    Exit;
  end;
  try
    CloseFile(FArquivo);
    Reset(FArquivo);
    FInicializado := True;
    FLinhasLidas := 0;
    Result := 0;
  except
    Result := EInicializarLeitura;
  end;
end;

function TArquivoPosicionalLeitura.ObterLinha: Integer;
var
  Caracter: Char;
begin
  try
    if not(FInicializado) then begin
      Result := ENaoInicializado;
      Exit;
    end;
    FLinhaTexto := '';
    Read(FArquivo, Caracter);
    while not System.Eof(FArquivo) and (Caracter <> #10) do begin
      if Caracter <> #13 then FLinhaTexto := FLinhaTexto + Caracter;
      Read(FArquivo, Caracter);
    end;
    Inc(FLinhasLidas);
    if Assigned(RotinaLeitura) then begin
      RotinaLeitura(self);
    end;
    Result := 0;
  except
    Result := EObterLinha;
  end;
end;

procedure TArquivoPosicionalLeitura.LimparColunas;
begin
  if Length(FColunas) > 0 then begin
    SetLength(FColunas, 0);
  end;
  FNumeroColunas := 0;
end;

procedure TArquivoPosicionalLeitura.AdicionarColuna(Valor: Variant);
var
  iAux: Integer;
begin
  iAux := Length(FColunas);
  SetLength(FColunas, iAux+1);
  FColunas[iAux] := Valor;
  Inc(FNumeroColunas);
end;

function TArquivoPosicionalLeitura.GetValorColuna(
  Coluna: Integer): Variant;
begin
  if not(FInicializado) then Abort;
  if (Coluna < 1) or (Coluna > FNumeroColunas) then Abort;
  Result := FColunas[Coluna-1];
end;

function TArquivoPosicionalLeitura.GetEOF: Boolean;
begin
  Result := System.Eof(FArquivo);
end;

function TArquivoPosicionalLeitura.Finalizar: Integer;
begin
  try
    CloseFile(FArquivo);
    FNomeArquivo := '';
    FLinhaTexto := '';
    FTipoLinha := 0;
    FLinhasLidas := 0;
    FNumeroColunas := 0;
    FInicializado := False;
    Result := 0;
  except
    Result := EFinalizarLeitura;
  end;
end;

{ TArquivoPosicionalEscrita }

constructor TArquivoPosicionalEscrita.Create;
begin
  FInicializado := False;
  FNomeArquivo := '';
  FLinhaDados := '';
  FLimparAoAbrir := True;
  FCompactar := False;
end;

destructor TArquivoPosicionalEscrita.Destroy;
begin
  if FInicializado then begin
    CloseFile(FArquivo);
  end;
  inherited;
end;

function TArquivoPosicionalEscrita.Inicializar: Integer;
var
  sAux, sArquivoExt: String;
  iAux: Integer;
  ArquivoZip: unzFile;
begin
  TrataNomeArquivo(FNomeArquivo);
  if FInicializado then begin
    Result := EJaInicializado;
    Exit;
  end;
  sAux := UpperCase(ExtractFileExt(FNomeArquivo));
  if sAux = '.ZIP' then begin
    iAux := Pos('.ZIP', UpperCase(FNomeArquivo));
    sAux := Copy(FNomeArquivo, 1, iAux);
    FNomeArquivo := sAux + 'txt';
    FCompactar := True;
  end;
  try
    if not FLimparAoAbrir then begin
      if FCompactar then begin
        iAux := Pos(ExtractFileExt(FNomeArquivo), FNomeArquivo);
        if iAux = 0 then begin
          Result := EArquivoZipNaoEncontrado;
          Exit;
        end;
        sAux := Copy(FNomeArquivo, 1, iAux)+'ZIP';
        Result := AbrirUnZip(sAux, ArquivoZip);
        if Result < 0 then begin
          Result := EArquivoZipNaoEncontrado;
          Exit;
        end;
        FNomeArquivo := NomeArquivoCorrenteDoUnzip(ArquivoZip);
        Result := ExtrairArquivoDoUnZip(ArquivoZip, sArquivoExt, ExtractFilePath(sAux));
        if Result < 0 then begin
          FecharUnZip(ArquivoZip);
          Result := EExtraindoArquivo;
          Exit;
        end;
        FecharUnZip(ArquivoZip);
        DeleteFile(sAux);
        FNomeArquivo := ExtractFilePath(sAux)+FNomeArquivo;
      end;
      if not FileExists(FNomeArquivo) then begin
        Result := ELerArquivoExistente;
        Exit;
      end;
    end;
    AssignFile(FArquivo, FNomeArquivo);
    if FLimparAoAbrir then begin
      Rewrite(FArquivo);
    end else begin
      Append(FArquivo);
    end;
    FInicializado := True;
    FLinhasEscritas := 0;
    Result := 0;
  except
    Result := EInicializarEscrita;
  end;
end;

function TArquivoPosicionalEscrita.AdicionarColuna(Valor: String): Integer;
begin
  FLinhaDados := FLinhaDados + Valor;
  Result := 0;
end;

function TArquivoPosicionalEscrita.AdicionarLinha: Integer;
begin
  try
    if not(FInicializado) then begin
      Result := ENaoInicializado;
      Exit;
    end;
    Writeln(FArquivo, FLinhaDados);
    FLinhaDados := '';
    Inc(FLinhasEscritas);
    Result := 0;
  except
    Result := EAdicionarLinha;
  end;
end;

function TArquivoPosicionalEscrita.AdicionarLinhaTexto(
  Linha: String): Integer;
begin
  try
    if not(FInicializado) then begin
      Result := ENaoInicializado;
      Exit;
    end;
    Writeln(FArquivo, Linha);
    Inc(FLinhasEscritas);
    Result := 0;
  except
    Result := EAdicionarLinhaTexto;
  end;
end;

function TArquivoPosicionalEscrita.CancelarLinha: Integer;
begin
  try
    if not(FInicializado) then begin
      Result := ENaoInicializado;
      Exit;
    end;
    FLinhaDados := '';
    Result := 0;
  except
    Result := ECancelarLinha;
  end;
end;

function TArquivoPosicionalEscrita.Finalizar: Integer;
var
  iAux: Integer;
  sAux: String;
  ArquivoZip: zipFile;
begin
  try
    if not(FInicializado) then begin
      Result := ENaoInicializado;
      Exit;
    end;
    Result := 0;
    if FLinhaDados <> '' then begin
      Writeln(FArquivo, FLinhaDados);
      Inc(FLinhasEscritas);
    end;
    CloseFile(FArquivo);
    if FCompactar then begin
      iAux := Pos(ExtractFileExt(FNomeArquivo), FNomeArquivo);
      if iAux = 0 then begin
        sAux := FNomeArquivo + '.zip';
      end else begin
        sAux := Copy(FNomeArquivo, 1, iAux)+'zip';
      end;
      Result := AbrirZip(sAux, ArquivoZip);
      if Result < 0 then begin
        Result := ECriandoArquivoZIP;
        Exit;
      end;
      Result := AdicionarArquivoNoZip(ArquivoZip, FNomeArquivo);
      if Result < 0 then begin
        Result := ECriandoArquivoZip;
      end;
      FecharZip(ArquivoZip, '');
      DeleteFile(FNomeArquivo);
      if Result < 0 then begin
        DeleteFile(sAux);
      end;
    end;
    FInicializado := False;
    FNomeArquivo := '';
    FLinhaDados := '';
  except
    Result := EFinalizarEscrita;
  end;
end;

end.
