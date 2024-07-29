// ********************************************************************
// *  Projeto            : BoiTata
// *  Sistema            : Gerenciamento de Rebanho
// *  Desenvolvedor      : Adalberto Knychala Neto
// *  Versão             : 1
// *  Data               : 03/06/2004
// *  Documentação       : Importação de dado geral - documentação das classes
// *  Código Classe      : 90
// *  Descrição Resumida : Armazena os atributos de dados não restritos a um único produtor, tais como
//                         propriedades, produtores, fazendas e locais                              
// ************************************************************************
// *  Últimas Alterações
// *
// ********************************************************************

unit uImportacaoDadoGeral;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TImportacaoDadoGeral = class(TASPMTSObject, IImportacaoDadoGeral)
  private
    FCodArqImportDadoGeral: Integer;
    FNomArqUpLoad: WideString;
    FNomArqImportDadoGeral: WideString;
    FDtaImportacao: TDateTime;
    FCodUsuarioUltimoProc: Integer;
    FNomUsuarioUltimoProc: WideString;
    FCodUsuarioUpload: Integer;
    FNomUsuarioUpload: WideString;
    FQtdVezesProcessamento: Integer;
    FDtaUltimoProcessamento: TDateTime;
    FQtdProdutoresTotal: Integer;
    FQtdProdutoresErrados: Integer;
    FQtdProdutoresProcessados: Integer;
    FQtdPropriedadesTotal: Integer;
    FQtdPropriedadesErradas: Integer;
    FQtdPropriedadesProcessadas: Integer;
    FQtdFazendasTotal: Integer;
    FQtdFazendasErradas: Integer;
    FQtdFazendasProcessadas: Integer;
    FQtdLocaisTotal: Integer;
    FQtdLocaisErrados: Integer;
    FQtdLocaisProcessados: Integer;
    FCodTipoOrigemArqImport: Integer;
    FSglTipoOrigemArqImport: WideString;
    FDesTipoOrigemArqImport: WideString;
    FCodSituacaoArqImport: WideString;
    FDesSituacaoArqImport: WideString;
    FQtdLinhas: Integer;
    FQtdOcorrencias: Integer;
    FCodUltimaTarefa: Integer;
    FCodSituacaoUltimaTarefa: WideString;
    FDesSituacaoUltimaTarefa: WideString;
    FDtaInicioPrevistoUltimaTarefa: TDateTime;
    FDtaInicioRealUltimaTarefa: TDateTime;
    FDtaFimRealUltimaTarefa: TDateTime;
    FTxtMensagem: WideString;
  protected
    function Get_CodArqImportDadoGeral: Integer; safecall;
    function Get_CodUsuarioUltimoProc: Integer; safecall;
    function Get_DtaImportacao: TDateTime; safecall;
    function Get_DtaUltimoProcessamento: TDateTime; safecall;
    function Get_NomArqImportDadoGeral: WideString; safecall;
    function Get_NomArqUpload: WideString; safecall;
    function Get_NomUsuarioUltimoProc: WideString; safecall;
    function Get_QtdVezesProcessamento: Integer; safecall;
    procedure Set_CodArqImportDadoGeral(Value: Integer); safecall;
    procedure Set_CodUsuarioUltimoProc(Value: Integer); safecall;
    procedure Set_DtaImportacao(Value: TDateTime); safecall;
    procedure Set_DtaUltimoProcessamento(Value: TDateTime); safecall;
    procedure Set_NomArqImportDadoGeral(const Value: WideString); safecall;
    procedure Set_NomArqUpload(const Value: WideString); safecall;
    procedure Set_NomUsuarioUltimoProc(const Value: WideString); safecall;
    procedure Set_QtdVezesProcessamento(Value: Integer); safecall;
    function Get_QtdFazendasErradas: Integer; safecall;
    function Get_QtdFazendasProcessadas: Integer; safecall;
    function Get_QtdFazendasTotal: Integer; safecall;
    function Get_QtdLocaisErrados: Integer; safecall;
    function Get_QtdLocaisProcessados: Integer; safecall;
    function Get_QtdLocaisTotal: Integer; safecall;
    function Get_QtdProdutoresErrados: Integer; safecall;
    function Get_QtdProdutoresProcessados: Integer; safecall;
    function Get_QtdProdutoresTotal: Integer; safecall;
    function Get_QtdPropriedadesErradas: Integer; safecall;
    function Get_QtdPropriedadesProcessadas: Integer; safecall;
    function Get_QtdPropriedadesTotal: Integer; safecall;
    procedure Set_QtdFazendasErradas(Value: Integer); safecall;
    procedure Set_QtdFazendasProcessadas(Value: Integer); safecall;
    procedure Set_QtdFazendasTotal(Value: Integer); safecall;
    procedure Set_QtdLocaisErrados(Value: Integer); safecall;
    procedure Set_QtdLocaisProcessados(Value: Integer); safecall;
    procedure Set_QtdLocaisTotal(Value: Integer); safecall;
    procedure Set_QtdProdutoresErrados(Value: Integer); safecall;
    procedure Set_QtdProdutoresProcessados(Value: Integer); safecall;
    procedure Set_QtdProdutoresTotal(Value: Integer); safecall;
    procedure Set_QtdPropriedadesErradas(Value: Integer); safecall;
    procedure Set_QtdPropriedadesProcessadas(Value: Integer); safecall;
    procedure Set_QtdPropriedadesTotal(Value: Integer); safecall;
    function Get_CodUsuarioUpload: Integer; safecall;
    function Get_NomUsuarioUpload: WideString; safecall;
    procedure Set_CodUsuarioUpload(Value: Integer); safecall;
    procedure Set_NomUsuarioUpload(const Value: WideString); safecall;
    function Get_CodTipoOrigemArqImport: Integer; safecall;
    function Get_DesTipoOrigemArqImport: WideString; safecall;
    function Get_SglTipoOrigemArqImport: WideString; safecall;
    procedure Set_CodTipoOrigemArqImport(Value: Integer); safecall;
    procedure Set_DesTipoOrigemArqImport(const Value: WideString); safecall;
    procedure Set_SglTipoOrigemArqImport(const Value: WideString); safecall;
    function Get_CodSituacaoArqImport: WideString; safecall;
    function Get_DesSituacaoArqImport: WideString; safecall;
    procedure Set_CodSituacaoArqImport(const Value: WideString); safecall;
    procedure Set_DesSituacaoArqImport(const Value: WideString); safecall;
    function Get_CodSituacaoUltimaTarefa: WideString; safecall;
    function Get_CodUltimaTarefa: Integer; safecall;
    function Get_DesSituacaoUltimaTarefa: WideString; safecall;
    function Get_DtaFimRealUltimaTarefa: TDateTime; safecall;
    function Get_DtaInicioPrevistoUltimaTarefa: TDateTime; safecall;
    function Get_DtaInicioRealUltimaTarefa: TDateTime; safecall;
    function Get_QtdLinhas: Integer; safecall;
    function Get_QtdOcorrencias: Integer; safecall;
    function Get_TxtMensagem: WideString; safecall;
    procedure Set_CodSituacaoUltimaTarefa(const Value: WideString); safecall;
    procedure Set_CodUltimaTarefa(Value: Integer); safecall;
    procedure Set_DesSituacaoUltimaTarefa(const Value: WideString); safecall;
    procedure Set_DtaFimRealUltimaTarefa(Value: TDateTime); safecall;
    procedure Set_DtaInicioPrevistoUltimaTarefa(Value: TDateTime); safecall;
    procedure Set_DtaInicioRealUltimaTarefa(Value: TDateTime); safecall;
    procedure Set_QtdLinhas(Value: Integer); safecall;
    procedure Set_QtdOcorrencias(Value: Integer); safecall;
    procedure Set_TxtMensagem(const Value: WideString); safecall;
  public
    property CodArqImportDadoGeral: Integer read FCodArqImportDadoGeral write FCodArqImportDadoGeral;
    property NomArqUpLoad: WideString read FNomArqUpLoad write FNomArqUpLoad;
    property NomArqImportDadoGeral: WideString read FNomArqImportDadoGeral write FNomArqImportDadoGeral;
    property DtaImportacao: TDateTime read FDtaImportacao write FDtaImportacao;
    property CodUsuarioUltimoProc: Integer read FCodUsuarioUltimoProc write FCodUsuarioUltimoProc;
    property NomUsuarioUltimoProc: WideString read FNomUsuarioUltimoProc write FNomUsuarioUltimoProc;
    property CodUsuarioUpload: Integer read FCodUsuarioUpload write FCodUsuarioUpload;
    property NomUsuarioUpload: WideString read FNomUsuarioUpload write FNomUsuarioUpload;
    property QtdVezesProcessamento: Integer read FQtdVezesProcessamento write FQtdVezesProcessamento;
    property DtaUltimoProcessamento: TDateTime read FDtaUltimoProcessamento write FDtaUltimoProcessamento;
    property QtdProdutoresTotal: Integer read FQtdProdutoresTotal write FQtdProdutoresTotal;
    property QtdProdutoresErrados: Integer read FQtdProdutoresErrados write FQtdProdutoresErrados;
    property QtdProdutoresProcessados: Integer read FQtdProdutoresProcessados write FQtdProdutoresProcessados;
    property QtdPropriedadesTotal: Integer read FQtdPropriedadesTotal write FQtdPropriedadesTotal;
    property QtdPropriedadesErradas: Integer read FQtdPropriedadesErradas write FQtdPropriedadesErradas;
    property QtdPropriedadesProcessadas: Integer read FQtdPropriedadesProcessadas write FQtdPropriedadesProcessadas;
    property QtdFazendasTotal: Integer read FQtdFazendasTotal write FQtdFazendasTotal;
    property QtdFazendasErradas: Integer read FQtdFazendasErradas write FQtdFazendasErradas;
    property QtdFazendasProcessadas: Integer read FQtdFazendasProcessadas write FQtdFazendasProcessadas;
    property QtdLocaisTotal: Integer read FQtdLocaisTotal write FQtdLocaisTotal;
    property QtdLocaisErrados: Integer read FQtdLocaisErrados write FQtdLocaisErrados;
    property QtdLocaisProcessados: Integer read FQtdLocaisProcessados write FQtdLocaisProcessados;
    property CodTipoOrigemArqImport: Integer read FCodTipoOrigemArqImport write FCodTipoOrigemArqImport;
    property SglTipoOrigemArqImport: WideString read FSglTipoOrigemArqImport write FSglTipoOrigemArqImport;
    property DesTipoOrigemArqImport: WideString read FDesTipoOrigemArqImport write FDesTipoOrigemArqImport;
    property CodSituacaoArqImport: WideString read FCodSituacaoArqImport write FCodSituacaoArqImport;
    property DesSituacaoArqImport: WideString read FDesSituacaoArqImport write FDesSituacaoArqImport;
    property QtdLinhas: Integer read FQtdLinhas write FQtdLinhas;
    property QtdOcorrencias: Integer read FQtdOcorrencias write FQtdOcorrencias;
    property CodUltimaTarefa: Integer read FCodUltimaTarefa write FCodUltimaTarefa;
    property CodSituacaoUltimaTarefa: WideString read FCodSituacaoUltimaTarefa write FCodSituacaoUltimaTarefa;
    property DesSituacaoUltimaTarefa: WideString read FDesSituacaoUltimaTarefa write FDesSituacaoUltimaTarefa;
    property DtaInicioPrevistoUltimaTarefa: TDateTime read FDtaInicioPrevistoUltimaTarefa write FDtaInicioPrevistoUltimaTarefa;
    property DtaInicioRealUltimaTarefa: TDateTime read FDtaInicioRealUltimaTarefa write FDtaInicioRealUltimaTarefa;
    property DtaFimRealUltimaTarefa: TDateTime read FDtaFimRealUltimaTarefa write FDtaFimRealUltimaTarefa;
    property TxtMensagem: WideString read FTxtMensagem write FTxtMensagem;

  end;
          
