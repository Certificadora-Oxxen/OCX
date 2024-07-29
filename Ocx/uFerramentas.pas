// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 31/07/2002
// *  Documentação       :
// *  Descrição Resumida : Biblioteca de Ferramenteas
// ************************************************************************
// *  Últimas Alterações
// *   Jerry    01/08/2002    Criação
// *   Hitalo   01/08/2002    Adicionar função digito Verificador CNPJ/CPF
// *   Arley    13/11/2002    Adição da função que realiza cópia de arquivo
// *   Fábio    03/02/2004    Adaptação da função digito Verificador SISBOV
// *   Fábio    14/07/2004    Inclusão da função de validação do NIRF/INCRA
// *
// ********************************************************************
unit uFerramentas;

interface

uses
  Windows, SysUtils, Math, DB, uIntClassesBasicas;

// Constantes utilizadas para chave na rotina de criptografia
const START_KEY      = 981;
const MULT_KEY       = 12674;
const ADD_KEY        = 35891;

function HexToInt(Value: String): Longint;
function Criptografar(InString: String): String;
function Descriptografar(InString: String): String;
function VerificarCnpjCpf(psNumSemDV,psNumDV, IndTrataCPFCNPJ : String) : boolean;
function ValidaLatitudeLongitude(const Valor: Extended; Tamanho,
  Decimais: Integer): boolean;
procedure AtribuiValorParametro(Parametro: TParam; Valor: Variant);
function BuscarDVSisBov(CodPaisSisBov,CodEstadoSisBov,CodMicroRegiaoSisBov,
  CodAnimalSisbov : Integer): integer;
function StrZero(inValue: integer; intTamanho: integer): string;
function PadR(Str, Carac: String; Tamanho : Integer): String;
function PadL(Str, Carac: String; Tamanho : Integer): String;
function RedimensionaString(Str: String; Tamanho: Integer): String;
function CopiaArquivo(Origem, Destino: String): Boolean;
function Win32_CopiaArquivo(Origem, Destino: String): Boolean;
function Win32_MoveArquivo(Origem, Destino: String): Boolean;
function ValidaNirfIncra(nirfIncra: String; IndObrigatorio: Boolean): Boolean; overload;
function ValidaNirfIncra(codTipoInscricao: Integer; nirfIncra: String; IndObrigatorio: Boolean): Boolean; overload;
function ehNumerico(valor: String): boolean;
function FormataCnpjCpf(Valor: String): String;
function FormataCodigoSISBOV(CodPaisSISBOV, CodEstadoSISBOV,
  CodMicroRegiaoSISBOV, CodAnimalSISBOV, NumDvSISBOV: Integer): String;
function ValidaCnpjCpf(Valor: String; IndValidaDV, IndObrigatorio: Boolean; IndTrataCPFCNPJ: String): Boolean;
procedure AtribuiParametro(QueryLocal: THerdomQuery; Valor: Integer;
  NomeParametro: String; ValorNull: Integer); Overload;
procedure AtribuiParametro(QueryLocal: THerdomQuery; Valor: String;
  NomeParametro: String; ValorNull: String); Overload;
procedure AtribuiParametro(QueryLocal: THerdomQuery; Valor: TDateTime;
  NomeParametro: String; ValorNull: TDateTime); Overload;
procedure AtribuiParametro(QueryLocal: THerdomQuery; Valor: Integer;
  NomeParametro: String; ValorValido: Boolean); Overload;

function RemoveAcentoString(Texto: String; IndTextoMaiusculas: Char): String;

function RetiraZerosEsquerda(EString: String): String;

implementation

uses Classes;

{* Converte uma string em hexadecimal para um valor inteiro.

  @param Value String em hexadecimal a ser convertida

  @return Numero inteiro com o valor da string}
function HexToInt(Value: String): Longint;
var
  I, D, P : Integer;
begin
  Result := 0;
  P := 0;
  for I := Length(Value) downto 1 do
  begin
    D := Ord(Value[I]);
    case D of
      48..57 : D := D - 48;
      65..70 : D := D - 55;
    else
      Result := -1;
      Exit;
    end;
    Result := Result + D * Trunc(Power(16, P));
    Inc(P);
  end;
