unit uEntradaInsumo;
// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Carlos Augusto
// *  Versão             : 1
// *  Data               : 17/09/2002
// *  Documentação       : Controle de Insumos - Definição das Classes
// *  Código Classe      : 64
// *  Descrição Resumida : Cadastro de Entrada de Insumo
// ********************************************************************
// *  Últimas Alterações
// *  Hitalo   01/10/2002  adiconar NumCNPJCPFRevendedor, TxtObservacao
// *
// ********************************************************************

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TEntradaInsumo = class(TASPMTSObject, IEntradaInsumo)
  private
    FCodPessoaProdutor:Integer;
    FCodEntradaInsumo:Integer;
    FCodFazenda:Integer;
    FSglFazenda:WideString;
    FNomFazenda:WideString;
    FCodTipoInsumo:Integer;
    FSglTipoInsumo:WideString;
    FDesTipoInsumo:WideString;
    FIndAdmitePartidaLote:WideString;
    FCodSubTipoInsumo:Integer;
    FSglSubTipoInsumo:WideString;
    FDesSubTipoInsumo:WideString;
    FCodInsumo:Integer;
    FDesInsumo:WideString;
    FCodFabricanteInsumo:Integer;
    FNomFabricanteInsumo:WideString;
    FNumRegistroFabricante:Integer;
    FCodPessoaSecundaria:Integer;
    FNomRevendedor:WideString;
    FNumCNPJCPFRevendedorFormatado:WideString;
    FDtaCompra:TdateTime;
    FNumNotaFiscal:Integer;
    FNumPartidaLote:WideString;
    FDtaValidade:TdateTime;
    FQtdInsumo:Double;
    FCodUnidadeMedida:Integer;
    FSglUnidadeMedida:WideString;
    FNumCNPJCPFRevendedor :WideString;
    FTxtObservacao :WideString;
    FCusto:double;
  protected
    function Get_CodEntradaInsumo: Integer; safecall;
    function Get_CodFabricanteInsumo: Integer; safecall;
    function Get_CodFazenda: Integer; safecall;
    function Get_CodInsumo: Integer; safecall;
    function Get_CodPessoaProdutor: Integer; safecall;
    function Get_CodPessoaSecundaria: Integer; safecall;
    function Get_CodSubTipoInsumo: Integer; safecall;
    function Get_CodTipoInsumo: Integer; safecall;
    function Get_CodUnidadeMedida: Integer; safecall;
    function Get_NomFazenda: WideString; safecall;
    function Get_DesInsumo: WideString; safecall;
    function Get_DesSubTipoInsumo: WideString; safecall;
    function Get_DesTipoInsumo: WideString; safecall;
    function Get_DtaCompra: TDateTime; safecall;
    function Get_DtaValidade: TDateTime; safecall;
    function Get_IndAdmitePartidaLote: WideString; safecall;
    function Get_NomFabricanteInsumo: WideString; safecall;
    function Get_NomRevendedor: WideString; safecall;
    function Get_NumCNPJCPFRevendedorFormatado: WideString; safecall;
    function Get_NumNotaFiscal: Integer; safecall;
    function Get_NumPartidaLote: WideString; safecall;
    function Get_NumRegistroFabricante: Integer; safecall;
    function Get_QtdInsumo: Double; safecall;
    function Get_SglFazenda: WideString; safecall;
    function Get_SglSubTipoInsumo: WideString; safecall;
    function Get_SglTipoInsumo: WideString; safecall;
    function Get_SglUnidadeMedida: WideString; safecall;
    procedure Set_CodEntradaInsumo(Value: Integer); safecall;
    procedure Set_CodFabricanteInsumo(Value: Integer); safecall;
    procedure Set_CodFazenda(Value: Integer); safecall;
    procedure Set_CodInsumo(Value: Integer); safecall;
    procedure Set_CodPessoaProdutor(Value: Integer); safecall;
    procedure Set_CodPessoaSecundaria(Value: Integer); safecall;
    procedure Set_CodSubTipoInsumo(Value: Integer); safecall;
    procedure Set_CodTipoInsumo(Value: Integer); safecall;
    procedure Set_CodUnidadeMedida(Value: Integer); safecall;
    procedure Set_NomFazenda(const Value: WideString); safecall;
    procedure Set_DesInsumo(const Value: WideString); safecall;
    procedure Set_DesSubTipoInsumo(const Value: WideString); safecall;
    procedure Set_DesTipoInsumo(const Value: WideString); safecall;
    procedure Set_DtaCompra(Value: TDateTime); safecall;
    procedure Set_DtaValidade(Value: TDateTime); safecall;
    procedure Set_IndAdmitePartidaLote(const Value: WideString); safecall;
    procedure Set_NomFabricanteInsumo(const Value: WideString); safecall;
    procedure Set_NomRevendedor(const Value: WideString); safecall;
    procedure Set_NumCNPJCPFRevendedorFormatado(const Value: WideString);
      safecall;
    procedure Set_NumNotaFiscal(Value: Integer); safecall;
    procedure Set_NumPartidaLote(const Value: WideString); safecall;
    procedure Set_NumRegistroFabricante(Value: Integer); safecall;
    procedure Set_QtdInsumo(Value: Double); safecall;
    procedure Set_SglFazenda(const Value: WideString); safecall;
    procedure Set_SglSubTipoInsumo(const Value: WideString); safecall;
    procedure Set_SglTipoInsumo(const Value: WideString); safecall;
    procedure Set_SglUnidadeMedida(const Value: WideString); safecall;
    function Get_NumCNPJCPFRevendedor: WideString; safecall;
    function Get_TxtObservacao: WideString; safecall;
    procedure Set_NumCNPJCPFRevendedor(const Value: WideString); safecall;
    procedure Set_TxtObservacao(const Value: WideString); safecall;
    function Get_Custo: Double; safecall;
    procedure Set_Custo(Value: Double); safecall;
  public
    property     CodPessoaProdutor              :Integer     read FCodPessoaProdutor               write FCodPessoaProdutor;
    property     CodEntradaInsumo               :Integer     read FCodEntradaInsumo                write FCodEntradaInsumo;
    property     CodFazenda                     :Integer     read FCodFazenda                      write FCodFazenda;
    property     SglFazenda                     :WideString  read FSglFazenda                      write FSglFazenda;
    property     NomFazenda                     :WideString  read FNomFazenda                      write FNomFazenda;
    property     CodTipoInsumo                  :Integer     read FCodTipoInsumo                   write FCodTipoInsumo;
    property     SglTipoInsumo                  :WideString  read FSglTipoInsumo                   write FSglTipoInsumo;
    property     DesTipoInsumo                  :WideString  read FDesTipoInsumo                   write FDesTipoInsumo;
    property     IndAdmitePartidaLote           :WideString  read FIndAdmitePartidaLote            write FIndAdmitePartidaLote;
    property     CodSubTipoInsumo               :Integer     read FCodSubTipoInsumo                write FCodSubTipoInsumo;
    property     SglSubTipoInsumo               :WideString  read FSglSubTipoInsumo                write FSglSubTipoInsumo;
    property     DesSubTipoInsumo               :WideString  read FDesSubTipoInsumo                write FDesSubTipoInsumo;
    property     CodInsumo                      :Integer     read FCodInsumo                       write FCodInsumo;
    property     DesInsumo                      :WideString  read FDesInsumo                       write FDesInsumo;
    property     CodFabricanteInsumo            :Integer     read FCodFabricanteInsumo             write FCodFabricanteInsumo;
    property     NomFabricanteInsumo            :WideString  read FNomFabricanteInsumo             write FNomFabricanteInsumo;
    property     NumRegistroFabricante          :Integer     read FNumRegistroFabricante           write FNumRegistroFabricante;
    property     CodPessoaSecundaria            :Integer     read FCodPessoaSecundaria             write FCodPessoaSecundaria;
    property     NomRevendedor                  :WideString  read FNomRevendedor                   write FNomRevendedor;
    property     NumCNPJCPFRevendedorFormatado  :WideString  read FNumCNPJCPFRevendedorFormatado   write FNumCNPJCPFRevendedorFormatado;
    property     DtaCompra                      :TdateTime   read FDtaCompra                       write FDtaCompra;
    property     NumNotaFiscal                  :Integer     read FNumNotaFiscal                   write FNumNotaFiscal;
    property     NumPartidaLote                 :WideString  read FNumPartidaLote                  write FNumPartidaLote;
    property     DtaValidade                    :TdateTime   read FDtaValidade                     write FDtaValidade;
    property     QtdInsumo                      :Double      read FQtdInsumo                       write FQtdInsumo;
    property     CodUnidadeMedida               :Integer     read FCodUnidadeMedida                write FCodUnidadeMedida;
    property     SglUnidadeMedida               :WideString  read FSglUnidadeMedida                write FSglUnidadeMedida;
    property     NumCNPJCPFRevendedor           :WideString  read FNumCNPJCPFRevendedor            write FNumCNPJCPFRevendedor;
    property     TxtObservacao                  :WideString  read FTxtObservacao                   write FTxtObservacao;
    property     Custo                          :Double      read Fcusto                           write FCusto;    
  end;

