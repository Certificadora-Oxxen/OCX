unit uImportacaoFabricante;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TImportacaoFabricante = class(TASPMTSObject, IImportacaoFabricante)
  protected
    FCodArqImportFabricante: Integer;
    FCodFabricanteIdentificador: Integer;
    FCodSituacaoArqImport: String;
    FCodSituacaoTarefa: String;
    FCodTarefa: Integer;
    FCodTipoArqImportFabricante: Integer;
    FCodTipoOrigemArqImport: Integer;
    FCodUsuarioProc: Integer;
    FCodUsuarioUpload: Integer;
    FDesSituacaoArqImport: String;
    FDesSituacaoTarefa: String;
    FDesTipoArqImportFabricante: String;
    FDesTipoOrigemArqImport: String;
    FDtaFimRealTarefa: TDateTime;
    FDtaImportacao: TDateTime; 
    FDtaInicioPrevistoTarefa: TDateTime; 
    FDtaInicioRealTarefa: TDateTime; 
    FDtaProcessamento: TDateTime; 
    FNomArqImportFabricante: String; 
    FNomArqUpload: String; 
    FNomFabricanteIdentificador: String;
    FNomReduzidoFabricanteIdentificador: String; 
    FNomUsuarioProc: String;
    FNomUsuarioUpload: String;
    FQtdOcorrencias: Integer;
    FQtdRegistrosErrados: Integer;
    FQtdRegistrosProcessados: Integer;
    FQtdRegistrosTotal: Integer;
    FSglTipoArqImportFabricante: String;
    FSglTipoOrigemArqImport: String;
    FTxtMensagem: String;

  protected
    function Get_CodArqImportFabricante: Integer; safecall;
    function Get_CodFabricanteIdentificador: Integer; safecall;
    function Get_CodSituacaoArqImport: WideString; safecall;
    function Get_CodSituacaoTarefa: WideString; safecall;
    function Get_CodTarefa: Integer; safecall;
    function Get_CodTipoArqImportFabricante: Integer; safecall;
    function Get_CodTipoOrigemArqImport: Integer; safecall;
    function Get_CodUsuarioProc: Integer; safecall;
    function Get_CodUsuarioUpload: Integer; safecall;
    function Get_DesSituacaoArqImport: WideString; safecall;
    function Get_DesSituacaoTarefa: WideString; safecall;
    function Get_DesTipoArqImportFabricante: WideString; safecall;
    function Get_DesTipoOrigemArqImport: WideString; safecall;
    function Get_DtaFimRealTarefa: TDateTime; safecall;
    function Get_DtaImportacao: TDateTime; safecall;
    function Get_DtaInicioPrevistoTarefa: TDateTime; safecall;
    function Get_DtaInicioRealTarefa: TDateTime; safecall;
    function Get_DtaProcessamento: TDateTime; safecall;
    function Get_NomArqImportFabricante: WideString; safecall;
    function Get_NomArqUpload: WideString; safecall;
    function Get_NomFabricanteIdentificador: WideString; safecall;
    function Get_NomReduzidoFabricanteIdentificador: WideString; safecall;
    function Get_NomUsuarioProc: WideString; safecall;
    function Get_NomUsuarioUpload: WideString; safecall;
    function Get_QtdOcorrencias: Integer; safecall;
    function Get_QtdRegistrosErrados: Integer; safecall;
    function Get_QtdRegistrosProcessados: Integer; safecall;
    function Get_QtdRegistrosTotal: Integer; safecall;
    function Get_SglTipoArqImportFabricante: WideString; safecall;
    function Get_SglTipoOrigemArqImport: WideString; safecall;
    function Get_TxtMensagem: WideString; safecall;
    
  public
    property CodArqImportFabricante: Integer read FCodArqImportFabricante write FCodArqImportFabricante;
    property CodFabricanteIdentificador: Integer read FCodFabricanteIdentificador write FCodFabricanteIdentificador;
    property CodSituacaoArqImport: String read FCodSituacaoArqImport write FCodSituacaoArqImport;
    property CodSituacaoTarefa: String read FCodSituacaoTarefa write FCodSituacaoTarefa;
    property CodTarefa: Integer read FCodTarefa write FCodTarefa;
    property CodTipoArqImportFabricante: Integer read FCodTipoArqImportFabricante write FCodTipoArqImportFabricante;
    property CodTipoOrigemArqImport: Integer read FCodTipoOrigemArqImport write FCodTipoOrigemArqImport;
    property CodUsuarioProc: Integer read FCodUsuarioProc write FCodUsuarioProc;
    property CodUsuarioUpload: Integer read FCodUsuarioUpload write FCodUsuarioUpload;
    property DesSituacaoArqImport: String read FDesSituacaoArqImport write FDesSituacaoArqImport;
    property DesSituacaoTarefa: String read FDesSituacaoTarefa write FDesSituacaoTarefa;
    property DesTipoArqImportFabricante: String read FDesTipoArqImportFabricante write FDesTipoArqImportFabricante;
    property DesTipoOrigemArqImport: String read FDesTipoOrigemArqImport write FDesTipoOrigemArqImport;
    property DtaFimRealTarefa: TDateTime read FDtaFimRealTarefa write FDtaFimRealTarefa;
    property DtaImportacao: TDateTime read FDtaImportacao write FDtaImportacao;
    property DtaInicioPrevistoTarefa: TDateTime read FDtaInicioPrevistoTarefa write FDtaInicioPrevistoTarefa;
    property DtaInicioRealTarefa: TDateTime read FDtaInicioRealTarefa write FDtaInicioRealTarefa;
    property DtaProcessamento: TDateTime read FDtaProcessamento write FDtaProcessamento;
    property NomArqImportFabricante: String read FNomArqImportFabricante write FNomArqImportFabricante;
    property NomArqUpload: String read FNomArqUpload write FNomArqUpload;
    property NomFabricanteIdentificador: String read FNomFabricanteIdentificador write FNomFabricanteIdentificador;
    property NomReduzidoFabricanteIdentificador: String read FNomReduzidoFabricanteIdentificador write FNomReduzidoFabricanteIdentificador;
    property NomUsuarioProc: String read FNomUsuarioProc write FNomUsuarioProc;
    property NomUsuarioUpload: String read FNomUsuarioUpload write FNomUsuarioUpload;
    property QtdOcorrencias: Integer read FQtdOcorrencias write FQtdOcorrencias;
    property QtdRegistrosErrados: Integer read FQtdRegistrosErrados write FQtdRegistrosErrados;
    property QtdRegistrosProcessados: Integer read FQtdRegistrosProcessados write FQtdRegistrosProcessados;
    property QtdRegistrosTotal: Integer read FQtdRegistrosTotal write FQtdRegistrosTotal;
    property SglTipoArqImportFabricante: String read FSglTipoArqImportFabricante write FSglTipoArqImportFabricante;
    property SglTipoOrigemArqImport: String read FSglTipoOrigemArqImport write FSglTipoOrigemArqImport;
    property TxtMensagem: String read FTxtMensagem write FTxtMensagem;
  end;