end;

{* Criptografa uma string.

  @param InString String a ser criptografada

  @return String criptografada}
function Criptografar(InString: String): String;
var
  S : String;
  I : Byte;
  N, StartKey, MultKey, AddKey : Integer;
  E : String;
begin
  StartKey := START_KEY;
  AddKey := ADD_KEY;
  MultKey := MULT_KEY;
  S := String(InString);

  E := '';
  for I := 1 to Length(S) do
  begin
    N := (Byte(S[I]) xor (StartKey shr 8)) Mod 256;
    E := E + CHAR(N);
    StartKey := (Byte(E[I]) + StartKey) * MultKey + AddKey;
  end;

  Result := '';
  for I := 1 to Length(E) do
  begin
    Result := Result + IntToHex(Ord(E[I]), 2);
  end;
end;

{* Descriptografa uma string.

  @param InString String a ser descriptografada

  @return String descriptografada}
function Descriptografar(InString: String): String;
var
  S : String;
  I : Byte;
  N, StartKey, MultKey, AddKey : Integer;
  E : String;
begin
  StartKey := START_KEY;
  AddKey := ADD_KEY;
  MultKey := MULT_KEY;
  E := '';
  S := String(InString);

  I := 1;
  while I < Length(S) do
  begin
    E := E + Chr(HexToInt(Copy(S, I, 2)));
    Inc(I, 2);
  end;

  Result := '';
  for I := 1 to Length(E) do
  begin
    N := (Byte(E[I]) xor (StartKey shr 8)) mod 256;
    Result := Result + CHAR(N);
    StartKey := (Byte(E[I]) + StartKey) * MultKey + AddKey;
  end;
end;

{* Valida o CPF/CNPJ.

  @param psNumSemDV CNPJ/CPF sem os digitos verificadores. Devem ser informados
                    sómente os número do CNPJ/CPF, ou sem sem os pontos e traços.
  @param psNumDV CNPJ/CPF com os digitos verificadores. Devem ser informados
                 sómente os número do CNPJ/CPF, ou sem sem os pontos e traços.

  @return True se o CNPJ/CPF for válido e False se for inválido}
function VerificarCnpjCpf(psNumSemDV,psNumDV, IndTrataCPFCNPJ: String) : boolean;
var
  i,j,k, Soma, Digito : Integer;
  NumeroAux : String;
  CNPJ : Boolean;
begin
  //-------------------------------------------------------------
  //  Valida o cpf ou CNPJ adicionando os dois paramentros
  //  nos quais o primeiro traz o CNPJ ou CPF sem Digito
  //  Verificador, e o segundo parâmentro traz o CNPJ ou CPF
  //  sem Digito Verificador, trazendo no final dos cálculos
  //  o primeiro parâmetro com o digito verificador, comparando
  //  no final o CNPJ ou CPF  com o segundo parâmetro (CNPj ou CPF
  //  completo)
  //--------------------------------------------------------------
  NumeroAux := psNumSemDv;
  Result := false;

  case Length(psNumSemDv) of
    9:  CNPJ := False;
    12: CNPJ := True;
  else
    Exit;
  end;

  if CNPJ and (
    (psNumDV = '00000000000000') or
    (psNumDV = '11111111111111') or
    (psNumDV = '22222222222222') or
    (psNumDV = '33333333333333') or
    (psNumDV = '44444444444444') or
    (psNumDV = '55555555555555') or
    (psNumDV = '66666666666666') or
    (psNumDV = '77777777777777') or
    (psNumDV = '88888888888888') or
    (psNumDV = '99999999999999')) and (IndTrataCPFCNPJ = 'N') then
  begin
    Result := False;
    Exit;
  end
  else
  if (
    (psNumDV = '00000000000') or
    (psNumDV = '11111111111') or
    (psNumDV = '22222222222') or
    (psNumDV = '33333333333') or
    (psNumDV = '44444444444') or
    (psNumDV = '55555555555') or
    (psNumDV = '66666666666') or
    (psNumDV = '77777777777') or
    (psNumDV = '88888888888') or
    (psNumDV = '99999999999')) and (IndTrataCPFCNPJ = 'N') then
  begin
    Result := False;
    Exit;
  end;
  
  for j := 1 to 2 do
  begin
    k := 2;
    Soma := 0;
    for i := Length(NumeroAux) downto 1 do
    begin
      Soma := Soma + (Ord(NumeroAux[i])-Ord('0'))*k;
      Inc(k);
      if (k > 9) and CNPJ then
      begin
        k := 2;
      end;
    end;
    Digito := 11 - Soma mod 11;
    if Digito >= 10 then
    begin
      Digito := 0;
    end;
    NumeroAux := NumeroAux + Chr(Digito + Ord('0'));
  end;
  
  //------------------------------------
  //Compara o CNPJ ou CPF são idênticos
  //------------------------------------
  if NumeroAux = psNumDV then
  begin
    result := true
  end
  else
  begin
    result := false;
  end;