implementation

uses ComServ;

function TImportacaoDadoGeral.Get_CodArqImportDadoGeral: Integer;
begin
        Result := FCodArqImportDadoGeral;
end;

function TImportacaoDadoGeral.Get_CodUsuarioUltimoProc: Integer;
begin
        Result := FCodUsuarioUltimoProc;
end;

function TImportacaoDadoGeral.Get_DtaImportacao: TDateTime;
begin
        Result := FDtaImportacao;
end;

function TImportacaoDadoGeral.Get_DtaUltimoProcessamento: TDateTime;
begin
        Result := FDtaUltimoProcessamento;
end;

function TImportacaoDadoGeral.Get_NomArqImportDadoGeral: WideString;
begin
        Result := FNomArqImportDadoGeral;
end;

function TImportacaoDadoGeral.Get_NomArqUpload: WideString;
begin
        Result := FNomArqUpload;
end;

function TImportacaoDadoGeral.Get_NomUsuarioUltimoProc: WideString;
begin
        Result := FNomUsuarioUltimoProc;
end;

function TImportacaoDadoGeral.Get_QtdVezesProcessamento: Integer;
begin
        Result := FQtdVezesProcessamento;
end;

procedure TImportacaoDadoGeral.Set_CodArqImportDadoGeral(Value: Integer);
begin
        FCodArqImportDadoGeral := Value;
