unit uLibZipM;

interface

uses SysUtils, Classes, Windows, ZipMstr, Dialogs, IniFiles;

const
  BUFLEN = 16384;

type
  ZipFile = class(TZipMaster)
  private
    FNomArquivoCorrente: String;
    function GetNomArquivoCorrente: String;
  public
    constructor Create(AOwner: TComponent); override;
    property NomArquivoCorrente: String read GetNomArquivoCorrente write FNomArquivoCorrente;
  end;

  unzFile = ZipFile;

{ Compactação }
function ObterNomeArquivoZip(NomeArquivo: String): String;
function AbrirZip(NomeArquivo: String; var ArquivoZip: ZipFile): Integer; overload;
function AbrirZip(NomeArquivo: String; var ArquivoZip: ZipFile; AdicionarArquivos: Boolean): Integer; overload;
function AbrirArquivoNoZip(ArquivoZip: ZipFile; NomeArquivo: String): Integer;
function GravarLinhaNoZip(ArquivoZip: ZipFile; Linha: String): Integer;
function AdicionarArquivoNoZip(ArquivoZip: ZipFile; NomeArquivo: String): Integer;
function AdicionarArquivoNoZipSemHierarquiaPastas(ArquivoZip: ZipFile; NomeArquivo: String): Integer;
function FecharArquivoNoZip(ArquivoZip: ZipFile): Integer;
function FecharZip(var ArquivoZip: ZipFile; Comentario: PChar): Integer;

{ Descompactação }
function AbrirUnZip(NomeArquivo: String; var ArquivoUnZip: unzFile): Integer;
function NumArquivosDoUnZip(ArquivoUnZip: unzFile): Integer;
function IrAoPrimeiroArquivoDoUnzip(ArquivoUnZip: unzFile): Integer;
function IrAoProximoArquivoDoUnzip(ArquivoUnZip: unzFile): Integer;
function NomeArquivoCorrenteDoUnzip(ArquivoUnzip: unzFile): String;
function ExtrairArquivoDoUnZip(ArquivoUnZip: unzFile; NomeArquivo, Destino: String): Integer;
function FecharUnZip(ArquivoUnZip: unzFile): Integer;

{ Genérico }
function CaminhoDLL: String;

implementation

{ Compactação }

function AbrirZip(NomeArquivo: String; var ArquivoZip: ZipFile): Integer;
begin
  Result := AbrirZip(NomeArquivo, ArquivoZip, false);
end;

function AbrirZip(NomeArquivo: String; var ArquivoZip: ZipFile;
  AdicionarArquivos: Boolean): Integer;
begin
  Result := 0;
  Try
//    if (not assigned(ArquivoZip)) or (ArquivoZip = nil) then begin
    ArquivoZip := ZipFile.Create(nil);
//    end;
    ArquivoZip.ZipFileName := NomeArquivo;
    if not ArquivoZip.Dll_Load then begin
      ArquivoZip.DLLDirectory := CaminhoDLL;
      ArquivoZip.Dll_Load := True;
    end;
    ArquivoZip.FSpecArgs.Clear;

    // Se parâmetro Adicionar Arquivos = false, então usuário deseja um arquivo zip "novo", sendo assim
    // exclui qualquer arquivo que possa estar contido dentro do arquivo zip
    if Not AdicionarArquivos then begin
      if ArquivoZip.Count > 0 then begin
        ArquivoZip.FSpecArgs.Add('*.*');
        ArquivoZip.Delete;
        ArquivoZip.FSpecArgs.Clear;
      end;
    end;

    if ArquivoZip.Count > 0 then begin
      ArquivoZip.NomArquivoCorrente := Arquivozip.DirEntry[0].FileName;
    end;

  Except
    Result := -1;
  End;
end;

function AbrirArquivoNoZip(ArquivoZip: ZipFile; NomeArquivo: String): Integer;
begin
  If ArquivoZip = nil Then Begin
    Result := -1;
    Exit;
  End;
  ArquivoZip.FSpecArgs.Clear;
  ArquivoZip.FSpecArgs.Add(NomeArquivo);
  ArquivoZip.NomArquivoCorrente := NomeArquivo;
  Result := 0;
end;

function GravarLinhaNoZip(ArquivoZip: ZipFile; Linha: String): Integer;
var
  L: TStringStream;
  Idx: Integer;
  Arq: String;