end;

{* Verifica se a Latitude ou Longitude informada é válida.

  @param Valor Latitudo/Longitude a ser validada
  @param Tamanho Tamanho do Número
  @param Decimais Quantidade de casas decimais

  @return True se o valor for válido ou False caso contrário}
function ValidaLatitudeLongitude(const Valor: Extended; Tamanho, Decimais: Integer): boolean;
var
  S1,
  S2,
  AddZero: String;
  X,
  nGrau,
  nMin,
  nSeg: Integer;
begin
  result := true;

  if Decimais > 0 then
  begin
    S1 := FloatToStrF(Valor, ffNumber, 30, Decimais);
  end
  else
  begin
    S1 := IntToStr(Trunc(Valor));
  end;

  if Length(S1) > Tamanho then
  begin
    AddZero := '';
    for X := 1 To Tamanho do
    begin
      AddZero := AddZero + '#';
    end;
    result := false;
    Exit;
  end;

  AddZero := '';
  for X := 1 to (Tamanho - Length(S1)) do
  begin
    AddZero := AddZero + '0';
  end;

  //---------------------------------------------------
  // Adiconar zero as esquerda para igualar ao tamanho
  // passado pelo parametro Tamanho
  //---------------------------------------------------
  S2 := AddZero + S1;

  //----------------------------------------------
  //Obtem a String Formatado com Zeros a esquerda
  // S2 tem que ser do tamanho ao parametro Tamanho.
  //---------------------------------------------
  if Length(S2) = Tamanho then
  begin
    nGrau := StrToInt(Copy(S2,1,2));
    nMin  := StrToInt(Copy(S2,3,2));
    nSeg  := StrToInt(Copy(S2,5,2));

    if (nGrau < 0) or (nGrau > 90) then
    begin
      result:= false;
      exit;
    end
    else
    if (nMin < 0) or (nMin > 59) then
    begin
      result:= false;
      exit;
    end
    else
    if (nSeg < 0) or (nSeg > 59) then
    begin
      result:= false;
      exit;
    end;
  end
  else
  begin
     result:= false;
  end;
end;

procedure AtribuiValorParametro(Parametro: TParam; Valor: Variant);
begin
  if ((Parametro.DataType = ftInteger) and (Valor <> -1))
  or ((Parametro.DataType = ftString) and (Trim(Valor) <> ''))
  or ((Parametro.DataType = ftMemo) and (Trim(Valor) <> ''))
  or ((Parametro.DataType = ftDateTime) and (Valor > 0)) then
    Parametro.Value := Valor
  else
    Parametro.Clear;
end;

function BuscarDVSisBov(CodPaisSisBov,CodEstadoSisBov,CodMicroRegiaoSisBov,CodAnimalSisbov : Integer): integer;
var
  Soma, Mult, Modulo, X, TamCodSisBov : Integer;
  CodSisbov : String;