implementation

uses ComServ;

function TEntradaInsumo.Get_CodEntradaInsumo: Integer;
begin
  result := FCodEntradaInsumo;
end;

function TEntradaInsumo.Get_CodFabricanteInsumo: Integer;
begin
  result := FCodFabricanteInsumo;
end;

function TEntradaInsumo.Get_CodFazenda: Integer;
begin
  result := FCodFazenda;
end;

function TEntradaInsumo.Get_CodInsumo: Integer;
begin
  result := FCodInsumo;
end;

function TEntradaInsumo.Get_CodPessoaProdutor: Integer;
begin
  result := FCodPessoaProdutor;
end;

function TEntradaInsumo.Get_CodPessoaSecundaria: Integer;
begin
  result := FCodPessoaSecundaria;
end;

function TEntradaInsumo.Get_CodSubTipoInsumo: Integer;
begin
  result := FCodSubTipoInsumo;
end;

function TEntradaInsumo.Get_CodTipoInsumo: Integer;
begin
  result := FCodTipoInsumo;
end;

function TEntradaInsumo.Get_CodUnidadeMedida: Integer;
begin
  result := FCodUnidadeMedida;
end;

function TEntradaInsumo.Get_NomFazenda: WideString;
begin
  result := FNomFazenda;
end;

