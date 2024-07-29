unit uLibZip;

interface

uses SysUtils, Zip, Unzip, ZipUtils, Dialogs, FileCtrl;

const
  BUFLEN = 16384;

{ Compactação }
function ObterNomeArquivoZip(NomeArquivo: String): String;
function AbrirZip(NomeArquivo: String; var ArquivoZip: ZipFile): Integer; overload;
function AbrirZip(NomeArquivo: String; var ArquivoZip: ZipFile; AdicionarArquivos: Boolean): Integer; overload;
function AbrirArquivoNoZip(ArquivoZip: ZipFile; NomeArquivo: String): Integer;
function GravarLinhaNoZip(ArquivoZip: ZipFile; Linha: String): Integer;
function AdicionarArquivoNoZip(ArquivoZip: ZipFile; NomeArquivo: String): Integer;
function AdicionarArquivoNoZipSemHierarquiaPastas(ArquivoZip: ZipFile; NomeArquivo: String): Integer;
function FecharArquivoNoZip(ArquivoZip: ZipFile): Integer;
function FecharZip(ArquivoZip: ZipFile; Comentario: PChar): Integer;

{ Descompactação }
function AbrirUnZip(NomeArquivo: String; var ArquivoUnZip: unzFile): Integer;
function NumArquivosDoUnZip(ArquivoUnZip: unzFile): Integer;
function IrAoPrimeiroArquivoDoUnzip(ArquivoUnZip: unzFile): Integer;
function IrAoProximoArquivoDoUnzip(ArquivoUnZip: unzFile): Integer;
function NomeArquivoCorrenteDoUnzip(ArquivoUnzip: unzFile): String;
function ExtrairArquivoDoUnZip(ArquivoUnZip: unzFile; NomeArquivo, Destino: String): Integer;
function FecharUnZip(ArquivoUnZip: unzFile): Integer;

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
  if AdicionarArquivos then begin
    ArquivoZip := ZipOpen(Pchar(NomeArquivo), 1);
  end else begin
    ArquivoZip := ZipOpen(Pchar(NomeArquivo), 0);
  end;
  If ArquivoZip = nil Then Begin
    Result := -1;
  End;
end;

function AbrirArquivoNoZip(ArquivoZip: ZipFile; NomeArquivo: String): Integer;
begin
  If ArquivoZip = nil Then Begin
    Result := -1;
    Exit;
  End;
  If NomeArquivo = '' Then Begin
    Result := -2;
    Exit;
  End;
  Result := ZipOpenNewFileInZip(ArquivoZip, PChar(NomeArquivo), nil, nil, 0, nil, 0, nil,
    8, 9);  // 8 = Z_DEFLATED, 9 = Z_BEST_COMPRESSION
end;

function GravarLinhaNoZip(ArquivoZip: ZipFile; Linha: String): Integer;
begin
  If ArquivoZip = nil Then Begin
    Result := -1;
    Exit;
  End;
  Linha := Linha + #13#10;
  Result := ZipWriteInFileInZip(ArquivoZip, PChar(Linha), Length(Linha));
end;

function FecharArquivoNoZip(ArquivoZip: ZipFile): Integer;
begin
  If ArquivoZip = nil Then Begin
    Result := -1;
    Exit;
  End;
  Result := ZipCloseFileInZip(ArquivoZip);
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
var
  Buffer: packed array [0..BUFLEN-1] of byte;
  Tamanho: Integer;
	ArqOrigem: File;
  sAux: String;
	ESErro: Integer;