begin
  // Se o codigo da micro regiao for 99, para o calculo do digito, o mesmo
  // sera substituido por 00. Pois, o SISBOV retirou o código a micro regiao
  // da composicao do codigo sisbov.
  if CodMicroRegiaoSisbov = 99 then CodMicroRegiaoSisbov := 0;
  //**********

  // Se o codigo da micro regiao for -1, para o calculo do digito, o mesmo
  // sera removido. Pois, o SISBOV retirou o código a micro regiao
  // da composicao do codigo sisbov.
  if CodMicroRegiaoSisbov = -1 then
    CodSisbov := StrZero(CodPaisSisbov, 3) +
                 StrZero(CodEstadoSisbov, 2) +
                 StrZero(CodAnimalSisbov, 9)
  else
    CodSisbov := StrZero(CodPaisSisbov, 3) +
                 StrZero(CodEstadoSisbov, 2) +
                 StrZero(CodMicroRegiaoSisbov, 2) +
                 StrZero(CodAnimalSisbov, 9);

  TamCodSisBov := Length(CodSisbov);

  Soma := 0;
  Mult := 2;
  for X := TamCodSisBov downto 1 do begin
    Soma := Soma + (Mult * StrToInt(Copy(CodSisbov, X, 1)));
    Inc(Mult);
    if Mult > 9 then begin
      Mult := 2;
    end;
  end;

  Modulo := Soma mod 11;
  if (Modulo = 0) or (Modulo = 1) then begin
    Result := 0;
  end else begin
    Result := 11 - Modulo;
  end;
end;

function StrZero(inValue: integer; intTamanho: integer): string;
begin
  Result := IntToStr(inValue);
  while Length(Result) < intTamanho do
    Result := '0' + Result;
end;

function PadR(Str, Carac: String; Tamanho : Integer): String;
var Cont: Integer;
begin
  Str := Copy(Str, 1, Tamanho);
  Cont := Length(Str);
  Result := Str;
  while Cont < Tamanho do begin
    Result := Result + Carac;
    Inc(Cont);
  end;
end;

function PadL(Str, Carac: String; Tamanho : Integer): String;
var Cont: Integer;
begin
  Str := Copy(Str, 1, Tamanho);
  Cont := Length(Str);
  Result := Str;
  while Cont < Tamanho do begin
    Result := Carac + Result;
    Inc(Cont);
  end;
end;

function RedimensionaString(Str: String; Tamanho: Integer): String;
begin
  if (Length(Str) > Tamanho) and (Tamanho > 0) then begin
    Result := Copy(Str, 1, Tamanho-3) + '...';
  end else begin
    Result := Str;
  end;
end;

function CopiaArquivo(Origem, Destino: String): Boolean;
var
  iOrigem, iDestino: Integer;
  iFileLength, iAux: Cardinal;
  pBuffer: PChar;
begin
  // Consiste existência do arquivo de origem
  Result := FileExists(Origem);
  if not Result then Exit;
  // Abre arquivo de origem
  iOrigem := FileOpen(Origem, fmOpenRead);
  Result := not(iOrigem = -1);
  if not Result then Exit;
  // Cria arquivo de destino
  iDestino := FileCreate(Destino);
  Result := not(iDestino = -1);
  if not Result then begin
    FileClose(iOrigem);
    Exit;
  end;
  try
    Result := False;
    // Copia conteudo do arquivo de origem byte-a-byte
    iFileLength := FileSeek(iOrigem,0,2);
    FileSeek(iOrigem,0,0);
    for iAux := 1 to iFileLength do begin
      FileRead(iOrigem, pBuffer, 1);
      FileWrite(iDestino, pBuffer, 1);
    end;
    // Identifica operação bem sucedida
    Result := True;
  finally
    // Encerra processamento de copia
    FileClose(iDestino);
    FileClose(iOrigem);
  end;
end;

function Win32_CopiaArquivo(Origem, Destino: String): Boolean;
begin
  Result := CopyFile(PChar(Origem), PChar(Destino), False);
end;

function Win32_MoveArquivo(Origem, Destino: String): Boolean;
begin
  Result := MoveFile(PChar(Origem), PChar(Destino));
end;

{* Função responsavel para validar se o valor é um numero do incra ou um
  nirf válido

  @param nirfIncra String com o valor do nirf ou incra.
  @param IndObrigatorio Variavel booleana que indica que o valor deve ser obrigatorio.
                        se o valor desta variavel for false e a variavel nirfIncra
                        for vazia o retorno da função sera falso.

  @return Retoroa true se o nirfInca for um numero nirf ou incra valido.}
