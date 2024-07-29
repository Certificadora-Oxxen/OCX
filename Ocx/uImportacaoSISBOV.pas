unit uImportacaoSISBOV;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TImportacaoSISBOV = class(TASPMTSObject, IImportacaoSISBOV)
  private //Declaração dos atributos, conforme tipo de dados TLB!
     FNIRF: WideString;
     FNumCpfCnpj: WideString;
     FCodProdutor: Integer;
     FCodPropriedade: Integer;
     FCodSisBov: WideString;
     FCodArqImportSisBov: Integer;
     FNomArqImportSisBov: WideString;
     FNomArqUpload: WideString;
     FCodUsuarioUpLoad: Integer;
     FNomUsuarioUpLoad: WideString;
     FDtaArqImportSisBov: TDateTime;
     FQtdVezesProcessamento: Integer;
     FDtaUltimoProcessamento: TDateTime;
     FQtdLinhas: Integer;
     FQtdLinhasErroUltimoProc: Integer;
     FQtdLinhasLogUltimoProc: Integer;
     FCodTipoArqImportSisBov: Integer;
     FTxtDados: WideString;
     FQtdLinhasProcessadas: Integer;
     FCodTipoOrigemArqImport: Integer;
     FCodSituacaoArqImport: WideString;
     FtxtMensagem: WideString;
     FDesTipoOrigemArqImport: WideString;
     FDesSituacaoArqImport: WideString;
  protected
    function Get_CodArqImportSisBov: Integer; safecall;
    function Get_CodProdutor: Integer; safecall;
    function Get_CodPropriedade: Integer; safecall;
    function Get_CodSisBov: WideString; safecall;
    function Get_CodTipoArqImportSisBov: Integer; safecall;
    function Get_NumCpfCnpj: WideString; safecall;
    function Get_DtaImportacao: TDateTime; safecall;
    function Get_DtaUltimoProcessamento: TDateTime; safecall;
    function Get_NIRF: WideString; safecall;
    function Get_NomArqImportSisBov: WideString; safecall;
    function Get_NomArqUpload: WideString; safecall;
    function Get_NomUsuarioUpLoad: WideString; safecall;
    function Get_QtdLinhas: Integer; safecall;
    function Get_QtdLinhasErroUltimoProc: Integer; safecall;
    function Get_QtdLinhasLogUltimoProc: Integer; safecall;
    function Get_QtdVezesProcessamento: Integer; safecall;
    procedure Set_CodArqImportSisBov(Value: Integer); safecall;
    procedure Set_CodProdutor(Value: Integer); safecall;
    procedure Set_CodPropriedade(Value: Integer); safecall;
    procedure Set_CodSisBov(const Value: WideString); safecall;
    procedure Set_CodTipoArqImportSisBov(Value: Integer); safecall;
    procedure Set_NumCpfCnpj(const Value: WideString); safecall;
    procedure Set_DtaImportacao(Value: TDateTime); safecall;
    procedure Set_DtaUltimoProcessamento(Value: TDateTime); safecall;
    procedure Set_NIRF(const Value: WideString); safecall;
    procedure Set_NomArqImportSisBov(const Value: WideString); safecall;
    procedure Set_NomArqUpload(const Value: WideString); safecall;
    procedure Set_NomUsuarioUpLoad(const Value: WideString); safecall;
    procedure Set_QtdLinhas(Value: Integer); safecall;
    procedure Set_QtdLinhasErroUltimoProc(Value: Integer); safecall;
    procedure Set_QtdLinhasLogUltimoProc(Value: Integer); safecall;
    procedure Set_QtdVezesProcessamento(Value: Integer); safecall;
    function Get_TxtDados: WideString; safecall;
    procedure Set_TxtDados(const Value: WideString); safecall;
    function Get_CodUsuarioUpLoad: Integer; safecall;
    procedure Set_CodUsuarioUpLoad(Value: Integer); safecall;
    function Get_QtdLinhasProcessadas: Integer; safecall;
    procedure Set_QtdLinhasProcessadas(Value: Integer); safecall;
    function Get_CodSituacaoArqImport: WideString; safecall;
    function Get_CodTipoOrigemArqImport: Integer; safecall;
    function Get_txtMensagem: WideString; safecall;
    procedure Set_CodSituacaoArqImport(const Value: WideString); safecall;
    procedure Set_CodTipoOrigemArqImport(Value: Integer); safecall;
    procedure Set_txtMensagem(const Value: WideString); safecall;
    function Get_DesSituacaoArqImport: WideString; safecall;
    function Get_DesTipoOrigemArqImport: WideString; safecall;
    procedure Set_DesSituacaoArqImport(const Value: WideString); safecall;
    procedure Set_DesTipoOrigemArqImport(const Value: WideString); safecall;

  public
    property NIRF: WideString  read FNIRF write FNIRF;
    property NumCpfCnpj: WideString  read FNumCpfCnpj write FNumCpfCnpj;
    property CodProdutor: Integer  read FCodProdutor write FCodProdutor;
    property CodPropriedade: Integer  read FCodPropriedade write FCodPropriedade;
    property CodSisBov: WideString  read FCodSisBov write FCodSisBov;
    property CodArqImportSisBov: Integer read FCodArqImportSisBov write FCodArqImportSisBov;
    property NomArqImportSisBov: WideString read FNomArqImportSisBov write FNomArqImportSisBov;
    property NomArqUpload: WideString read FNomArqUpload write FNomArqUpload;
    property NomUsuarioUpLoad: WideString read FNomUsuarioUpLoad write FNomUsuarioUpLoad;
    property QtdVezesProcessamento: Integer read FQtdVezesProcessamento write FQtdVezesProcessamento;
    property DtaUltimoProcessamento: TDateTime read FDtaUltimoProcessamento write FDtaUltimoProcessamento;
    property DtaArqImportSisBov: TDateTime read FDtaArqImportSisBov write FDtaArqImportSisBov;
    property QtdLinhas: Integer read FQtdLinhas write FQtdLinhas;
    property QtdLinhasErroUltimoProc: Integer read FQtdLinhasErroUltimoProc write FQtdLinhasErroUltimoProc;
    property QtdLinhasLogUltimoProc: Integer read FQtdLinhasLogUltimoProc write FQtdLinhasLogUltimoProc;
    property CodTipoArqImportSisBov: Integer read FCodTipoArqImportSisBov write FCodTipoArqImportSisBov;
    property TxtDados: WideString read FTxtDados write FTxtDados;
    property QtdLinhasProcessadas: Integer read FQtdLinhasProcessadas write FQtdLinhasProcessadas;
    property CodTipoOrigemArqImport: Integer read FCodTipoOrigemArqImport write FCodTipoOrigemArqImport;
    property CodSituacaoArqImport: WideString read FCodSituacaoArqImport write FCodSituacaoArqImport;
    property txtMensagem: WideString read FtxtMensagem write FtxtMensagem;
    property DesTipoOrigemArqImport: WideString read FDesTipoOrigemArqImport write FDesTipoOrigemArqImport;
    property DesSituacaoArqImport: WideString read FDesSituacaoArqImport write FDesSituacaoArqImport;
    
  end;
                                                                                                  