begin
  // Consistindo caminho de destino
  if not FileExists(NomeArquivo) then begin
    Result := -1;
    Exit;
  end;

  sAux := ObterNomeArquivoZip(NomeArquivo);
  Result := ZipOpenNewFileInZip(ArquivoZip, PChar(sAux), nil, nil, 0, nil, 0, nil,
    8, 9);  // 8 = Z_DEFLATED, 9 = Z_BEST_COMPRESSION
  if Result <> UNZ_OK then begin
    Result := -2;
    Exit;
  end;

  // Segmento de leitura do arquivo
  try
    // Cria em disco o arquivo que receberá o conteúdo do arquivo extraído
    AssignFile(ArqOrigem, NomeArquivo);
    {$I-}
    Reset(ArqOrigem, 1);
    {$I+}
    ESErro := IOResult;
    if (ESErro <> 0) then begin
      Result := -3;
      Exit;
    end;

    // Segmento de leitura/escrita do arquivo
    try
      while (True) do begin
        {$I-}
        // Le dados do arquivo em disco
        BlockRead(ArqOrigem, Buffer, BUFLEN, Tamanho);
        {$I+}
        ESErro := IOResult;
        if (ESErro <> 0) then begin
          Result := -4;
          Break;
        end;
        if Tamanho = 0 then begin
          Result := 0;
          Break;
        end;

        Result := zipWriteInFileInZip(ArquivoZip, @Buffer, Tamanho);
        if (Result <> ZIP_OK) then begin
          Result := -5;
          Break;
        end;
      end;
    finally
      // Finaliza arquivo
      {$I-}
      Close(ArqOrigem);
      {$I+}
      ESErro := IOResult;
      if (ESErro <> 0) then begin
        Result := -6;
      end;
    end;
  finally
    // Finaliza arquivo adicionado no zip
    zipCloseFileInZip(ArquivoZip);
  end;
end;

function AdicionarArquivoNoZipSemHierarquiaPastas(ArquivoZip: ZipFile; NomeArquivo: String): Integer;
var
  Buffer: packed array [0..BUFLEN-1] of byte;
  Tamanho: Integer;
	ArqOrigem: File;
  sAux: String;
	ESErro: Integer;
begin
  // Consistindo caminho de destino
  if not FileExists(NomeArquivo) then begin
    Result := -1;
    Exit;
  end;

  sAux := ObterNomeArquivoZip(ExtractFileName(NomeArquivo));
  Result := ZipOpenNewFileInZip(ArquivoZip, PChar(sAux), nil, nil, 0, nil, 0, nil,
    8, 9);  // 8 = Z_DEFLATED, 9 = Z_BEST_COMPRESSION
  if Result <> UNZ_OK then begin
    Result := -2;
    Exit;
  end;

  // Segmento de leitura do arquivo
  try
    // Cria em disco o arquivo que receberá o conteúdo do arquivo extraído
    AssignFile(ArqOrigem, NomeArquivo);
    {$I-}
    Reset(ArqOrigem, 1);
    {$I+}
    ESErro := IOResult;
    if (ESErro <> 0) then begin
      Result := -3;
      Exit;
    end;

    // Segmento de leitura/escrita do arquivo
    try
      while (True) do begin
        {$I-}
        // Le dados do arquivo em disco
        BlockRead(ArqOrigem, Buffer, BUFLEN, Tamanho);
        {$I+}
        ESErro := IOResult;
        if (ESErro <> 0) then begin
          Result := -4;
          Break;
        end;
        if Tamanho = 0 then begin
          Result := 0;
          Break;
        end;

        Result := zipWriteInFileInZip(ArquivoZip, @Buffer, Tamanho);
        if (Result <> ZIP_OK) then begin
          Result := -5;
          Break;
        end;
      end;
    finally
      // Finaliza arquivo
      {$I-}
      Close(ArqOrigem);
      {$I+}
      ESErro := IOResult;
      if (ESErro <> 0) then begin
        Result := -6;
      end;
    end;
  finally
    // Finaliza arquivo adicionado no zip
    zipCloseFileInZip(ArquivoZip);
  end;
end;

function FecharZip(ArquivoZip: ZipFile; Comentario: PChar): Integer;
begin
  If ArquivoZip = nil Then Begin
    Result := -1;
    Exit;
  End;
  Result := ZipClose(ArquivoZip, Comentario);
end;

{ Descompactação }

function AbrirUnZip(NomeArquivo: String; var ArquivoUnZip: unzFile): Integer;
begin
  Result := 0;
  ArquivoUnZip := unzOpen(Pchar(NomeArquivo));
  If ArquivoUnZip = nil Then Begin
    Result := -1;
  End;
end;

function NumArquivosDoUnZip(ArquivoUnZip: unzFile): Integer;
var
  GlobalInfo: unz_global_info;