function ValidaNirfIncra(nirfIncra: String; IndObrigatorio: Boolean): Boolean;
var
  valor: String;
begin
  Result := False;
  valor := Trim(nirfIncra);

  { Se a string for vazia e o valor for obrigatorio retorna false, }
  { caso contrario retorna true                                    }
  if (valor = '') then
  begin
//    if not IndObrigatorio then    {NIRF DEIXOU DE SER OBRIGATÓRIO NO NOVO SISBOV - JERRY 09/03/2007}
      Result := True;

    Exit;
  end;

  { Verfica se o valor é um Nirf, se for retorna true }
  if Length(valor) = 8 then
  begin
    Result := ehNumerico(Valor);
    Exit;
  end;

  { Se o valor é um numero INCRA valida o Digito verificador }
  if Length(valor) = 13 then
  begin
    Result := ehNumerico(Valor);
    Exit;
  end;
end;

{* Função responsavel para validar se o valor é um numero do incra ou um
  nirf válido

  @param codTipoInscricao  Inteiro identificando o tipo do valor.
  @param nirfIncra  String com o valor do nirf ou incra.
  @param IndObrigatorio  Variavel booleana que indica que o valor deve ser obrigatorio.
                         se o valor desta variavel for false e a variavel nirfIncra
                         for vazia o retorno da função sera falso.

  @return Retoroa true se o nirfInca for um numero nirf ou incra valido.}
function ValidaNirfIncra(codTipoInscricao: Integer; nirfIncra: String; IndObrigatorio: Boolean): Boolean;
var
  valor: String;
begin
  Result := False;
  valor := Trim(nirfIncra);

  { Se a string for vazia e o valor for obrigatorio retorna false, }
  { caso contrario retorna true                                    }
  if (valor = '') then
  begin
//    if not IndObrigatorio then       {NIRF DEIXOU DE SER OBRIGATÓRIO NO NOVO SISBOV - JERRY 09/03/2007}
      Result := True;

    Exit;
  end;

  { Verfica se o valor é um Nirf, se for retorna true }
  if (codTipoInscricao = 1) and (Length(valor) = 8) then
  begin
    Result := ehNumerico(Valor);
    Exit;
  end;

  { Se o valor é um numero INCRA valida o Digito verificador }
  if (codTipoInscricao = 2) and (Length(valor) = 13) then
  begin
    Result := ehNumerico(Valor);
    Exit;
  end;
end;

{* Valida se a string possui somente caracteres numericos

  @param nirfIncra String a ser validada

  @return Retoroa true se a string possuir somente caracteres numericos
    e false caso contrario}
function ehNumerico(valor: String): boolean;
var
  I: Integer;
begin
  Result := True;

  I := 1;
  while Result and (I <= Length(valor)) do
  begin
    if not (valor[I] in ['1', '2', '3', '4', '5' ,'6', '7','8', '9', '0']) then
      Result := False;
    Inc(I);
  end;
end;

{* Se o valor informado for um CNPJ ou CPF retorna o valor formatado.

  @param Valor String a ser formatada

  @return Se for um CNPJ retorna no formato XX.XXX.XXX/XXXX-XX
    Se for um CPF  retorna no formato XXX.XXX.XXX-XX
    Se não retorna o mesmo valor.}
function FormataCnpjCpf(Valor: String): String;
begin
  if Length(Valor) = 14 then // Formata se for CNPJ
  begin
    Result := Copy(Valor, 1, 2) + '.' + Copy(Valor, 3, 3) + '.' +
      Copy(Valor, 6, 3) + '/' + Copy(Valor, 9, 4) + '-' + Copy(Valor, 13, 2);
  end
  else if Length(valor) = 11 then // Formata se for CPF
  begin
    Result := Copy(Valor, 1, 3) + '.' + Copy(Valor, 4, 3) + '.' +
      Copy(Valor, 7, 3) + '-' + Copy(Valor, 10, 2);
  end
  else // Retorna o mesmo valor se não for um CNPJ/CPF
  begin
    Result := Valor;
  end;
end;