implementation


uses ComServ;

function TImportacaoSISBOV.Get_CodArqImportSisBov: Integer;
begin
   Result := FCodArqImportSisBov;
end;

function TImportacaoSISBOV.Get_CodProdutor: Integer;
begin
   Result := FCodProdutor;
end;

function TImportacaoSISBOV.Get_CodPropriedade: Integer;
begin
   Result := FCodPropriedade;
end;

function TImportacaoSISBOV.Get_CodSisBov: WideString;
begin
   Result := FCodSisBov;
end;

function TImportacaoSISBOV.Get_CodTipoArqImportSisBov: Integer;
begin
   Result := FCodArqImportSisBov;
end;

function TImportacaoSISBOV.Get_NumCpfCnpj: WideString;
begin
   Result := FNumCpfCnpj;
end;

function TImportacaoSISBOV.Get_DtaImportacao: TDateTime;
begin
   Result := FDtaArqImportSisBov;
end;

function TImportacaoSISBOV.Get_DtaUltimoProcessamento: TDateTime;
begin
   Result := FDtaUltimoProcessamento;
end;

function TImportacaoSISBOV.Get_NIRF: WideString;
begin
   Result := FNIRF;
end;

function TImportacaoSISBOV.Get_NomArqImportSisBov: WideString;
begin
   Result := FNomArqImportSisBov;
end;

function TImportacaoSISBOV.Get_NomArqUpload: WideString;
begin
   Result := FNomArqUpload;
end;

function TImportacaoSISBOV.Get_NomUsuarioUpLoad: WideString;
begin
   Result := FNomUsuarioUpLoad;
end;

function TImportacaoSISBOV.Get_QtdLinhas: Integer;
begin
   Result := FQtdLinhas;
end;

function TImportacaoSISBOV.Get_QtdLinhasErroUltimoProc: Integer;
begin
   Result := FQtdLinhasErroUltimoProc;
end;

function TImportacaoSISBOV.Get_QtdLinhasLogUltimoProc: Integer;
begin
   Result := FQtdLinhasLogUltimoProc;
end;

function TImportacaoSISBOV.Get_QtdVezesProcessamento: Integer;
begin
   Result := FQtdVezesProcessamento;
end;

procedure TImportacaoSISBOV.Set_CodArqImportSisBov(Value: Integer);
begin
   FCodArqImportSisBov := Value;
