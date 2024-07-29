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

unit uIntTipoPropriedades;

interface
uses
  uIntClassesBasicas,dbtables, sysutils, db, uConexao, uIntMensagens,uFerramentas,
  uRaca,uIntTipoPropriedade;

type TIntTipoPropriedades = class(TIntClasseBDNavegacaoBasica)
private
  FIntTipoPropriedade:TIntTipoPropriedade;
protected
  procedure AoRetornarDados;override;
  procedure AoFecharDataset;override;

public
  function Pesquisar(CodTipoPropriedade:integer;des_tipo_propriedade:string):integer;
  function Inserir(CodTipoPropriedade:integer;des_tipo_propriedade:string;qtd_dias_prox_vistoria:integer):integer;
  function alterar(CodTipoPropriedade:integer;des_tipo_propriedade:string;qtd_dias_prox_vistoria:integer):integer;
  function excluir(CodTipoPropriedade:integer):integer;
  constructor Create; override;
  destructor Destroy; override;
  property IntTipoPropriedade : TIntTipoPropriedade read FIntTipoPropriedade write FIntTipoPropriedade;
published

end;

implementation

function TIntTipoPropriedades.alterar(CodTipoPropriedade: integer;
  des_tipo_propriedade: string; qtd_dias_prox_vistoria: integer): integer;
var   Q : THerdomQuery;
const
  NomeMetodo      : String  = 'Atualizar';
  CodMetodo       : integer = 654;//OBS Trocar esse valor de acordo com a tabela
  CodClasse       : integer = 120;//OBS Trocar esse valor de acordo com a tabela
  EBDUpdateError  : integer = 10247;