{ Valida o CNPJ/CPF informado.

  @param Valor CNPJ/CPF
  @param IndObrigatorio Indicador se o valor pode ser diferente de vazio
  @param IndValidaDV Indica se o Digito Verificador deve ser verificado

  @return Se for um CNPJ/CPF válido retorna True, caso contrário False}
function ValidaCnpjCpf(Valor: String; IndValidaDV, IndObrigatorio: Boolean; IndTrataCPFCNPJ: String): Boolean;
begin
  Result := False;
  Valor := Trim(Valor);

  // Verifica se o valor é obrigatório mas não foi informado
  if (Valor = '') and IndObrigatorio then
  begin
    Exit;
  end;

  // Verifica se o CNPJ/CPF é valido
  if Valor <> '' then
  begin
    if (Length(Valor) = 11) or (Length(Valor) = 14) and ehNumerico(Valor) then
    begin
      if IndValidaDV then
      begin
        Result := VerificarCnpjCpf(Copy(Valor, 1, Length(Valor) - 2), Valor, IndTrataCPFCNPJ);
      end
      else
      begin
        Result := True;
      end;
    end;
  end
  else
  begin
    Result := True;
  end;
end;

{* Atribui um valor ao parametro. Se o valor do parametro for nulo limpa o
  parametro e atribui nulo

  @param QueryLocal Query para defirnir os parametros
  @param Valor Valor a ser atribuido ao parametro
  @param NomeParametro Nome do parametro
  @param ValorValido Boleando que indica que a variavel é nula}
procedure AtribuiParametro(QueryLocal: THerdomQuery; Valor: Integer;
  NomeParametro: String; ValorValido: Boolean);
begin
  with QueryLocal.ParamByName(NomeParametro) do
  begin
    if not ValorValido then
    begin
      DataType := ftInteger;
      Clear;
      Bound := True;
    end
    else
    begin
      AsInteger := Valor;
    end;
  end;
end;

{* Atribui um valor ao parametro. Se o valor do parametro for nulo limpa o
  parametro e atribui nulo

  @param QueryLocal Query para defirnir os parametros
  @param Valor Valor a ser atribuido ao parametro
  @param NomeParametro Nome do parametro
  @param ValorNull Valor que indica que a variavel é nula}
procedure AtribuiParametro(QueryLocal: THerdomQuery; Valor: Integer;
  NomeParametro: String; ValorNull: Integer);
begin
  AtribuiParametro(QueryLocal, Valor, NomeParametro, ValorNull <> Valor);
end;

{* Atribui um valor ao parametro. Se o valor do parametro for nulo limpa o
  parametro e atribui nulo

  @param QueryLocal Query para defirnir os parametros
  @param Valor Valor a ser atribuido ao parametro
  @param NomeParametro Nome do parametro
  @param ValorNull Valor que indica que a variavel é nula}
procedure AtribuiParametro(QueryLocal: THerdomQuery;
  Valor, NomeParametro, ValorNull: String);
begin
  with QueryLocal.ParamByName(NomeParametro) do
  begin
    if Valor = ValorNull then
    begin
      DataType := ftString;
      Clear;
      Bound := True;
    end
    else
    begin
      AsString := Valor;
    end;
  end;
end;

{* Atribui um valor ao parametro. Se o valor do parametro for nulo limpa o
 parametro e atribui nulo

  @param QueryLocal Query para defirnir os parametros
  @param Valor Valor a ser atribuido ao parametro
  @param NomeParametro Nome do parametro
  @param ValorNull Valor que indica que a variavel é nula}
procedure AtribuiParametro(QueryLocal: THerdomQuery; Valor: TDateTime;
  NomeParametro: String; ValorNull: TDateTime);
begin
  with QueryLocal.ParamByName(NomeParametro) do
  begin
    if Valor = ValorNull then
    begin
      DataType := ftString;
      Clear;
      Bound := True;
    end
    else
    begin
      AsDateTime := Valor;
    end;
  end;
end;

function RemoveAcentoString(Texto: String; IndTextoMaiusculas: Char): String;
var
  i: Integer;
  sTexto: String;
