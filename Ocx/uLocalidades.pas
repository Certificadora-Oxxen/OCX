// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Hitalo Cordeiro Silva
// *  Versão             : 1
// *  Data               : 06/08/2002
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Cadastro de Localidades
// ********************************************************************
// *  Últimas Alterações
// *   Jerry    06/08/2002    Criação
// *
// *
// ********************************************************************
unit uLocalidades;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl, uConexao, uIntMensagens, uIntLocalidades,
  uLocalidade;

type
  TLocalidades = class(TASPMTSObject, ILocalidades)
  private
    FIntLocalidades : TIntLocalidades;
    FInicializado : Boolean;
    FLocalidade: TLocalidade;
  protected
    function BOF: WordBool; safecall;
    function Deslocar(QtdRegistros: Integer): Integer; safecall;
    function EOF: WordBool; safecall;
    function Get_Localidade: ILocalidade; safecall;
    function NumeroRegistros: Integer; safecall;
    function ValorCampo(const NomeColuna: WideString): OleVariant; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoAnterior; safecall;
    procedure IrAoPrimeiro; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoUltimo; safecall;
    procedure Posicionar(NumRegistro: Integer); safecall;
    function Pesquisar(CodPais, CodEstado: Integer;
      const NomLocalidade: WideString; CodMIcroRegiao: Integer;
      const NomMicroRegiao, NumMunicipioIBGE, IndCadastroEfetivado,
      CodTipoLocalidade, CodOrdenacao: WideString): Integer; safecall;
    function Buscar(CodLocalidade: Integer;
      const CodTipoLocalidade: WideString): Integer; safecall;
    function Inserir(const NomLocalidade: WideString; CodLocalidadePai,
      NumLatitude, NumLogitude, CodMIcroRegiao: Integer;
      const NumMunicipioIBGE, CodTipoLocalidade: WideString): Integer;
      safecall;
    function Alterar(CodLocalidade: Integer; const NomLocalidade: WideString;
      NumLatitude, NumLongitude, CodMIcroRegiao: Integer;
      const NumMunicipioIBGE, CodTipoLocalidade: WideString): Integer;
      safecall;
    function Excluir(CodLocalidade: Integer;
      const CodTipoLocalidade: WideString): Integer; safecall;
    function CancelarEfetivacao(CodLocalidade: Integer): Integer; safecall;
    function EfetivarCadastro(CodLocalidade: Integer): Integer; safecall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

procedure TLocalidades.AfterConstruction;
begin
  inherited;
  FLocalidade := TLocalidade.Create;
  FLocalidade.ObjAddRef;
  FInicializado := False;
end;

procedure TLocalidades.BeforeDestruction;
begin
  If FIntLocalidades <> nil Then Begin
    FIntLocalidades.Free;
  End;
  If FLocalidade <> nil Then Begin
    FLocalidade.ObjRelease;
    FLocalidade := nil;
  End;
  inherited;
end;

function TLocalidades.Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
begin
  FIntLocalidades := TIntLocalidades.Create;
  Result := FIntLocalidades.Inicializar(ConexaoBD, Mensagens);
  If Result = 0 Then Begin
    FInicializado := True;
  End;
end;

function TLocalidades.BOF: WordBool;
begin
 Result := FIntLocalidades.BOF;
end;

function TLocalidades.Deslocar(QtdRegistros: Integer): Integer;
begin
  Result := FIntLocalidades.Deslocar(QtdRegistros);
end;

function TLocalidades.EOF: WordBool;
begin
  Result := FIntLocalidades.EOF;
end;

function TLocalidades.Get_Localidade: ILocalidade;
begin
  FLocalidade.CodLocalidade        := FIntLocalidades.IntLocalidade.CodLocalidade;
  FLocalidade.NomLocalidade        := FIntLocalidades.IntLocalidade.NomLocalidade;
  FLocalidade.NumLatitude          := FIntLocalidades.IntLocalidade.NumLatitude;
  FLocalidade.NumLongitude         := FIntLocalidades.IntLocalidade.NumLongitude;
  FLocalidade.DesTipoLocalidade    := FIntLocalidades.IntLocalidade.DesTipoLocalidade;
  FLocalidade.CodPais              := FIntLocalidades.IntLocalidade.CodPais;
  FLocalidade.NomPais              := FIntLocalidades.IntLocalidade.NomPais;
  FLocalidade.CodPaisSisBov        := FIntLocalidades.IntLocalidade.CodPaisSisBov;
  FLocalidade.CodEstado            := FIntLocalidades.IntLocalidade.CodEstado;
  FLocalidade.SglEstado            := FIntLocalidades.IntLocalidade.SglEstado;
  FLocalidade.CodEstadoSisBov      := FIntLocalidades.IntLocalidade.CodEstadoSisBov;
  FLocalidade.CodMicroRegiao       := FIntLocalidades.IntLocalidade.CodMicroRegiao;
  FLocalidade.NomMicroRegiao       := FIntLocalidades.IntLocalidade.NomMicroRegiao;
  FLocalidade.CodMicroRegiaoSisBov := FIntLocalidades.IntLocalidade.CodMicroRegiaoSisBov;
  FLocalidade.CodMunicipio         := FIntLocalidades.IntLocalidade.CodMunicipio;
  FLocalidade.NomMunicipio         := FIntLocalidades.IntLocalidade.NomMunicipio;
  FLocalidade.NumMunicipioIBGE     := FIntLocalidades.IntLocalidade.NumMunicipioIBGE;
  FLocalidade.DtaEfetivacaoCadastro := FIntLocalidades.IntLocalidade.DtaEfetivacaoCadastro;


  Result := FLocalidade;