begin
  Result := unzGetGlobalInfo(ArquivoUnzip, GlobalInfo);
  if Result <> UNZ_OK then begin
    Result := -1;
  end else begin
    Result := GlobalInfo.number_entry;
  end;
end;

function IrAoPrimeiroArquivoDoUnzip(ArquivoUnZip: unzFile): Integer;
begin
  Result := unzGoToFirstFile(ArquivoUnZip);
  if Result = UNZ_OK then begin
    Result := 0;
  end else begin
    Result := -1;
  end;
end;

function IrAoProximoArquivoDoUnzip(ArquivoUnZip: unzFile): Integer;
begin
  Result := unzGoToNextFile(ArquivoUnZip);
  if Result = UNZ_OK then begin
    Result := 0;
  end else if Result = UNZ_END_OF_LIST_OF_FILE then begin
    Result := -1;
  end else begin
    Result := -2;
  end;
end;

{$HINTS OFF}
function NomeArquivoCorrenteDoUnzip(ArquivoUnzip: unzFile): String;
var
  ArqInfo: unz_file_info;
  NomeArquivoCorrente: array[0..Z_MAXFILENAMEINZIP+1-1] of char;
begin
  unzGetCurrentFileInfo(ArquivoUnZip, NIL,
    NomeArquivoCorrente, SizeOf(NomeArquivoCorrente)-1, NIL, 0, NIL, 0);
  Result := NomeArquivoCorrente;
end;
{$HINTS ON}

function ExtrairArquivoDoUnZip(ArquivoUnZip: unzFile; NomeArquivo, Destino: String): Integer;
var
  Buffer: packed array [0..BUFLEN-1] of byte;
  Escrito, Tamanho: Integer;
	ArqDestino: File;
	ESErro: Integer;
begin
  // Busca arquivo a ser extraído dentro arquivo zip
  Result := unzLocateFile(ArquivoUnZip, PChar(NomeArquivo), 2);
  if Result <> UNZ_OK then begin
    Result := -1;
    Exit;
  end;

  // Consistindo caminho de destino
  Destino := Trim(Destino);
  if Length(Destino) > 0 then begin
    if Destino[Length(Destino)] <> #92 then begin
      Destino := Destino + #92;
    end;
    if not DirectoryExists(Destino) then begin
      if not ForceDirectories(Destino) then begin
        Result := -2;
        Exit;
      end;
    end;
  end;

  // Abre o arquivo a ser extraído
  Result := unzOpenCurrentFile(ArquivoUnZip);
  if Result <> UNZ_OK then begin
    Result := -3;
    Exit;
  end;

  // Segmento de extração do arquivo desejado
  try
    // Cria em disco o arquivo que receberá o conteúdo do arquivo extraído
    AssignFile(ArqDestino, Destino+ExtractFileName(NomeArquivo));
    {$I-}
    Rewrite(ArqDestino, 1);
    {$I+}
    ESErro := IOResult;
    if (ESErro <> 0) then begin
      Result := -4;
      Exit;
    end;

    // Segmento de leitura/escrita do arquivo compactado
    try
      while (True) do begin
        Tamanho := unzReadCurrentFile(ArquivoUnZip, @Buffer, BUFLEN);
        if (Tamanho < 0) then begin
          Result := -5;
          Break;
        end else if (Tamanho = 0) then begin
          Result := 0;
          Break;
        end;

        {$I-}
        // Salva buffer do arquivo lido em disco
        BlockWrite(ArqDestino, Buffer, Tamanho, Escrito);
        {$I+}

        if (Escrito <> Tamanho) then begin
           Result := -6;
           Break;
        end;
      end;
    finally
      // Finaliza escrita do arquivo
      {$I-}
      Close(ArqDestino);
      {$I+}
      ESErro := IOResult;
      if (ESErro <> 0) then begin
        Result := -7;
      end;
    end;
  finally
    // Finaliza fechamento do arquivo desejado dentro do zip
    unzCloseCurrentFile(ArquivoUnZip);
  end;
end;

function FecharUnZip(ArquivoUnZip: unzFile): Integer;
begin
  If ArquivoUnZip = nil Then Begin
    Result := -1;
    Exit;
  End;
  Result := unzClose(ArquivoUnZip);
end;

end.