end;

procedure TImportacaoSISBOV.Set_CodProdutor(Value: Integer);
begin
   FCodProdutor := Value;
end;

procedure TImportacaoSISBOV.Set_CodPropriedade(Value: Integer);
begin
   FCodPropriedade := Value;
end;

procedure TImportacaoSISBOV.Set_CodSisBov(const Value: WideString);
begin
   FCodSisBov := Value;
end;

procedure TImportacaoSISBOV.Set_CodTipoArqImportSisBov(Value: Integer);
begin
   FCodTipoArqImportSisBov := Value;
end;

procedure TImportacaoSISBOV.Set_NumCpfCnpj(const Value: WideString);
begin
   FNumCpfCnpj := Value;
end;

procedure TImportacaoSISBOV.Set_DtaImportacao(Value: TDateTime);
begin
   FDtaArqImportSisBov := Value;
end;

procedure TImportacaoSISBOV.Set_DtaUltimoProcessamento(Value: TDateTime);
begin
   FDtaUltimoProcessamento := Value;
end;

procedure TImportacaoSISBOV.Set_NIRF(const Value: WideString);
begin
   FNIRF := Value;
end;

procedure TImportacaoSISBOV.Set_NomArqImportSisBov(
  const Value: WideString);
begin
   FNomArqImportSisBov := Value;
end;

procedure TImportacaoSISBOV.Set_NomArqUpload(const Value: WideString);
begin
   FNomArqUpload := Value;
end;

procedure TImportacaoSISBOV.Set_NomUsuarioUpLoad(const Value: WideString);
begin
   FNomUsuarioUpLoad := Value;
end;

procedure TImportacaoSISBOV.Set_QtdLinhas(Value: Integer);
begin
   FQtdLinhas := Value;
end;

procedure TImportacaoSISBOV.Set_QtdLinhasErroUltimoProc(Value: Integer);
begin
   FQtdLinhasErroUltimoProc := Value;
end;

procedure TImportacaoSISBOV.Set_QtdLinhasLogUltimoProc(Value: Integer);
begin
   FQtdLinhasLogUltimoProc := Value;
end;

procedure TImportacaoSISBOV.Set_QtdVezesProcessamento(Value: Integer);
begin
   FQtdVezesProcessamento := Value;
end;

function TImportacaoSISBOV.Get_TxtDados: WideString;
begin
   Result := FTxtDados;
end;

procedure TImportacaoSISBOV.Set_TxtDados(const Value: WideString);
begin
   FTxtDados := Value;
end;

function TImportacaoSISBOV.Get_CodUsuarioUpLoad: Integer;
begin
   Result := FCodUsuarioUpLoad;
end;

procedure TImportacaoSISBOV.Set_CodUsuarioUpLoad(Value: Integer);
begin
   FCodUsuarioUpLoad := Value;
end;

function TImportacaoSISBOV.Get_QtdLinhasProcessadas: Integer;
begin
   Result := FQtdLinhasProcessadas;
end;

procedure TImportacaoSISBOV.Set_QtdLinhasProcessadas(Value: Integer);
begin
   FQtdLinhasProcessadas := Value;
end;

function TImportacaoSISBOV.Get_CodSituacaoArqImport: WideString;
begin
   Result := FCodSituacaoArqImport;
end;

function TImportacaoSISBOV.Get_CodTipoOrigemArqImport: Integer;
begin
   Result := FCodTipoOrigemArqImport;
end;

function TImportacaoSISBOV.Get_txtMensagem: WideString;
begin
   Result := FtxtMensagem;
end;

procedure TImportacaoSISBOV.Set_CodSituacaoArqImport(
  const Value: WideString);
begin
   FCodSituacaoArqImport := Value;
end;

procedure TImportacaoSISBOV.Set_CodTipoOrigemArqImport(Value: Integer);
begin
   FCodTipoOrigemArqImport := Value;
end;

procedure TImportacaoSISBOV.Set_txtMensagem(const Value: WideString);
begin
   FtxtMensagem := Value;
end;

function TImportacaoSISBOV.Get_DesSituacaoArqImport: WideString;
begin
   Result := FDesSituacaoArqImport;
end;

function TImportacaoSISBOV.Get_DesTipoOrigemArqImport: WideString;
begin
   Result := FDesTipoOrigemArqImport
end;

procedure TImportacaoSISBOV.Set_DesSituacaoArqImport(
  const Value: WideString);
begin
   FDesSituacaoArqImport := Value;
end;

procedure TImportacaoSISBOV.Set_DesTipoOrigemArqImport(
  const Value: WideString);
begin
   FDesTipoOrigemArqImport := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TImportacaoSISBOV, Class_ImportacaoSISBOV,
    ciMultiInstance, tmApartment);
end.
