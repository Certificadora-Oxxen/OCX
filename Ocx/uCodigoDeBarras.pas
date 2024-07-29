unit uCodigoDeBarras;

interface

uses
  Classes, SysUtils, Graphics, Math, barcode;

type

  TOrientacao = (oHorizontal, oVertical);

  TLegenda = (lOculta, lApresentada);

  TCodigoDeBarras2De5Intercalado = class(TAsBarcode)
  private
    FOrientacao: TOrientacao;
    FLegenda: TLegenda;
    function getAltura: Integer;
    procedure setAltura(const Value: Integer);
  public
    constructor Create(Owner: TComponent); override;
    function GetBitmap(Digitos: String): TBitmap;
  published
    property Orientacao: TOrientacao read FOrientacao write FOrientacao;
    property Legenda: TLegenda read FLegenda write FLegenda;
    property Altura: Integer read getAltura write setAltura;
  end;

  EDigitosInvalidos = class(Exception)
  end;

implementation

{ TCodigoDeBarras2De5Intercalado }

constructor TCodigoDeBarras2De5Intercalado.Create(Owner: TComponent);
begin
  inherited;
  Top := 1;
  Left := 1;
  Typ := bcCode_2_5_interleaved;
  Modul := 2;
  Ratio := 2.0;
  Height := 30;
  Angle := 0;
  FOrientacao := oHorizontal;
  FLegenda := lOculta;
end;

function TCodigoDeBarras2De5Intercalado.getAltura: Integer;
begin
  Result := Height;
end;

function TCodigoDeBarras2De5Intercalado.GetBitmap(Digitos: String): TBitmap;
const
  Fonte_Nome: String = 'MS Sans Serif';
  Fonte_Tamanho: Integer = 14;
var
  X, iX, Y, iY: Integer;
  BmpTexto: TBitmap;
begin
  // Define retorno sem sucesso
  Result := nil;
  Digitos := Trim(Digitos);

  // Verifica se os dígitos foram informados
  if Trim(Digitos) = '' then begin
    exit;
  end;

  // Se quantidade de dígitos for ímpar, então adiciona um zero à esquerda
  if Odd(Length(Digitos)) then begin
    Digitos := '0' + Digitos;
  end;

  // Verifica se somente dígitos numérios foram informados
  for iX := 1 to Length(Digitos) do begin
    if not(Digitos[iX] in ['0'..'9']) then begin
      raise EDigitosInvalidos.Create('Somente dígitos numéricos podem ser '+
        'representados no formato de código de barras 2 de 5 intercalado');
    end;
  end;

  // Define os dígitos a serem impressos
  Text := Digitos;

  // Gera imagem final
  Result := TBitmap.Create;

  // Verifica orientação
  case Orientacao of
    oHorizontal:
      begin
        // Define dimensões e inclinação da imagem
        if Legenda = lApresentada then begin
          Result.Height := 56;
        end else begin
          Result.Height := 33;
        end;
        Result.Width := 300;
        Angle := 0;
      end;
    oVertical:
      begin
        // Define dimensões e incluinação da imagem
        if Legenda = lApresentada then begin
          Result.Width := 56;
        end else begin
          Result.Width := 33;
        end;
//        Result.Height := 215;
        Result.Height := 300;
        Angle := 90;
      end;
  end;

  // Desenha o código de barras
  DrawBarcode(Result.Canvas);

  if Legenda = lApresentada then begin
    if Orientacao = oHorizontal then begin
      // Define a fonte a ser utilizada
      Result.Canvas.Font.Name := Fonte_Nome;
      Result.Canvas.Font.Size := Fonte_Tamanho;

      // Define real posição do texto dentro da imagem
      X := (Result.Width - Result.Canvas.TextWidth(Text)) div 2;
      Y := self.Top + self.Height + 1;

      // Escreve texto definitivo (na horizontal)
      Result.Canvas.TextOut(X, Y, Text);
    end else begin
      // Gera imagem auxiliar para texto na vertical
      BmpTexto := TBitmap.Create;
      try
        // Define a fonte a ser utilizada
        BmpTexto.Canvas.Font.Name := Fonte_Nome;
        BmpTexto.Canvas.Font.Size := Fonte_Tamanho;

        // Define dimensões
        BmpTexto.Height := BmpTexto.Canvas.TextHeight(Text);
        BmpTexto.Width := BmpTexto.Canvas.TextWidth(Text);

        // Escreve o texto provisório (na horizontal)
        BmpTexto.Canvas.TextOut(0, 0, Text);

        // Define real posição do texto dentro da imagem final
        X := self.Left + self.Height + 1;
        Y := Result.Height - (Result.Height - BmpTexto.Width) div 2;

        // Escreve como definitivo o texto provisório invertido (na vertical)
        for iX := 0 to BmpTexto.Width-1 do begin
          for iY := 0 to BmpTexto.Height-1 do begin
            Result.Canvas.Pixels[X + iY, Y - iX] := BmpTexto.Canvas.Pixels[iX, iY];
          end;
        end;
      finally
        BmpTexto.Free;
      end;
    end;
  end;
end;

procedure TCodigoDeBarras2De5Intercalado.setAltura(const Value: Integer);
begin
  if Height <> Value then Height := Value;
end;

end.