end;

function TLocalidades.NumeroRegistros: Integer;
begin
  Result := FIntLocalidades.NumeroRegistros;
end;

function TLocalidades.ValorCampo(const NomeColuna: WideString): OleVariant;
begin
  Result := FIntLocalidades.ValorCampo(NomeColuna);
end;

procedure TLocalidades.FecharPesquisa;
begin
  FIntLocalidades.FecharPesquisa;
end;

procedure TLocalidades.IrAoAnterior;
begin
  FIntLocalidades.IrAoAnterior;
end;

procedure TLocalidades.IrAoPrimeiro;
begin
  FIntLocalidades.IrAoPrimeiro;
end;

procedure TLocalidades.IrAoProximo;
begin
  FIntLocalidades.IrAoProximo;
end;

procedure TLocalidades.IrAoUltimo;
begin
  FIntLocalidades.IrAoUltimo;
end;

procedure TLocalidades.Posicionar(NumRegistro: Integer);
begin
  FIntLocalidades.Posicionar(NumRegistro);
end;

function TLocalidades.Pesquisar(CodPais, CodEstado: Integer;
  const NomLocalidade: WideString; CodMIcroRegiao: Integer;
  const NomMicroRegiao, NumMunicipioIBGE, IndCadastroEfetivado,
  CodTipoLocalidade, CodOrdenacao: WideString): Integer;
begin
  Result := FIntLocalidades.Pesquisar(CodPais, CodEstado, NomLocalidade, CodMicroRegiao,
                                      NomMicroRegiao,NumMunicipioIBGE, IndCadastroEfetivado,CodTipoLocalidade, CodOrdenacao);
end;

function TLocalidades.Buscar(CodLocalidade: Integer;
  const CodTipoLocalidade: WideString): Integer;
begin
  Result := FIntLocalidades.Buscar(CodLocalidade, CodTipoLocalidade);
end;

function TLocalidades.Inserir(const NomLocalidade: WideString;
  CodLocalidadePai, NumLatitude, NumLogitude, CodMIcroRegiao: Integer;
  const NumMunicipioIBGE, CodTipoLocalidade: WideString): Integer;
begin
  Result := FIntLocalidades.Inserir(NomLocalidade,CodLocalidadePai,
            NumLatitude, NumLogitude, CodMicroRegiao, NumMunicipioIBGE,CodTipoLocalidade);
end;

function TLocalidades.Alterar(CodLocalidade: Integer;
  const NomLocalidade: WideString; NumLatitude, NumLongitude,
  CodMIcroRegiao: Integer; const NumMunicipioIBGE,
  CodTipoLocalidade: WideString): Integer;
begin
  Result := FIntLocalidades.Alterar(CodLocalidade, NomLocalidade,NumLatitude,
                                    NumLongitude,CodMicroRegiao, NumMunicipioIBGE,CodTipoLocalidade);
end;

function TLocalidades.Excluir(CodLocalidade: Integer;
  const CodTipoLocalidade: WideString): Integer;
begin
  Result := FIntLocalidades.Excluir(CodLocalidade,CodTipoLocalidade);
end;

function TLocalidades.CancelarEfetivacao(CodLocalidade: Integer): Integer;
begin
  Result := FIntLocalidades.CancelarEfetivacao(CodLocalidade);
end;

function TLocalidades.EfetivarCadastro(CodLocalidade: Integer): Integer;
begin
  Result := FIntLocalidades.EfetivarCadastro(CodLocalidade);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TLocalidades, Class_Localidades,
    ciMultiInstance, tmApartment);
end.
