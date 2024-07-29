unit uColecoes;

interface

uses classes;

type
  {TItemMenuUsuario}
  TItemMenuUsuario = class(TCollectionItem)
  private
    FCodItemMenu: Integer;
    FTxtTitulo: String;
    FTxtHintItemMenu: String;
    FIndDestaqueTitulo: String;
    FCodItemPai: Integer;
    FNumOrdem: Integer;
    FNumNivel: Integer;
    FQtdFilhos: Integer;
    FCodPagina: Integer;
    FURLPagina: String;
  public
    property CodItemMenu: Integer      read FCodItemMenu       write FCodItemMenu;
    property TxtTitulo: String         read FTxtTitulo         write FTxtTitulo;
    property TxtHintItemMenu: String           read FTxtHintItemMenu           write FTxtHintItemMenu;
    property IndDestaqueTitulo: String read FIndDestaqueTitulo write FIndDestaqueTitulo;
    property CodItemPai: Integer       read FCodItemPai        write FCodItemPai;
    property NumOrdem: Integer         read FNumOrdem          write FNumOrdem;
    property NumNivel: Integer         read FNumNivel          write FNumNivel;
    property QtdFilhos: Integer        read FQtdFilhos         write FQtdFilhos;
    property CodPagina: Integer        read FCodPagina         write FCodPagina;
    property URLPagina: String         read FURLPagina         write FURLPagina;
  end;

  {TItensMenuUsuario}
  TItensMenuUsuario = class(TCollection)
  private
    function GetItem(Index: Integer): TItemMenuUsuario;
    procedure SetItem(Index: Integer; Value: TItemMenuUsuario);
  public
    function Add(CodItemMenu: Integer; TxtTitulo, TxtHintItemMenu, IndDestaqueTitulo: String;
      CodItemPai, NumOrdem, NumNivel, QtdFilhos, CodPagina: Integer;
      URLPagina: String): TItemMenuUsuario;
    property Items[Index: Integer]: TItemMenuUsuario read GetItem write SetItem; default;
  end;

  {TErroConexao}
  TErroConexao = class(TCollectionItem)
  private
    FCodigo: Integer;
    FTexto: String;
  public
    property Codigo: Integer read FCodigo write FCodigo;
    property Texto:  String  read FTexto  write FTexto;
  end;

  {TErrosConexao}
  TErrosConexao = class(TCollection)
  private
    function GetItem(Index: Integer): TErroConexao;
    procedure SetItem(Index: Integer; Value: TErroConexao);
  public
    function Add(Codigo: Integer; Texto: String): TErroConexao;
    property Items[Index: Integer]: TErroConexao read GetItem write SetItem; default;
  end;

  {TValorParametro}
  TValorParametro = class(TCollectionItem)
  private
    FValor: Variant;
  public
    property Valor: Variant read FValor write FValor;
  end;

  {TValoresParametro}
  TValoresParametro = class(TCollection)
  private
    function GetItem(Index: Integer): TValorParametro;
    procedure SetItem(Index: Integer; Value: TValorParametro);
  public
    function Add(Valor: Variant): TValorParametro;
    property Items[Index: Integer]: TValorParametro read GetItem write SetItem; default;
  end;


implementation

{TItensMenuUsuario}
function TItensMenuUsuario.Add(CodItemMenu: Integer; TxtTitulo, TxtHintItemMenu, IndDestaqueTitulo: String;
  CodItemPai, NumOrdem, NumNivel, QtdFilhos, CodPagina: Integer; URLPagina: String): TItemMenuUsuario;
begin
  Result := TItemMenuUsuario(inherited Add);
  Result.CodItemMenu       := CodItemMenu;
  Result.TxtTitulo         := TxtTitulo;
  Result.TxtHintItemMenu           := TxtHintItemMenu;
  Result.IndDestaqueTitulo := IndDestaqueTitulo;
  Result.CodItemPai        := CodItemPai;
  Result.NumOrdem          := NumOrdem;
  Result.NumNivel          := NumNivel;
  Result.QtdFilhos         := QtdFilhos;
  Result.CodPagina         := CodPagina;
  Result.URLPagina         := UrlPagina;
end;

function TItensMenuUsuario.GetItem(Index: Integer): TItemMenuUsuario;
begin
  Result := TItemMenuUsuario(inherited GetItem(Index));
end;

procedure TItensMenuUsuario.SetItem(Index: Integer; Value: TItemMenuUsuario);
begin
  inherited SetItem(Index, Value);
end;

{TErrosConexao}
function TErrosConexao.Add(Codigo: Integer; Texto: String): TErroConexao;
begin
  Result := TErroConexao(inherited Add);
  Result.Codigo := Codigo;
  Result.Texto  := Texto;
end;

function TErrosConexao.GetItem(Index: Integer): TErroConexao;
begin
  Result := TErroConexao(inherited GetItem(Index));
end;

procedure TErrosConexao.SetItem(Index: Integer; Value: TErroConexao);
begin
  inherited SetItem(Index, Value);
end;

{ TValoresParametro }
function TValoresParametro.Add(Valor: Variant): TValorParametro;
begin
  Result := TValorParametro(inherited Add);
  Result.Valor := Valor;
end;

function TValoresParametro.GetItem(
  Index: Integer): TValorParametro;
begin
  Result := TValorParametro(inherited GetItem(Index));
end;

procedure TValoresParametro.SetItem(Index: Integer;
  Value: TValorParametro);
begin
  inherited SetItem(Index, Value);
end;

end.
