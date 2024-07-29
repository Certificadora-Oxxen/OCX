// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Antonio Druzo Rocha Neto
// *  Versão             : 1
// *  Data               : 13/02/2009
// *  Documentação       : Gerenciamento de Rebanho - Especificação das
// *                       classes.doc
// *  Descrição Resumida : Cadastro de tipos de propriedade de animais
// ********************************************************************
// *
// ********************************************************************

unit utipopropriedades;

interface
  uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl,uConexao, uIntMensagens,
  uIntTipoPropriedades,uIntTipoPropriedade,uTipoPropriedade;

 type
  TTipoPropriedades = class(TASPMTSObject,ITipoPropriedades)
  private
    fTipoPropriedade:TTipoPropriedade;
    fintTipoPropriedades:TIntTipoPropriedades;
    FInicializado : Boolean;
    function  Get_TipoPropriedade():ITipoPropriedade;safecall;
  protected
    function Pesquisar(CodTipoPropriedade:integer;const des_tipo_propriedade:widestring):integer;safecall;
    function Inserir(CodTipoPropriedade:integer;const des_tipo_propriedade:widestring;qtd_dias_prox_vistoria:integer):integer; safecall;
    function Alterar(CodTipoPropriedade:integer;const des_tipo_propriedade:widestring;qtd_dias_prox_vistoria:integer):integer;safecall;
    function Excluir(CodTipoPropriedade:integer):integer;safecall;
    function EOF: WordBool; safecall;
    procedure FecharPesquisa; safecall;
    procedure IrAoProximo; safecall;
    procedure IrAoAnterior;safecall;
    procedure IrAoPrimeiro;safecall;
    procedure IrAoUltimo;safecall;
    property  TipoPropriedade       : ITipoPropriedade        Read Get_TipoPropriedade;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Inicializar(ConexaoBD: TConexao; Mensagens: TIntMensagens): Integer;
  end;

implementation

uses ComServ;

{ TTipoPropriedades }

procedure TTipoPropriedades.AfterConstruction;
begin
  inherited;
  fTipoPropriedade  :=  TTipoPropriedade.Create;
  fTipoPropriedade.ObjAddRef;
  FInicializado     :=  false;
end;

function TTipoPropriedades.alterar(CodTipoPropriedade: integer;
  const des_tipo_propriedade: widestring; qtd_dias_prox_vistoria: integer): integer;
begin
  result  :=  fintTipoPropriedades.alterar(CodTipoPropriedade,des_tipo_propriedade,qtd_dias_prox_vistoria);
end;

procedure TTipoPropriedades.BeforeDestruction;
begin
  if fintTipoPropriedades <> nil then
    fintTipoPropriedades.Free;
  if fTipoPropriedade <> nil then
  begin
    fTipoPropriedade.ObjRelease;
    fTipoPropriedade := nil;
  end;
  inherited;
end;
                        
function TTipoPropriedades.EOF: WordBool;
begin
  result  :=  fintTipoPropriedades.EOF;
end;

function TTipoPropriedades.excluir(CodTipoPropriedade: integer): integer;
begin
  result  :=  fintTipoPropriedades.excluir(CodTipoPropriedade);
end;

procedure TTipoPropriedades.FecharPesquisa;
begin
  fintTipoPropriedades.FecharPesquisa;
end;

function TTipoPropriedades.Get_TipoPropriedade: ITipoPropriedade;
begin
  fTipoPropriedade.CodTipoPropriedade   :=  fintTipoPropriedades.IntTipoPropriedade.CodTipoPropriedade;
  fTipoPropriedade.DesTipoPropriedade   :=  fintTipoPropriedades.IntTipoPropriedade.DesTipoPropriedade;
  fTipoPropriedade.QtdDiasProxVistoria  :=  fintTipoPropriedades.IntTipoPropriedade.QtdDiasProxVistoria;
  result                                :=  fTipoPropriedade;
end;

function TTipoPropriedades.Inicializar(ConexaoBD: TConexao;
  Mensagens: TIntMensagens): Integer;
begin
  fintTipoPropriedades  :=  TIntTipoPropriedades.Create;
  result  :=  fintTipoPropriedades.Inicializar(ConexaoBD,Mensagens);
  if Result = 0 then
  begin
    FInicializado :=  true;
  end;
end;

function TTipoPropriedades.Inserir(CodTipoPropriedade: integer;
  const des_tipo_propriedade: widestring; qtd_dias_prox_vistoria: integer): integer;
begin
  result  :=  fintTipoPropriedades.Inserir(CodTipoPropriedade,des_tipo_propriedade,qtd_dias_prox_vistoria);
end;

procedure TTipoPropriedades.IrAoAnterior;
begin
  fintTipoPropriedades.IrAoAnterior;
end;

procedure TTipoPropriedades.IrAoPrimeiro;
begin
  fintTipoPropriedades.IrAoPrimeiro;
end;

procedure TTipoPropriedades.IrAoProximo;
begin
  fintTipoPropriedades.IrAoProximo;
end;

procedure TTipoPropriedades.IrAoUltimo;
begin
  fintTipoPropriedades.IrAoUltimo;
end;

function TTipoPropriedades.Pesquisar(CodTipoPropriedade: integer;
  const des_tipo_propriedade: widestring): integer;
begin
  result  :=  fintTipoPropriedades.Pesquisar(CodTipoPropriedade,des_tipo_propriedade);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTipoPropriedades, CLASS_TipoPropriedades,
    ciMultiInstance, tmApartment);

end.