implementation

uses ComServ;

function TImportacaoFabricante.Get_CodArqImportFabricante: Integer;
begin
  Result := CodArqImportFabricante;
end;

function TImportacaoFabricante.Get_CodFabricanteIdentificador: Integer;
begin
  Result := CodFabricanteIdentificador;
end;

function TImportacaoFabricante.Get_CodSituacaoArqImport: WideString;
begin
  Result := CodSituacaoArqImport;
end;

function TImportacaoFabricante.Get_CodSituacaoTarefa: WideString;
begin
  Result := CodSituacaoTarefa;
end;

function TImportacaoFabricante.Get_CodTarefa: Integer;
begin
  Result := CodTarefa;
end;

function TImportacaoFabricante.Get_CodTipoArqImportFabricante: Integer;
begin
  Result := CodTipoArqImportFabricante;
end;

function TImportacaoFabricante.Get_CodTipoOrigemArqImport: Integer;
begin
  Result := CodTipoOrigemArqImport;
end;

function TImportacaoFabricante.Get_CodUsuarioProc: Integer;
begin
  Result := CodUsuarioProc;
end;

function TImportacaoFabricante.Get_CodUsuarioUpload: Integer;
begin
  Result := CodUsuarioUpload;
end;

function TImportacaoFabricante.Get_DesSituacaoArqImport: WideString;
begin
  Result := DesSituacaoArqImport;
end;

function TImportacaoFabricante.Get_DesSituacaoTarefa: WideString;
begin
  Result := DesSituacaoTarefa;
end;

function TImportacaoFabricante.Get_DesTipoArqImportFabricante: WideString;
begin
  Result := DesTipoArqImportFabricante;
end;

function TImportacaoFabricante.Get_DesTipoOrigemArqImport: WideString;
begin
  Result := DesTipoOrigemArqImport;
end;

function TImportacaoFabricante.Get_DtaFimRealTarefa: TDateTime;
begin
  Result := DtaFimRealTarefa;
end;

function TImportacaoFabricante.Get_DtaImportacao: TDateTime;
begin
  Result := DtaImportacao;
end;

function TImportacaoFabricante.Get_DtaInicioPrevistoTarefa: TDateTime;
begin
  Result := DtaInicioPrevistoTarefa;
end;

function TImportacaoFabricante.Get_DtaInicioRealTarefa: TDateTime;
begin
  Result := DtaInicioRealTarefa;
end;

function TImportacaoFabricante.Get_DtaProcessamento: TDateTime;
begin
  Result := DtaProcessamento;
end;

function TImportacaoFabricante.Get_NomArqImportFabricante: WideString;
begin
  Result := NomArqImportFabricante;
end;

function TImportacaoFabricante.Get_NomArqUpload: WideString;
begin
  Result := NomArqUpload;
end;

function TImportacaoFabricante.Get_NomFabricanteIdentificador: WideString;
begin
  Result := NomFabricanteIdentificador;
end;

function TImportacaoFabricante.Get_NomReduzidoFabricanteIdentificador: WideString;
begin
  Result := NomReduzidoFabricanteIdentificador;
end;

function TImportacaoFabricante.Get_NomUsuarioProc: WideString;
begin
  Result := NomUsuarioProc;
end;

function TImportacaoFabricante.Get_NomUsuarioUpload: WideString;
begin
  Result := NomUsuarioUpload;
end;

function TImportacaoFabricante.Get_QtdOcorrencias: Integer;
begin
  Result := QtdOcorrencias;
end;

function TImportacaoFabricante.Get_QtdRegistrosErrados: Integer;
begin
  Result := QtdRegistrosErrados;
end;

function TImportacaoFabricante.Get_QtdRegistrosProcessados: Integer;
begin
  Result := QtdRegistrosProcessados;
end;

function TImportacaoFabricante.Get_QtdRegistrosTotal: Integer;
begin
  Result := QtdRegistrosTotal;
end;

function TImportacaoFabricante.Get_SglTipoArqImportFabricante: WideString;
begin
  Result := SglTipoArqImportFabricante;
end;

function TImportacaoFabricante.Get_SglTipoOrigemArqImport: WideString;
begin
  Result := SglTipoOrigemArqImport;
end;

function TImportacaoFabricante.Get_TxtMensagem: WideString;
begin
  Result := TxtMensagem;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TImportacaoFabricante, Class_ImportacaoFabricante,
    ciMultiInstance, tmApartment);
end.