function TEntradaInsumo.Get_DesInsumo: WideString;
begin
  result := FDesInsumo;
end;

function TEntradaInsumo.Get_DesSubTipoInsumo: WideString;
begin
  result := FDesSubTipoInsumo;
end;

function TEntradaInsumo.Get_DesTipoInsumo: WideString;
begin
  result := FDesTipoInsumo;
end;

function TEntradaInsumo.Get_DtaCompra: TDateTime;
begin
  result := FDtaCompra;
end;

function TEntradaInsumo.Get_DtaValidade: TDateTime;
begin
  result := FDtaValidade;
end;

function TEntradaInsumo.Get_IndAdmitePartidaLote: WideString;
begin
  result := FIndAdmitePartidaLote;
end;

function TEntradaInsumo.Get_NomFabricanteInsumo: WideString;
begin
  result := FNomFabricanteInsumo;
end;

function TEntradaInsumo.Get_NomRevendedor: WideString;
begin
  result := FNomRevendedor;
end;

function TEntradaInsumo.Get_NumCNPJCPFRevendedorFormatado: WideString;
begin
  result := FNumCNPJCPFRevendedorFormatado;
end;

function TEntradaInsumo.Get_NumNotaFiscal: Integer;
begin
  result := FNumNotaFiscal;
end;

function TEntradaInsumo.Get_NumPartidaLote: WideString;
begin
  result := FNumPartidaLote;
end;

function TEntradaInsumo.Get_NumRegistroFabricante: Integer;
begin
  result := FNumRegistroFabricante;
end;

function TEntradaInsumo.Get_QtdInsumo: Double;
begin
  result := FQtdInsumo;
end;

function TEntradaInsumo.Get_SglFazenda: WideString;
begin
  result := FSglFazenda;
end;

function TEntradaInsumo.Get_SglSubTipoInsumo: WideString;
begin
  result := FSglSubTipoInsumo;
end;

function TEntradaInsumo.Get_SglTipoInsumo: WideString;
begin
  result := FSglTipoInsumo;
end;

function TEntradaInsumo.Get_SglUnidadeMedida: WideString;
begin
  result := FSglUnidadeMedida;
end;

procedure TEntradaInsumo.Set_CodEntradaInsumo(Value: Integer);
begin
  FCodEntradaInsumo := Value;
end;

procedure TEntradaInsumo.Set_CodFabricanteInsumo(Value: Integer);
begin
  FCodFabricanteInsumo := Value;
end;

procedure TEntradaInsumo.Set_CodFazenda(Value: Integer);
begin
  FCodFazenda := Value;
