unit uItemMenu;

interface

uses
  ComObj, ActiveX, AspTlb, Boitata_TLB, StdVcl;

type
  TItemMenu = class(TASPMTSObject, IItemMenu)
  private
    FCodItemMenu : Integer;
    FTxtTitulo : WideString;
    FTxtHintItemMenu : WideString;
    FIndDestaqueTitulo : WideString;
    FCodItemPai : Integer;
    FNumOrdem : Integer;
    FNumNivel : Integer;
    FQtdFilhos : Integer;
    FCodPagina : Integer;
    FURLPagina : WideString;
  protected
    function Get_CodItemMenu: Integer; safecall;
    function Get_CodItemPai: Integer; safecall;
    function Get_CodPagina: Integer; safecall;
    function Get_IndDestaqueTitulo: WideString; safecall;
    function Get_NumNivel: Integer; safecall;
    function Get_NumOrdem: Integer; safecall;
    function Get_QtdFilhos: Integer; safecall;
    function Get_TxtHintItemMenu: WideString; safecall;
    function Get_TxtTitulo: WideString; safecall;
    function Get_URLPagina: WideString; safecall;
    procedure Set_CodItemMenu(Value: Integer); safecall;
    procedure Set_CodItemPai(Value: Integer); safecall;
    procedure Set_CodPagina(Value: Integer); safecall;
    procedure Set_IndDestaqueTitulo(const Value: WideString); safecall;
    procedure Set_NumNivel(Value: Integer); safecall;
    procedure Set_NumOrdem(Value: Integer); safecall;
    procedure Set_QtdFilhos(Value: Integer); safecall;
    procedure Set_TxtHintItemMenu(const Value: WideString); safecall;
    procedure Set_TxtTitulo(const Value: WideString); safecall;
    procedure Set_URLPagina(const Value: WideString); safecall;
  public
    property CodItemMenu : Integer              read FCodItemMenu        write FCodItemMenu;
    property TxtTitulo : WideString             read FTxtTitulo          write FTxtTitulo;
    property TxtHintItemMenu : WideString               read FTxtHintItemMenu            write FTxtHintItemMenu;
    property IndDestaqueTitulo : WideString     read FIndDestaqueTitulo  write FIndDestaqueTitulo;
    property CodItemPai : Integer               read FCodItemPai         write FCodItemPai;
    property NumOrdem : Integer                 read FNumOrdem           write FNumOrdem;
    property NumNivel : Integer                 read FNumNivel           write FNumNivel;
    property QtdFilhos : Integer                read FQtdFilhos          write FQtdFilhos;
    property CodPagina : Integer                read FCodPagina          write FCodPagina;
    property URLPagina : WideString             read FURLPagina          write FURLPagina;
  end;

implementation

uses ComServ;

function TItemMenu.Get_CodItemMenu: Integer;
begin
  Result := FCodItemMenu;
end;

function TItemMenu.Get_CodItemPai: Integer;
begin
  Result := FCodItemPai;
end;

function TItemMenu.Get_CodPagina: Integer;
begin
  Result := FCodPagina;
end;

function TItemMenu.Get_IndDestaqueTitulo: WideString;
begin
  Result := FIndDestaqueTitulo;
end;

function TItemMenu.Get_NumNivel: Integer;
begin
  Result := FNumNivel;
end;

function TItemMenu.Get_NumOrdem: Integer;
begin
  Result := FNumOrdem;
end;

function TItemMenu.Get_QtdFilhos: Integer;
begin
  Result := FQtdFilhos;
end;

function TItemMenu.Get_TxtHintItemMenu: WideString;
begin
  Result := FTxtHintItemMenu;
end;

function TItemMenu.Get_TxtTitulo: WideString;
begin
  Result := FTxtTitulo;
end;

function TItemMenu.Get_URLPagina: WideString;
begin
  Result := FURLPagina;
end;

procedure TItemMenu.Set_CodItemMenu(Value: Integer);
begin
  FCodItemMenu := Value;
end;

procedure TItemMenu.Set_CodItemPai(Value: Integer);
begin
  FCodItemPai := Value;
end;

procedure TItemMenu.Set_CodPagina(Value: Integer);
begin
  FCodPagina := Value;
end;

procedure TItemMenu.Set_IndDestaqueTitulo(const Value: WideString);
begin
  FIndDestaqueTitulo := Value;
end;

procedure TItemMenu.Set_NumNivel(Value: Integer);
begin
  FNumNivel := Value;
end;

procedure TItemMenu.Set_NumOrdem(Value: Integer);
begin
  FNumOrdem := Value;
end;

procedure TItemMenu.Set_QtdFilhos(Value: Integer);
begin
  FQtdFilhos := Value;
end;

procedure TItemMenu.Set_TxtHintItemMenu(const Value: WideString);
begin
  FTxtHintItemMenu := Value;
end;

procedure TItemMenu.Set_TxtTitulo(const Value: WideString);
begin
  FTxtTitulo := Value;
end;

procedure TItemMenu.Set_URLPagina(const Value: WideString);
begin
  FURLPagina := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TItemMenu, Class_ItemMenu,
    ciMultiInstance, tmApartment);
end.