begin
  if Length(Trim(Texto)) = 0 then begin
    Result := '';
    Exit;
  end;
  sTexto := Texto;
  for i := 0 to Length(Trim(sTexto)) do begin
    case Texto[i] of
      // Letra A
      'à': sTexto[i] := 'a';
      'À': sTexto[i] := 'A';
      'á': sTexto[i] := 'a';
      'Á': sTexto[i] := 'A';
      'â': sTexto[i] := 'a';
      'Â': sTexto[i] := 'A';
      'ã': sTexto[i] := 'a';
      'Ã': sTexto[i] := 'A';
      'ä': sTexto[i] := 'a';
      'Ä': sTexto[i] := 'A';

      // Letra E
      'è': sTexto[i] := 'e';
      'È': sTexto[i] := 'E';
      'é': sTexto[i] := 'e';
      'É': sTexto[i] := 'E';
      'ê': sTexto[i] := 'e';
      'Ê': sTexto[i] := 'E';
      'ë': sTexto[i] := 'e';
      'Ë': sTexto[i] := 'E';

      // Letra I
      'ì': sTexto[i] := 'i';
      'Ì': sTexto[i] := 'I';
      'í': sTexto[i] := 'i';
      'Í': sTexto[i] := 'I';
      'î': sTexto[i] := 'i';
      'Î': sTexto[i] := 'I';
      'ï': sTexto[i] := 'i';
      'Ï': sTexto[i] := 'I';

      // Letra O
      'ò': sTexto[i] := 'o';
      'Ò': sTexto[i] := 'O';
      'ó': sTexto[i] := 'o';
      'Ó': sTexto[i] := 'O';
      'ô': sTexto[i] := 'o';
      'Ô': sTexto[i] := 'O';
      'õ': sTexto[i] := 'o';
      'Õ': sTexto[i] := 'O';
      'ö': sTexto[i] := 'o';
      'Ö': sTexto[i] := 'O';

      // Letra U
      'ù': sTexto[i] := 'u';
      'Ù': sTexto[i] := 'U';
      'ú': sTexto[i] := 'u';
      'Ú': sTexto[i] := 'U';
      'û': sTexto[i] := 'u';
      'Û': sTexto[i] := 'U';
      'ü': sTexto[i] := 'u';
      'Ü': sTexto[i] := 'U';

      // Letra Ç
      'ç': sTexto[i] := 'c';
      'Ç': sTexto[i] := 'C';

{      //Acentos
      '´': sTexto[i] := '';
      '`': sTexto[i] := '';
      '~': sTexto[i] := '';
      '^': sTexto[i] := '';
      '¨': sTexto[i] := ''; }
    end;
  end;
  // Transforma o texto para MAIUSCULAS!
  if (UpperCase(IndTextoMaiusculas) = 'S') then
    sTexto := UpperCase(sTexto);

  Result := sTexto;
end;

function FormataCodigoSISBOV(CodPaisSISBOV, CodEstadoSISBOV,
  CodMicroRegiaoSISBOV, CodAnimalSISBOV, NumDvSISBOV: Integer): String;
begin
  Result := StrZero(CodPaisSISBOV, 3) + StrZero(CodEstadoSISBOV, 2);
  if CodMicroRegiaoSISBOV <> -1 then begin
    Result := Result + StrZero(CodMicroRegiaoSISBOV, 2);
  end;
  Result := Result + StrZero(CodAnimalSISBOV, 9) + StrZero(NumDvSISBOV, 1);
end;

function RetiraZerosEsquerda(EString: String): String;
var
  i: Integer;
  EncontrouPrimeiroCaracter: Boolean;
begin
  Result := '';

  if Length(Trim(EString)) = 0 then
  begin
    Exit;
  end;

  EncontrouPrimeiroCaracter := False;
  for i := 1 to Length(EString) do
  begin
    if EString[i] <> '0' then
    begin
      EncontrouPrimeiroCaracter := True;
      Result := Result + EString[i];
    end
    else
    begin
      if not EncontrouPrimeiroCaracter then
      begin
        EncontrouPrimeiroCaracter := False;
      end
      else
      begin
        Result := Result + EString[i];
      end;
    end;
  end;
end;

end.