end;

procedure TEntradaInsumo.Set_CodInsumo(Value: Integer);
begin
  FCodInsumo := Value;
end;

procedure TEntradaInsumo.Set_CodPessoaProdutor(Value: Integer);
begin
  FCodPessoaProdutor := Value;
end;

procedure TEntradaInsumo.Set_CodPessoaSecundaria(Value: Integer);
begin
  FCodPessoaSecundaria := Value;
end;

procedure TEntradaInsumo.Set_CodSubTipoInsumo(Value: Integer);
begin
  FCodSubTipoInsumo := Value;
end;

procedure TEntradaInsumo.Set_CodTipoInsumo(Value: Integer);
begin
  FCodTipoInsumo := Value;
end;

procedure TEntradaInsumo.Set_CodUnidadeMedida(Value: Integer);
begin
  FCodUnidadeMedida := Value;
end;

procedure TEntradaInsumo.Set_NomFazenda(const Value: WideString);
begin
  FNomFazenda := Value;
end;

procedure TEntradaInsumo.Set_DesInsumo(const Value: WideString);
begin
  FDesInsumo := Value;
end;

procedure TEntradaInsumo.Set_DesSubTipoInsumo(const Value: WideString);
begin
  FDesSubTipoInsumo := Value;
end;

procedure TEntradaInsumo.Set_DesTipoInsumo(const Value: WideString);
begin
  FDesTipoInsumo := Value;
end;

procedure TEntradaInsumo.Set_DtaCompra(Value: TDateTime);
begin
  FDtaCompra := Value;
end;

procedure TEntradaInsumo.Set_DtaValidade(Value: TDateTime);
begin
  FDtaValidade := Value;
end;

procedure TEntradaInsumo.Set_IndAdmitePartidaLote(const Value: WideString);
begin
  FIndAdmitePartidaLote := Value;
end;

procedure TEntradaInsumo.Set_NomFabricanteInsumo(const Value: WideString);
begin
  FNomFabricanteInsumo := Value;
end;

procedure TEntradaInsumo.Set_NomRevendedor(const Value: WideString);
begin
  FNomRevendedor := Value;
end;

procedure TEntradaInsumo.Set_NumCNPJCPFRevendedorFormatado(
  const Value: WideString);
begin
  FNumCNPJCPFRevendedorFormatado := Value;
end;

procedure TEntradaInsumo.Set_NumNotaFiscal(Value: Integer);
begin
  FNumNotaFiscal := Value;
end;

procedure TEntradaInsumo.Set_NumPartidaLote(const Value: WideString);
begin
  FNumPartidaLote := Value;
end;

procedure TEntradaInsumo.Set_NumRegistroFabricante(Value: Integer);
begin
  FNumRegistroFabricante := Value;
end;

procedure TEntradaInsumo.Set_QtdInsumo(Value: Double);
begin
  FQtdInsumo := Value;
end;

procedure TEntradaInsumo.Set_SglFazenda(const Value: WideString);
begin
  FSglFazenda := Value;
end;

procedure TEntradaInsumo.Set_SglSubTipoInsumo(const Value: WideString);
begin
  FSglSubTipoInsumo := Value;
end;

procedure TEntradaInsumo.Set_SglTipoInsumo(const Value: WideString);
begin
  FSglTipoInsumo := Value;
end;

procedure TEntradaInsumo.Set_SglUnidadeMedida(const Value: WideString);
begin
  FSglUnidadeMedida := Value;
end;

function TEntradaInsumo.Get_NumCNPJCPFRevendedor: WideString;
begin
  result := FNumCNPJCPFRevendedor;
end;

function TEntradaInsumo.Get_TxtObservacao: WideString;
begin
  result := FTxtObservacao;
end;

procedure TEntradaInsumo.Set_NumCNPJCPFRevendedor(const Value: WideString);
begin
  FNumCNPJCPFRevendedor := value;
end;

procedure TEntradaInsumo.Set_TxtObservacao(const Value: WideString);
begin
  FTxtObservacao := value;
end;

function TEntradaInsumo.Get_Custo: Double;
begin
  result  :=  FCusto;
end;

procedure TEntradaInsumo.Set_Custo(Value: Double);
begin
  FCusto  :=  Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TEntradaInsumo, Class_EntradaInsumo,
    ciMultiInstance, tmApartment);
end.
