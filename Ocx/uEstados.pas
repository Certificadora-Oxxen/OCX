// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 19/07/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Cadastro de Estados
// ********************************************************************
// *  Últimas Alterações
// *   Hitalo    19/07/2002    Criação
// *
// *
// ********************************************************************
unit uEstados;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao, uIntMensagens,
  uIntEstados,uEstado;

type
  TEstados = class(TASPMTSObject, IEstados)
  private
    FIntEstados     : TIntEstados;
    FInicializado   : Boolean;
    FEstado         : TEstado;
  protected
    function EOF: WordBool; safecall;
    function Pesquisar(CodPais: Integer;
      const CodOrdenacao: WideString): Integer; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
    function Alterar(CodEstado: Integer; const NomEstado,
      SglEstado: WideString; CodEstSisBov: Integer): Integer; safecall;
    function Inserir(const NomEstado, SglEstado: WideString; CodEstSisBov,
      CodPais: Integer): Integer; safecall;
    function Excluir(CodEstado: Integer): Integer; safecall;
    function BOF: WordBool; safecall;
    function Buscar(CodEstado: Integer): Integer; safecall;
    function NumeroRegistros: Integer; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoUltimo; safecall;
    procedure IrAoAnterior; safecall;
    function Deslocar(NumDeslocamento: Integer): Integer; safecall;
    procedure Posicionar(NumPosicao: Integer); safecall;
    function Get_Estado: IEstado; safecall;
  Public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TEstados.AfterConstruction;
begin
  inherited;
  FEstado := TEstado.Create;
  FEstado.ObjAddRef;
  FInicializado := False;
end;

procedure TEstados.BeforeDestruction;
begin
  If FIntEstados <> nil Then Begin
    FIntEstados.Free;
  End;
  If FEstado <> nil Then Begin
    FEstado.ObjRelease;
    FEstado := nil;
  End;
  inherited;
end;

function TEstados.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntEstados := TIntEstados.Create;
  Result := FIntEstados.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TEstados.EOF: WordBool;
begin
  Result := FIntEstados.EOF;
end;

function TEstados.Pesquisar(CodPais: Integer;
  const CodOrdenacao: WideString): Integer;
begin
  Result := FIntEstados.Pesquisar(CodPais,CodOrdenacao);
end;

function TEstados.ValorCampo(const NomeColuna: WideString): OleVariant;
begin
  Result := FIntEstados.ValorCampo(NomeColuna);
end;

procedure TEstados.FecharPesquisa;
begin
  FIntEstados.FecharPesquisa;
end;

procedure TEstados.IrAoProximo;
begin
  FIntEstados.IrAoProximo;
end;

function TEstados.Alterar(CodEstado: Integer; const NomEstado,
  SglEstado: WideString; CodEstSisBov: Integer): Integer;
begin
  result :=  FIntEstados.Alterar(CodEstado,NomEstado,
                                  SglEstado,CodEstSisBov);
end;

function TEstados.Inserir(const NomEstado, SglEstado: WideString;
  CodEstSisBov, CodPais: Integer): Integer;
begin
  result :=  FIntEstados.Inserir(NomEstado, SglEstado,CodEstSisBov, CodPais);
end;

function TEstados.Excluir(CodEstado: Integer): Integer;
begin
  result :=  FIntEstados.Excluir(CodEstado);
end;

function TEstados.BOF: WordBool;
begin
  result :=  FIntEstados.BOF;
end;

function TEstados.Buscar(CodEstado: Integer): Integer;
begin
  result :=  FIntEstados.Buscar(CodEstado);
end;

function TEstados.NumeroRegistros: Integer;
begin
  result :=  FIntEstados.NumeroRegistros;
end;

procedure TEstados.IrAoPrimeiro;
begin
  FIntEstados.IrAoPrimeiro;
end;

procedure TEstados.IrAoUltimo;
begin
  FIntEstados.IrAoUltimo;
end;

procedure TEstados.IrAoAnterior;
begin
  FIntEstados.IrAoAnterior;
end;

function TEstados.Deslocar(NumDeslocamento: Integer): Integer;
begin
  result := FIntEstados.Deslocar(NumDeslocamento);
end;

procedure TEstados.Posicionar(NumPosicao: Integer);
begin
  FIntEstados.Posicionar(NumPosicao);
end;

function TEstados.Get_Estado: IEstado;
begin
  FEstado.CodEstado         :=  FIntEstados.IntEstado.CodEstado;
  FEstado.NomEstado         :=  FIntEstados.IntEstado.NomEstado;
  FEstado.SglEstado         :=  FIntEstados.IntEstado.SglEstado;
  FEstado.CodEstadoSisbov   :=  FIntEstados.IntEstado.CodEstadoSisbov;
  FEstado.CodPais           :=  FIntEstados.IntEstado.CodPais;
  FEstado.NomPais           :=  FIntEstados.IntEstado.NomPais;
  FEstado.CodPaisSisbov     :=  FIntEstados.IntEstado.CodPaisSisbov;
  Result := FEstado;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TEstados, Class_Estados,
    ciMultiInstance, tmApartment);
end.