end;

procedure TImportacaoDadoGeral.Set_CodUsuarioUltimoProc(Value: Integer);
begin
        FCodUsuarioUltimoProc := Value;
end;

procedure TImportacaoDadoGeral.Set_DtaImportacao(Value: TDateTime);
begin
        FDtaImportacao := Value;
end;

procedure TImportacaoDadoGeral.Set_DtaUltimoProcessamento(
  Value: TDateTime);
begin
        FDtaUltimoProcessamento := Value;
end;

procedure TImportacaoDadoGeral.Set_NomArqImportDadoGeral(
  const Value: WideString);
begin
        FNomArqImportDadoGeral := Value;
end;

procedure TImportacaoDadoGeral.Set_NomArqUpload(const Value: WideString);
begin
        FNomArqUpload := Value;
end;

procedure TImportacaoDadoGeral.Set_NomUsuarioUltimoProc(
  const Value: WideString);
begin
        FNomUsuarioUltimoProc := Value;
end;

procedure TImportacaoDadoGeral.Set_QtdVezesProcessamento(Value: Integer);
begin
        FQtdVezesProcessamento := Value;
end;

function TImportacaoDadoGeral.Get_QtdFazendasErradas: Integer;
begin
        Result := FQtdFazendasErradas;
end;

function TImportacaoDadoGeral.Get_QtdFazendasProcessadas: Integer;
begin
        Result := FQtdFazendasProcessadas;