begin
  Result := 0;
  If ArquivoZip = nil Then Begin
    Result := -1;
    Exit;
  End;

  Try
    if ArquivoZip.NomArquivoCorrente <> '' then begin
      Arq := ArquivoZip.NomArquivoCorrente;
    end else begin
      Result := -1;
      Exit;
    end;

    L := TStringStream.Create('');
    Try
      Idx := -1;
      ArquivoZip.Find(Arq, Idx);
      if Idx > -1 then begin
        ArquivoZip.ExtractFileToStream(Arq);
      end;
      ArquivoZip.ZipStream.SaveToStream(L);
      L.Size := ArquivoZip.ZipStream.Size + Length(Linha) + 2;
      L.WriteString(Linha + #13#10);
      ArquivoZip.ZipStream.LoadFromStream(L);
      ArquivoZip.AddStreamToFile(Arq, 0, FILE_ATTRIBUTE_ARCHIVE);
    Finally
      L.Free;
    End;
  Except
    Result := -1;
  End;
end;

function FecharArquivoNoZip(ArquivoZip: ZipFile): Integer;
begin
  Result := 0;
end;

function ObterNomeArquivoZip(NomeArquivo: String): String;
const
  aMinuscula: String = 'àáäâãèéëêìíïîòóöôõùúüûç';
  aMinusculaNula: String = 'aaaaaeeeeiiiiooooouuuuc';
  aMaiuscula: String = 'ÀÁÄÂÃÈÉËÊÌÍÏÎÒÓÖÔÕÙÚÜÛÇ';
  aMaiusculaNula: String = 'AAAAAEEEEIIIIOOOOOUUUUC';
var
  iAux, jAux: Integer;
begin
  Result := ExtractFileName(NomeArquivo);
  for iAux := 1 to Length(Result) do begin
    jAux := Pos(Result[iAux], aMinuscula);
    if jAux > 0 then Result[iAux] := aMinusculaNula[jAux];
    jAux := Pos(Result[iAux], aMaiuscula);
    if jAux > 0 then Result[iAux] := aMaiusculaNula[jAux];
  end;
  NomeArquivo := ExtractFilePath(NomeArquivo)+Result;
  Result := ExtractFileDrive(NomeArquivo);
  if Result = '' then begin
    if Copy(NomeArquivo, 1, 1) = '\' then begin
      Result := Copy(NomeArquivo, 2, Length(NomeArquivo)-1);
    end else begin
      Result := NomeArquivo;
    end;
  end else begin
    Result := Result+'\';
    iAux := Pos(Result, NomeArquivo);
    if iAux > 0 then begin
      Result := Copy(NomeArquivo, Length(Result)+1, Length(NomeArquivo)-Length(Result));
    end else begin
      Result := NomeArquivo;
    end;
  end;
end;

function AdicionarArquivoNoZip(ArquivoZip: ZipFile; NomeArquivo: String): Integer;
begin
  Result := 0;
  If ArquivoZip = nil Then Begin
    Result := -1;
    Exit;
  End;

  if not FileExists(NomeArquivo) then begin
    Result := -1;
    Exit;
  end;

  Try
    ArquivoZip.AddOptions := [AddDirNames];
    ArquivoZip.FSpecArgs.Clear;
    ArquivoZip.FSpecArgs.Add(NomeArquivo);
    ArquivoZip.NomArquivoCorrente := NomeArquivo;
    ArquivoZip.Add;
  Except
    Result := -1;
  End;
end;

function AdicionarArquivoNoZipSemHierarquiaPastas(ArquivoZip: ZipFile; NomeArquivo: String): Integer;
begin
  Result := 0;
  If ArquivoZip = nil Then Begin
    Result := -1;
    Exit;
  End;

  if not FileExists(NomeArquivo) then begin
    Result := -1;
    Exit;
  end;

  Try
    ArquivoZip.AddOptions := [];
    ArquivoZip.FSpecArgs.Clear;
    ArquivoZip.FSpecArgs.Add(NomeArquivo);
    ArquivoZip.NomArquivoCorrente := ExtractFileName(NomeArquivo);
    ArquivoZip.Add;
  Except
    Result := -1;
  End;
end;

function FecharZip(var ArquivoZip: ZipFile; Comentario: PChar): Integer;
var
  C : String;
begin
  Result := 0;
  If ArquivoZip = nil Then Begin
    Result := -1;
    Exit;
  End;

  Try
    C := StrPas(Comentario);
    if Trim(C) <> '' then begin
      ArquivoZip.ZipComment := Trim(C);
    end;
    ArquivoZip.Dll_Load := False;
    FreeAndNil(ArquivoZip);
  Except
    Result := -1;
  End;
end;

{ Descompactação }

function AbrirUnZip(NomeArquivo: String; var ArquivoUnZip: unzFile): Integer;
begin
  Result := AbrirZip(NomeArquivo, ArquivoUnZip, True);
  If ArquivoUnZip = nil Then Begin
    Result := -1;
  End;
end;

function NumArquivosDoUnZip(ArquivoUnZip: unzFile): Integer;
begin
  If ArquivoUnZip = nil Then Begin
    Result := -1;
    Exit;
  End;
  Result := ArquivoUnZip.Count;
end;

function IrAoPrimeiroArquivoDoUnzip(ArquivoUnZip: unzFile): Integer;
begin
  Result := -1;
  If ArquivoUnZip = nil Then Begin
    Exit;
  End;
  ArquivoUnZip.FSpecArgs.Clear;
  ArquivoUnZip.NomArquivoCorrente := '';
  if ArquivoUnZip.Count > 0 then begin
    ArquivoUnzip.FSpecArgs.Add(ArquivoUnzip.DirEntry[0].FileName);
    ArquivoUnZip.NomArquivoCorrente := ArquivoUnzip.DirEntry[0].FileName;
    Result := 0;
  end;
end;

function IrAoProximoArquivoDoUnzip(ArquivoUnZip: unzFile): Integer;
var
  Idx: Integer;
begin
  Result := -1;
  If ArquivoUnZip = nil Then Begin
    Exit;
  End;

  if ArquivoUnZip.NomArquivoCorrente = '' then begin
    IrAoPrimeiroArquivoDoUnzip(ArquivoUnZip);
    Exit;
  end;

  Idx := -1;
  ArquivoUnZip.Find(ArquivoUnZip.NomArquivoCorrente, Idx);
  if Idx > -1 then begin
    if Idx < ArquivoUnZip.Count - 1 then begin
      Inc(Idx);
      ArquivoUnZip.FSpecArgs.Clear;
      ArquivoUnzip.FSpecArgs.Add(ArquivoUnzip.DirEntry[Idx].FileName);
      ArquivoUnZip.NomArquivoCorrente := ArquivoUnzip.DirEntry[Idx].FileName;
      Result := 0;
    end;
  end;
end;

function NomeArquivoCorrenteDoUnzip(ArquivoUnzip: unzFile): String;
begin
  Result := '';
  If ArquivoUnZip = nil Then Begin
    Exit;
  End;
  Result := ArquivoUnZip.NomArquivoCorrente;
end;

function ExtrairArquivoDoUnZip(ArquivoUnZip: unzFile; NomeArquivo, Destino: String): Integer;
var
  Idx: integer;
begin
  Result := -1;
  If ArquivoUnZip = nil Then Begin
    Exit;
  End;

  // Localiza NomeArquivo dentro do arquivo zip
  Idx := -1;
  ArquivoUnZip.Find(NomeArquivo, Idx);
  if Idx > -1 then begin
    ArquivoUnZip.FSpecArgs.Clear;
    ArquivoUnZip.FSpecArgs.Add(ArquivoUnzip.DirEntry[Idx].FileName);
    ArquivoUnZip.NomArquivoCorrente := ArquivoUnzip.DirEntry[Idx].FileName;
  end else begin
    Exit;
  end;

  Try
//    ArquivoUnZip.AddOptions := [AddDirNames];
    ArquivoUnZip.ExtrOptions := [ExtrOverWrite];
    ArquivoUnZip.ExtrBaseDir := Destino;
    ArquivoUnZip.Extract;
     if ArquivoUnZip.SuccessCnt > 0 then begin
//      if ExtractFileName(ArquivoUnzip.DirEntry[Idx].FileName) <> ExtractFileName(NomeArquivo) then begin
//         if not RenameFile(Destino + ExtractFileName(ArquivoUnzip.DirEntry[Idx].FileName), ExtractFileName(NomeArquivo)) then begin
//           Exit;
//         end;
//      end;
      Result := 0;
    end;
  Except
    Result := -2;
  End;
end;

function FecharUnZip(ArquivoUnZip: unzFile): Integer;
begin
  Result := 0;
  If ArquivoUnZip = nil Then Begin
    Result := -1;
    Exit;
  End;

  Try
    ArquivoUnZip.Dll_Load := False;
    FreeAndNil(ArquivoUnZip);
  Except
    Result := -1;
  End;
end;

{ Genérico }

function CaminhoDLL: String;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create('herdom.ini');
  Try
    Result := Ini.ReadString('HERDOM', 'PATH_DLL_ZIP', '');
  Finally
    Ini.Free;
  End;
end;


{ ZipFile }

constructor ZipFile.Create(AOwner: TComponent);
begin
  inherited;
  FNomArquivoCorrente := '';
end;

function ZipFile.GetNomArquivoCorrente: String;
begin
  if FNomArquivoCorrente = '' then begin
    if Self.Count > 0 then begin
      FNomArquivoCorrente := Self.DirEntry[0].FileName;
    end;
  end;
  Result := FNomArquivoCorrente;
end;

end.