begin
  result  :=  0;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;
  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then
  Begin
    Mensagens.Adicionar(EFaltaAcesso, Self.ClassName, NomeMetodo, []);
    Result := -1*EFaltaAcesso;
    Exit;
  End;
  Q           :=  THerdomQuery.Create(Conexao, nil);
  try
    Q.SQL.Text  :=  'UPDATE  TAB_TIPO_PROPRIEDADE_RURAL '+
                    'SET DES_TIPO_PROPRIEDADE_RURAL = :DES_TIPO_PROPRIEDADE_RURAL,'+
                    'QTD_DIAS_PROX_VISTORIA = :QTD_DIAS_PROX_VISTORIA '+
                    'WHERE COD_TIPO_PROPRIEDADE_RURAL = :COD_TIPO_PROPRIEDADE_RURAL';
    q.ParamByName('COD_TIPO_PROPRIEDADE_RURAL').AsInteger :=  CodTipoPropriedade;
    q.ParamByName('DES_TIPO_PROPRIEDADE_RURAL').AsString  :=  trim(des_tipo_propriedade);
    q.ParamByName('QTD_DIAS_PROX_VISTORIA').AsInteger     :=  qtd_dias_prox_vistoria;

    try
      Begintran;
      q.ExecSQL();
      Commit;
    except
      on e:exception do
      begin
        Rollback;
        Mensagens.Adicionar(EBDUpdateError, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1*EBDUpdateError;
        Exit;
      end;
    end;
  finally
    FreeAndNil(q);
  end;
  result  :=  CodTipoPropriedade;
end;

procedure TIntTipoPropriedades.AoFecharDataset;
begin
  FIntTipoPropriedade.CodTipoPropriedade  :=  0;
  FIntTipoPropriedade.DesTipoPropriedade  :=  '';
  FIntTipoPropriedade.QtdDiasProxVistoria :=  0;
end;

procedure TIntTipoPropriedades.AoRetornarDados;
begin
  FIntTipoPropriedade.CodTipoPropriedade  :=  query.FieldByName('COD_TIPO_PROPRIEDADE_RURAL').AsInteger;
  FIntTipoPropriedade.DesTipoPropriedade  :=  query.FieldByName('DES_TIPO_PROPRIEDADE_RURAL').AsString;
  FIntTipoPropriedade.QtdDiasProxVistoria :=  query.FieldByName('QTD_DIAS_PROX_VISTORIA').AsInteger;
end;

constructor TIntTipoPropriedades.Create;
begin
  inherited;
  FIntTipoPropriedade :=  TIntTipoPropriedade.Create;
end;

destructor TIntTipoPropriedades.Destroy;
begin
  FreeAndNil(FIntTipoPropriedade);
  inherited;
end;

function TIntTipoPropriedades.excluir(CodTipoPropriedade: integer): integer;
var   Q : THerdomQuery;
const
  NomeMetodo      : String  = 'Excluir';
  CodMetodo       : integer = 655;//OBS Trocar esse valor de acordo com a tabela
  CodClasse       : integer = 120;//OBS Trocar esse valor de acordo com a tabela
  EBDDeleteError  : integer = 10246;
begin
  result  :=  0;
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;
  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then
  Begin
    Mensagens.Adicionar(EFaltaAcesso, Self.ClassName, NomeMetodo, []);
    Result := -1*EFaltaAcesso;
    Exit;
  End;
  Q           :=  THerdomQuery.Create(Conexao, nil);
  try
    Q.SQL.Text  :=  'DELETE FROM TAB_TIPO_PROPRIEDADE_RURAL '+
                    'WHERE COD_TIPO_PROPRIEDADE_RURAL = :COD_TIPO_PROPRIEDADE_RURAL';
    q.ParamByName('COD_TIPO_PROPRIEDADE_RURAL').AsInteger :=  CodTipoPropriedade;

    try
      Begintran;
      q.ExecSQL();
      Commit;
    except
      on e:Exception do
      begin
        Rollback;
        Mensagens.Adicionar(EBDDeleteError, Self.ClassName, NomeMetodo, [E.Message]);
        Result := -1*EBDDeleteError;
        Exit;
      end;
    end;
  finally
    FreeAndNil(q);
  end;
  result  :=  CodTipoPropriedade;
end;

function TIntTipoPropriedades.Inserir(CodTipoPropriedade: integer;
  des_tipo_propriedade: string; qtd_dias_prox_vistoria: integer): integer;
var
  Q : THerdomQuery;
Const
  NomeMetodo      : String  = 'Inserir';
  CodMetodo       : integer = 653;//OBS Trocar esse valor de acordo com a tabela
  CodClasse       : integer = 120;//OBS Trocar esse valor de acordo com a tabela
  ECcodDuplicado  : integer = 10241;
  EDescDuplicada  : integer = 10242;
  EFaltaDesc      : integer = 10243;
  EBDInsertError  : integer = 10244;
begin
  result  :=  -1;
  //============================================================================
  //Inicio das Validacoes
  //============================================================================
  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;
  // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then
  Begin
    Mensagens.Adicionar(EFaltaAcesso, Self.ClassName, NomeMetodo, []);
    Result := -1*EFaltaAcesso;
    Exit;
  End;
  //Verifica se possui descricao
  if trim(des_tipo_propriedade) = '' then
  begin
    Mensagens.Adicionar(EFaltaDesc, Self.ClassName, NomeMetodo, []);
    Result := -1*EFaltaDesc;
    Exit;
  end;
  Q := THerdomQuery.Create(Conexao, nil);

  try
    q.Close;
    q.SQL.Text  :=  'SELECT COD_TIPO_PROPRIEDADE_RURAL '+
                    'FROM TAB_TIPO_PROPRIEDADE_RURAL '  +
                    'WHERE COD_TIPO_PROPRIEDADE_RURAL = :COD_TIPO_PROPRIEDADE_RURAL';
    q.ParamByName('COD_TIPO_PROPRIEDADE_RURAL').AsInteger :=  CodTipoPropriedade;
    q.Open;

    //caso possua registros entao quer dizer que existe algum tipo de propriedade rural com esse codigo
    if not q.Eof then
    begin
      Mensagens.Adicionar(ECcodDuplicado, Self.ClassName, NomeMetodo, [IntToStr(CodTipoPropriedade)]);
      Result := -1*ECcodDuplicado;
      Exit;
    end;

    q.Close;
    q.SQL.Text  :=  'SELECT COD_TIPO_PROPRIEDADE_RURAL '+
                    'FROM TAB_TIPO_PROPRIEDADE_RURAL '  +
                    'WHERE DES_TIPO_PROPRIEDADE_RURAL = :DES_TIPO_PROPRIEDADE_RURAL';
    q.ParamByName('DES_TIPO_PROPRIEDADE_RURAL').AsString :=  trim(des_tipo_propriedade);
    q.Open;

    //caso possua registros entao quer dizer que existe algum tipo de propriedade rural com essa descricao
    if not q.Eof then
    begin
      Mensagens.Adicionar(EDescDuplicada, Self.ClassName, NomeMetodo, [IntToStr(CodTipoPropriedade)]);
      Result := -1*EDescDuplicada;
      Exit;
    end;
  //============================================================================
  //Fim das Validacoes
  //============================================================================
  Q.Close;
  q.SQL.Text  :=  'INSERT INTO TAB_TIPO_PROPRIEDADE_RURAL '+
                  '(COD_TIPO_PROPRIEDADE_RURAL,           '+
                  'DES_TIPO_PROPRIEDADE_RURAL,            '+
                  'QTD_DIAS_PROX_VISTORIA)                '+
                  'VALUES(:COD_TIPO_PROPRIEDADE_RURAL,    '+
                  ':DES_TIPO_PROPRIEDADE_RURAL,           '+
                  ':QTD_DIAS_PROX_VISTORIA)               ';
  Q.ParamByName('COD_TIPO_PROPRIEDADE_RURAL').AsInteger :=  CodTipoPropriedade;
  Q.ParamByName('DES_TIPO_PROPRIEDADE_RURAL').AsString  :=  TRIM(des_tipo_propriedade);
  Q.ParamByName('QTD_DIAS_PROX_VISTORIA').AsInteger     :=  qtd_dias_prox_vistoria;

  Begintran;
  try
    Q.ExecSQL();
    Commit;
  except
    on e:exception do
    begin
      Rollback;
      Mensagens.Adicionar(EBDInsertError, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1*EBDInsertError;
      Exit;
    end;
  end;
  finally
    Q.Close;
    FreeAndNil(q);
  end;
end;

//Usar o Metodo Valor Campo para resgatar esses valores
function TIntTipoPropriedades.Pesquisar(CodTipoPropriedade: integer;
  des_tipo_propriedade: string): integer;
Const
  NomeMetodo : String = 'Pesquisar';
  CodMetodo       : integer = 652;//OBS Trocar esse valor de acordo com a tabela
  CodClasse       : integer = 120;//OBS Trocar esse valor de acordo com a tabela
  EBDPESQERR      : integer = 10245;
begin

  If Not Inicializado Then Begin
    RaiseNaoInicializado(NomeMetodo);
    Exit;
  End;

    // Verifica se usuário pode executar método
  If Not Conexao.PodeExecutarMetodo(CodMetodo) Then
  Begin
    Mensagens.Adicionar(EFaltaAcesso, Self.ClassName, NomeMetodo, []);
    Result := -1*EFaltaAcesso;
    Exit;
  End;

  query.Close;
  query.SQL.Text  :=  'SELECT P.COD_TIPO_PROPRIEDADE_RURAL,P.DES_TIPO_PROPRIEDADE_RURAL,P.QTD_DIAS_PROX_VISTORIA '+
                      'FROM TAB_TIPO_PROPRIEDADE_RURAL P '+
                      'WHERE P.DES_TIPO_PROPRIEDADE_RURAL LIKE :DES_TIPO_PROPRIEDADE ';
  if CodTipoPropriedade <> -1 then
  begin
    query.SQL.Text  :=  query.SQL.Text + 'AND P.COD_TIPO_PROPRIEDADE_RURAL = :CODTIPOPROPRIEDADE';
    query.ParamByName('CODTIPOPROPRIEDADE').AsInteger :=  CodTipoPropriedade;
  end;
  query.ParamByName('DES_TIPO_PROPRIEDADE').AsString :=  '%'+des_tipo_propriedade+'%';

  Try
    Query.Open;
    Result := 0;
  Except
    On E: Exception do Begin
      Rollback;
      Mensagens.Adicionar(EBDPESQERR, Self.ClassName, NomeMetodo, [E.Message]);
      Result := -1*EBDPESQERR;
      Exit;
    End;
  End;
end;

end.