end;

function TImportacaoDadoGeral.Get_QtdFazendasTotal: Integer;
begin
        Result := FQtdFazendasTotal;
end;

function TImportacaoDadoGeral.Get_QtdLocaisErrados: Integer;
begin
        Result := FQtdLocaisErrados;
end;

function TImportacaoDadoGeral.Get_QtdLocaisProcessados: Integer;
begin
        Result := FQtdLocaisProcessados;
end;

function TImportacaoDadoGeral.Get_QtdLocaisTotal: Integer;
begin
        Result := FQtdLocaisTotal;
end;

function TImportacaoDadoGeral.Get_QtdProdutoresErrados: Integer;
begin
        Result := FQtdProdutoresErrados;
end;

function TImportacaoDadoGeral.Get_QtdProdutoresProcessados: Integer;
begin
        Result := FQtdProdutoresProcessados;
end;

function TImportacaoDadoGeral.Get_QtdProdutoresTotal: Integer;
begin
        Result := FQtdProdutoresTotal;
end;

function TImportacaoDadoGeral.Get_QtdPropriedadesErradas: Integer;
begin
        Result := FQtdPropriedadesErradas;
end;

function TImportacaoDadoGeral.Get_QtdPropriedadesProcessadas: Integer;
begin
        Result := FQtdPropriedadesProcessadas;
