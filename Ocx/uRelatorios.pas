unit uRelatorios;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uIntRelatorios, uIntMensagens,
  uConexao, uRelatorio;

type
  TRelatorios = class(TASPMTSObject, IRelatorios)
  private
    FIntRelatorios: TIntRelatorios;
    FInicializado: Boolean;
    FRelatorio: TRelatorio;
  protected
    function Buscar(CodRelatorio: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function Personalizar(CodRelatorio, CodOrientacao,
      CodTamanhoFonte: Integer; const TxtSubTitulo,
      CodCampos: WideString): Integer; safecall;
    function Pesquisar(CodRelatorio: Integer): Integer; safecall;
    function ValorCampo(const NomCampo: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
    function Get_Relatorio: IRelatorio; safecall;
    procedure IrAoPrimeiro; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TRelatorios.AfterConstruction;
begin
  inherited;
  FRelatorio := TRelatorio.Create;
  FRelatorio.ObjAddRef;
  FInicializado := False;
end;

procedure TRelatorios.BeforeDestruction;
begin
  If FIntRelatorios <> nil Then Begin
    FIntRelatorios.Free;
  End;
  If FRelatorio <> nil Then Begin
    FRelatorio.ObjRelease;
    FRelatorio := nil;
  End;
  inherited;
end;

function TRelatorios.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntRelatorios := TIntRelatorios.Create;
  Result := FIntRelatorios.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TRelatorios.Buscar(CodRelatorio: Integer): Integer;
begin
  Result := FIntRelatorios.Buscar(CodRelatorio);
end;

function TRelatorios.EOF: WordBool;
begin
  Result := FIntRelatorios.EOF;
end;

function TRelatorios.Personalizar(CodRelatorio, CodOrientacao,
  CodTamanhoFonte: Integer; const TxtSubTitulo,
  CodCampos: WideString): Integer;
begin
  Result := FIntRelatorios.Personalizar(CodRelatorio, CodOrientacao,
    CodTamanhoFonte, TxtSubTitulo, CodCampos);
end;

function TRelatorios.Pesquisar(CodRelatorio: Integer): Integer;
begin
  Result := FIntRelatorios.Pesquisar(CodRelatorio);
end;

function TRelatorios.ValorCampo(const NomCampo: WideString): OleVariant;
begin
  Result := FIntRelatorios.ValorCampo(NomCampo);
end;

procedure TRelatorios.FecharPesquisa;
begin
  FIntRelatorios.FecharPesquisa;
end;

procedure TRelatorios.IrAoProximo;
begin
  FIntRelatorios.IrAoProximo;
end;

function TRelatorios.Get_Relatorio: IRelatorio;
begin
  FRelatorio.CodRelatorio := FIntRelatorios.IntRelatorio.CodRelatorio;
  FRelatorio.TxtTitulo := FIntRelatorios.IntRelatorio.TxtTitulo;
  FRelatorio.QtdColunas := FIntRelatorios.IntRelatorio.QtdColunas;
  FRelatorio.CodOrientacao := FIntRelatorios.IntRelatorio.CodOrientacao;
  FRelatorio.CodTamanhoFonte := FIntRelatorios.IntRelatorio.CodTamanhoFonte;
  FRelatorio.IndPersonalizavel := FIntRelatorios.IntRelatorio.IndPersonalizavel;
  FRelatorio.TxtSubTitulo := FIntRelatorios.IntRelatorio.TxtSubTitulo;
  Result := FRelatorio;
end;

procedure TRelatorios.IrAoPrimeiro;
begin
  FIntRelatorios.IrAoPrimeiro;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TRelatorios, Class_Relatorios,
    ciMultiInstance, tmApartment);
end.
