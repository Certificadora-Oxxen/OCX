unit uFerramentas;

interface

uses
  Windows, SysUtils, Math;

function ehNumerico(valor: String): boolean;
function ValidaCnpjCpf(Valor: String; IndValidaDV, IndObrigatorio: Boolean): Boolean;
function VerificarCnpjCpf(psNumSemDV,psNumDV : String) : boolean;
                                            
implementation

{*******************************************************************************
* Valida se a string possui somente caracteres numericos
*
* Parametros de Entrada:
*      nirfIncra - String a ser validada
*
* Retorno:
*    Retoroa true se a string possuir somente caracteres numericos
*    e false caso contrario
*******************************************************************************}
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


{*******************************************************************************
* Valida o CNPJ/CPF informado.
*
* Parametros de Entrada:
*      Valor: CNPJ/CPF
*      IndObrigatorio: Indicador se o valor pode ser diferente de vazio
*      IndValidaDV: Indica se o Digito Verificador deve ser verificado.
*
* Retorno:
*    Se for um CNPJ/CPF válido retorna True, caso contrário False.
*******************************************************************************}
function ValidaCnpjCpf(Valor: String; IndValidaDV, IndObrigatorio: Boolean): Boolean;
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
      Result := VerificarCnpjCpf(Copy(Valor, 1, Length(Valor) - 2),
        Copy(Valor, Length(Valor) - 1, 2));
    end;
  end
  else
  begin
    Result := True;
  end;
end;

function VerificarCnpjCpf(psNumSemDV,psNumDV : String) : boolean;
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
  (psNumDV = '11111111111111') or
  (psNumDV = '22222222222222') or
  (psNumDV = '33333333333333') or
  (psNumDV = '44444444444444') or
  (psNumDV = '55555555555555') or
  (psNumDV = '66666666666666') or
  (psNumDV = '77777777777777') or
  (psNumDV = '88888888888888') or
  (psNumDV = '99999999999999')) then begin
    Result := False;
    Exit;
  end else if (
  (psNumDV = '11111111111') or
  (psNumDV = '22222222222') or
  (psNumDV = '33333333333') or
  (psNumDV = '44444444444') or
  (psNumDV = '55555555555') or
  (psNumDV = '66666666666') or
  (psNumDV = '77777777777') or
  (psNumDV = '88888888888') or
  (psNumDV = '99999999999')) then begin
    Result := False;
    Exit;
  end;
  
  for j := 1 to 2 do begin
    k := 2;
    Soma := 0;
    for i := Length(NumeroAux) downto 1 do  begin
      Soma := Soma + (Ord(NumeroAux[i])-Ord('0'))*k;
      Inc(k);
      if (k > 9) and CNPJ then
        k := 2;
    end;
    Digito := 11 - Soma mod 11;
    if Digito >= 10 then
      Digito := 0;
    NumeroAux := NumeroAux + Chr(Digito + Ord('0'));
  end;
  //------------------------------------
  //Compara o CNPJ ou CPF são idênticos
  //------------------------------------
  if (NumeroAux = (psNumSemDV + psNumDV)) then
    result := true
  else
    result := false;
end;

end.