end;

function TImportacaoDadoGeral.Get_QtdPropriedadesTotal: Integer;
begin
        Result := FQtdPropriedadesTotal;
end;

procedure TImportacaoDadoGeral.Set_QtdFazendasErradas(Value: Integer);
begin
        FQtdFazendasErradas := Value;
end;

procedure TImportacaoDadoGeral.Set_QtdFazendasProcessadas(Value: Integer);
begin
        FQtdFazendasProcessadas := Value;
end;

procedure TImportacaoDadoGeral.Set_QtdFazendasTotal(Value: Integer);
begin
        FQtdFazendasTotal := Value;
end;

procedure TImportacaoDadoGeral.Set_QtdLocaisErrados(Value: Integer);
begin
        FQtdLocaisErrados := Value;
end;

procedure TImportacaoDadoGeral.Set_QtdLocaisProcessados(Value: Integer);
begin
        FQtdLocaisProcessados := Value;
end;

procedure TImportacaoDadoGeral.Set_QtdLocaisTotal(Value: Integer);
begin
        FQtdLocaisTotal := Value;
end;

procedure TImportacaoDadoGeral.Set_QtdProdutoresErrados(Value: Integer);
begin
        FQtdProdutoresErrados := Value;
end;

procedure TImportacaoDadoGeral.Set_QtdProdutoresProcessados(
  Value: Integer);
begin
        FQtdProdutoresProcessados := Value;
end;

procedure TImportacaoDadoGeral.Set_QtdProdutoresTotal(Value: Integer);
begin
        FQtdProdutoresTotal := Value;
end;

procedure TImportacaoDadoGeral.Set_QtdPropriedadesErradas(Value: Integer);
begin
        FQtdPropriedadesErradas := Value;
end;

procedure TImportacaoDadoGeral.Set_QtdPropriedadesProcessadas(
  Value: Integer);
begin
        FQtdPropriedadesProcessadas := Value;
end;

procedure TImportacaoDadoGeral.Set_QtdPropriedadesTotal(Value: Integer);
begin
        FQtdPropriedadesTotal := Value;
end;

function TImportacaoDadoGeral.Get_CodUsuarioUpload: Integer;
begin
        Result := FCodUsuarioUpload;
end;

function TImportacaoDadoGeral.Get_NomUsuarioUpload: WideString;
begin
        Result := FNomUsuarioUpload;
end;

procedure TImportacaoDadoGeral.Set_CodUsuarioUpload(Value: Integer);
begin
        FCodUsuarioUpload := Value;
end;

procedure TImportacaoDadoGeral.Set_NomUsuarioUpload(
  const Value: WideString);
begin
        FNomUsuarioUpload := Value;
end;

function TImportacaoDadoGeral.Get_CodTipoOrigemArqImport: Integer;
begin
        Result := FCodTipoOrigemArqImport;
end;

function TImportacaoDadoGeral.Get_DesTipoOrigemArqImport: WideString;
begin
        Result := FDesTipoOrigemArqImport;
end;

function TImportacaoDadoGeral.Get_SglTipoOrigemArqImport: WideString;
begin
        Result := FSglTipoOrigemArqImport;
end;

procedure TImportacaoDadoGeral.Set_CodTipoOrigemArqImport(Value: Integer);
begin
        FCodTipoOrigemArqImport := Value;
end;

procedure TImportacaoDadoGeral.Set_DesTipoOrigemArqImport(
  const Value: WideString);
begin
        FDesTipoOrigemArqImport := Value;
end;

procedure TImportacaoDadoGeral.Set_SglTipoOrigemArqImport(
  const Value: WideString);
begin
        FSglTipoOrigemArqImport := Value;
end;

function TImportacaoDadoGeral.Get_CodSituacaoArqImport: WideString;
begin
        Result := FCodSituacaoArqImport;
end;

function TImportacaoDadoGeral.Get_DesSituacaoArqImport: WideString;
begin
        Result := FDesSituacaoArqImport;
end;

procedure TImportacaoDadoGeral.Set_CodSituacaoArqImport(
  const Value: WideString);
begin
        FCodSituacaoArqImport := Value;
end;

procedure TImportacaoDadoGeral.Set_DesSituacaoArqImport(
  const Value: WideString);
begin
        FDesSituacaoArqImport := Value;
end;

function TImportacaoDadoGeral.Get_CodSituacaoUltimaTarefa: WideString;
begin
        Result := FCodSituacaoUltimaTarefa;
end;

function TImportacaoDadoGeral.Get_CodUltimaTarefa: Integer;
begin
        Result := FCodUltimaTarefa;
end;

function TImportacaoDadoGeral.Get_DesSituacaoUltimaTarefa: WideString;
begin
        Result := FDesSituacaoUltimaTarefa;
end;

function TImportacaoDadoGeral.Get_DtaFimRealUltimaTarefa: TDateTime;
begin
        Result := FDtaFimRealUltimaTarefa;
end;

function TImportacaoDadoGeral.Get_DtaInicioPrevistoUltimaTarefa: TDateTime;
begin
        Result := FDtaInicioPrevistoUltimaTarefa;
end;

function TImportacaoDadoGeral.Get_DtaInicioRealUltimaTarefa: TDateTime;
begin
        Result := FDtaInicioRealUltimaTarefa;
end;

function TImportacaoDadoGeral.Get_QtdLinhas: Integer;
begin
        Result := FQtdLinhas;
end;

function TImportacaoDadoGeral.Get_QtdOcorrencias: Integer;
begin
        Result := FQtdOcorrencias;
end;

function TImportacaoDadoGeral.Get_TxtMensagem: WideString;
begin
        Result := FTxtMensagem;
end;

procedure TImportacaoDadoGeral.Set_CodSituacaoUltimaTarefa(
  const Value: WideString);
begin
        FCodSituacaoUltimaTarefa := Value;
end;

procedure TImportacaoDadoGeral.Set_CodUltimaTarefa(Value: Integer);
begin
        FCodUltimaTarefa := Value;
end;

procedure TImportacaoDadoGeral.Set_DesSituacaoUltimaTarefa(
  const Value: WideString);
begin
        FDesSituacaoUltimaTarefa := Value;
end;

procedure TImportacaoDadoGeral.Set_DtaFimRealUltimaTarefa(
  Value: TDateTime);
begin
        FDtaFimRealUltimaTarefa := Value;
end;

procedure TImportacaoDadoGeral.Set_DtaInicioPrevistoUltimaTarefa(
  Value: TDateTime);
begin
        FDtaInicioPrevistoUltimaTarefa := Value;
end;

procedure TImportacaoDadoGeral.Set_DtaInicioRealUltimaTarefa(
  Value: TDateTime);
begin
        FDtaInicioRealUltimaTarefa := Value;
end;

procedure TImportacaoDadoGeral.Set_QtdLinhas(Value: Integer);
begin
        FQtdLinhas := Value;
end;

procedure TImportacaoDadoGeral.Set_QtdOcorrencias(Value: Integer);
begin
        FQtdOcorrencias := Value;
end;

procedure TImportacaoDadoGeral.Set_TxtMensagem(const Value: WideString);
begin
        FTxtMensagem := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TImportacaoDadoGeral, Class_ImportacaoDadoGeral,
    ciMultiInstance, tmApartment);
end.
